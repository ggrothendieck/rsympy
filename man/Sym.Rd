\name{Sym}
\alias{Sym}
\alias{as.character.Sym}
\alias{as.expression.Sym}
\alias{Ops.Sym}
\alias{Math.Sym}
\alias{print.Sym}
\alias{deriv.Sym}
\alias{Limit}
\alias{Var.Sym}
\alias{solve.Sym}
\alias{Integrate}
\alias{t.Sym}
\alias{List}
\alias{Matrix}
\alias{Var}
\alias{Zero}
\alias{Zeros}
\alias{Eye}

\title{
sympy variables
}
\description{
Create and manipulate sympy variables.
}
\usage{
Sym(..., retclass = c("Sym", "character"))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{
	Variable name as a string by which sympy should identify this varible
}
  \item{retclass}{
	Class of object to be returned.
}
}
\details{
An object of class  \code{"Sym"} is internally a sympy character string.
One can combine such objects using the Math and Ops R operators (see
help(Math) and help(Ops) for a list).  Also the following are supported:
\code{as.character.Sym},
\code{as.expression.Sym},
\code{Ops.Sym},
\code{Math.Sym},
\code{print.Sym},
\code{deriv.Sym},
\code{Limit},
\code{Var.Sym},
\code{solve.Sym},
\code{Integrate},
\code{t.Sym},
\code{List},
\code{Matrix},
\code{Var},
\code{Zero},
\code{Zeros} and
\code{Eye}.
}
\value{
As in \code{retclass}.
}

\seealso{
\code{\link{sympy}}
}
\examples{
\dontrun{
x <- Var("x")
x+x
}
}
\keyword{ symbolmath }

