
sympyStart <- function() {
	system.file. <- function(...) {
		s <- system.file(...)
		if (.Platform$OS == "windows") gsub("/", "\\", s, fixed = TRUE) else s
	}
	jython.jar <- Sys.getenv("RSYMPY_JYTHON")
	if (jython.jar == "") {
		# jython <- "C:/jython2.5.1"
		jython.jar <- system.file.("jython.jar", package = "rSymPy")
	}
	stopifnot(require(rJava))
	.jinit(jython.jar)
	assign(".Rsympy", .jnew("org.python.util.PythonInterpreter"), .GlobalEnv)
	.Rsympy$exec("import sys")
	# rSymPy <- system.file.(package = "rSymPy")
	# .Rsympy$exec(sprintf('sys.path.append("%s")', rSymPy))
	.Rsympy$exec("from sympy import *")
}

sympy <- function(..., retclass = c("character", "Sym", "NULL"), debug = FALSE) {
	if (!exists(".Rsympy", .GlobalEnv)) sympyStart()
    retclass <- match.arg(retclass)
	if (retclass != "NULL") {
		.Rsympy$exec(paste("__Rsympy=", ...))
		if (debug) .Rsympy$exec("print __Rsympy") 
		Rsympy <- .Rsympy$get("__Rsympy")
		out <- if (!is.null(Rsympy)) .jstrVal(Rsympy)
        if (!is.null(out) && retclass == "Sym") structure(out, class = "Sym")
		else out
	} else .Rsympy$exec(paste(...))
}



