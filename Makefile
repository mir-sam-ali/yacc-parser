myparser: y.tab.c lex.yy.c y.tab.h
	gcc y.tab.c lex.yy.c  -g -ll -ly  -o myparser
lex.yy.c: parser.l
	lex parser.l
y.tab.c: parser.y
	yacc -v -d parser.y
clean:
	rm -f myparser y.tab.c lex.yy.c y.tab.h y.output
