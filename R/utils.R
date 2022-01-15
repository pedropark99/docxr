


pair_wise_attrs <- function(x){

  if(length(x) == 1){
    return(list("val" = unname(x)))
  }

  attrs <- as.list(unname(x))
  names(attrs) <- names(x)

  return(attrs)

}


