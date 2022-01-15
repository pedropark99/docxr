library(xml2)
library(magrittr)
library(purrr)
library(stringr)

unzip_folder <- "/docx_vazio/"
wd <- getwd()
wd <- paste0(wd, unzip_folder, "word/document.xml", collapse = "")

doc <- read_xml(wd)

doc

t <- "Teste.\nQuem sabe isso funciona (2145.0)"


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

is_not_null <- function(x){
  !is.null(x) | length(x) > 0
}

split_text <- function(x, pattern){
  unlist(str_split(x, pattern))
}


set_par_attrs <- function(doc, pars){
  doc <- doc
  attr_list <- map(pars, `[[`, "attr")
  not_null <- map_lgl(attr_list, is_not_null)
  index <- seq_along(pars)[not_null]

  ### If none attribute needs to be set, return early
  if(length(index) == 0){
    return(doc)
  }

  body_node <- xml_child(doc, "w:body")
  par_nodes <- xml_find_all(body_node, "w:p")
  for(i in index){
    xml_attrs(par_nodes[[i]]) <- attr_list[[i]]
  }

  return(doc)
}



build_text_nodes <- function(doc, pars){
  doc <- doc
  body_node <- xml_child(doc, "w:body")
  par_nodes <- xml_find_all(body_node, "w:p")
  texts <- map(pars, `[[`, "text")

  for(i in seq_along(texts)){
    xml_add_child(par_nodes[[i]], "w:r")
    run_node <- xml_child(par_nodes[[i]], "w:r")
    xml_add_child(run_node, "w:t")
  }

  text_nodes <- xml_find_all(par_nodes, "w:r/w:t")
  xml_text(text_nodes) <- unlist(texts)

  return(doc)
}

build_paragraphs(vec) %>% xml_contents() %>% as.character()


build_paragraphs <- function(pars){
    body_node <- xml_child(doc, "w:body")

    for(i in seq_along(pars)) xml_add_child(body_node, "w:p", .where = "after")
    par_nodes <- xml_find_all(body_node, "w:p")
    doc <- set_par_attrs(doc, pars)
    doc <- build_text_nodes(doc, pars)

    return(par_nodes)
}


tp <- unlist(str_split(t, "\n"))
vec <- vector("list", length = length(tp))
for(i in seq_along(tp)){
  vec[[i]] <- list(text = tp[i])
}
vec[[1]][["attr"]] <- c("w14:textId" = "43BD13C9")


doc <- read_xml(wd)

docx_add_text <- function(xml, pars){
  xml <- xml
  paragraphs <- build_paragraphs(pars)
  body_node <- xml_child(xml, "w:body")

  for(par in paragraphs){
    xml_add_child(body_node, par, .where = "after")
  }

  return(xml)
}

a <- docx_add_text(doc, vec)
write_xml(a, wd)


