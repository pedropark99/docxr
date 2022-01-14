
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
