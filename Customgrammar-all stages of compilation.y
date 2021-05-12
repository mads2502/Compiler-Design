%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    int yylex(void);
    #include "catqs.tab.h"
    FILE* yyin;
    int a=0,b=0,c=0;
    FILE* fp1;
    FILE* fp2;

%}
%token TERM PLUSOP MULTOP DIVOP MINUSOP POWOP ENDOFFILE 
%left '+' '-'
%right '*' '/'
%%
program : line ENDOFFILE {printf("\nPARSING SUCCESSFUL\n");}
line :  TERM '=' expr ';' {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");$$=$3;fprintf(fp1,"t%d=%s\n",a,$3);fprintf(fp2,"\nMOV %s,R%d",$3,b);b=b+1;fclose(fp1);fclose(fp2);} 
     | TERM '=' expr PLUSOP expr ';' {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");if(strcmp($5,"0")==0){fprintf(fp1,"t%d=%s\n",a,$3);}else{fprintf(fp1,"t%d=%s %s %s\n%s=t%d\n",a,$3,$4,$5,$1,a);}a=a+1;fprintf(fp2,"MOV %s,R%d\nADD %s,R%d",$5,b,$3,b);b=b+1;} line
     | TERM '=' expr MINUSOP expr ';' {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");fprintf(fp1,"t%d=%s %s %s\n%s=t%d\n",a,$3,$4,$5,$1,a);a=a+1;fprintf("MOV %s,R%d\nSUB %s,R%d",$5,b,$3,b);b=b+1;} line
     | TERM '=' expr MULTOP expr ';' {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");if(strcmp($3,$5)==0){fprintf(fp1,"t%d=%s + %s\n",a,$3,$3);}else{fprintf(fp1,"t%d=%s %s %s\n%s=t%d\n",a,$3,$4,$5,$1,a);}a=a+1;fprintf(fp2,"MOV %s,R%d\nMUL %s,R%d",$5,b,$3,b);b=b+1;} line
     | TERM '=' expr DIVOP expr ';' {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");fprintf(fp1,"t%d=%s %s %s\n%s=t%d\n",a,$3,$4,$5,$1,a);a=a+1;fprintf(fp2,"MOV %s,R%d\nDIV %s,R%d",$5,b,$3,b);b=b+1;} line
     | TERM '=' expr POWOP expr ';' {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");if(strcmp($5,"2")==0){fprintf(fp1,"t%d=%s<<2\n",a,$3);}else{fprintf(fp2,"t%d=%s %s %s\n%s=t%d\n",a,$3,$4,$5,$1,a);}a=a+1;fprintf(fp2,"MOV %s,R%d\nADD %s,R%d",$5,b,$3,b);b=b+1;} line
     
     
expr : TERM PLUSOP TERM {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");fprintf(fp1,"t%d=%s %s %s\n",a,$1,$2,$3);fprintf(fp2,"MOV %s,R%d\nADD %s,R%d\n",$3,b,$1,b);b=b+1;}
expr : TERM PLUSOP TERM {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");fprintf(fp1,"t%d=%s %s %s\n",a,$1,$2,$3);fprintf(fp2,"MOV %s,R%d\nADD %s,R%d\n",$3,b,$1,b);b=b+1;}
     | TERM MINUSOP TERM {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");fprintf(fp1,"t%d=%s %s %s\n",a,$1,$2,$3);fprintf(fp2,"MOV %s,R%d\nADD %s,R%d\n",$3,b,$1,b);b=b+1;}
     | TERM MULTOP TERM {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");if(strcmp($1,$3)==0){fprintf(fp1,"t%d=%s + %s\n",a,$3,$3);}else{fprintf(fp1,"t%d=%s %s %s\n",a,$1,$2,$3);}fprintf(fp2,"MOV %s,R%d\nADD %s,R%d\n",$3,b,$1,b);b=b+1;}
     | TERM DIVOP TERM {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");fprintf(fp1,"t%d=%s %s %s\n",a,$1,$2,$3);fprintf(fp2,"MOV %s,R%d\nADD %s,R%d\n",$3,b,$1,b);b=b+1;}
     | TERM POWOP TERM {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");if(strcmp($3,"2")==0){fprintf(fp1,"t%d=%s<<2\n",a,$3);}else{fprintf(fp1,"t%d=%s %s %s\n",a,$1,$2,$3);}fprintf(fp2,"MOV %s,R%d\nADD %s,R%d\n",$3,b,$1,b);b=b+1;}
     | TERM {fp1=fopen("taccat.txt","w");fp2=fopen("assembly.txt","w");fprintf(fp1,"t%d=%s \n",a,$1);fprintf(fp2,"MOV %s,R%d\n",$1,b);b=b+1;}

     
    



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
    char ch;
    FILE* fps1;
    yyin=fopen("catinput.txt","r");
    fps1=fopen("taccat.txt","r");

 while((ch = fgetc(fps1)) != EOF)
      printf("%c", ch);
      fclose(fps1);
    yyparse();
    //printf("PARSING SUCCESSFUL");
    printf("ICG IN FILE taccat.txt\n");
    printf("\nMACHINE CODE IN FILE assembly.txt");
    fclose(yyin);
}
