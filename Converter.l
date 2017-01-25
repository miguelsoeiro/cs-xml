%option noyywrap  yylineno

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "header.h"
#include "Converter.tab.h"

int debug=0;
int bracketsNum =0;

%}

%%

int					return VARINT;
double				return VARDOUBLE;
char				return VARCHAR;
void				return VARVOID;
boolean				return VARBOOL;
true				return TRUE;
false				return FALSE;
if					return IF;
else				return ELSE;
while				return WHILE;
for					return FOR;
do					return DO;
let					return LET;
this				return THIS;
null				return NUL;
return				return RETURN;
function			return FUNCTION;
method				return METHOD;
field				return FIELD;
constructor			return CTOR;
class				return CLASS;
static				return STATIC;
var					return VAR;

"=="				return EQUAL;
"!="				return DIFF;
"&&"				return AND;
"||"				return OR;
">="				return GE;
"<="				return LE;

[!{}\[\]();,.+\-*/\\&|<>=~]	return yytext[0];

["]([^\\\n]|\\.)*["]	{ strncpy( yylval.s, yytext, MAX_STR_LEN ); yylval.s[ strlen(yylval.s) ] = '\0';return STRING; }

[0-9]+					{ yylval.i = atoi( yytext ); return INTEGER;}
[0-9]+\.[0-9]+			{ yylval.d = atof( yytext ); return DOUBLE;}
[a-zA-Z_][a-zA-Z0-9_]{0,31}	{ strcpy( yylval.s, yytext ); return IDENT; }

"//".*\n				/* ignorar */

.|\n|\r					/* ignorar */

%%

void start_flex( const char *filename )
{
	FILE *fp;

	if( filename != NULL )
	{
		fp = fopen( filename, "r" );
		if( fp == NULL )
			fprintf( stderr, "File \"%s\" not found: while reading from keyboard.\n", filename );
		else
			yyrestart( fp );
	}
}

void end_flex( void )
{
	fclose( yyin );
}
