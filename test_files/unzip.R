#library(fs)

docx <- "test_files/docx_teste.docx"

officer::unpack_folder(docx, "test_files/docx_teste")

path <- "test_files/docx_teste/word/"
arq <- xml2::read_xml(paste0(path, "document.xml"))
xml2::write_xml(arq, paste0(path, "document.xml"))

# zip::zip(
#   "resultado.docx",
#   files = c("_rels", "[Content_Types].xml", "docProps", "word"),
#   include_directories = FALSE,
#   root = "docx_vazio/",
#   mode = "mirror"
# )


# file_move("docx_vazio/resultado.docx", "resultado.docx")
