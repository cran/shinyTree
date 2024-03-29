#' Get the checked nodes from a tree
#' 
#' Extract the nodes from the tree that are checked in a more
#' convenient format. You can choose which format you prefer.
#' 
#' @param tree The \code{input$tree} shinyTree you want to 
#' inspect.
#' @param format In which format you want the output. Use 
#' \code{names} to get a simple list of the names (with attributes
#' describing the node's ancestry), or \code{slices} to get a list
#' of lists, each of which is a slice of the list used to get down
#' to the selected node. 
#' @export
get_checked<- function(tree, format=c("names", "slices", "classid")){
  format <- match.arg(format, c("names", "slices", "classid"), FALSE)
  switch(format,
         "names"=get_checked_names(tree),
         "slices"=get_checked_slices(tree),
         "classid"=get_checked_classid(tree)
         )  
}

get_checked_names <- function(tree, ancestry=NULL, vec=list()){
  if (is.list(tree)){
    for (i in 1:length(tree)){
      anc <- c(ancestry, names(tree)[i])
      vec <- get_checked_names(tree[[i]], anc, vec)
    }    
  }
  
  a <- attr(tree, "stchecked", TRUE)
  if (!is.null(a) && a == TRUE){
    # Get the element name
    len_anc <- length(ancestry)
    el <- ancestry[len_anc]
    vec[length(vec)+1] <- el
    attr(vec[[length(vec)]], "ancestry") <- ancestry[1:len_anc-1]
    #save attributes that start with "st" (ShinyTree)
    lapply(names(attributes(tree)),function(attribute){
        if(grepl("^st",attribute)){
            attr(vec[[length(vec)]], attribute) <<- attr(tree,attribute)
        }
    })
  }
  return(vec)
}

get_checked_slices <- function(tree, ancestry=NULL, vec=list()){
  
  if (is.list(tree)){
    for (i in 1:length(tree)){
      anc <- c(ancestry, names(tree)[i])
      vec <- get_checked_slices(tree[[i]], anc, vec)
    }    
  }
  
  a <- attr(tree, "stchecked", TRUE)
  if (!is.null(a) && a == TRUE){
    # Get the element name
    ancList <- 0
    
    for (i in length(ancestry):1){
      nl <- list()
      nl[ancestry[i]] <- list(ancList)
      ancList <- nl
    }
    vec[length(vec)+1] <- list(ancList)
  }
  return(vec)
}

get_checked_classid <- function(tree, ancestry=NULL, vec=list()){
    if (is.list(tree)){
      for (i in 1:length(tree)){
        anc <- c(ancestry, names(tree)[i])
        vec <- get_checked_classid(tree[[i]], anc, vec)
      }
    }
    
    a <- attr(tree, "stchecked", TRUE)
    if (!is.null(a) && a == TRUE){
      # Get the element name
      el <- ancestry[length(ancestry)]
      vec[length(vec)+1] <- el
      attr(vec[[length(vec)]], "stclass") <- attr(tree, "stclass", TRUE)
      attr(vec[[length(vec)]], "stid") <- attr(tree, "stid", TRUE)
      attr(vec[[length(vec)]], "id") <- attr(tree, "id", TRUE)
    }
    return(vec)
  }
