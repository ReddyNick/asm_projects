extern ax2dec
extern ax2bin
extern mprintf
extern ax2hex

str_size equ 17

section .text
global _start

 _start:         
                
                mov rsi, format_s

                push '!'
                push 100
                push 3802
                push love
                push string
                push qword '>'
                push 242
                push 8
                push 8                 ; 2nd arg
                push 17                ; 1st argument
                call mprintf


                mov rax, 0x3c
                xor rdi, rdi
                syscall

section         .data

num:           times 17 db 0
                db 0x0a

endstr:         equ $

var:            dw 34
char:           db '>'

format_s:       db "She is %d years old and her cat is %d.", 0x0a
                db "No it is %b. mmm hex numbers %x. Tiger %c %s. And so I %s %x %d %c", 0x0a, 0x00   
string:         db "than cat", 0x00  
love:           db "love", 0x00                


