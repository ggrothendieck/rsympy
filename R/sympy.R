
jythonStart <- function(jython.jar) {
	stopifnot(require(rJava))
	.jinit(jython.jar)
	assign(".Jython", .jnew("org.python.util.PythonInterpreter"), .GlobalEnv)
	invisible(.Jython)
}

sympyStart <- function() {

	# like system.file but on Windows uses \ in path rather than /
	system.file. <- function(...) {
		s <- system.file(...)
		if (.Platform$OS == "windows") gsub("/", "\\", s, fixed = TRUE) else s
	}

	jython.jar <- Sys.getenv("RSYMPY_JYTHON")
	if (jython.jar == "") {
		# jython <- "C:/jython2.5.1"
		jython.jar <- system.file.("jython.jar", package = "rSymPy")
	}

	jythonStart(jython.jar)
	.Jython$exec("import sys")

	# old:
	# rSymPy <- system.file.(package = "rSymPy")
	# .Rsympy$exec(sprintf('sys.path.append("%s")', rSymPy))

	# new:
	# there should be a Lib directory in same directory as jython.jar
	# and sympy directory should be in Lib.   The sympy directory should
	# contain core and other sympy directories, etc.
	.Jython$exec("from sympy import *")

}

sympy <- function(..., retclass = c("character", "Sym", "NULL"), debug = FALSE) {
	if (!exists(".Jython", .GlobalEnv)) sympyStart()
    retclass <- match.arg(retclass)
	if (retclass != "NULL") {
		.Jython$exec(paste("__Rsympy=", ...))
		if (debug) .Jython$exec("print __Rsympy") 
		Rsympy <- .Jython$get("__Rsympy")
		out <- if (!is.null(Rsympy)) .jstrVal(Rsympy)
        if (!is.null(out) && retclass == "Sym") structure(out, class = "Sym")
		else out
	} else .Jython$exec(paste(...))
}



