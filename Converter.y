%{
#include <stdio.h>
#include <string.h>
#include "header.h"

//#define YYDEBUG 1

extern int yylex( void);
extern int yylineno;
extern void start_flex( const char *filename );
extern void end_flex( void );

#define YYERROR_VERBOSE 1
int yyerror( const char *s )
{
	fprintf( stderr, "Bison error in line %d: %s\n", yylineno, s );
	return 1;
}

void emitxml(char* outp, char* no, char* value, char* sub1, char* sub2, char* sub3 )
{
	sprintf(outp, "<%s value=\"%s\">\n", no, value);
	char buf[MAX_CODE_LEN];
	buf[0]=0;
	if (sub1 && sub1[0]){ 
		sprintf(buf+strlen(buf), "%s\n", sub1);
	}
	if (sub2 && sub2[0]){ 
		sprintf(buf+strlen(buf), "%s\n", sub2);
	}
	if (sub3 && sub3[0]){
		sprintf(buf+strlen(buf), "%s\n", sub3);
	}
	// transforma \n => \n\t
	int i, j;
	for (i = strlen(outp), j = 0; buf[j]; i++, j++) {
		outp[i] = buf[j];
		if (buf[j] == '\n')
			outp[++i] = '\t';
	}
	outp[i] = 0;
	sprintf(outp+i-1, "</%s>", no);

}


void concatlist(char* outp, char* list, char* elem)
{
	sprintf(outp, "%s%s", list, elem);
}


%}

%union	{
	int       i;
	double    d;
	char      s[ MAX_STR_LEN + 1];
	char	  codigo[MAX_CODE_LEN +1];
}

%token VARINT 
%token VARDOUBLE
%token VARCHAR
%token VARVOID
%token VARBOOL
%token IF
%token ELSE
%token WHILE
%token FOR
%token FUNCTION
%token ';'
%token ','
%token TRUE FALSE DO LET THIS NUL RETURN
%token METHOD FIELD CTOR CLASS STATIC GE LE VAR 

%left '|' '&'
%left '/' '%' '*'
%left '+' '-'
%left AND
%left OR
%left NOT
%left EQUAL DIFF GE LE '<' '>'
%left '=' 

%token <s> IDENT
%token <s> STRING
%token <i> INTEGER
%token <d> DOUBLE

%type <codigo> program classlist class  field fieldlist fieldlisti funclist funclisti
%type <codigo> funckind functype vartype paramlist paramlisti vardecllist vardecllisti vardecl function fbody
%type <codigo> instrs instrsi param block instr call arithmetic condition
%type <codigo> exprlist exprlisti keywordconst  expr value identlist identlisti


%%

program
: classlist				{ emitxml($$, "program", "C#", $1, 0, 0); puts($$); }
;

classlist
: class					{ strcpy($$, $1); }
| classlist class		{ concatlist($$, $1, $2); }
;

class
: CLASS IDENT '{' fieldlist funclist'}'	{ emitxml($$, "class", $2, $4, $5, 0); }
| CLASS IDENT '{' fieldlist  '}'		{ emitxml($$, "class", $2, $4, 0, 0); }
| CLASS IDENT '{' funclist '}'			{ emitxml($$, "class", $2, $4, 0, 0); }
| CLASS IDENT '{' '}'	{ emitxml($$, "class", $2, 0, 0, 0); }
;

fieldlist
: fieldlisti			{ emitxml($$, "list", "fields", $1, 0, 0); }
;

fieldlisti
: field					{ strcpy($$, $1); }
| fieldlisti field		{ concatlist($$, $1, $2); }
;

field
: STATIC vartype identlist ';'	{ emitxml($$, "static field", "", $3, 0, 0); }
| FIELD vartype identlist ';'	{ emitxml($$, "field", "", $3, 0, 0); }
;

funclist
: funclisti				{ emitxml($$, "list", "functions", $1, 0, 0); }
;

funclisti
: function				{ strcpy($$, $1); }
| funclisti function	{ concatlist($$, $1, $2); }
;

function : funckind functype IDENT '(' paramlist ')' fbody	{ emitxml($$, $1, $3, $2, $5, $7); }
	;

funckind
: CTOR					{ strcpy($$, "constructor"); }
| FUNCTION				{ strcpy($$, "function"); }
| METHOD				{ strcpy($$, "method"); }
;

functype
: VARVOID				{ emitxml($$, "type", "VOID", 0,0,0); }
| vartype				{ strcpy($$, $1); }
;

fbody
: '{' vardecllist instrs '}'	{ emitxml($$, "body", "", $2, $3, 0); }
;

vardecllist
: vardecllisti			{ emitxml($$, "list", "variable decls", $1, 0, 0); }
;

vardecllisti
: /* eps */				{ $$[0] = 0; }
| vardecllisti vardecl	{ concatlist($$, $1, $2); }
;

vardecl
: VAR vartype identlist ';'	{ emitxml($$, "variable decl", "", $2, 0, 0); }
;

paramlist
: paramlisti				{ emitxml($$, "list", "parameters", $1, 0, 0); }
;

paramlisti
: param					{ strcpy($$, $1); }
| paramlisti ',' param	{ concatlist($$, $1, $3); }
;

