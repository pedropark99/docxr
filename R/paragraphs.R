

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


format_paragraphs <- function(pars){
  pars <- stringr::str_c("<w:p>", pars, "<w:p/>")
  return(pars)
}

texto <- "Teste"
texto <- format_paragraphs(texto)



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

