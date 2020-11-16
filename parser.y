%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
extern FILE * yyin;

int yylex();
int yyerror(char *);
	 struct Snode {
		  struct Snode *left;
		  struct Snode *right;
		  struct Snode *parent;
		  int size;
		  char tok[20];
		  char lexval[20];
		  
		  char type[20];
	 };
void postorder(struct Snode*);
void inorder(struct Snode*);
%}

%union {
	int dval;
	 char lexeme[20];
	 struct Snode *snode;
	
}
		  

%token NUMBER ID ASGN 	LP RP SCOL COMMA  LSB RSB FLOAT INT CHAR
%type <lexeme> NUMBER
%type <lexeme> ID;

%type <lexeme> LSB;
%type <lexeme> RSB;

%type <snode> TYPE;

%type <snode> NUM
%type <snode> LIST
%type <snode> VAR
%type <snode> VARID
%type <snode> dec
%type <snode> decl
%type <snode> ARRAYDECL
%type <snode> ARRAYDEC

%%

decl : dec SCOL 		{
	 						printf("\nDeclaration Statement Accepted.\n");
			 				inorder($1);
		};
decl : decl dec SCOL {
	 						printf("\nDeclaration Statement Accepted.\n");
			 				inorder($2);
			 		
		};

dec	: 	TYPE LIST {$$ = (struct Snode *) malloc(sizeof(struct Snode)); 
							$$->left = $1;
							$$->right = $2;
							strcpy($$->type,$1->type); 
							strcpy($2->type,$1->type);
										strcpy($$->lexval,""); 
										strcpy($$->tok,"dec"); 
		};

TYPE : INT { $$ = (struct Snode *) malloc(sizeof(struct Snode)); 
			 						strcpy($$->tok, "INT");
			 						strcpy($$->lexval, "int");
									strcpy($$->type, "integer");
						 			$$->right = NULL; 
						 			$$->left = NULL; 
								} ;

TYPE : FLOAT { $$ = (struct Snode *) malloc(sizeof(struct Snode)); 
			 						strcpy($$->tok, "FLOAT");
			 						strcpy($$->lexval, "float");
									strcpy($$->type, "float");
						 			$$->right = NULL; 
						 			$$->left = NULL; 
								} ;

TYPE : CHAR { $$ = (struct Snode *) malloc(sizeof(struct Snode)); 
			 						strcpy($$->tok, "CHAR");
			 						strcpy($$->lexval, "char");
									strcpy($$->type, "character");
						 			$$->right = NULL; 
						 			$$->left = NULL; 
								} ;

LIST:   VAR		{$$ = (struct Snode *) malloc(sizeof(struct Snode)); 
										$$->left = $1;
										$$->right= NULL;
										strcpy($1->type,$<snode>0->type);
										if(!strcmp($1->type, "integer") || !strcmp($1->type, "float")){
											$1->size=4*$1->size;
										}
										strcpy($$->lexval,""); 
										strcpy($$->tok,"LIST"); 
									} 
										;
LIST:	LIST COMMA VAR 
{$$ = (struct Snode *) malloc(sizeof(struct Snode)); 
										$$->left = $1;
										$1->parent=$$;
										$$->right= $3;
										$3->parent=$$;
										
										strcpy($3->type,$<snode>0->type);
										if(!strcmp($3->type, "integer") || !strcmp($3->type, "float")){
											$3->size=4*$3->size;
										}
										
										strcpy($$->lexval,","); 
										strcpy($$->tok,"COMMA"); 
									} 
										;
VAR	:	VARID	{ $$ = (struct Snode *) malloc(sizeof(struct Snode)); 
			 						strcpy($$->tok, "variable");
			 						strcpy($$->lexval, $1->lexval);
						 			$$->right = NULL; 
									$$->size=1;
						 			$$->left = $1; 
								} ;
VAR	:	VARID ARRAYDECL	{ $$ = (struct Snode *) malloc(sizeof(struct Snode)); 
			 						strcpy($$->tok, "array");									
			 						strcpy($$->lexval, strcat($1->lexval,$2->lexval));
									$$->size=$2->size;
						 			$$->right = $2; 
						 			$$->left = $1; 
								} ;

VARID	:	ID	{ $$ = (struct Snode *) malloc(sizeof(struct Snode)); 
			 						strcpy($$->tok, "ID");
			 						strcpy($$->lexval, $1);
						 			$$->right = NULL; 
						 			$$->left = NULL; 
								} ;

ARRAYDECL	: ARRAYDEC					{ $$ = (struct Snode *) malloc(sizeof(struct Snode)); 
			 						strcpy($$->tok, "");
								
			 						strcpy($$->lexval, $1->lexval);
									$$->size=$1->size;
						 			$$->right = NULL; 
						 			$$->left = $1; 
								} ;
ARRAYDECL	: ARRAYDECL ARRAYDEC  { $$ = (struct Snode *) malloc(sizeof(struct Snode)); 
			 						strcpy($$->tok, "");									
			 						strcpy($$->lexval, strcat($1->lexval,$2->lexval));
									$$->size=$1->size*$2->size;
						 			$$->right = $2; 
						 			$$->left = $1; 
								} ;
ARRAYDEC	: LSB NUM RSB         { $$ = (struct Snode *) malloc(sizeof(struct Snode)); 
			 						strcpy($$->tok, "");									
									char dest[20]="[";
									strcat(dest,strcat($2->lexval,"]"));
			 						strcpy($$->lexval,dest);
									$$->size=$2->size;
						 			$$->right = $2; 
						 			$$->left = NULL; 
								} ;
NUM			: NUMBER		       { $$ = (struct Snode *) malloc(sizeof(struct Snode)); 
			 						strcpy($$->tok, "NUMBER");
			 						strcpy($$->lexval, $1);
									$$->size=atoi($1);
						 			$$->right = NULL; 
						 			$$->left = NULL; 
								} ;											
%%

int main(int argc, char *argv[])
{
   if (argc != 2) {
       printf("\nUsage: <exefile> <inputfile>\n\n");
       exit(0);
   }
   yyin = fopen(argv[1], "r");
  yyparse();
  return 0;
}


int yyerror(char *s){
  printf("\n\nError: %s\n", s);
  return 0;
}

void inorder(struct Snode *ptr) {
	if (ptr == NULL)
		 return;

   inorder(ptr->left);
	if (!strcmp(ptr->tok, "variable"))
		printf("%s\t%s\t%d\t%s\n",ptr->type,ptr->lexval,ptr->size,ptr->tok);
	if (!strcmp(ptr->tok, "array"))
		printf("%s\t%s\t%d\t%s\n",ptr->type,ptr->lexval,ptr->size,ptr->tok);

	inorder(ptr->right);
}

