
%{
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include "syn.tab.h"
	void yyerror(char*);
	

%}
alp ([a-zA-Z\_][a-zA-Z\_0-9]*)


%%
"int "|"char "|"float "|"int* "|"char* "|"float* " {yylval=strdup(yytext);return DTYPE;}
"while" {return WHILE;}
"break" {return BREAK;}
"switch" {return SWITCH;}
"if" {return IF;}
"else" {return ELSE;}
"for" {return FOR;}
"case" {return CASE;}
"<"|">"|"<="|">="|"=="|"!=" {return RELOP;}
"++"|"--" {return UNARY;}
"+"|"-"|"*"|"/" {return ARITH;}
"&&"|"||" {return CODTN;}
"{"|"}"|"("|")" {return *yytext;}
[ \t]+ {return *yytext;}
[0-9]+ {yylval=atoi(yytext);return INTEGER;}
{alp} {yylval=strdup(yytext);return ALP;}
"=" {yylval=strdup(yytext);return EOP;}
";"|","|"'" {return *yytext;}



. {char msg[25];sprintf(msg,"%s<%s>","invalid character",yytext);yyerror(msg);}

%%
