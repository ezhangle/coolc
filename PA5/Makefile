#========================================================================
# FILE:
#   Makefile
#
# AUTHOR:
#   zimzum@github 
#
# DESCRIPTION:
#	The Makefile for building the code generator.
#
#   -------------------------------------
#   Sample usage
#   -------------------------------------
#   To build type the following in the current directory:
#
#   ~/cool/PA5$ make clean; make
#
#   All binaries, except for cgen, are build in the CGEN_BIN
#   directory. 
#	
#
# License: MIT
#========================================================================
#-----------------------
#  BIN DIR
#-----------------------
CGEN_BIN = bin

#-----------------------
#  SHELL COMMANDS
#-----------------------
MKDIR = mkdir -p

#-----------------------
#  SOURCE/OBJECT FILES
#-----------------------
source_files = cgen-phase.cc utilities.cc stringtab.cc dumptype.cc \
			   tree.cc cool-tree.cc ast-lex.cc ast-parse.cc \
			   handle_flags.cc cgen.cc cgen_supp.cc
object_files = $(patsubst %.cc, $(CGEN_BIN)/%.o, $(source_files))

#-----------------------
#  COMPILATION VARIABLES 
#-----------------------
CPPINCLUDE = -I./include/
CC         = g++
CFLAGS     = -g -Wall -Wno-unused -Wno-write-strings -Wno-deprecated ${CPPINCLUDE} -DDEBUG
LIB        = -lfl

#-----------------------
#  TARGETS
#-----------------------
cgen: ${chkdirs} ${object_files}
	${CC} ${CFLAGS} ${object_files} ${LIB} -o cgen

chkdirs:
	$(MKDIR) $(CGEN_BIN)

dotest:	cgen example.cl
	@echo "\nRunning code generator on example.cl\n"
	-./mycoolc example.cl

clean :
	-rm -f ${OUTPUT} *.s core ${object_files} cgen *~ *.a *.o

clean-compile:
	@-rm -f core ${object_files} 

#-----------------------
#  IMPLICIT RULES 
#-----------------------
bin/%.o: src/%.cc
	@echo "Dupa"
	${CC} ${CFLAGS} -c $< -o $@
