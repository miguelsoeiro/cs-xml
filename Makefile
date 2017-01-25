all:
	bison -dtv Converter.y
#	byacc -dtv -o Converter.tab.c Converter.y 
	flex Converter.l
	gcc Converter.tab.c lex.yy.c -o Converter -g

clean:
	rm Converter.tab.c
	rm lex.yy.c


