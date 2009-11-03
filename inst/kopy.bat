
rem This batch file only works on the author's system and is used
rem for copying jython and sympy to the rSymPy tree.
rem
rem To use edit the:
rem 1. 1st line to change directory to folder constaining rSymPy source folder
rem 2. 1st xcopy line to identify the jython source tree
rem 3. 2nd xcopy line to identify the sympy tree

:: gor.bat changes directory to the R development area
call gor svn rSympy inst
copy \jython2.5.1\jython.jar jython.jar

:: The following xcopy arguments are used:
:: /e = recursively copy including empty directories
:: /i = target is directory to be created if not already present
if not exist Lib md Lib
if not exist Lib\sympy md Lib\sympy
xcopy /e /i \tmp2\sympy-0.6.5\sympy Lib\sympy
