#========================================================================
# FILE:
#   Makefile
#
# AUTHOR:
#   zimzum@github 
#
# DESCRIPTION:
#	The Makefile for building the parser.
#
#   -------------------------------------
#   Sample usage
#   -------------------------------------
#   To build type the following in the current directory:
#
#   ~/cool/PA3$ make clean; make
#
#   All binaries, except for the parser, are build in the PARSER_BIN
#   directory. 
#	
#
# License: MIT
#========================================================================
#-----------------------
#  BIN DIR
#-----------------------
PARSER_BIN = bin

#-----------------------
#  SOURCE/OBJECT FILES
#-----------------------
source_files = parser-phase.cc utilities.cc stringtab.cc dumptype.cc \
			   tree.cc cool-tree.cc tokens-lex.cc  handle_flags.cc \
			   cool-parse.cc

object_files = $(patsubst %.cc, $(PARSER_BIN)/%.o, $(source_files))


#-----------------------
#  COMPILATION VARIABLES 
#-----------------------
BFLAGS     = -d -v -y -b cool --debug -p cool_yy
CC         = g++
CFLAGS     = -g -Wall -Wno-unused -Wno-deprecated -Wno-write-strings -DDEBUG ${CPPINCLUDE}
CPPINCLUDE = -Iinclude/


#-----------------------
#  TARGETS
#-----------------------
parser: $(chkdirs) ${object_files}
	${CC} ${CFLAGS} ${object_files} ${LIB} -o parser

#-----------------------
#  IMPLICIT RULES 
#-----------------------
bin/%.o: src/%.cc
	${CC} ${CFLAGS} -c $< -o $@

chkdirs:
	$(MKDIR) $(LEX_BIN)

src/cool-parse.cc cool-parse.h: cool.y
	bison ${BFLAGS} cool.y
	mv -f cool.tab.c src/cool-parse.cc

clean :
	-rm -f  *.s core ${object_files} parser  *~ *.a *.o
