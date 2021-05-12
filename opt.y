%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "opt.tab.h"
int yylex(void);
int cnt=0;
char regdesc[30][30];
char addrdesc[30][30];
int ind=0;
char flag[30];
FILE *yyin;
strcpy(flag,"none");

%}
%token TERM RELOP OP WHILE DO SWITCH CASE DEFAULT BREAK IF ELSE ENDOFFILE

%%
line:  TERM '=' TERM OP TERM ';' {if(strcmp($4,"+")==0){printf("MOV %s,R%d\nADD %s,R%d\n",$3,cnt,$5,cnt);cnt=cnt+1;}
else if(strcmp($4,"-")==0){printf("MOV %s,R%d\nSUB %s,R%d\n",$3,cnt,$5,cnt);cnt=cnt+1;}
else if(strcmp($4,"*")==0){printf("MOV %s,R%d\nMUL %s,R%d\n",$3,cnt,$5,cnt);cnt=cnt+1;}
else if(strcmp($4,"/")==0){printf("MOV %s,R%d\nDIV %s,R%d\n",$3,cnt,$5,cnt);cnt=cnt+1;}
strcpy(flag,$1);
} line

| TERM '=' TERM OP TERM ';' {if(strcmp($4,"+")==0){printf("MOV %s,R%d\nADD %s,R%d\n",$3,cnt,$5,cnt);cnt=cnt+1;}
else if(strcmp($4,"-")==0){printf("MOV %s,R%d\nSUB %s,R%d\n",$3,cnt,$5,cnt);cnt=cnt+1;}
else if(strcmp($4,"*")==0){printf("MOV %s,R%d\nMUL %s,R%d\n",$3,cnt,$5,cnt);cnt=cnt+1;}
else if(strcmp($4,"/")==0){printf("MOV %s,R%d\nDIV %s,R%d\n",$3,cnt,$5,cnt);cnt=cnt+1;}
strcpy(flag,$1);
}
| TERM '=' TERM ';' {if(strcmp(flag,"none)){printf("MOV %s,R%d\n",$1,cnt);cnt=cnt+1; }else{printf(MOV %s,%s\n",flag,$1);}}


     
     
%%
int yyerror(char *s){
    fprintf(stderr, "%s\n", s);
  return 0;
}
int yywrap()
{
  return 1;
}
int main()
{
  
  yyin=fopen("inputy.txt","r");
   
  yyparse();

  fclose(yyin);
  return 0;
}
