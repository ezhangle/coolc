/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
int nesting_level = 0;

%}

/*
 * Define names for regular expressions here.
 */

CLASS           (?i:class)
ELSE            (?i:else)
FI              (?i:fi)
IF              (?i:if)
IN              (?i:in)
INHERITS        (?i:inherits)
LET             (?i:let)
LOOP            (?i:loop)
POOL            (?i:pool)
THEN            (?i:then)
WHILE           (?i:while)
CASE            (?i:case)
ESAC            (?i:esac)
OF              (?i:of)
DARROW          =>
NEW             (?i:new)
ISVOID          (?i:isvoid)
STR_CONST       "[a-zA-Z0-9 \t\n\f\r\v]*"
INT_CONST       [0-9]+
BOOL_CONST      (t(?i:rue))|(f(?i:alse))
TYPEID          [A-Z][a-zA-z0-9_]*
OBJECTID        [a-z][a-zA-z0-9_]*
ASSIGN          <-
NOT             (?i:not)
LE              <=|<|=
ERROR           error

WHITESPACE      [ \t\f\r\v]
NEWLINE         \n
COMMENT_INLINE  --.*\n
COMMENT_START   "(*"
COMMENT_END     "*)"

%x COMMENT_BLOCK
%%

 /*
  *  Nested comments
  */
{COMMENT_START} { 
    BEGIN(COMMENT_BLOCK);
    nesting_level++;
    }
<COMMENT_BLOCK>{COMMENT_END} {
    nesting_level--;
    if (nesting_level == 0)
        BEGIN(INITIAL); 
}
<COMMENT_BLOCK>\n {++curr_lineno;}
<COMMENT_BLOCK><<EOF>> {
    cool_yylval.error_msg = "EOF in comment";
    BEGIN(INITIAL);
    return ERROR;
}
<COMMENT_BLOCK>. {;}
{COMMENT_END} { 
    cool_yylval.error_msg = "Unmatched *)";
    return ERROR;
}


 /*
  *  The multiple-character operators.
  */
{DARROW}        { return (DARROW); }
{IF}            { return (IF);}
{ELSE}          { return (ELSE);}
{INHERITS}      { return (INHERITS);}
{WHITESPACE}    { ;}
{NEWLINE} { 
    ++curr_lineno;
}
{CLASS}         { return(CLASS);}
{FI}            { return(FI);}
{LET}           { return(LET);}
{LOOP}          { return(LOOP);}
{POOL}          { return(POOL);}
{THEN}          { return(THEN);}
{IN}            { return(IN);}
{WHILE}         { return(WHILE);}
{CASE}          { return(CASE);}
{ESAC}          { return(ESAC);}
{OF}            { return(OF);}
{NEW}           { return(NEW);}
{ISVOID}        { return(ISVOID);}
{STR_CONST}     { return(STR_CONST);}
{INT_CONST} {
    cool_yylval.symbol = inttable.add_string(yytext);
    return INT_CONST;
}
{BOOL_CONST} {
    cool_yylval.symbol = inttable.add_string(yytext);
    return(BOOL_CONST);
}
{TYPEID} { 
    cool_yylval.symbol = inttable.add_string(yytext);
    return(TYPEID);
}
{ASSIGN}        { return(ASSIGN);}
{NOT}           { return(NOT);}
{LE}            { return(LE);}
{OBJECTID} {
    cool_yylval.symbol = inttable.add_string(yytext);
    return(OBJECTID);
}

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */


 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */


%%
