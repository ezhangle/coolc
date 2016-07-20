# The libfl library doesn't define any symbols and passing this option to the
# linker only causes trouble. I suspect that in the past it would define some
# symbols (e.g. yylex and yywrap), but it no longer does. libfl.a does
# instead, but I'm unclear as how to obtain it withou building flex manually.
#LIB= -lfl

SRC= cool.flex src/test.cl README
CSRC= lextest.cc utilities.cc stringtab.cc handle_flags.cc
CGEN= cool-lex.cc
CFIL= ${CSRC} ${CGEN}
LSRC= Makefile
OBJS= ${CFIL:.cc=.o}
OUTPUT= test.output
LEX_BIN = bin

CPPINCLUDE= -I. -I./include/ -I./src/ -I./bin/

#-----------------------
#  SHELL COMMANDS
#-----------------------
MKDIR   = mkdir -p

#-----------------------
#  SOURCE/OBJECT FILES
#-----------------------
c_source_files = lextest.cc utilities.cc stringtab.cc handle_flags.cc
cgen_source_files = cool-lex.cc
source_files = ${c_source_files} ${cgen_source_files}
object_files = $(patsubst %.cc, $(LEX_BIN)/%.o, $(source_files))

#-----------------------
#  TARGETS
#-----------------------
chkdirs:
	$(MKDIR) $(LEX_BIN)


#-----------------------
#  COMPILATION VARIABLES 
#-----------------------
# Added '--noyywrap', because it's not defined anywhere. I believe that the
# original intention  was to add '-lfs', which was assumed to define 'yywrap',
# but that's not the case for libfl.so that's on my system.
FFLAGS= --noyywrap -d -osrc/cool-lex.cc

CC=g++
CFLAGS= -g -Wall -Wno-unused -Wno-write-strings ${CPPINCLUDE}
FLEX=flex ${FFLAGS}
DEPEND = ${CC} -MM ${CPPINCLUDE}

#-----------------------
#  IMPLICIT RULES 
#-----------------------
bin/%.o: src/%.cc
	${CC} ${CFLAGS} -c $< -o $@

lexer: ${chkdirs} ${object_files}
	${CC} ${CFLAGS} ${object_files} ${LIB} -o lexer

src/cool-lex.cc: src/cool.flex
	${FLEX} src/cool.flex

# These dependencies allow you to get the starting files for
# the assignment.  They will not overwrite a file you already have.

clean :
	-rm -f  *.s core ${OBJS} lexer src/cool-lex.cc *~ parser cgen semant

clean-compile:
	@-rm -f core ${OBJS} src/cool-lex.cc ${LSRC}

%.d: %.cc ${SRC} ${LSRC}
	${SHELL} -ec '${DEPEND} $< | sed '\''s/\($*\.o\)[ :]*/\1 $@ : /g'\'' > $@'

-include ${CFIL:.cc=.d}


