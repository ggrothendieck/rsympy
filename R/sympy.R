
sympyStart <- function() {
	jython <- Sys.getenv("RSYMPY_JYTHON")
	if (jython == "") {
		# jython <- "C:/jython2.5b0"
		jython <- system.file("jython", package = "rSymPy")
	}
	library(rJava)
	.jinit(file.path(jython, "jython-complete.jar"))
	assign(".Rsympy", .jnew("org.python.util.PythonInterpreter"), .GlobalEnv)
	.jcall(.Rsympy, "V", "exec", "import sys")
	.jcall(.Rsympy, "V", "exec", 'print sys.path')
	.jcall(.Rsympy, "V", "exec", 
		sprintf("sys.path = ['%s', '%s', '__classpath__', '%s']", jython, 
			file.path(jython, "Lib"), 
			file.path(jython, "Lib", "site-packages")
		)
	)
	.jcall(.Rsympy, "V", "exec", "from sympy import *")
}

sympy <- function(..., retclass = c("character", "Sym", "NULL"), debug = FALSE) {
	if (!exists(".Rsympy", .GlobalEnv)) sympyStart()
    retclass <- match.arg(retclass)
	if (retclass != "NULL") {
		.jcall(.Rsympy, "V", "exec", paste("__Rsympy=", ...))
		if (debug) .jcall(.Rsympy, "V", "exec", "print __Rsympy")
		Rsympy <- .jcall(.Rsympy, "Lorg/python/core/PyObject;", "get", "__Rsympy")
		out <- if (!is.null(Rsympy)) .jstrVal(Rsympy)
        if (!is.null(out) && retclass == "Sym") structure(out, class = "Sym")
		else out
	} else .jcall(.Rsympy, "V", "exec", paste(...))
}

