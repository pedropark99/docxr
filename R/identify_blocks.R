library(readr)
library(purrr)
library(magrittr)
library(stringr)
library(glue)

caminho <- "teste.md"
arq_md <- read_file(caminho)
arq_md <- str_split(arq_md, "\n") %>% unlist()


#' Blocks of markdown document can be categorized in 9 categories:
#' - chunk code: blocks that contain source code with a defined language, to use as reference highlight.
#' - chunk output: blocks that contain output of some source code, or, the source code without a language to use as highlight.
#' - yaml header: block of yaml header.
#' - blockquote: blocks that contain normal markdown blockquotes, initialized by '>' character.
#' - header: a part, chapter, section or subsection header.
#' - table: blocks of markdown formatted table.
#' - paragraph: a paragraph of normal text and inline formatting.
#' - numbered lists: block of numered lists.
#' - unnordered lists: block of unnumbered lists.
#' - images: line including some image.
#' 
#' 
#' The functions on this script, seeks to divide the markdown document into
#' these 9 categories. All these functions starts with the prefix "identify", and
#' receives a character vector as input. Each element of this input vector should
#' be a line in the markdown document.




#' `%notin%`
#' A shortcut to get a negated `in` logical test.

`%notin%` <- function(x, y){
  return(!(x %in% y))
}


#' identify_chunk_code() receives a character vector
#' with the lines of the markdown document. This function
#' try to identify highlighted chunk code blocks.
#' These blocks usually start with "```" followed by
#' some identifier of the programming language used in the chunk,
#' like "r", "python", "c" or "sql".

identify_chunk_code <- function(text){
  supported_languages <- names(knitr::knit_engines$get())
  supported_languages <- str_c("(", str_c(str_to_lower(supported_languages), collapse = "|"), ")")
  pattern <- sprintf("^[\t ]*```%s( *)$", supported_languages)
  
  starts <- str_which(text, pattern)
  if (length(starts) == 0) {
    return("Not a single chunk start was found.")
  }
  starts <- sort(starts)
  
  ends <- str_which(text, "^[\t ]*```( *)$")
  ends <- sort(ends)
  
  true_ends <- vector("integer", length = length(starts))
  for (i in seq_along(starts)) {
    possibilities <- ends[ends > starts[i]]
    true_ends[i] <- possibilities[1]
  }
  
  dif <- true_ends - starts
  chunk_lines <- sequence.default(dif + 1L, from = starts, by = 1L)
  
  return(chunk_lines)
}

#chunks <- identify_chunk_code(arq_md)
#arq_md[chunks]



#' Helper functions for generating even and odd numeric sequences.

even_seq <- function(n){
  if(n == 0){
    return(integer())
  }
  
  seq <- seq.int(2L, length.out = n, by = 2L)
  return(seq)
}

odd_seq <- function(n){
  if(n == 0){
    return(integer())
  }
  
  seq <- seq.int(1L, length.out = n, by = 2L)
  return(seq)
}



identify_chunk_output <- function(text, chunk_code){
  ids <- seq_along(text)
  text <- text[text %notin% chunk_code]
  limits <- str_which(text, "^[\t ]*```( *)$")
  
  if (length(limits) %% 2 != 0) {
    stop("Some chunk output start '```' is not matched with an end '```'. Did you forgot to add an ending ``` line to some chunk output?")
  }
  
  if (length(limits) == 0) {
    return("Not a single chunk output start was found.")
  }
  
  n <- length(limits) / 2
  starts <- limits[odd_seq(n)]
  ends <- limits[even_seq(n)]
  
  dif <- ends - starts
  chunk_output_lines <- sequence.default(dif + 1, from = starts, by = 1L)
  
  return(chunk_output_lines)
}

#chunks_outputs <- identify_chunk_output(arq_md, chunks)
#arq_md[chunks_outputs]





identify_headers <- function(text, chunk_code, chunk_output){
  ## Hashtag is a commom caracter for comments in many
  ## programming languages, so, is important to 
  ## remove chunk lines from the search for section headers.
  ids <- seq_along(text)
  chunk_lines <- c(chunk_code, chunk_output)
  text <- text[text %notin% chunk_lines]
  limits <- str_which(text, "^(#+) (.+)$")
  
  return(limits)
}


#identify_headers(arq_md, chunks, chunks_outputs)





identify_tables <- function(text){
  headers <- str_which(text, "^[|]-+[|](.*)$")
  if (length(headers) == 0 || is.null(headers)) {
    cat("Not a single table was found in the document!")
    return(invisible())
  }
  possibilities <- str_which(text, "^[|](.+)[|](.*)$")
  distances <- possibilities - dplyr::lag(possibilities)
  split_ids <- cumsum(as.integer(distances != 1 | is.na(distances)))
  
  groups <- split.default(possibilities, split_ids)
  table_id <- 1L
  tables <- vector("list", length = length(headers))
  for (group in groups) {
    if (any(group %in% headers)) {
      tables[[table_id]] <- group
      table_id <- table_id + 1L
    }
  }
  
  return(tables)
}

