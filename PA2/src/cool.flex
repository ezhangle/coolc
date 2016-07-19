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
int n_chars = 0;

%}

/*
 * Define names for regular expressions here.
 */

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
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
STR_START       \"
STR_END         \"
STR_ESCAPE      \\b|\\t|\\f|\\n
STR_ESCAPE2     \\.|\\\n
STR_NORMAL      .
STR_CONST       \".*\"
STR_CONST_NULL  \".*\0.*\"
NULL_CHAR       \0
INT_CONST       [0-9]+
BOOL_CONST      (t(?i:rue))|(f(?i:alse))
TYPEID          [A-Z][a-zA-z0-9_]*
OBJECTID        [a-z][a-zA-z0-9_]*
OBJECTID_INVALID [^a-z]/[a-z][a-zA-z0-9_]*
ASSIGN          <-
NOT             (?i:not)
LE              <=|<|=
ERROR           error

WHITESPACE      [ \t\f\r\v]
NEWLINE         \n
COMMENT_INLINE  --
COMMENT_START   "(*"
COMMENT_END     "*)"

%x COMMENT_BLOCK STRING COMMENT_INLINE_BLOCK
%%

 /*
  *  Nested comments
  */
<INITIAL,COMMENT_BLOCK>{COMMENT_START} { 
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

{COMMENT_INLINE} { 
    BEGIN(COMMENT_INLINE_BLOCK);
}
<COMMENT_INLINE_BLOCK><<EOF>> {
    BEGIN(INITIAL);
}

<COMMENT_INLINE_BLOCK>\n {
    curr_lineno++;
    BEGIN(INITIAL);
}
<COMMENT_INLINE_BLOCK>. {
    ;
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
{ASSIGN}        { return(ASSIGN);}
{NOT}           { return(NOT);}
{LE}            { return(LE);}
{STR_CONST_NULL} { 
    cool_yylval.error_msg = "String contains null character";
    return ERROR;
}
{NULL_CHAR} { 
    cool_yylval.error_msg = yytext;
    return ERROR;
}
{STR_START} {
    string_buf_ptr = &string_buf[0];
    n_chars = 0;
    BEGIN(STRING);
}
<STRING><<EOF>> {
    cool_yylval.error_msg = "EOF in string constant";
    curr_lineno++;
    BEGIN(INITIAL);
    return(ERROR);
}
<STRING>{NEWLINE} {
    cool_yylval.error_msg = "Unterminated string constant";
    curr_lineno++;
    BEGIN(INITIAL);
    return(ERROR);
}
 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */
<STRING>{STR_ESCAPE2} {
    /* printf("Escaped normal: %s\n", yytext); */
    if (yytext[1] == 'n')
    {
        *string_buf_ptr = '\n';
    } else if (yytext[1] == 'b')
    {
        *string_buf_ptr = '\b';
    } else if (yytext[1] == 't')
    {
        *string_buf_ptr = '\t';
    } else if (yytext[1] == 'f')
    {
        *string_buf_ptr = '\f';
    } else
    {
        *string_buf_ptr = yytext[1];
    }
    if (yytext[1] == '\n')
        curr_lineno++;
    string_buf_ptr++;
    n_chars += 1;
}
<STRING>{STR_ESCAPE} {
    /* printf("Escaped normal: %s\n", yytext); */
    *string_buf_ptr = yytext[1];
    string_buf_ptr++;
    n_chars += 1;
}
<STRING>{STR_END} {
    *string_buf_ptr = '\0';
    BEGIN(INITIAL);
    /* printf("string buffer: %s\n", string_buf); */
    if (n_chars <= MAX_STR_CONST)
    {
        cool_yylval.symbol = inttable.add_string(string_buf);
        return(STR_CONST);
    } else
    {
        cool_yylval.error_msg = "String constant too long";
        return ERROR;
    }
}
<STRING>{STR_NORMAL} {
    /* printf("Normal: %s\n", yytext); */
    *string_buf_ptr = yytext[0];
    string_buf_ptr++;
    n_chars += 1;
}
{INT_CONST} {
    cool_yylval.symbol = inttable.add_string(yytext);
    return INT_CONST;
}
{BOOL_CONST} {
    if (yytext[0] == 'f' || yytext[0] == 'F')
        cool_yylval.boolean = false;
    else
        cool_yylval.boolean = true;

    return(BOOL_CONST);
}
{TYPEID} { 
    cool_yylval.symbol = inttable.add_string(yytext);
    return(TYPEID);
}
{OBJECTID} {
    cool_yylval.symbol = inttable.add_string(yytext);
    return(OBJECTID);
}
_/{OBJECTID} {
    cool_yylval.error_msg = yytext;
    return(ERROR);
}
{STR_NORMAL} {
    return(int(yytext[0]));
}

%%
