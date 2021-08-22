psych: psych.o
	ld -s -o psych psych.o

psych.o: psych.asm
	nasm -f elf64 -o psych.o psych.asm

clean:
	rm *.o psych

