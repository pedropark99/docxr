

docx_add_text <- function(docx, text){
  ### Move to w:body
  body <- xml2::xml_find_first(docx, "w:body")
  for (i in seq_along(text)) {
    body |>
      xml2::xml_add_child("w:p") |>
      xml2::xml_add_child("w:r") |>
      xml2::xml_add_child("w:rPr")
  }

  ### After adding the tags, fill them with the text
  all_pars <- xml2::xml_find_all(body, "w:p")
  #xml2::xml_text(all_pars) <- text

  return(docx)
}




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


texto <- "Estou testando **uma** nova funcionalidade

Quem sabe a gente `consegue`;"

a <- process_paragraphs(texto)

a <- c(
  "Estou testando **uma** nova *funcionalidade*",
  "Quem sabe a gente `consegue`;"
)


markdown_patterns <- c(
  "[*]{3}", "[*]{2}", "[*]",
  "[_]{3}", "[_]{2}", "[_]",
  "`"
)

split_markdown_runs <- function(pars){

  for (pattern in markdown_patterns) {
    pars <- lapply(
      pars,
      function(x) str_split(x, pattern) |> unlist()
    )
  }

  return(pars)
}


# get_run_ids <- function(pars){
#
# }
#
#
# get_run_ids(a)


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





md_formatting <- function(text){

}
