extern printf



section .text
global _start

_start:
				mov 	rax, 1			; sys_write
				mov 	rdi, 1			; stdout
				mov 	rsi, invite
				mov     rdx, invitelen
				syscall

				mov 	rsi, buffer

				xor 	rax, rax		; sys_read
				xor 	rdi, rdi 		; stdin
				mov 	rdx, 100		
				syscall

				mov 	rsi, buffer
				mov 	rdi, pswrd
				call 	check_pswrd	

				mov		al, [str1]
				cmp 	al, 'Y'
				jne		access_denied
				
				mov 	rax, 1			; sys_write
				mov 	rdi, 1			; stdout
				mov 	rsi, right_pswrd
				mov     rdx, right_pswrdlen
				syscall

				jmp endprog

access_denied:				
				mov 	rax, 1			; sys_write
				mov 	rdi, 1			; stdout
				mov 	rsi, wrong_pswrd
				mov     rdx, wrong_pswrdlen
				syscall
				
endprog:
				mov 	rax, 0x3C		; exit64 (rdi)
            	xor 	rdi, rdi
            	syscall


section .data

pswrd:			db		0x89, 0xa2, 0xaf, 0xaa, 0xb6, 0xaa, 0xa7, 0xbb
pswrdlen		equ		$ - pswrd

invite:					db		"Введите пароль", 0xa
invitelen				equ		$ - invite

right_pswrd:			db 		"Доступ получен!", 0xa , "Здравствуйте!", 0xa
right_pswrdlen			equ		$ - right_pswrd

wrong_pswrd:			db		"Неверный пароль!", 0xa
wrong_pswrdlen			equ		$ - wrong_pswrd

buffer:			times pswrdlen + 1 db 0
str1:			db 0, 0

section	.text
;---------------CHECK_PASSWORD---------------------------
check_pswrd:
				mov 	al, 0x40
		loop_:
				add 	byte[rsi], al
				inc    	rsi
				inc   	al

				cmp 	al, 0x48
				jne 	loop_


				mov 	rsi, buffer
				mov		rcx, pswrdlen
				repe 	cmpsb

				jne		incorrect
				mov		byte [str1], 'Y'
incorrect:
				ret

