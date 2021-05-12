
%{
 
    #include<stdio.h>
    #include "syntaxcheck.tab.h"
    int yylex(void);
    int yyerror(const char *s);
    int success = 1;
    FILE* yyin;
%}

%start Program
%token IFTOK ELSETOK ID NUM WHILETOK DOTOK BREAKTOK TYPE VOIDTOK RETURNTOK NULLTOK 
%token DEQ NEQ LE GE
%nonassoc ELSETOK
%left '+' '-'
%left '*' '/'
%%

Program    : Program Block
           | Block
           ;

Block      : '{' Decls Stmts '}'
           ;
Decls      : Decls Decl
           | 
           ;
Decl       : Type ID ';'
           | Type ID '=' NUM ';' 
           ;
Type       : Type '[' NUM ']'
           | TYPE
           ;
Stmts      : Stmts Stmt
           
           ;
Stmt       : IFTOK '(' Rel ')' Stmt ELSETOK Stmt
           | WHILETOK '(' Rel ')' Stmt
           | DOTOK Stmt WHILETOK '(' Rel ')' ';'
           | BREAKTOK ';'
           | Block
           | ID '=' Expr ';'
           | Expr ';'
           ;


Equality   : Equality DEQ Rel
           | Equality NEQ Rel
           | Rel
           ;
Rel        : Expr LE Expr
           | Expr '<' Expr
           | Expr '>' Expr
           | Expr GE Expr
           | Expr
           ;
Expr       : Expr '+' Term
           | Expr '-' Term
           | Term
           ;
Term       : Term '*' Unary
           | Term '/' Unary
           | Unary
           ;
Unary      : '!' Unary
           | '-' Unary
           | '-' '-' Unary
           | '+' '+' Unary
           | Factor
           ;
Factor     : ID
           | NUM
           ;

%%

int main (void)
{
      yyin=fopen("input.txt","r");
	yyparse();
  
    if(success)
    	printf("Parsing Successful\n");
    	fclose(yyin);
    return 0;
}

int yyerror(const char *msg)
{
    
	printf("Parsing Failed\nLine Number: %d %s\n",yylval,msg);
  success = 0;
	return 0;
}
