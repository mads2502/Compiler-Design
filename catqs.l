%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "catqs.tab.h"
extern YYSTYPE yylval;
%}
term ([a-zA-Z\_][a-zA-Z\_0-9]*|[0-9]+)
plusop "+"
minusop "-"
multop "*"
divop "/"
powop "^"
%%
 
{term} {yylval=strdup(yytext);return TERM;}

{plusop} {yylval=strdup(yytext);return PLUSOP;}
{minusop} {yylval=strdup(yytext);return MINUSOP;}
{multop} {yylval=strdup(yytext);return MULTOP;}
{divop} {yylval=strdup(yytext);return DIVOP;}
{powop} {yylval=strdup(yytext);return POWOP;}
. {return *yytext;}
<<EOF>> {return ENDOFFILE;}
%%
