
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

sympy <- function(..., output = TRUE, debug = FALSE) {
	if (!exists(".Rsympy", .GlobalEnv)) sympyStart()
	if (output) {
		.jcall(.Rsympy, "V", "exec", paste("__Rsympy=", ...))
		if (debug) .jcall(.Rsympy, "V", "exec", "print __Rsympy")
		Rsympy <- .jcall(.Rsympy, "Lorg/python/core/PyObject;", "get", "__Rsympy")
		if (!is.null(Rsympy)) .jstrVal(Rsympy)
	} else .jcall(.Rsympy, "V", "exec", paste(...))
}

