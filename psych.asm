; psych.asm
; Ben Crabtree, 2021

; The doctor is in...

; Helpful macros
%define sys_write	4
%define sys_read	3
%define sys_exit	1

%define stdin		2
%define stdout		1

%define newline		10

%define success		0

%define kernel_call	80h

; Initialised variables
section .data
	one:			db	"How are we feeling today?", newline
	one_l:			equ $-one										; Length of string one
	two:			db	"You are feeling "							; Follow two by printing response
	two_l:			equ $-two
	three:			db	"This is concerning.", newline
	three_l:		equ $-three
	four:			db	"I would like to perform some diagnostic tests.", newline
	four_l:			equ	$-four
	five:			db	"I will ask you a series of questions.", newline
	five_l:			equ	$-five
	six:			db	"Try to answer honestly.", newline
	six_l:			equ	$-six
	seven:			db	"Are you ready to begin?", newline
	seven_l:		equ	$-seven
	eight:			db	"What is the name of your first pet?", newline
	eight_l:		equ	$-eight
	nine:			db	"What is the name of the street you lived on as a child?", newline
	nine_l:			equ	$-nine
	ten:			db	"Ok, I can now tell you that your adult film name is " ; Follow ten by printing pet_name+street_name.
	ten_l:			equ $-ten
	eleven:			db	"With that out of the way, we can begin the diagnostic test.", newline
	eleven_l:		equ	$-eleven
	twelve:			db	"Ever since we streamlined the clinical definition of insanity, testing for it has become trivial.", newline
	twelve_l:		equ	$-twelve
	thirteen:		db	"The test consists of a single question. Are you ready?", newline
	thirteen_l:		equ $-thirteen
	fourteen:		db	"Do you ever do the same thing over and over again expecting a different result?", newline
	fourteen_l:		equ	$-fourteen
	; (Repeat until they answer yes)
	fifteen:		db	"Thank you, I can now formulate my diagnosis.", newline
	fifteen_l:		equ	$-fifteen
	sixteen:		db	"I am afraid you meet the clinical criteria for insanity.", newline
	sixteen_l:		equ	$-sixteen
	seventeen:		db	"But don't fret.", newline
	seventeen_l:	equ	$-seventeen
	eighteen:		db	"We're all mad here.", newline
	eighteen_l:		equ $-eighteen

	; Comparison value
	yes:			db	"yes", newline

; Uninitialised variables
section .bss
	%define		buffer_len	255
	response	resb		buffer_len 	; Reserve buffer_len bytes for user response
	pet			resb		buffer_len
	street		resb		buffer_len

; Code
section .text
	; Declare global entry point to program
	global _start:

; Wait for user response
_response:
	mov rax, sys_read
	mov rbx, stdin
	mov rcx, response
	mov rdx, buffer_len
	int kernel_call
	;mov rsi, rax						; Move the number of characters user enters from rax to rsi
	ret

; Ask diagnostic question
_question:
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, fourteen
	mov rdx, fourteen_l
	int kernel_call
	ret

; Print response buffer
_print:
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, response
	mov rdx, buffer_len
	;mov rdx, rsi
	int kernel_call
	ret

; Compare user entered string in response buffer to string "yes\0"
_compare:
	cld										; Scan in forward direction
	mov rcx, 4								; Scan 4 bytes (length of "yes\0")
	lea rsi, [response]						; Load address of response into rsi
	lea rdi, [yes]							; Load address of yes into rdi
	rep cmpsb								; Looks at value in rcx to determine number of bytes to compare
	jne _notsame
	ret

; If strings not equal, ask again
_notsame:
	call _question
	call _response
	call _compare
	ret

; Entry point
_start:
	; Print message one to stdout
	mov rax, sys_write
	mov rbx, stdout							; file descriptor
	mov rcx, one
	mov rdx, one_l
	int kernel_call							; Interrupt - call the kernel with interrupt code 0x80

	call _response

	; Print message two
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, two
	mov rdx, two_l
	int kernel_call

	; Print response
	call _print

	; Print message three
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, three
	mov rdx, three_l
	int kernel_call

	call _response

	; Print message four
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, four
	mov rdx, four_l
	int kernel_call

	call _response

	; Print message five
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, five
	mov rdx, five_l
	int kernel_call

	call _response

	; Print message six
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, six
	mov rdx, six_l
	int kernel_call

	call _response

	; Print message seven
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, seven
	mov rdx, seven_l
	int kernel_call

	call _response

	; Print message eight
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, eight
	mov rdx, eight_l
	int kernel_call

	; Get user response - pet name
	mov rax, sys_read
	mov rbx, stdin
	mov rcx, pet
	mov rdx, buffer_len
	int kernel_call

	; Print message nine
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, nine
	mov rdx, nine_l
	int kernel_call

	; Get user response - street name
	mov rax, sys_read
	mov rbx, stdin
	mov rcx, street
	mov rdx, buffer_len
	int kernel_call

	; Print message ten 
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, ten
	mov rdx, ten_l
	int kernel_call

	; Print pet name
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, pet
	mov rdx, buffer_len
	int kernel_call

	; Print street name
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, street
	mov rdx, buffer_len
	int kernel_call

	call _response

	; Print message eleven 
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, eleven
	mov rdx, eleven_l
	int kernel_call

	call _response

	; Print message twelve 
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, twelve
	mov rdx, twelve_l
	int kernel_call

	call _response

	; Print message thirteen 
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, thirteen
	mov rdx, thirteen_l
	int kernel_call

	call _response
	;call _print

	call _notsame

	; Print message fifteen
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, fifteen
	mov rdx, fifteen_l
	int kernel_call
	                        
	call _response

	; Print message sixteen
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, sixteen
	mov rdx, sixteen_l
	int kernel_call
	                        
	call _response

	; Print message seventeen
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, seventeen
	mov rdx, seventeen_l
	int kernel_call
	                        
	call _response

	; Print message eighteen
	mov rax, sys_write
	mov rbx, stdout
	mov rcx, eighteen
	mov rdx, eighteen_l
	int kernel_call

	; Exit program
	mov rax, sys_exit
	mov rbx, success				; Error code 0
	int kernel_call
