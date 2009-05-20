
Sym <- function(..., retclass = c("Sym", "character")) {
   args <- list(...)
   retclass <- match.arg(retclass)
   value <- if (length(args) > 1) paste("(", ..., ")") else paste(args[[1]])
   if (retclass == "Sym") class(value) <- c("Sym", "character")
   value
}

as.character.Sym <- function(x, ...) as.character(unclass(x))
as.expression.Sym <- function(x, ...) yacas(x, ...)[[1]]

Ops.Sym <- function (e1, e2) 
    if (missing(e2)) { Sym(.Generic, e1)
    } else Sym(e1, .Generic, e2)

Math.Sym <- function(x, ...) {
	idx <- match(.Generic, transtab[,1], nomatch = 0)
	fn <- if (idx > 0) transtab[idx, 3] else .Generic
	Sym(fn, "(", x, ")")
}

print.Sym <- function(x, ...) print(sympy(unclass(x), ...))

deriv.Sym <- function(expr, name = "x", n = 1, ...) 
	Sym("diff(", expr, ", ", name, ",", n, ")")

limit <- function(expr, name = "x", value) 
	Sym("limit(", expr, ",", name, ",", value, ")")

transtab <- matrix( c(
	#R			not_used	sympy
	"exp", 		"exp", 		"exp"
), byrow = TRUE, ncol = 3)
colnames(transtab) <- c("R", "OM", "yacas")

Var <- function(x, retclass = c("Sym", "character", "NULL")) {
	x <- paste("var('", x, "')", sep = "")
	sympy(x, retclass = match.arg(retclass))
}

