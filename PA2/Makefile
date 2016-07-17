
ASSN = 2
CLASS= cs143
CLASSDIR= /usr/class/cs143/cool
# The libfl library doesn't define any symbols and passing this option to the
# linker only causes trouble. I suspect that in the past it would define some
# symbols (e.g. yylex and yywrap), but it no longer does. libfl.a does
# instead, but I'm unclear as how to obtain it withou building flex manually.
#LIB= -lfl

SRC= cool.flex src/test.cl README
CSRC= lextest.cc utilities.cc stringtab.cc handle_flags.cc
HSRC= 
CGEN= cool-lex.cc
HGEN=
LIBS= parser semant cgen
CFIL= ${CSRC} ${CGEN}
LSRC= Makefile
OBJS= ${CFIL:.cc=.o}
OUTPUT= test.output

CPPINCLUDE= -I. -I./include/ -I./src/


# Added '--noyywrap', because it's not defined anywhere. I believe that the
# original intention  was to add '-lfs', which was assumed to define 'yywrap',
# but that's not the case for libfl.so that's on my system.
FFLAGS= --noyywrap -d -osrc/cool-lex.cc

CC=g++
CFLAGS= -g -Wall -Wno-unused -Wno-write-strings ${CPPINCLUDE}
FLEX=flex ${FFLAGS}
DEPEND = ${CC} -MM ${CPPINCLUDE}

%.o: src/%.cc
	@echo Compile
	${CC} ${CFLAGS} -c $<

${OUTPUT}: lexer src/test.cl
	@echo Compile
	@rm -f test.output
	-./lexer src/test.cl >test.output 2>&1

lexer: ${OBJS}
	@echo Compile2
	${CC} ${CFLAGS} ${OBJS} ${LIB} -o lexer


src/cool-lex.cc: src/cool.flex
	@echo Compile
	${FLEX} src/cool.flex

dotest: lexer src/test.cl
	./lexer src/test.cl

${LIBS}:
	@echo Compile
	${CLASSDIR}/etc/link-object ${ASSN} $@

# These dependencies allow you to get the starting files for
# the assignment.  They will not overwrite a file you already have.

submit-clean: ${OUTPUT}
	-rm -f *.s core ${OBJS} lexer cool-lex.cc *~ parser cgen semant

clean :
	-rm -f ${OUTPUT} *.s core ${OBJS} lexer cool-lex.cc *~ parser cgen semant

clean-compile:
	@-rm -f core ${OBJS} cool-lex.cc ${LSRC}

%.d: %.cc ${SRC} ${LSRC}
	${SHELL} -ec '${DEPEND} $< | sed '\''s/\($*\.o\)[ :]*/\1 $@ : /g'\'' > $@'

-include ${CFIL:.cc=.d}


