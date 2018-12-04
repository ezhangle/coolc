coolc
========
[![Build Status](https://travis-ci.org/banach-space/coolc.svg?branch=master)](https://travis-ci.org/banach-space/coolc)

A compiler for the [COOL](http://theory.stanford.edu/~aiken/#teaching) -
Classroom Object Oriented Language invented by [Prof. Alex
Aiken](http://theory.stanford.edu/~aiken/) for his
[Compilers](https://web.stanford.edu/class/cs143/) class.

About
--------
I created this repository when I was studying for the Stanford [online
course](https://lagunita.stanford.edu/courses/Engineering/Compilers/Fall2014/about)
on compilers. All the source files were originally downloaded from the
course's website. I contributed by:

1. Completing the missing core bits (**lexer** and **parser**), as required for
   the course assignments
2. Major re-factoring of the `Makefiles` so that the sub-projects/assignments
   build nicely on any Linux machine and in Travis (as opposed to relying on the
   available VM)
3. Moving the files around so that the structure of the sub-rojects are a bit more
   straightforward (originally these projects were designed to use a lot of
   symlinks, which isn't very GitHub friendly)

At the point of creating this repository the original source files weren't
available on GitHub. Do let me know when that changes and I will fork such
project instead.

Completed assignments
---------------------
there are four programming assignments in this online course. Weirdly enough
the numbering starts at 2. Here's a quick summary of the assignments that I
have completed so far: 

1. **Lexer** (PA2)
  * status: completed
  * core files: PA2/src/cool.flex
  * Pass rate: 63/63
2. **Parser** (PA3)
  * status: completed
  * core files: PA3/cool.y
  * Pass rate: 65/70

How-to build and run
--------------------
In order to build, go to one of the sub-directories (e.g. `PA2`) and run `make`:
```
$ make
```
This will build the corresponding binary (e.g. `lexer` or `parser`). In order to
run the tests available with the course, run the following `perl` script:
```
$ perl pa<ID>-grading.pl
```
where <ID> is the assignment number. Note that the parser requires a lexer to
be present in the same directory. You can use the lexer from PA2.

Technicalities
--------------
Developed and tested under Linux (4.6.0) with GCC (6.1.1). As far as I can tell
this should work on any relatively up-to-date Linux.
