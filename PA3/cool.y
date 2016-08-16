/*
*  cool.y
*              Parser definition for the COOL language.
*
*/
%{
  #include <iostream>
  #include "cool-tree.h"
  #include "stringtab.h"
  #include "utilities.h"
  
  extern char *curr_filename;
  
  
  /* Locations */
  #define YYLTYPE int              /* the type of locations */
  #define cool_yylloc curr_lineno  /* use the curr_lineno from the lexer
  for the location of tokens */
    
    extern int node_lineno;          /* set before constructing a tree node
    to whatever you want the line number
    for the tree node to be */
      
      
      #define YYLLOC_DEFAULT(Current, Rhs, N)         \
      Current = Rhs[1];                             \
      node_lineno = Current;
    
    
    #define SET_NODELOC(Current)  \
    node_lineno = Current;
    
    /* IMPORTANT NOTE ON LINE NUMBERS
    *********************************
    * The above definitions and macros cause every terminal in your grammar to 
    * have the line number supplied by the lexer. The only task you have to
    * implement for line numbers to work correctly, is to use SET_NODELOC()
    * before constructing any constructs from non-terminals in your grammar.
    * Example: Consider you are matching on the following very restrictive 
    * (fictional) construct that matches a plus between two integer constants. 
    * (SUCH A RULE SHOULD NOT BE  PART OF YOUR PARSER):
    
    plus_consts	: INT_CONST '+' INT_CONST 
    
    * where INT_CONST is a terminal for an integer constant. Now, a correct
    * action for this rule that attaches the correct line number to plus_const
    * would look like the following:
    
    plus_consts	: INT_CONST '+' INT_CONST 
    {
      // Set the line number of the current non-terminal:
      // ***********************************************
      // You can access the line numbers of the i'th item with @i, just
      // like you acess the value of the i'th exporession with $i.
      //
      // Here, we choose the line number of the last INT_CONST (@3) as the
      // line number of the resulting expression (@$). You are free to pick
      // any reasonable line as the line number of non-terminals. If you 
      // omit the statement @$=..., bison has default rules for deciding which 
      // line number to use. Check the manual for details if you are interested.
      @$ = @3;
      
      
      // Observe that we call SET_NODELOC(@3); this will set the global variable
      // node_lineno to @3. Since the constructor call "plus" uses the value of 
      // this global, the plus node will now have the correct line number.
      SET_NODELOC(@3);
      
      // construct the result node:
      $$ = plus(int_const($1), int_const($3));
    }
    
    */
    
    
    
    void yyerror(char *s);        /*  defined below; called for each parse error */
    extern int yylex();           /*  the entry point to the lexer  */
    
    /************************************************************************/
    /*                DONT CHANGE ANYTHING IN THIS SECTION                  */
    
    Program ast_root;	      /* the result of the parse  */
    Classes parse_results;        /* for use in semantic analysis */
    int omerrs = 0;               /* number of errors in lexing and parsing */
    %}
    
    /* A union of all the types that can be the result of parsing actions. */
    %union {
      Boolean boolean;
      Symbol symbol;
      Program program;
      Class_ class_;
      Classes classes;
      Feature feature;
      Features features;
      Formal formal;
      Formals formals;
      Case case_;
      Cases cases;
      Expression expression;
      Expressions expressions;
      char *error_msg;
    }
    
    /* 
    Declare the terminals; a few have types for associated lexemes.
    The token ERROR is never used in the parser; thus, it is a parse
    error when the lexer returns it.
    
    The integer following token declaration is the numeric constant used
    to represent that token internally.  Typically, Bison generates these
    on its own, but we give explicit numbers to prevent version parity
    problems (bison 1.25 and earlier start at 258, later versions -- at
    257)
    */
    %token CLASS 258 ELSE 259 FI 260 IF 261 IN 262 
    %token INHERITS 263 LET 264 LOOP 265 POOL 266 THEN 267 WHILE 268
    %token CASE 269 ESAC 270 OF 271 DARROW 272 NEW 273 ISVOID 274
    %token <symbol>  STR_CONST 275 INT_CONST 276 
    %token <boolean> BOOL_CONST 277
    %token <symbol>  TYPEID 278 OBJECTID 279 
    %token ASSIGN 280 NOT 281 LE 282 ERROR 283
    
    /*  DON'T CHANGE ANYTHING ABOVE THIS LINE, OR YOUR PARSER WONT WORK       */
    /**************************************************************************/
    
    /* Complete the nonterminal list below, giving a type for the semantic
    value of each non terminal. (See section 3.6 in the bison 
    documentation for details). */
    
    /* Declare types for the grammar's non-terminals. */
    %type <program> program
    %type <classes> class_list
    %type <class_> class
    %token <symbol> SELF
    
    %type <features> feature_list
    %type <feature> method
    %type <feature> attribute
    %type <formal> formal
    %type <formals> formals
    %type <expression> arg
    %type <expressions> args_list
    %type <expression> expr let_stmt
    %type <expressions> expr_list
    %type <expression> block
    %type <expression> assign
    %type <case_> branch
    %type <cases> branch_list
    
    /* Precedence declarations. */
    %right ASSIGN
    %right NOT
    %nonassoc '=' '<' "<="
    %left '+' '-'
    %left '*' '/'
    %left ISVOID
    %right '~'

    %%
    /* =============================================================
        THE GRAMMAR
       =============================================================*/
    /* -------------------------------------------------------------
        PROGRAM
       -------------------------------------------------------------*/
    program	: class_list	{ @$ = @1; ast_root = program($1); }
    ;
    
    /* -------------------------------------------------------------
        CLASS
       -------------------------------------------------------------*/
    class_list
    : class
    {
      $$ = single_Classes($1);
    }
    | class_list class
    { 
      $$ = append_Classes($1,single_Classes($2)); 
    }
    ;
    
    class	: CLASS TYPEID '{' feature_list '}' ';'
    { 
      $$ = class_($2,idtable.add_string("Object"),$4,
           stringtable.add_string(curr_filename));
    }
    | CLASS TYPEID INHERITS TYPEID '{' feature_list '}' ';'
    { 
      $$ = class_($2,$4,$6,stringtable.add_string(curr_filename));
    }
    | CLASS error '}' {;} 
    | CLASS error ';' {;} 
    | CLASS error '{' feature_list'}' ';' {;}
    ;

    /* Class features */
    feature_list: method ';' feature_list
    {
      $$ = append_Features(single_Features($1), $3);
    }
    | attribute ';' feature_list
    {
      $$ = append_Features(single_Features($1), $3);
    }
    | {$$ = nil_Features();}

    /* A class method. */
    method:  OBJECTID'(' formals ')'':' TYPEID '{' expr '}'
    {
      $$ = method($1, $3, $6, $8);
    }
    | error {;}

    formal: OBJECTID ':' TYPEID 
    {
      $$ = formal($1, $3); 
    }

    /* Method's formal params */
    formals: formal 
    {
      $$ = single_Formals($1); 
    }
    | formal ',' formals
    {
      $$ = append_Formals(single_Formals($1), $3); 
    }
    | {$$ = nil_Formals();}


    /* Class attribute. */
    attribute: OBJECTID ':' TYPEID
    {
      $$ = attr($1, $3, no_expr());
    }
    | OBJECTID ':' TYPEID ASSIGN expr
    {
      $$ = attr($1, $3, $5);
    }

    /* ---------------------------------------------------------------------
        EXPRESSIONS
       ---------------------------------------------------------------------*/
    /* 1. Bool, int and string constants */
    expr: BOOL_CONST
    { $$ = bool_const($1);
    } 
    | INT_CONST
    { $$ = int_const($1);
    }
    | STR_CONST
    {
      $$ = string_const($1);
    }

    /* 2. Standalone object*/
    expr: OBJECTID 
    {
      $$ = object($1);
    };

    /* 3. Various forms of dispatch */
    expr: OBJECTID '(' args_list ')'
    {
      $$ = dispatch(object(new Entry("self", 4, 255)), $1, $3);
    }
    | OBJECTID '.' OBJECTID '(' args_list ')'
    {
      $$ = dispatch(object($1), $3,$5);
    }
    | OBJECTID '@' TYPEID '.' OBJECTID '(' args_list ')'
    {
      $$ = static_dispatch(object($1), $3, $5, $7);
    };

    /* 4. Method's arguments */
    arg: expr 
    {
      $$ = $1; 
    }
    
    args_list: arg
    {
      $$ = single_Expressions($1); 
    }
    | args_list ',' arg
    {
      $$ = append_Expressions($1, single_Expressions($3)); 
    }
    | {$$ = nil_Expressions();}

    /* 5. Assignement */
    expr: OBJECTID assign
    {
      $$ = assign($1, $2);
    }
    assign: ASSIGN expr
    {
      $$ = $2;
    }

    /* 6. Allow expressions surrounded with brackets*/
    expr: '(' expr ')' 
    {
      $$ = $2;
    }

    /* 7. Unary and binary operations */
    expr: '~' expr 
    { $$ = neg($2);
    }
    | expr '+' expr
    {
      $$ = plus($1, $3);
    }
    | expr '-' expr
    {
      $$ = sub($1, $3);
    }
    | expr '*' expr
    {
      $$ = mul($1, $3);
    }
    | expr '/' expr
    {
      $$ = divide($1, $3);
    }
    | NOT expr
    {
      $$ = comp($2);
    }
    | expr '=' expr
    {
      $$ = eq($1, $3);
    }
    | expr '<' expr
    {
      $$ = lt($1, $3);
    }
    | expr "<=" expr
    {
      $$ = leq($1, $3);
    }
    | NEW TYPEID
    {
      $$ = new_($2);
    }
    | ISVOID expr
    {
      $$ = isvoid($2);
    }

    /* 8. WHILE loop */
    expr: WHILE expr LOOP expr POOL
    {
      $$ = loop($2, $4);;
    }
    | WHILE expr LOOP expr error { ;}
    | WHILE expr error  { ;}

    /* 9. IF statement */
    expr: IF expr THEN expr ELSE expr FI
    {
      $$ = cond($2, $4, $6);  
    }

    /* 10. CASE statements */ 
    expr: CASE expr OF branch_list ESAC ';'
    {
      $$ = typcase($2, $4); 
    } | CASE error {;}

    branch: OBJECTID ':' TYPEID DARROW expr ';'
    {
      $$ = branch($1, $3, $5);
    }

    branch_list: branch_list ';' branch
    {
      $$ = append_Cases($1, single_Cases($3));
    }
    | branch
    { $$ = single_Cases($1);}
    | {$$ = nil_Cases();}

    /* 11. LET expressions */
    expr: LET let_stmt 
    {
      $$ = $2;
    }

    let_stmt: OBJECTID ':' TYPEID IN expr
    {
      $$ = let($1, $3, no_expr(), $5);
    }
    | OBJECTID ':' TYPEID ',' let_stmt
    {
      $$ = let($1, $3, no_expr(), $5);
    }
    | OBJECTID ':' TYPEID ASSIGN expr IN expr
    {
      $$ = let($1, $3, $5, $7);
    }

    /* 12. Blocks of expressions */
    expr: block
    {
      $$ = $1;
    } 
    block: '{' expr_list '}'
    {
      $$ = block($2);
    }
    | '{' block '}'
    {
      $$ = $2;
    } 
    | error {;}
    | '{' '}' error {;}
    ;

    expr_list: expr ';' expr_list
    {
      $$ = append_Expressions(single_Expressions($1), $3);  
    }
    | expr
    {
      $$ = single_Expressions($1);
    }
    | {$$ = nil_Expressions();}
    
    /* ===============================================================
        END OF GRAMMAR
       =============================================================== */
    %%
    
    /* This function is called automatically when Bison detects a parse error. */
    void yyerror(char *s)
    {
      extern int curr_lineno;
      
      cerr << "\"" << curr_filename << "\", line " << curr_lineno << ": " \
      << s << " at or near ";
      print_cool_token(yychar);
      cerr << endl;
      omerrs++;
      
      if(omerrs>50) {fprintf(stdout, "More than 50 errors\n"); exit(1);}
    }
    
    
