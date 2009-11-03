\name{sympy}
\alias{sympy}
\alias{sympyStart}
\alias{jythonStart}
\title{ sympy }
\description{
  Interface to the sympy computer algebra system.
}
\usage{
sympy(..., retclass = c("character", "Sym", "NULL"), debug = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{Character strings which are pasted together with space 
	separators.  The resulting string is passed to sympy.}
  \item{retclass}{Character string representing the class of the output or 
    the string \code{"NULL"} to mean no output. }
  \item{debug}{Logical.  If TRUE then additional debugging info is shown.}
}
\details{
The \code{sympy} function passes
an input string to SymPy and returns the output.  The first time
\code{sympy} is invokved in a session it also starts up SymPy by invoking
\code{sympyStart} 
(which sets the appropriate paths, calls \code{jythonStart}
and then imports \code{sympy}).  As a result the first invocation of sympy 
can be expected to much slower than subsequent ones.
\code{jythonStart} creates 
a variable \code{.Jython} which is stored in the global environment
holding the connection information to the SymPy/Jython session.

Internally if the argument 
\code{output=TRUE}, the default, input character string
is prefaced with \code{__Rsympy=} so if such preface would cause an error 
then ensure that the argument \code{output=FALSE}.

Note that error messages from SymPy appear on the shell/batch console,
not on the R console.  In the case of an error message the returned
value may be wrong.

}
\value{
The character string produced from SymPy.
}
\references{ \url{http://code.google.com/p/sympy/}, \url{http://www.jython.org/Project/}
}
\note{SymPy is run under Jython, the Java version of Python.}
\examples{
\dontrun{
# These examples are mostly from: http://wiki.sympy.org/wiki/Tutorial

# create a SymPy variable called x
sympy("var('x')")
sympy("y = x*x")
sympy("y")

sympy("limit(1/x, x, oo)")

# the next line fails under jython even without R
# and seems to corrupt the rest of the session
# sympy("(1/cos(x)).series(x, 0, 10)")

sympy("diff(sin(2*x), x, 1)")
sympy("diff(sin(2*x), x, 2)")

sympy("integrate(exp(-x), (x, 0, oo))")

sympy("xr = Symbol('xr', real=True)")
sympy("exp(I*xr).expand(complex=True)")

# Matrices are stored row by row (unlike R matrices)
cat(sympy("A = Matrix([[1,x], [y,1]])"), "\n")
cat(sympy("A**2"), "\n")


}
}
\keyword{ symbolmath }

