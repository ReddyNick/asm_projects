;____________________________________________
;   This library includes useful FUNCTIONS 
;   that are used in many porjects.      
;____________________________________________

section .text

;_______WRITE_AX_IN_DECIMAL(NOT COMPLETED FOR x64!!!)_______________
;
;   Entry: ax, rsi - address of the end of
;   the string where to write ax.
;   Exit:  rsi - addres of the begining
;   Destr: ax, si, bx
;________________________________________
global ax2dec
ax2dec:

        mov ebx, 10d  ; divide by 10d
        xor dx, dx
        inc rsi

continue_dec:
        dec rsi

		div bx
		add dx, 0x30

		mov [rsi], dl
                xor dx, dx

                cmp	ax, 0
		jne continue_dec

        ret

;_______WRITE_AX_IN_BINARY_______________
;   Entry: ax, si - address of the end of
;   the string where to write ax.
;   Exit:  si - addres of the begining
;   Destr: ax, si, bx
;________________________________________
global ax2bin
ax2bin:
  
continue:
                mov bx, ax
                and bx, 1b
                cmp bx, 1h
                je loop_one
                
                mov byte [rsi], 0x30
                jmp toloop  
loop_one:
                mov byte [rsi], 0x31 
                
toloop:
                shr ax, 1
                cmp ax, 0h
                
                je break
                        dec rsi
                jmp continue

break:
                ret
;____________ax2hex___________________
;
;   Entry: ax, rsi
;   Exit: rsi
;   Destroy: ax,rsi
;__________________________________________
global ax2hex
ax2hex:

                mov ebx, 16d
                xor dx, dx
                inc rsi
continue_hex:    
                dec rsi
                div bx

                cmp dx, 10
                jl numeral
                jmp letter

write_hex:          
                mov [rsi], dl
                xor dx, dx

                cmp     ax, 0
                jne continue_hex
                
                ret

numeral:
        add dx, 48d
        jmp write_hex
letter:
        add dx, 'A' - 10d
        jmp write_hex
;_________________________________________________

;____________strchr___________________
;
;       Entry: rsi = char* string
;       Exit: rsi
;       Destroy: rsi
;__________________________________________
global strchr
strchr:
                mov ax, 0x00
                repne 
                

;____________My_printf___________________
;
;       Entry: (rsi = char* string, op1, op2, ...)
;       Exit: ???
;       Destroy: ???
;__________________________________________
global mprintf
mprintf:
                push rbp
                mov rbp, rsp

                mov r8, 0x10

 
                mov rdi, buffer

                
                ; 
                ;         if ([rsi] == '%')
                ;                 do smth
                ;         else
                ;                 [rdi] = rsi]
                ;                 inc rdi
                ;                 inc rsi
loop_prf:                
                cmp byte [rsi], 0x0             ; while([rsi] != 0)
                je write
                        cmp byte [rsi], '%'     ; while([rsi] != %)
                        je operand
                                movsb           ;[rdi] = byte [rsi], inc rdi, inc rsi
                                jmp loop_prf
                        operand:
                        inc rsi
                        
                        cmp byte [rsi], 's'
                        je string
                        cmp byte [rsi], 'c'
                        je char_symb
                                mov r9, rsi     ; r9 - saved rsi
                               
                                mov ax, [rbp + r8] ; ax = 1st arg to convert to str
                                mov rsi, endbuf
                                dec rsi            ; rsi is the end of the num

                                cmp byte [r9], 'd'     ; if ([rsi] == 'd')
                                jne not_d
                                
                                call ax2dec        ; rsi is the begining of the num
                                
                                jmp endarg
                                
                                not_d:
                                
                                cmp byte [r9], 'b'        ; if ([rsi] == 'c')
                                jne not_b
                                
                                call ax2bin
                                jmp endarg

                                not_b:
                                cmp byte [r9], 'x'
                                ;jne not_x

                                call ax2hex
                                jmp endarg
                                ;not_x
                                endarg:
                                add r8, 8          ; update r8 = r8 + sizeof(ax, 1 word)
                                mov rcx, endbuf    
                                sub rcx, rsi       ; rcx - length of number

                                rep movsb          ; while((cx--)) [rdi] = [rsi], inc rdi, inc rsi

                                mov rsi, r9        ; restore rsi
                                inc rsi

                                jmp loop_prf       ; continue
                        string:
                                mov r9, rsi     ; r9 - saved rsi
                                mov rsi, [rbp + r8]
                                add r8, 8

                        str_loop:
                                cmp byte [rsi], 0x00
                                je endstr
                                movsb
                                jmp str_loop
                        char_symb:
                                ;mov r9, rsi
                                mov rax, [rbp + r8]
                                add r8, 8

                                mov [rdi], rax 
                                inc rdi
                                inc rsi
                                jmp loop_prf
                        endstr: 
                                mov rsi, r9
                                inc rsi
                                jmp loop_prf
                        ;         

                write:                  ;[rsi] = 0

                mov rax, 0x01           ;write
                mov rdx, rdi
                sub rdx, buffer         ;strlen
                mov rdi, 0x01           ;stdout
                mov rsi, buffer
                syscall                 ;profit!

                pop rbp    

        ret


section         .data

buffer:         times 100 db 0
numbuf:         times 20  db 0
endbuf          equ $