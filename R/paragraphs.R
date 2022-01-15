

### Paragraph object
#
#
# A par object is a list object with 2 elements:
# - text: the raw text of the paragraph;
# - properties: the properties of the paragraph (w:pPr);
#


default_properties <- list(
  jc = "both",
  spacing = c("before" = "360", "after" = "120", "line" = "480", "lineRule" = "auto", "beforeAutospacing" = "0", "afterAutospacing" = "0")
)


par <- structure(
  list(
    list(text = "Testando um paragrafo interessante", properties = NULL),
    list(text = "Outro parágrafo muito interessante", properties = NULL),
    list(text = "Não sei o que escrever nesse parágrafo", properties = NULL),
    list(text = "Quem sabe amanhã vai", properties = NULL)
  ),
  class = "docx_par"
)


docx_add_text <- function(docx, text){
  ### Move to w:body
  body <- xml2::xml_find_first(docx, "w:body")

  ## If is a simple character vector:
  if (is.character(text)) {
    for (i in seq_along(text)) {
      body |>
        xml2::xml_add_child("w:p")
    }

    ### After adding the tags, fill them with the text
    all_pars <- xml2::xml_find_all(body, "w:p")
    xml2::xml_text(all_pars) <- text
  }


  ## But if user is giving paragraphs
  ## we should build differently
  if (inherits(text, "docx_par")) {
    pars <- purrr::transpose(text)
    contents <- pars$text
    prs <- pars$properties

    for (i in seq_along(contents)) {
      body |>
        xml2::xml_add_child("w:p")
    }

    all_pars <- xml2::xml_find_all(body, "//w:p")
    for (i in seq_along(contents)) {
      for (j in seq_along(prs[[i]])) {
        all_pars[[i]] |>
          xml2::xml_add_child("w:rPr")
      }
    }
  }

  return(docx)
}




build_paragraph_properties <- function(properties){

  if(is.null(properties)){
    prs <- get("default_properties")
  }

  prs <- lapply(properties, pair_wise_attrs)

  return(prs)
}

build_paragraph_properties(default_properties)





pr_names <- names(default_properties)
values <-



process_paragraphs <- function(text, markdown_mode = TRUE){
  ### Normalize line endings
  text <- stringr::str_replace_all(text, "\r\n", "\n")

  ### Get list of paragraphs
  pars <- stringr::str_split(text, "\n\n") |>
    unlist() |>
    as.list()

  pars <- split_markdown_runs(pars)

  return(pars)
}




markdown_patterns <- c(
  "(?<!\\\\)[*]{3}", "(?<!\\\\)[*]{2}", "(?<!\\\\)[*]",
  "(?<!\\\\)[_]{3}", "(?<!\\\\)[_]{2}", "(?<!\\\\)[_]",
  "(?<!\\\\)`"
)



split_markdown_runs <- function(pars){

  for (pattern in markdown_patterns) {
    pars <- lapply(
      pars,
      function(x) stringr::str_split(x, pattern) |> unlist()
    )
  }

  return(pars)
}


inline_patterns <- list(
  asterisks = c(
    "\\*\\*\\*(([^\\s]|[\\s])+?)\\*\\*\\*",
    "\\*\\*(([^\\s]|[\\s])+?)\\*\\*",
    "\\*(([^\\s]|[\\s])+?)\\*"
  ),
  underscores = c(
    "___(([^\\s]|[\\s])+?)___",
    "__(([^\\s]|[\\s])+?)__",
    "_(([^\\s]|[\\s])+?)_"
  )
)




# If you build a pipe chain of commands
# the node structure is different that if
# you just run the commands individually.
#
#
# a <- xml2::xml_new_root("document")
# xml2::xml_add_child(a, "body")
# body <- xml2::xml_find_first(a, "body")
# xml2::xml_add_child(body, "p")
# xml2::xml_add_child(body, "p")
# xml2::xml_add_child(body, "p")
#
# xml2::as_list(a)
#
# a <- xml2::xml_new_root("document")
# xml2::xml_add_child(a, "body")
# xml2::xml_find_first(a, "body") |>
#   xml2::xml_add_child("p") |>
#   xml2::xml_add_child("p") |>
#   xml2::xml_add_child("p")
#
# xml2::as_list(a)






