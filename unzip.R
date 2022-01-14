library(knitr)
library(fs)

docx_vazio <- "C:/Users/Pedro/Documents/docxr/docx_vazio.docx"
docx_template <- "C:/Users/Pedro/Documents/docxr/docx_template.docx"

officer::unpack_folder(docx_vazio, "C:/Users/Pedro/Documents/docxr/docx_vazio")
officer::unpack_folder(docx_template, "C:/Users/Pedro/Documents/docxr/docx_vazio")
officer::unpack_folder("teste.docx", "pandoc_style")

ls(envir = getNamespace("knitr"))


zip::zip(
  "resultado.docx",
  files = c("_rels", "[Content_Types].xml", "docProps", "word"),
  include_directories = FALSE,
  root = "docx_vazio/",
  mode = "mirror"
)



file_move("docx_vazio/resultado.docx", "resultado.docx")
