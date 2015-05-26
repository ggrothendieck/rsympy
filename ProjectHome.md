_In real life, I assure you, there is no such thing as algebra._ --- [Fran Lebowitz](http://en.wikipedia.org/wiki/Fran_Lebowitz)

[rSymPy](http://cran.r-project.org/web/packages/rSymPy/index.html) (googlecode name rsympy) is an [R](http://www.r-project.org) package giving R users access to the [SymPy](http://sympy.googlecode.com) computer algebra system (CAS) running on [Jython](http://www.jython.org) (java-hosted python) from within R.  The state of the SymPy session is maintained between calls.  rSymPy is available on [CRAN](http://cran.r-project.org/web/packages/rSymPy/index.html), the Comprehensive R Archive Network.

[rSymPy](http://cran.r-project.org/web/packages/rSymPy/index.html), [R](http://www.r-project.org), [SymPy](http://sympy.googlecode.com), [Jython](http://www.jython.org), the CRAN package [rJava](http://cran.r-project.org/web/packages/rJava/index.html) (which provides the lower level interface from R to java) and [Java](http://java.com) itself are all free software.

Below on this page are sections on:


## News ##

Aug 1/10.  rSymPy 0.1-2.1 is now on [CRAN](http://cran.r-project.org/web/packages/rSymPy/index.html) and should appear on the mirrors shortly.  For this version of rSymPy the Jython interface and Jython itself have been moved to a separate CRAN package, [rJython](http://cran.r-project.org/web/packages/rSymPy/index.html), upon which rSymPy now depends.

Nov 3/09. rSymPy 0.1-4 is now in the svn repository and uploaded to CRAN. It works with R-2.10.0 (also R-2.9.2) and rJava 0.8-1 and includes jython 2.5.1 and sympy 0.6.5 in the package .  The size of the rSymPy 0.1-4 distribution has been reduced from 15MB in older distributions to 10MB for 0.1-4.

Aug 21/09. [SymPy tutorial](http://github.com/certik/scipy09-tutorial/blob/74bbbdd7988a6060dc1502abe78a97a7996dc83e/tut.py). See tut.py at that link.

May 26/09. SymPy [SoC plans](http://groups.google.com/group/sympy/msg/60c56df6eddc0be8)

May 20/09.  Slightly simpllified the [Semi-Automatic Differentiation](http://code.google.com/p/rsympy/#Semi-Automatic_Differentiation) examples.

Apr 16/09.  Added example of [Semi-Automatic Differentiation](http://code.google.com/p/rsympy/#Semi-Automatic_Differentiation) on this page.

Jan 11/09. rSymPy 0.1-2 is now on the [CRAN](http://cran.r-project.org/web/packages/rSymPy/index.html).  The primary difference between it and older versions is that now rSymPy uses and includes Jython 2.5b1.  This seems to clear up all the Jython problems that we previously encountered under Jython 2.5b0 except that on Vista one must still start R as Administrator in order to use rSymPy.

Jan 10/09.  jython and sympy removed from svn repository (Source tab) above; however, they are still distributed in the rSymPy [package](http://cran.r-project.org/web/packages/rSymPy/index.html) from CRAN in order to simplify installation.

Jan 4/09.  Added more info to [Troubleshooting](http://code.google.com/p/rsympy/#Troubleshooting) section.

Jan 1/09.  Added a new [Installation from CRAN](http://code.google.com/p/rsympy/#Installation_from_CRAN) section below and added new Troubleshooting information for Linux/Debian in the [Troubleshooting](http://code.google.com/p/rsympy/#Troubleshooting) section below with thanks to Ben Goodrich.

Dec 16/08.  A few weeks ago the [SymPy](http://sympy.googlecode.com) project issued a new release that for the first time supports [Jython](http://www.jython.org).  Since [R](http://www.r-project.org) has a Java interface ([rJava](http://www.rforge.net/rJava/)) we put the two together to create this project.  Today we have uploaded an initial version of rSymPy to Google Code.  Some testing has been done on Windows Vista and one user has successfully run it on Linux/Debian.  There is nothing that is knowingly operating system specific so it may run on the Mac too but this has not been tested.
## Citation ##
To get the citation for this package use the R command:
```
citation("rSymPy")
```
## Sample R Session ##
### Minimal Example ###
```
library(rSymPy)
sympy("var('x')")
sympy("y = x*x") # output is x**2
sympy("y") # same
```
or using Sym class:
```
library(rSymPy)
x <- Var("x")
y <- x*x
y
```
Also note that one can run general Python code via the `.Jython` interface:
```
> .Jython$exec("x = 1")
> .Jython$exec("if x == 1:
+    z = 2
+ else:
+    z = 3")
> z <- .Jython$get("z")
> .jstrVal(z)
[1] "2"
```
This makes use of the rJython package (which is automatically loaded by rSymPy) and was once part of rSymPy but has since been factored out into its own package.

### Matrix Manipulation ###
```
library(rSymPy)
a1 <- Var("a1")
a2 <- Var("a2")
a3 <- Var("a3")
a4 <- Var("a4")
A <- Matrix(List(a1, a2), List(a3, a4))

#define inverse and determinant
Inv <- function(x) Sym("(", x, ").inv()")
Det <- function(x) Sym("(", x, ").det()")

A
Inv(A)
Det(A)
```
### Define Exp ###
```
library(rSymPy)
x <- Var("x")
Exp <- function(x) Sym("exp(", x, ")") 
Exp(-x) * Exp(x) 
```

### SymPy Version ###
```
# shows which version of SymPy is being used
library(rSymPy)
.Jython$exec("import sympy")
.Jython$exec("z = sympy.__dict__['__version__']")
z <- .Jython$get("z")
.jstrVal(z)
```
### Semi-Automatic Differentiation ###
John Nash suggested the following classic function to differentiate.  True Automatic Differentiation (AD) would be to input the function and output another function that represents its gradient.  While rSymPy is aimed at symbolic calculation rather than AD we can perform semi-automatic AD by reducing the function to be differentiated to a single line given `n`, the length of the 'x' argument, using rSymPy and then use rSymPy again to symbolically differentiate that.  Finally, we can package it up as an R function.  Here is the function we wish to differentiate:
```
broydt.f <- function(x) {
 n <- length(x)
 res <- rep(NA, n)
 res[1] <- ((3 - 0.5*x[1]) * x[1]) - 2*x[2] + 1
 tnm1 <- 2:(n-1)
 res[tnm1] <- ((3 - 0.5*x[tnm1]) * x[tnm1]) - x[tnm1-1] - 2*x[tnm1+1] + 1
 res[n] <- ((3 - 0.5*x[n]) * x[n]) - x[n-1] + 1
 result <- 0 
 for(i in 1:n) result <- result + res[i] * res[i]
 result
}
```
Now we show how to differentiate that function in R using rSymPy.
Below, the `res <- x <- line` defines `x[[1]], x[[2]], x[[3]]` as Sym variables
in R.  `x[[1]]` holds `x1`, etc.  Then, in the subsequent lines
we define `res[[1]], ..., res[[3]]` using ordinary formulas
and finally define `result` also using the ordinary formula.
We then differentiate it with respect to each variable
The first `sapply` differentiates it with each variable in `x`
on three successive lines.  The `gsub` replaces variables of
the form `x3` with the form `x[3]`.   Finally we create the
function as a character string and then parse and evaluate
it to produce an R function.  First we show an example
with `n=3`:
```
library(rSymPy)

# x holds R symbolic variables corresponding to sympy variables x1, x2, x3 
g2 <- res <- x <- list(Var("x1"), Var("x2"), Var("x3"))

res[[1]] <- ((3 - 0.5*x[[1]]) * x[[1]]) - 2*x[[2]] + 1
res[[2]] <- ((3 - 0.5*x[[2]]) * x[[2]]) - x[[1]] - 2*x[[3]] + 1
res[[3]] <- ((3 - 0.5*x[[3]]) * x[[3]]) - x[[2]] + 1
result <- res[[1]] * res[[1]] + res[[2]] * res[[2]] + res[[3]] * res[[3]]

g2[[1]] <- sympy(deriv(result, x[[1]]))
g2[[2]] <- sympy(deriv(result, x[[2]]))
g2[[3]] <- sympy(deriv(result, x[[3]]))

g3 <- gsub("x([0-9]+)", "x[\\1]", g2)
grad <- function(x) {}
body(grad) <- parse(text = sprintf("c(%s)", toString(g3)))

```

and now we encode the repeated parts in loops and show it for `n=5`.  **If you wish to apply this code to another function (of a vector x) of your choosing then just replace the indented lines.**

```
library(rSymPy)

   n <- 5

# x is vector such that x[[1]] holds symbolic variable 
# corresponding to x1, x[[2]] to x2, etc.
res <- x <- lapply(sprintf("x%d", 1:n), Var)

   res[[1]] <- ((3 - 0.5*x[[1]]) * x[[1]]) - 2*x[[2]] + 1
   for(i in 2:(n-1)) res[[i]] <- ((3 - 0.5*x[[i]]) * x[[i]]) - x[[i-1]] - 2*x[[i+1]] + 1
   res[[n]] <- ((3 - 0.5*x[[n]]) * x[[n]]) - x[[n-1]] + 1
   result <- 0
   for(i in 1:n) result <- result + res[[i]] * res[[i]]

# symbolically differentiate with respect to each component of x
g2 <- lapply(x, function(xi) sympy(deriv(result, xi)))

# in R function x1 should be referred to as x[1], x2 as x[2], etc.
g3 <- gsub("x([0-9]+)", "x[\\1]", g2)

# define grad as an R function
grad <- function(x) {}
body(grad) <- parse(text = sprintf("c(%s)", toString(g3)))
```

For another similar example of semiautomatic differentiation see: https://stat.ethz.ch/pipermail/r-help/2009-May/198054.html

A variety of other examples, not necessarily related to differentiation, are at the end of the [help file](http://rsympy.googlecode.com/svn/trunk/man/sympy.Rd) in the rSymPy package.  There is also an example (requiring the devel version of rSymPy, see source() statement in last example above) [here](https://stat.ethz.ch/pipermail/r-help/2009-April/196071.html).

## Troubleshooting ##

### Current ###

1. rSymPy startup is very slow.  This is due to problems with how the rJava package unpacks jython.jar.  While it does not cause wrong results it does dramatically increase the startup time.  The development version of rJava already has a fix for this and once this version of rJava is released the startup should speed up substantially.

2. Java version. One user had problems with an old version of java.  If you have problems make sure the latest version of java is installed.  It is known that Sun Java 1.6.0\_13 works and likely any newer versions than that work too (and possibly certain older versions as well).  For example, I am currently running 1.6.0\_17 on Vista and it works.  To discover the version of java on your machine try this at the command line (not in R):
```
java -version
```
or use your browser to go to http://www.javatester.org/version.html .   The latest version of Java can be downloaded from Sun at http://www.java.com/en/download/index.jsp .

3. Bad .Rysmpy.  Any time sympy interaction is requested it checks whether the `.Rsympy` variable exists in the workspace and if not it concludes that SymPy has not been started and starts it by calling `sympyStart()`.  If a session goes bad and you have a left over `.Rsympy` variable prior to starting rSymPy you will need to manually remove it first (or else it will never start SymPy):
```
ls(all = TRUE)
rm(.Rsympy)
```

4. Linux. For Linux there are some tips regarding installing Java [here](https://stat.ethz.ch/pipermail/r-help/2009-July/203793.html).

### Old (no longer a problem) ###

The problems below were all encountered under rSymPy 0.1-0 and as far as we know they are all solved in rSymPy 0.1-4 but we are going to leave them here at least for a while just in case they do appear.

#### All Operating Systems ####

You may get a warning message about `cache dir` when you start up.  This is discussed in the [Jython FAQ](http://www.jython.org/Project/userfaq.html#why-do-i-get-the-error-can-t-create-package-cache-dir-cachedir-packages).   As far as I can tell it can simply be ignored.

This example which is one of the examples in the sympy [help file](http://rsympy.googlecode.com/svn/trunk/man/sympy.Rd) gives a recursion depth error:
```
sympy("var('x')")
sympy("(1/cos(x)).series(x, 0, 10)")
```
It seems to work when used under python/sympy directly but similarly fails when used with jython/sympy (without R) so it seems to be a bug in jython.

#### Windows ####
One XP user reported the same unicode problem listed under [Linux/Debian](http://code.google.com/p/rsympy/#Linux/Debian) below.  See that section for three different solutions.  (Note that a version of touch for Windows is available in the [Rtools](http://www.murdoch-sutherland.com/Rtools/) download.)

If you get a message about not being able to find jvm.dll then reboot your system and try again.

With older versions of rSymPy under Windows Vista it could be necessary to start R as Administrator in order to run rSymPy.  To do that right click the R icon on the Windows Vista Desktop and choose Run As Administrator.  Another possibility is to use the `el.js` and `Rgui.bat` scripts from [batchfiles](http://batchfiles.googlecode.com) at the Windows cmd console:
```
el cmd
rem in the new command window that is started enter
Rgui
```

#### Linux/Debian ####
There is a bug in Jython relating to the use of unicode. See [Bug 3684](http://bugs.jython.org/msg3684) in the [jython bugs list](http://bugs.jython.org).  Ben Goodrich found that he could circumvent this problem using any one of the following three alternate approaches:

(1) Issue the shell command (this only has to be done once):
```
touch /usr/local/lib/R/site-library/rSymPy/jython/Lib/unicodedata.py
```
If your installation is at a different location you can use the shell command `mlocate unicodedata.py` to find the file path.  This is the best of the three alternatives since it does not involve modifying any source code; however, if it does not work for you try the others.

(2) alternately, put:
```
# -*- coding: utf-8 -*-
```
on the first line of `/usr/local/lib/R/site-library/rSymPy/jython/Lib/unicodedata.py`.

(3) alternately replace line 42 of `/usr/local/lib/R/site-library/rSymPy/jython/Lib/unicodedata.py` with the following (i.e. replace the calculated path with the correct hard coded path):
```
      # open(os.path.join(path, 'UnicodeData.txt'))
      open('/usr/local/lib/R/site-library/rSymPy/jython/Lib/UnicodeData.txt')
```
If your installation is at a different location you can use the shell command `mlocate unicodedata.py` to find the file path.

## Installation from CRAN - its just one line ##

Make sure you have Java installed on your machine (you don't need python, jython or sympy as they are already included) and then type one line into R:
```
install.packages("rSymPy")
```
That's it!

This installs rSymPy, which includes both SymPy and Jython, and also installs the rJava package if not already installed.

Linux Users:  On Linux your Java installation should be Sun's Java; ensure that you have installed JDK and not just JRE and that the shell environment variable JAVA\_HOME is pointed to your JDK.  See the [Troubleshooting section](#Current.md) on this page for more.

## Installation from Source - not needed by most users ##

### All Operating Systems ###

Most people will install directly from CRAN using `install.packages` and won't need this section.

Note that the source tree includes jython 2.5b0 and sympy 0.63 thus the basic installation procedure is simply to ensure that Java is installed, grab the source from the [source tab](http://code.google.com/p/rsympy/source/checkout) above using any [svn client](http://en.wikipedia.org/wiki/Comparison_of_Subversion_clients) and then build the resulting R package just as you would any R source package.

The instructions below basically just add info on how to install an R source package but there is nothing special about this one and if you already know how to do that this one is   installed in the same way.

### Windows ###

First ensure that you have Java installed.  The remainder of these instructions are just the instructions for installing any R package from source.  There is nothing special that this package requires for installation.  In particular, it includes jython and sympy so these need not be separately installed.

Download the package from [CRAN](http://cran.r-project.org/web/packages/rSymPy/index.html) and if you want the very latest development version use any [subversion](http://subversion.tigris.org/) client, e.g. [TortoiseSVN](http://tortoisesvn.tigris.org/), to download the source code from this site (see Source tab above) and overwrite the corresponding files from CRAN.  Once you do that rSymPy will contain a DESCRIPTION file and inst, man and R folders.  (The svn repository does not include jython and symp but the CRAN packages do which is why we need to combine them.)

Most R users will already have the next three but if you don't already have the following make sure you have [R](http://www.r-project.org), [Rtools](http://www.murdoch-sutherland.com/Rtools/) and [MiKTeX](http://miktex.org/) installed.  They all have automated Windows installers so they are all easy to install.

Place `Rcmd.bat` from [batchfiles](http://batchfiles.googlecode.com) somewhere on your PATH.  Then issue this command from the Windows console which will install rSymPy, Jython and SymPy:
```

Rcmd INSTALL rSymPy


```
To Run rSymPy right click the R icon and choose Run As Administrator.  At R's console enter this:
```
# next line only needs to be done once to download
# and install rJava package
install.packages("rJava")

library(rSymPy)
# next line gives a screen of help and examples at end
?sympy
sympy("var('x')")
sympy("y = x*x")
sympy("y")
```

### UNIX/Linux ###


### Mac ###