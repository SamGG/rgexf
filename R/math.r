################################################################################
# COLLECTION OF FUNCTIONS FOR EDGES ANALYSIS
################################################################################



#' Check (and count) duplicated edges
#' 
#' Looks for duplicated edges and reports the number of instances of them.
#' 
#' `check.dpl.edges` looks for duplicated edges reporting duplicates and
#' counting how many times each edge is duplicated.
#' 
#' For every group of duplicated edges only one will be accounted to report
#' number of instances (which will be recognized with a value higher than 2 in
#' the `reps` column), the other ones will be assigned a `-1` at the
#' `reps` value.
#' 
#' Function is mainly written in C, so speed gains are important.
#' 
#' @param edges A matrix or data frame structured as a list of edges
#' @param undirected Declares if the net is directed or not (does de difference)
#' @param order.edgelist Whether to sort the resulting matrix or not
#' @return A three column `data.frame` with colnames \dQuote{source},
#' \dQuote{target} \dQuote{reps}.
#' @author George Vega Yon 
#' @keywords manip
#' @examples
#' 
#'   # An edgelist with duplicated dyads
#'   relations <- cbind(c(1,1,3,4,2,5,6), c(2,3,1,2,4,1,1))
#'   
#'   # Checking duplicated edges (undirected graph)
#'   check.dpl.edges(edges=relations, undirected=TRUE)
#' @export
check.dpl.edges <- function(edges, undirected=FALSE, order.edgelist=TRUE) {
################################################################################
# Checks for duplicated edges, and switchs between source and target
# (optionally).
################################################################################  
  srce <- edges[,1]
  trgt <- edges[,2]

  if (any(!is.finite(edges) | is.null(edges)))
    stop("No NA, NULL or NaN elements can be passed to this function.")
 
  nedges <- length(srce)
  
  result <- .C(C_RCheckDplEdges, 
     as.double(srce),           # Input Source
     as.double(trgt),           # Input Target
     as.integer(undirected),    # Tells the function if the graph is undirected
     "source" = as.double(      # Output Source
       vector("double", nedges) 
       ),
     "target" = as.double(      # Output Target
       vector("double", nedges)
     ),
     "reps" = as.double(        # Output Target
       vector("double", nedges)
     ) #, PACKAGE="rgexf"
     )
  
  result <- data.frame(source=result$source, target=result$target, 
                       reps=result$reps, check.names=FALSE)

  if (order.edgelist) 
    result <- result[order(result[,1], result[,2]),]
  
  return(result)
}



#' Switches between source and target
#' 
#' Puts the lowest id node among every dyad as source (and the other as target)
#' 
#' `edge.list` transforms the input into a two-elements list containing a
#' dataframe of nodes (with columns \dQuote{id} and \dQuote{label}) and a
#' dataframe of edges. The last one is numeric (with columns \dQuote{source}
#' and \dQuote{target}) and based on autogenerated nodes' ids.
#' 
#' @param edges A matrix or data frame structured as a list of edges
#' @return A list containing two data frames.
#' @author George Vega Yon 
#' @keywords manip
#' @examples
#' 
#'   relations <- cbind(c(1,1,3,4,2,5,6), c(2,3,1,2,4,1,1))
#'   relations
#'   
#'   switch.edges(relations)
#' @export
switch.edges <- function(edges) {
################################################################################
# Orders pairs of edges by putting the lowest id first as source
################################################################################
  if (any(is.na(edges) | is.null(edges) | is.nan(edges))) 
    stop("No NA, NULL or NaN elements can be passed to this function.")

  result <- .C(
    C_RSwitchEdges,
    as.integer(NROW(edges)),
    as.double(edges[,1]),
    as.double(edges[,2]),
    "source" = as.double(              # Output Source
      vector("double", NROW(edges)) 
    ),
    "target" = as.double(              # Output Target
      vector("double", NROW(edges))
    ) # , PACKAGE="rgexf"
    )
  
  return(
    data.frame(
      source=result$source, 
      target=result$target,
      check.names=FALSE)
  )
}

#try(dyn.unload("src/RCheckDplEdges.so"))
#dyn.load("src/RCheckDplEdges.so")

#relations <- cbind(c(1,1,3,4,2,5,6), c(2,3,1,2,4,1,1))


#check.dpl.edges(relations)
#ordAndCheckDplEdges(relations, undirected=FALSE)
#switch.edges(relations)
