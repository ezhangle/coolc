#========================================================================
# FILE:
#   Makefile
#
# AUTHOR:
#   banach-space@github 
#
# DESCRIPTION:
#	The Makefile for building the lexer.
#
#   -------------------------------------
#   Sample usage
#   -------------------------------------
#   To build type the following in the current directory:
#
#   ~/cool/PA2$ make clean; make
#
#   All binaries, except for the lexer, are build in the LEX_BIN directory. 
#	
#
# License: MIT
#========================================================================
#-----------------------
#  BIN DIR
#-----------------------
LEX_BIN = bin

#-----------------------
#  SHELL COMMANDS
#-----------------------
MKDIR   = mkdir -p

#-----------------------
#  SOURCE/OBJECT FILES
#-----------------------
c_source_files    = lextest.cc utilities.cc stringtab.cc handle_flags.cc
cgen_source_files = cool-lex.cc
source_files      = ${c_source_files} ${cgen_source_files}
object_files      = $(patsubst %.cc, $(LEX_BIN)/%.o, $(source_files))

#-----------------------
#  TARGETS
#-----------------------
lexer: chkdirs ${object_files}
	${CC} ${CFLAGS} ${object_files} ${LIB} -o lexer

chkdirs:
	$(MKDIR) $(LEX_BIN)

#-----------------------
#  COMPILATION VARIABLES 
#-----------------------
CC = g++
CFLAGS = -g -Wall -Wno-unused -Wno-write-strings ${CPPINCLUDE}
FLEX = flex
CPPINCLUDE= -I. -I./include/ -I./src/ -I./bin/

# Added '--noyywrap', because it's not defined anywhere. I believe that the
# original intention  was to add '-lfs', which was assumed to define 'yywrap',
# but that's not the case for libfl.so that's on my system.
FFLAGS = --noyywrap -d -osrc/cool-lex.cc


#-----------------------
#  IMPLICIT RULES 
#-----------------------
bin/%.o: src/%.cc
	${CC} ${CFLAGS} -c $< -o $@

src/cool-lex.cc: src/cool.flex
	${FLEX} ${FFLAGS} src/cool.flex

clean :
	-rm -f  ${object_files} lexer src/cool-lex.cc
