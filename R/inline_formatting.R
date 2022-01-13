library(readr)
library(magrittr)
library(stringr)
library(glue)

caminho <- "C:/Users/pedro.duarte/Documents/projects/docxr/teste.md"
arq_md <- read_file(caminho)
arq_md <- str_split(arq_md, "\n") %>% unlist()
source("R/identify_blocks.R", encoding = "UTF-8")
blocks <- build_blocks(arq_md)


t_teste <- "Teste, **`testando`**, **quem sabe** _não_ funciona `sei lá`"

tags <- c(
  "`" = "<w:rPr><w:rStyle w:val=\"VerbatimChar\"/></w:rPr>",
  "***" = "<w:rPr><w:b/><w:bCs/><w:i/><w:iCs/></w:rPr>",
  "**" = "<w:rPr><w:b/><w:bCs/></w:rPr>",
  "*" = "<w:rPr><w:i/><w:iCs/></w:rPr>"
)

patterns <- list(
  asterisk = c(
    "(<w:r><w:rPr>(.*)</w:rPr><w:t>)?\\*\\*\\*(([^\\s]|[\\s])+?)\\*\\*\\*(</w:t></w:r>)?",
    "(<w:r><w:rPr>(.*)</w:rPr><w:t>)?\\*\\*(([^\\s]|[\\s])+?)\\*\\*(</w:t></w:r>)?",
    "(<w:r><w:rPr>(.*)</w:rPr><w:t>)?\\*(([^\\s]|[\\s])+?)\\*(</w:t></w:r>)?"
  ),
  underscore = c(
    "(<w:r><w:rPr>(.*)</w:rPr><w:t>)?___(([^\\s]|[\\s])+?)___(</w:t></w:r>)?",
    "(<w:r><w:rPr>(.*)</w:rPr><w:t>)?__(([^\\s]|[\\s])+?)__(</w:t></w:r>)?",
    "(<w:r><w:rPr>(.*)</w:rPr><w:t>)?_(([^\\s]|[\\s])+?)_(</w:t></w:r>)?"
  ),
  replacements = c(
    "<w:r><w:rPr>\\2<w:b/><w:bCs/><w:i/><w:iCs/></w:rPr><w:t>\\3</w:t></w:r>",
    "<w:r><w:rPr>\\2<w:b/><w:bCs/></w:rPr><w:t>\\3</w:t></w:r>",
    "<w:r><w:rPr>\\2<w:i/><w:iCs/></w:rPr><w:t>\\3</w:t></w:r>"
  )
)


asterisks <- function(text){
  repl <- patterns$replacements
  ast <- patterns$asterisk
  for(i in 1:3){
    text <- str_replace_all(text, ast[i], repl[i])
  }
  return(text)
}

a <- asterisks(t_teste)


underscores <- function(text){
  repl <- patterns$replacements
  und <- patterns$underscore
  for(i in 1:3){
    text <- str_replace_all(text, und[i], repl[i])
  }
  return(text)
}


a <- underscores(t_teste)

accents <- function(text){
  pattern <- "(<w:r><w:rPr>(.*)</w:rPr><w:t>)?`(([^\\s]|[\\s])+?)`(</w:t></w:r>)?"
  replacement <- "<w:r><w:rPr>\\2<w:rStyle w:val=\"VerbatimChar\"/></w:rPr><w:t>\\3</w:t></w:r>"
  text <- str_replace_all(text, pattern, replacement)
  return(text)
}


accents(a)


inline_formatting <- function(blocks){
  text <- blocks$paragraphs$text
  text <- asterisks(text)
  text <- underscores(text)
  text <- accents(text)
  return(text)
}


inline_formatting(blocks)



