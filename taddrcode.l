%{
#include<stdio.h>
#include<string.h>
#include "taddrcode.tab.h"
%}
term ([a-zA-Z\_][a-zA-Z\_0-9]*|[0-9]+)
relop ("<"|"<="|">"|">="|"=="|"!=")
op ("+"|"-"|"/"|"*"|"%")
%%
"while" { return WHILE; }
"if"    {return IF;}
"else"  {return ELSE;}
"do" { return DO; }
"switch" { printf("%s",yytext);return SWITCH; }
"case" { return CASE; }
"default" { return DEFAULT; }
"break" { return BREAK; }
{term} { yylval = strdup(yytext); return TERM; }
{relop} { yylval = strdup(yytext); return RELOP; }
{op} { yylval = strdup(yytext); return OP; }
[ \t\n]+ { }
. {return *yytext;}
<<EOF>> {return ENDOFFILE;}
%%