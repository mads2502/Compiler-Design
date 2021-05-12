%{
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
int yylex(void);
#include "taddrcode.tab.h"
FILE* yyin;


int a = 1, b = 1, c = 1, sc = 0;
FILE* fp1;

//here b-counter for temporaries, a-counter for labels of blocks, sc-switch case
%}
%token TERM RELOP OP WHILE DO SWITCH CASE DEFAULT BREAK IF ELSE ENDOFFILE


%%
start: line ENDOFFILE {printf("PARSING PHASE\nsuccessfully parsed\nINTERMEDIATE CODE GEN\n");}
line: 
    | TERM '=' TERM OP TERM ';' {fp1=fopen("output.txt","w"); fprintf(fp1,"t%d := %s %s %s\n%s := t%d\n", b, $3, $4, $5, $1, b); b=b+1; } line 
    | TERM '=' TERM RELOP TERM ';'  { printf("t%d := %s %s %s\n%s := t%d\n", b, $3, $4, $5, $1, b); b=b+1; } line 
    | TERM '=' TERM ';' { printf("%s := %s\n", $1, $3); } line
    | WHILE TERM RELOP TERM DO '{' { printf("L%d: if  %s %s %s then goto E%d.TRUE\nE%d.TRUE: ", a, $2, $3, $4, a, a); } line '}' { printf("E%d.FALSE: \n", a); a++; } line
    | WHILE TERM OP TERM DO '{' { printf("L%d: if  %s %s %s then goto E%d.TRUE\nE%d.TRUE: ", a, $2, $3, $4, a, a); } line '}' { printf("E%d.FALSE: \n", a); a++; } line
    | WHILE TERM DO '{' { printf("L%d: if  %s then goto E%d.TRUE\nE%d.TRUE: ", a, $2, a, a); } line '}' { printf("E%d.FALSE: \n", a); a++; } line
    | IF TERM RELOP TERM DO '{' { printf("L%d: if  %s %s %s then goto E%d.TRUE\nE%d.TRUE: ", a, $2, $3, $4, a, a); } line '}' ELSE   { printf("E%d.FALSE: \n", a); a++; } line
    | IF TERM OP TERM DO '{' { printf("L%d: if  %s %s %s then goto E%d.TRUE\nE%d.TRUE: ", a, $2, $3, $4, a, a); } line '}' ELSE   { printf("E%d.FALSE: \n", a); a++; } line
    | SWITCH '(' TERM RELOP TERM ')' '{' { printf("t%d := %s %s %s\n", b, $3, $4, $5); sc = b; b++; } cases '}' { printf("LAST%d: ", a); a++; } line
    | SWITCH '(' TERM OP TERM ')' '{' { printf("t%d := %s %s %s\n", b, $3, $4, $5); sc = b; b++; } cases '}' { printf("LAST%d: ", a); a++; } line
    | SWITCH '(' TERM ')' '{' { printf("t%d := %s\n", b, $3); sc = b; b++; } cases '}' { printf("LAST%d: ", a); a++; } line
    | BREAK ';' line { printf("goto LAST%d\n",a); } 
cases: /* empty */
     | CASE TERM ':' { printf("L%d: if  t%d != %s goto L%d\n", c, sc, $2, c + 1); c++; } line cases

     | DEFAULT { printf("L%d: ", c); c++; } ':' line { printf("goto LAST%d\n", a); } cases
%%
int yyerror(char* s)
{
  fprintf(stderr, "%s\n", s);
  return 0;
}
int yywrap()
{
  return 1;
}
int main()
{
  FILE* fp;
  char ch;
  
  yyin=fopen("input.txt","r");
   
  yyparse();

  fclose(yyin);
  fclose(fp1);
fp=fopen("output.txt","r");
 while((ch = fgetc(fp)) != EOF)
      printf("%c", ch);
      fclose(fp);
  return 0;
}