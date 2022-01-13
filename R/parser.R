library(stringr)
library(xml)
library(knitr)
library(readr)
library(magrittr)
library(fs)
library(purrr)

render_markdown()
knit("teste.Rmd")


chars <- "[a-zA-ZãõâêîôûáéíóúÃÕÂÊÎÔÛÁÉÍÓÚ0-9]|[:space:]|[-!@#$%&?/|\\[\\](){}+=_\"'´^~;:.,<>]|\\\\"
patt1 <- str_c("[*]", "(", chars, ")*", "[*]")
patt2 <- str_c("[_]", "(", chars, ")*", "[_]")
patt3 <- str_c("[`]", "(", chars, ")*", "[`]")
patt4 <- str_c("[_]{2}", "(", chars, ")*", "[_]{2}")
patt5 <- str_c("[*]{2}", "(", chars, ")*", "[*]{2}")


patterns <- list(
  inline_formatting = str_c(patt1, patt2, patt3, patt4, patt5, sep = "|", collapse = "")
)

namespaces <- c(
  "xmlns:aink" = "http://schemas.microsoft.com/office/drawing/2016/ink",
  "xmlns:am3d" = "http://schemas.microsoft.com/office/drawing/2017/model3d",
  "xmlns:cx" = "http://schemas.microsoft.com/office/drawing/2014/chartex",
  "xmlns:cx1" = "http://schemas.microsoft.com/office/drawing/2015/9/8/chartex",
  "xmlns:cx2" = "http://schemas.microsoft.com/office/drawing/2015/10/21/chartex",
  "xmlns:cx3" = "http://schemas.microsoft.com/office/drawing/2016/5/9/chartex",
  "xmlns:cx4" = "http://schemas.microsoft.com/office/drawing/2016/5/10/chartex",
  "xmlns:cx5" = "http://schemas.microsoft.com/office/drawing/2016/5/11/chartex",
  "xmlns:cx6" = "http://schemas.microsoft.com/office/drawing/2016/5/12/chartex",
  "xmlns:cx7" = "http://schemas.microsoft.com/office/drawing/2016/5/13/chartex",
  "xmlns:cx8" = "http://schemas.microsoft.com/office/drawing/2016/5/14/chartex",
  "xmlns:m" = "http://schemas.openxmlformats.org/officeDocument/2006/math",
  "xmlns:mc" = "http://schemas.openxmlformats.org/markup-compatibility/2006",
  "xmlns:o" = "urn:schemas-microsoft-com:office:office",
  "xmlns:r" = "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
  "xmlns:v" = "urn:schemas-microsoft-com:vml",
  "xmlns:w" = "http://schemas.openxmlformats.org/wordprocessingml/2006/main",
  "xmlns:w10" = "urn:schemas-microsoft-com:office:word",
  "xmlns:w14" = "http://schemas.microsoft.com/office/word/2010/wordml",
  "xmlns:w15" = "http://schemas.microsoft.com/office/word/2012/wordml",
  "xmlns:w16" = "http://schemas.microsoft.com/office/word/2018/wordml",
  "xmlns:w16cex" = "http://schemas.microsoft.com/office/word/2018/wordml/cex",
  "xmlns:w16cid" = "http://schemas.microsoft.com/office/word/2016/wordml/cid",
  "xmlns:w16sdtdh" = "http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash",
  "xmlns:w16se" = "http://schemas.microsoft.com/office/word/2015/wordml/symex",
  "xmlns:wne" = "http://schemas.microsoft.com/office/word/2006/wordml",
  "xmlns:wp" = "http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing",
  "xmlns:wp14" = "http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing",
  "xmlns:wpc" = "http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas",
  "xmlns:wpg" = "http://schemas.microsoft.com/office/word/2010/wordprocessingGroup",
  "xmlns:wpi" = "http://schemas.microsoft.com/office/word/2010/wordprocessingInk",
  "xmlns:wps" = "http://schemas.microsoft.com/office/word/2010/wordprocessingShape"
)





start_document <- function(){
  doc <- xml_new_root(.value = "document")
  xml_attrs(doc) <- namespaces
  xml_add_child(doc, "w:body")
  
  return(doc)
}


read_md <- function(path, encoding = "UTF-8"){
  text <- read_file(path, locale = locale(encoding = encoding))
  file <- unlist(str_split(text, "\n"))
  begin <- max(str_which(file, "^---([:space:])?$")) + 1
  file <- file[begin:length(file)]
  return(file)
}

arq <- read_md("teste.md")

chunk_start_line <- function(x){
  n <- seq_along(x)
  return(x[n %% 2 != 0])
}

chunk_end_line <- function(x){
  n <- seq_along(x)
  return(x[n %% 2 == 0])
}



get_paragraphs <- function(file){
  chunk_lines <- find_chunk_lines(file)
  lines <- seq_along(file)
  pars <- file[ !(lines %in% chunk_lines) ]
  
  return(pars)
}

ps <- get_paragraphs(arq)


format_paragraphs <- function(pars){
  pars <- str_c("<w:p>", pars, "<w:p/>")
  
  return(pars)
}