#identify_tables(arq_md)









identify_yaml <- function(text){
  limits <- str_which(text, "^[\t ]*---( *)$")
  if (length(limits) == 0) {
    cat("None YAML header was found in the file.")
    return(invisible())
  }
  if (length(limits) < 2) {
    stop(
      sprintf(
        "The start of a YAML header was found at line %f, but an ending `---` was not found.",
        limits[1]
      )
    )
  }
  
  seq <- seq.int(from = limits[1], to = limits[2], by = 1L)
  return(seq)
}

#yaml <- identify_yaml(arq_md)




identify_blockquotes <- function(text){
  starts <- str_which(text, "^([\t ]*)(>+)")
  distances <- starts - dplyr::lag(starts)
    
  next_lines <- text[starts + 1]
  to_include <- !str_detect(next_lines, "^[\t ]*```([r])?( *)$|^( *)$")
  to_include <- (starts + 1)[to_include]
  
  limits <- unique(sort(c(starts, to_include)))
  
  return(limits)
}

#blockquotes <- identify_blockquotes(arq_md)
#blockquotes




identify_numered_lists <- function(text){
  ## Talvez seja melhor apenas identificar essas linhas, e deixar o processamento delas para depois
  lines <- str_which(text, "^([\t ]*)([0-9]+[.]) (.*)")
  return(lines)
}

#identify_numered_lists(arq_md)



identify_unordered_lists <- function(text){
  ## Talvez seja melhor apenas identificar essas linhas, e deixar o processamento delas para depois
  lines <- str_which(text, "^([\t ]*)- (.*)")
  return(lines)
}

#identify_unordered_lists(arq_md)






identify_images <- function(text){
  lines <- str_which(text, "^!\\[(.*)\\]\\((.*)\\) *$")
  return(lines)
}

#identify_images(arq_md)







identify_paragraphs <- function(text, yaml, chunk_code, chunk_output,
                                blockquotes, headers, tables,
                                numered_lists, unordered_lists, images){
  
  ids <- seq_along(text)
  test <- (ids %notin% yaml) &
    (ids %notin% chunk_code) &
    (ids %notin% chunk_output) &
    (ids %notin% blockquotes) &
    (ids %notin% headers) &
    (ids %notin% unlist(tables)) &
    (ids %notin% numered_lists) &
    (ids %notin% unordered_lists) &
    (ids %notin% images)
    
  paragraph_lines <- ids[test]
  
  return(paragraph_lines)
}

#identify_paragraphs(arq_md, yaml, chunks, chunks_outputs)






block_vector <- function(ids, text){
  text_vec <- text[ids]
  obj <- list(
    line_ids = ids,
    text = text_vec
  )
  return(obj)
}



collect_arguments <- function(fun){
  f <- formals(fun)
  return(names(f))
}


fun_blocks <- list(
  list(fun = identify_yaml, category = "yaml"),
  list(fun = identify_blockquotes, category = "blockquotes"),
  list(fun = identify_chunk_code, category = "chunk_code"),
  list(fun = identify_chunk_output, category = "chunk_output"),
  list(fun = identify_headers, category = "headers"),
  list(fun = identify_tables, category = "tables"),
  list(fun = identify_numered_lists, category = "numered_lists"),
  list(fun = identify_unordered_lists, category = "unordered_lists"),
  list(fun = identify_images, category = "images"),
  list(fun = identify_paragraphs, category = "paragraphs")
)

for (i in seq_along(fun_blocks)) {
  fun_blocks[[i]][["args"]] <- collect_arguments(fun_blocks[[i]][["fun"]])
}




build_blocks <- function(text){
  text <- text
  env <- environment()
  
  for (i in seq_along(fun_blocks)) {
    category <- fun_blocks[[i]][["category"]]
    args <- fun_blocks[[i]][["args"]]
    fun <- fun_blocks[[i]][["fun"]]
    
    args <- map(args, ~get(., envir = env))
    result <- do.call(fun, args)
    assign(category, value = result, envir = env)
  }
  
  categories <- map_chr(fun_blocks, "category")
  blocks <- vector("list", length = length(categories))
  names(blocks) <- categories
  ## For tables, we need to pass block_vector() to map(),
  ## so, for more succint code, we deal with this category
  ## after the loop.
  categories <- categories[categories != "tables"]
  for (category in categories) {
    ids <- get(category, envir = env)
    blocks[[category]] <- block_vector(ids, text)
  }
  
  blocks$tables <- purrr::map(tables, block_vector, text)
  
  return(blocks)
}


blocks <- build_blocks(arq_md)