param
: vartype IDENT			{ emitxml($$, "parameter", $2, $1,0,0); }
;

vartype
: VARINT				{ emitxml($$, "type", "INTEGER", 0,0,0); }
| VARDOUBLE				{ emitxml($$, "type", "DOUBLE", 0,0,0); }
| VARCHAR				{ emitxml($$, "type", "CHARACTER", 0,0,0); }
| VARBOOL				{ emitxml($$, "type", "BOOLEAN", 0,0,0); }
| IDENT					{ emitxml($$, "type", $1, 0,0,0); }
;

instrs
: instrsi				{ emitxml($$, "list", "instructions", $1, 0, 0); }
; 

instrsi
: instr ';'				{ strcpy($$, $1); }
| instrsi instr ';'		{ concatlist($$, $1, $2); }
;

instr
: LET IDENT '[' expr ']' '=' expr	{ emitxml($$, "local array var", $2, $2, $4, $7); }
| LET IDENT '=' expr				{ emitxml($$, "local var", $2, $4, 0,0); }
| IF '(' expr ')' block				{ emitxml($$, "if", "", $3, $5, 0); }
| IF '(' expr ')' block ELSE block	{ emitxml($$, "if-else", "", $3, $5, $7); }
| WHILE '(' expr ')' block			{ emitxml($$, "while", "", $3, $5, 0); }
| DO call							{ strcpy($$, $2); }
| RETURN expr						{ emitxml($$, "return", "", $2, 0, 0); }
;

block
: '{' instrs '}'					{ emitxml($$, "block", "", $2, 0, 0); }
;

call
: IDENT '(' exprlist ')'			{ emitxml($$, "call", $1, $1, $3, 0); }
| IDENT '.' IDENT '(' exprlist ')'	{ emitxml($$, "call", $3, $1, $3, $5); }
;

exprlist
: exprlisti				{ emitxml($$, "list", "expressions", $1, 0, 0); }
;

exprlisti
: expr					{ strcpy($$, $1); }
| exprlisti ',' expr	{ concatlist($$, $1, $3); }
;

expr
: '(' expr ')'			{ strcpy($$, $2); }
| keywordconst			{ strcpy($$, $1); }
| value					{ strcpy($$, $1); }
| arithmetic			{ strcpy($$, $1); }
| condition				{ strcpy($$, $1); }
| '-' expr				{ emitxml($$, "unary plus", "", $2, 0, 0); }
| '~' expr				{ emitxml($$, "unary minus", "", $2, 0, 0); }
;

arithmetic
: expr '+' expr			{ emitxml($$, "plus", "", $1, $3, 0); }
| expr '-' expr			{ emitxml($$, "minus", "", $1, $3, 0); }
| expr '/' expr			{ emitxml($$, "div", "", $1, $3, 0); }
| expr '*' expr			{ emitxml($$, "mult", "", $1, $3, 0); }
| expr '&' expr			{ emitxml($$, "b.and", "", $1, $3, 0); }
| expr '|' expr			{ emitxml($$, "b.xor", "", $1, $3, 0); }
;

condition
: expr '<' expr			{ emitxml($$, "less-than", "", $1, $3, 0); }
| expr '>' expr			{ emitxml($$, "greater-than", "", $1, $3, 0); }
| expr EQUAL expr		{ emitxml($$, "equal", "", $1, $3, 0); }
| expr GE expr			{ emitxml($$, "greater-or-equal", "", $1, $3, 0); }
| expr LE expr			{ emitxml($$, "less-or-equal", "", $1, $3, 0); }
| expr DIFF expr		{ emitxml($$, "not-equal", "", $1, $3, 0); }
| expr AND expr			{ emitxml($$, "logical and", "", $1, $3, 0); }
| expr OR expr			{ emitxml($$, "logical or", "", $1, $3, 0); }
;

keywordconst
: THIS					{ emitxml($$, "pointer", "this", 0, 0, 0); }
| NUL					{ emitxml($$, "pointer", "0", 0, 0, 0); }
| FALSE					{ emitxml($$, "boolean", "false", 0, 0, 0); }
| TRUE					{ emitxml($$, "boolean", "true", 0, 0, 0); }
;

value
: INTEGER				{ char buf[100]; sprintf(buf, "%d", $1); emitxml($$, "integer", buf, 0, 0, 0); }
| DOUBLE				{ char buf[100]; sprintf(buf, "%f", $1); emitxml($$, "double", buf, 0, 0, 0); }
| STRING				{ emitxml($$, "string", $1, 0, 0, 0); }
| IDENT					{ emitxml($$, "identifier", $1, 0, 0, 0); }
;

identlist
: identlisti			{ emitxml($$, "list", "identifiers", $1, 0, 0); }
;

identlisti
: IDENT					{ strcpy($$, $1); }
| identlisti ',' IDENT	{ concatlist($$, $1, $3); }
;

%%

int main(int argc, char* argv[]){
	int rv;
//	yydebug = 1;

	start_flex( argc >= 2 ? argv[1] : NULL );
	rv = yyparse();
	end_flex();

	return rv;
}
