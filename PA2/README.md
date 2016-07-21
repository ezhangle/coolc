coolc
========

A compiler for the Cool programming language.

About
--------
This repository contains my solutions to the programming assignments for the
online course on [Compilers](https://lagunita.stanford.edu/courses/Engineering/Compilers/Fall2014/about).
All the source files were originally downloaded from the course's website. I
contributed by:
1. Filling in the missing core bits (summarised in the next section) to pass the
   assignments;
2. Modifying and simplifying Makefiles so that these sub-projects build nicely
   on my Linux machine;
3. Moving the files around so that the structure of the projects is a bit more
   straightforward (originally these projects were designed to use a lot of
   symlinks, which isn't very GitHub friendly).

Sub-projects
------------
In this online course there are four programming assignments. Weirdly enough
the numbering starts at 2 (consult the course's content for explanation).
Here's a quick summary of each project with a list of files that I had to
modify in order to pass the assignment.
1. **Lexer** (PA2)
    ..* core files: PA2/src/cool.flex
    ..* Pass rate: 63/63
2. **Parser** (PA3)
    ..* Not yet started
    ..* Pass rate: ?

How-to
-------
Go to one of the subdirectories and type
```
$ make
```
This will build the corresponding binary. In order to run the tests shipped
with the course, run the following perl script:
```
$ perl pa<id>-grading.pl
```
where <id> is the assignment number.

Technicalities
--------------
Developed and tested under Linux (4.6.0) with GCC (6.1.1)