if (FALSE) {
transtab <- matrix( c(
	"pi",		"pi",		"Pi",
	"+",		"plus",		"+",
	"-",		"minus",	"-",
	"*",		"times",	"*",
	"/",		"divide",	"/",
	"/",		"rational",	"/",
	"^",		"power",	"^",
	"%%",		"mod",		"Mod",
	"%/%",		"div",		"Div",
	"root",		"root",		"NthRoot",
	"Inf",		"infinity",	"Infinite",
	"NaN",		"undefined","Undefined",
	
	"sin",		"Sin",		"Sin",
	"cos",		"Cos",		"Cos",
	"tan",		"Tan",		"Tan",
	
	"asin",		"arcsin",	"ArcSin",
	"acos",		"arccos",	"ArcCos",
	"atan", 	"arctan", 	"ArcTan",
	"asinh", 	"arcsinh", 	"ArcSinh", 
	"acosh", 	"arccosh", 	"ArcCosh", 
	"atanh", 	"arctanh", 	"ArcTanh",
	
	"acsc",		"arccsc",	"ArcCsc",
	"acsch",	"arccsch",	"ArcCsch",
	
	"asec",		"arcsec",	"ArcSec",
	"asech",	"arcsech",	"ArcSech",
	
	"acot",		"arccot",	"ArcCot",
	"acoth",	"arccoth",	"ArcCoth",
	
	"log", 		"ln", 		"Ln",
	"sqrt", 	"sqrt", 	"Sqrt",
	"choose", 	"bin", 		"Bin",
	"gamma", 	"gamma", 	"Gamma",
	
	"!",		"not",		"Not",
	"==",		"eq",		"=",
	"==",		"equivalent","=",
	">=",		"geq",		">=",
	">", 		"gt",		">",
	"<=", 		"leq",		"<=",
	"<", 		"lt",		"<",
	"!=", 		"neq",		"!=",
	":", 		"seq",		"sequence",
	":", 		"seq",		"..",
	
	"factorial","factorial","factorial",
	"factorial","factorial","!",
	"limit", 	"lim", 		"Limit",
	"deriv", 	"deriv", 	"Deriv",
	"integrate","integrate","Integrate",
	"?",		"taylor",	"Taylor",

	"list",		"List", 	"List",
	"TRUE",		"true", 	"True",
	"<-",		"?",		":=",
	"Expr",		"?",		"",
	"Exprq", 	"?",		"",
	"expression", 	"?", 		""
	
), byrow = TRUE, ncol = 3)
colnames(transtab) <- c("R", "OM", "yacas")

as.Sym <- function(x, ...) UseMethod("as.Sym")
as.Sym.yacas <- function(x, ...) Sym(format(yparse(x[[1]])))
as.Sym.Expr <- function(x, ...) Sym(format(yparse(x)))


Integrate <- function(f, ...) UseMethod("Integrate")
Integrate.default <- function(f, x, a, b, ...) {
   if (missing(a) && missing(b)) { Sym("Integrate(", x, ")", f)
   } else Sym("Integrate(", x, ",", a, ",", b, ")", f)
}

Eval.Sym <- function(x, env = parent.frame(), ...) 
	eval(yacas(unclass(x))[[1]], env = env)

Simplify <- function(x, ...) UseMethod("Simplify")
Simplify.default <- function(x, ...) Sym("Simplify(", x, ")")

Factorial <- function(x) UseMethod("Factorial")
Factorial.default <- function(x) Sym("Factorial(", x, ")")

List <- function(x, ...) UseMethod("List")
List.default <- function(x, ...) Sym("List(", paste(x, ..., sep = ","), ")")

N <- function(x, ...) UseMethod("N")
N.default <- function(x, ...) Sym("N(", paste(x, ..., sep = ","), ")")

Pi <- Sym("Pi")

Ver <- function(x) UseMethod("Ver")
Ver.default <- function(x) Sym("Version()")

Clear <- function(x, ...) UseMethod("Clear")
Clear.default <- function(x, ...) Sym("Clear(", x, ")")

Factor <- function(x) UseMethod("Factor")
Factor.default <- function(x) Sym("Factor(", x, ")")

Expand <- function(x, ...) UseMethod("Expand")
Expand.default <- function(x, ...) Sym("Expand(", x, ")")

Taylor <- function(f, ...) UseMethod("Taylor")
Taylor.default <- function(f, x, a, n, ...) 
	Sym("Taylor(", x, ",", a, ",", n, ")", f) 

InverseTaylor <- function(x, ...) UseMethod("Taylor")
InverseTaylor.default <- function(f, x, a, n, ...) 
	Sym("InverseTaylor(", x, ",", a, ",", n, ")", f) 

PrettyForm <- function(x, ...) UseMethod("PrettyForm")
PrettyForm.default <- function(x, ...) Sym("PrettyForm(", x, ")")

TeXForm <- function(x, ...) UseMethod("TeXForm")
TeXForm.default <- function(x, ...) Sym("TeXForm(", x, ")")

Precision <- function(x, ...) UseMethod("Precision")
Precision.default <- function(x, ...) Sym("Precision(", x, ")")

Conjugate <- function(x, ...) UseMethod("Conjugate")
Conjugate.default <- function(x, ...) Sym("Conjugate(", x, ")")

PrettyPrinter <- function(x, ...) UseMethod("PrettyPrinter")
PrettyPrinter.default <- function(x, ...) {
	if (missing(x)) Sym("PrettyPrinter()")
	else Sym(paste('PrettyPrinter("', x, '")', sep = ""))
}

Solve <- function(x, ...) UseMethod("Solve")
Solve.default <- function(x, y, ...) Sym("Solve(", x, ",", y, ")")

Newton <- function(x, ...) UseMethod("Newton")
Newton.default <- function(x, ...) Sym("Newton(", paste(x, ..., sep = ","), ")")

Set <- function(x, value) {
	if (inherits(value, "expression")) 
		yacas(substitute(Set(x, value, as.list(match.call())[-1])))
	else
		yacas(unclass(Sym(deparse(substitute(x)), ":=", value)))
}

Infinity <- Sym("Infinity")
I <- Sym("I")

Limit <- function(f, ...) UseMethod("Limit")
Limit.default <- function(f, x, a, ...) Sym("Limit(", x, ",", a, ")", f)

Subst <- function(expr, ...) UseMethod("Subst")
Subst.default <- function(expr, x, replacement, ...) 
	Sym("Subst(", x, ",", replacement, ")", expr)

Inverse <- function(x, ...) UseMethod("Inverse")
Inverse.default <- function(x, ...) Sym("Inverse(", x, ")")

determinant.Sym <- function(x, ...) Sym("Determinant(", x, ")")

Identity <- function(x) UseMethod("Identity")
Identity.default <- function(x) Sym("Identity(", x, ")")

"%Where%" <- function(x, y) UseMethod("%Where%")
"%Where%.default" <- function(x, y) {
	Sym(x, "Where", paste("{", names(y)[[1]], "==", Sym(y[[1]]), "}"))
}

}
