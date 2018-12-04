#========================================================================
# FILE:
#   Makefile
#
# AUTHOR:
#   banach-space@github 
#
# DESCRIPTION:
#	The Makefile for building the semantic analysis phase.
#
#   -------------------------------------
#   Sample usage
#   -------------------------------------
#   To build type the following in the current directory:
#
#   ~/cool/PA4$ make clean; make
#
#   All binaries, except for the parser, are build in the SEMANT_BIN
#   directory. 
#	
#
# License: MIT
#========================================================================
#-----------------------
#  BIN DIR
#-----------------------
SEMANT_BIN = bin

#-----------------------
#  SOURCE/OBJECT FILES
#-----------------------
source_files = semant-phase.cc handle_flags.cc\
			   ast-lex.cc ast-parse.cc utilities.cc stringtab.cc\
			   dumptype.cc tree.cc cool-tree.cc semant.cc

object_files = $(patsubst %.cc, $(SEMANT_BIN)/%.o, $(source_files))

#-----------------------
#  SHELL COMMANDS
#-----------------------
MKDIR   = mkdir -p

# No idea what category is this
OUTPUT= good.output bad.output

#-----------------------
#  COMPILATION VARIABLES 
#-----------------------
CPPINCLUDE = -I. -I./include/ -I./src/
CC = g++
CFLAGS = -g -O0 -Wall -Wno-unused -Wno-write-strings ${CPPINCLUDE} -DDEBUG

#-----------------------
#  TARGETS
#-----------------------
semant: chkdirs ${object_files} lexer parser cgen
	${CC} ${CFLAGS} ${object_files} ${LIB} -o semant

${OUTPUT}: semant
	@rm -f ${OUTPUT}
	./mysemant good.cl >good.output 2>&1 
	-./mysemant bad.cl >bad.output 2>&1 

symtab_example: src/symtab_example.cc 
	${CC} ${CFLAGS} src/symtab_example.cc ${LIB} -o symtab_example

.cc.o:
	${CC} ${CFLAGS} -c $<

dotest:	semant good.cl bad.cl
	@echo "\nRunning semantic checker on good.cl\n"
	-./mysemant good.cl
	@echo "\nRunning semantic checker on bad.cl\n"
	-./mysemant bad.cl

# These dependencies allow you to get the starting files for
# the assignment.  They will not overwrite a file you already have.

submit-clean: ${OUTPUT}
	-rm -f *.s core ${object_files} semant symtab_example

clean :
	-rm -f ${OUTPUT} *.s core ${object_files} semant cgen symtab_example parser lexer *~ *.a *.o

clean-compile:
	@-rm -f core ${object_files}

#-----------------------
#  IMPLICIT RULES 
#-----------------------
bin/%.o: src/%.cc
	${CC} ${CFLAGS} -c $< -o $@

chkdirs:
	$(MKDIR) $(SEMANT_BIN)
