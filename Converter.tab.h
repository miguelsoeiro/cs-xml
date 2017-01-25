/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_CONVERTER_TAB_H_INCLUDED
# define YY_YY_CONVERTER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    VARINT = 258,
    VARDOUBLE = 259,
    VARCHAR = 260,
    VARVOID = 261,
    VARBOOL = 262,
    IF = 263,
    ELSE = 264,
    WHILE = 265,
    FOR = 266,
    FUNCTION = 267,
    TRUE = 268,
    FALSE = 269,
    DO = 270,
    LET = 271,
    THIS = 272,
    NUL = 273,
    RETURN = 274,
    METHOD = 275,
    FIELD = 276,
    CTOR = 277,
    CLASS = 278,
    STATIC = 279,
    GE = 280,
    LE = 281,
    VAR = 282,
    AND = 283,
    OR = 284,
    NOT = 285,
    EQUAL = 286,
    DIFF = 287,
    IDENT = 288,
    STRING = 289,
    INTEGER = 290,
    DOUBLE = 291
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 55 "Converter.y" /* yacc.c:1909  */

	int       i;
	double    d;
	char      s[ MAX_STR_LEN + 1];
	char	  codigo[MAX_CODE_LEN +1];

#line 98 "Converter.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_CONVERTER_TAB_H_INCLUDED  */
