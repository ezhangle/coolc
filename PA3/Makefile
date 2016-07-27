
ASSN = 3
CLASS= cs143
CLASSDIR= /usr/class/cs143/cool
# LIB= -lfl
AR= gar
ARCHIVE_NEW= -cr
RANLIB= gar -qs

SRC= cool.y cool-tree.handcode.h good.cl bad.cl README
CSRC= parser-phase.cc utilities.cc stringtab.cc dumptype.cc \
      tree.cc cool-tree.cc tokens-lex.cc  handle_flags.cc 
TSRC= myparser mycoolc cool-tree.aps
CGEN= cool-parse.cc
HGEN= cool-parse.h
LIBS= lexer semant cgen
CFIL= ${CSRC} ${CGEN}
HFIL= cool-tree.h cool-tree.handcode.h 
LSRC= Makefile
PARSER_BIN = bin
OBJS= $(patsubst %.cc, $(PARSER_BIN)/%.o, $(CFIL))
OUTPUT= good.output bad.output


CPPINCLUDE= -Iinclude/

BFLAGS = -d -v -y -b cool --debug -p cool_yy

CC=g++
CFLAGS=-g -Wall -Wno-unused -Wno-deprecated -Wno-write-strings -DDEBUG ${CPPINCLUDE}
FLEX=flex ${FFLAGS}
BISON= bison ${BFLAGS}
DEPEND = ${CC} -MM ${CPPINCLUDE}

source: ${SRC} ${TSRC} ${LIBS} lsource

lsource: ${LSRC}

${OUTPUT}:	parser good.cl bad.cl
	@rm -f ${OUTPUT}
	./myparser good.cl >good.output 2>&1 
	-./myparser bad.cl >bad.output 2>&1 

parser: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} ${LIB} -o parser

bin/%.o: src/%.cc
	${CC} ${CFLAGS} -c $< -o $@

src/cool-parse.cc cool-parse.h: cool.y
	bison ${BFLAGS} cool.y
	mv -f cool.tab.c src/cool-parse.cc

dotest:	parser good.cl bad.cl
	@echo "\nRunning parser on good.cl\n"
	-./myparser good.cl 
	@echo "\nRunning parser on bad.cl\n"
	-./myparser bad.cl

${LIBS}:
	${CLASSDIR}/etc/link-object ${ASSN} $@

# These dependencies allow you to get the starting files for
# the assignment.  They will not overwrite a file you already have.

${SRC} :								
	-${CLASSDIR}/etc/copy-skel ${ASSN} ${SRC}

${LSRC} :
	-${CLASSDIR}/etc/link-shared ${ASSN} ${LSRC}

submit-clean: ${OUTPUT}
	-rm -f *.s core ${OBJS} ${CGEN} ${HGEN} lexer *~ parser cgen semant

clean :
	-rm -f ${OUTPUT} *.s core ${OBJS} ${CGEN} ${HGEN} lexer parser cgen semant *~ *.a *.o 

clean-compile:
	@-rm -f core ${OBJS} ${CGEN} ${HGEN} ${LSRC}

-include ${CFIL:.cc=.d}