%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}
alpha [A-Za-z]
digit [0-9]
%%
"int"                           {strcpy(yylval.lexeme, yytext); return INT; }
"float"                         {strcpy(yylval.lexeme, yytext); return FLOAT; }
"char"                         {strcpy(yylval.lexeme, yytext); return CHAR; }
{alpha}({alpha}|{digit})*    	{strcpy(yylval.lexeme, yytext); return ID; }
{digit}+ 							{strcpy(yylval.lexeme, yytext); return NUMBER;}

"("									return LP;
")"									return RP;
"["                                 return LSB;
"]"                                 return RSB;
","                                 return COMMA;
";"									return SCOL;

[ \t\n] ;      /* ignore white space */
"{"   ;
"}"   ;
"$"		{ return 0; }

.  		{ return yytext[0]; }
%%
