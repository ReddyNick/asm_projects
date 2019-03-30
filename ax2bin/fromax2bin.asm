;   write al in videomemory in binary 

.model tiny
.code

color	= 4eh
org 100h

one = 00000001b
start:
        mov ax, 0b800h
        mov es, ax
        mov di, 80*5*2 + 16*2

		mov	ax, 85d
		mov cx, 8
        
continue:
		mov bx, ax
		and bx, one
		cmp bx, 1h
		je loop_one
		
		mov word ptr es:[di], 4e30h
		jmp toloop  
loop_one:
		mov word ptr es:[di], 4e31h 
		
toloop:
		sub di, 2
		ror ax , 1
		loop continue

		mov	ax, 4c00h
		int 21h

end start