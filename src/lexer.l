%option noyywrap 
%{
#include <stdio.h>
#include "header.h" 
int linenumber;
symtab * lookup();
symtab * ptr;
void     insertID();
void 	   printSymTab();
void     printFormattedSymTab();

#define RW_RETURN    1
#define RW_TYPEDEF   2
#define RW_IF        3
#define RW_ELSE      4
#define RW_INT       5
#define RW_FLOAT     6
#define RW_FOR       7
#define RW_VOID      8
#define RW_WHILE     9

#define DL_LPAREN    10
#define DL_RPAREN    11
#define DL_LSQBRC    12
#define DL_RSQBRC    13
#define DL_LBRACE    14
#define DL_RBRACE    15
#define DL_COMMA     16
#define DL_SEMICOL   17
#define DL_DOT       18

#define ID           20

#define CS_INT       21
#define CS_FLOAT     22
#define CS_STRING    23

#define OP_ADD       24
#define OP_SUB       25
#define OP_DIV       26
#define OP_MUL       27
#define OP_LESS      28
#define OP_GREATER   29
#define OP_LESSEQUAL 30
#define OP_GREATEREQUAL 31
#define OP_NOTEQUAL  31
#define OP_EQUAL     32
#define OP_ASSIGN    33
#define OP_OR        34
#define OP_AND       35
#define OP_NOT       36

#define COMMENT      37

#define ERROR 		   100 

%}

newline              "\n"
WS	                  [ \t]+

letter               [A-Za-z]
digit                [0-9]

RW_return            "return"
RW_typedef           "typedef"
RW_if                "if"
RW_else              "else"
RW_int               "int"
RW_float             "float"
RW_for               "for"
RW_void              "void"
RW_while             "while"

comment              "/*"([^*]|\*+[^*/])*\*+"/"

id	                  {letter}({letter}|{digit}|"_")*

CS_int               {digit}+
CS_float             [-+]?({digit}*)(.)?({digit}+)
CS_string            ["][^"]*["]

DL_lparen            "("
DL_rparen            ")"
DL_lsqbrc            "["
DL_rsqbrc            "]"
DL_lbrace            "{"
DL_rbrace            "}"
DL_comma             ","
DL_semicol           ";"
DL_dot               "."

OP_add               "+"
OP_sub               "-"
OP_div               "/"
OP_mul               "*"
OP_less              "<"
OP_greater           ">"
OP_lessequal         "<="
OP_greaterequal      ">="
OP_notequal          "!="
OP_equal             "=="
OP_assign            "="
OP_or                "||"
OP_and               "&&"
OP_not               "!"

error                .

%%

{WS}            { }
{newline}       { linenumber += 1; }

{RW_return}          { return RW_RETURN; }
{RW_typedef}         { return RW_TYPEDEF; }
{RW_if}              { return RW_IF; }
{RW_else}            { return RW_ELSE; }
{RW_int}             { return RW_INT; }
{RW_float}           { return RW_FLOAT; }
{RW_for}             { return RW_FOR; }
{RW_void}            { return RW_VOID; }
{RW_while}           { return RW_WHILE; }

{comment}            { printf("%s\n", yytext); return COMMENT; }

{id}            {
      ptr = lookup(yytext);
      if (ptr == NULL)
            insertID(yytext);	
      else 
            ptr->counter++;
      return ID;
}

{CS_int}             { return CS_INT; }
{CS_float}           { return CS_FLOAT; }
{CS_string}          { return CS_STRING; }

{DL_lparen}          { return DL_LPAREN; }
{DL_rparen}          { return DL_RPAREN; }
{DL_lsqbrc}          { return DL_LSQBRC; }
{DL_rsqbrc}          { return DL_RSQBRC; }
{DL_lbrace}          { return DL_LBRACE; }
{DL_rbrace}          { return DL_RBRACE; }
{DL_comma}           { return DL_COMMA; }
{DL_semicol}         { return DL_SEMICOL; }
{DL_dot}             { return DL_DOT; }

{OP_add}             { return OP_ADD; }
{OP_sub}             { return OP_SUB; }
{OP_div}             { return OP_DIV; }
{OP_mul}             { return OP_MUL; }
{OP_less}            { return OP_LESS; }
{OP_greater}         { return OP_GREATER; }
{OP_lessequal}       { return OP_LESSEQUAL; }
{OP_greaterequal}    { return OP_GREATEREQUAL; }
{OP_notequal}        { return OP_NOTEQUAL; }
{OP_equal}           { return OP_EQUAL; }
{OP_assign}          { return OP_ASSIGN; }
{OP_or}              { return OP_OR; }
{OP_and}             { return OP_AND; }
{OP_not}             { return OP_NOT; }

{error}         { printf("ERR: Bad character %s\n", yytext); return ERROR; }

%%

int main(int argc, char **argv)
{
   int ntoken;
   argc--; ++argv;
   if (argc > 0)
      yyin = fopen(argv[0], "r");
   else
      yyin = stdin;
   while (ntoken) {
      // printf("%d\n", ntoken);
      ntoken = yylex();
      if (ntoken == ERROR) return 1;
   }
   // printf("%d\n", linenumber);
   printFormattedSymTab();
   return 0;
}
