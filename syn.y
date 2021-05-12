%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
   #include "syn.tab.h"
    #include<math.h>
    int yylex(void);
    int f=1;
    FILE* yyin;

%}
%token INTEGER EOP ALP DTYPE WHILE BREAK SWITCH IF ELSE FOR RELOP UNARY CODTN ARITH CASE

%%
program : line program 
        | line 
line : stmt line {printf("valid");}
     | '{'
     | '}'
     | stmt
stmt :  WHILE '(' var EOP INTEGER ')'
     | WHILE '(' var RELOP INTEGER ')' 
     | WHILE '(' var RELOP var ')'
     | IF '(' var EOP EOP INTEGER ')' 
     | IF '(' var RELOP INTEGER ')' 
     | IF '(' var RELOP var ')' 
     | ELSE
     | ELSE '(' exp ')'
     | SWITCH '(' var ')'
     | SWITCH '(' INTEGER ')' '{' case '}'
     | FOR '(' var EOP INTEGER ';' var RELOP INTEGER ';' var UNARY ')'
     | exp   {printf("valid");}
     | decl  {printf("valid");}
case : CASE INTEGER ':' exp BREAK ';'
     | CASE ''' var ''' ':' exp BREAK ';'
     
    
decl : DTYPE var ';'
    | DTYPE var ',' listvar ';'
    | DTYPE var OP INTEGER ';'

exp : var EOP var ';'
    | var EOP INTEGER ';'
    | var RELOP var 
    | var RELOP INTEGER 
    | var EOP var ARITH var ';'
    | var EOP var ARITH INTEGER ';'
    | var EOP INTEGER ARITH INTEGER ';'
    | var
listvar : ALP ',' listvar 
        | ALP 
var : ALP 
%%

/*Madhumitha S 185001086*/


void yyerror(char* s){
    fprintf(stderr,"Invalid syntax %s\n",s);
    f=0;
    
}
void yywrap(){
    return 1; 
}
int main(){
  yyin=fopen("input.txt","r");
	yyparse();
    if(f)
    printf("Syntactically correct");
	fclose(yyin);
	return 0;
}



