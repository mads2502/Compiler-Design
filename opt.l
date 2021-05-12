%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "opt.tab.h"
extern YYSTYPE yylval;
%}
term ([a-zA-Z\_][a-zA-Z\_0-9]*|[0-9]+)
relop ("<"|"<="|">"|">="|"=="|"!=")
op ("+"|"-"|"/"|"*"|"%")
%%
"while" { return WHILE; }
"if"    {return IF;}
"else"  {return ELSE;}
"do" { return DO; }
"switch" { return SWITCH; }
"case" { return CASE; }
"default" { return DEFAULT; }

{term} { yylval = strdup(yytext);printf("hello%s",yytext); return TERM; }
{relop} { yylval = strdup(yytext); return RELOP; }
{op} { yylval = strdup(yytext); return OP; }
[ \t\n]+ { }
. {return *yytext;}
<<EOF>> {return ENDOFFILE;}
%%
int main(){
    FILE *yyin;
yyin=fopen("inputy.txt","r");
yyset_in(yyin);
    yylex();
    return 0;
}