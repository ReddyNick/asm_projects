;   write al in videomemory in dec 

.model tiny
.code

color	= 4eh
org 100h

start:
        mov ax, 0b800h
        mov es, ax
        mov di, 80*5*2 + 16*2
        std         ; di decreases

		mov	ax, 85d
        mov dl, 10d  ; divide by 10d
continue:    
		div dl
        mov	dh, al	; remeber quotient
		add ah, 48d
		
		xor al, ah
		xor ah, al
		xor al, ah	; swop al, ah

		mov ah, color ; 

		stosw			; mov es:[di], ax / di = di - 2
		mov	al, dh		; write quotient
		xor	ah, ah		; ah = 0

		cmp	al, 0
		jne continue

		mov	ax, 4c00h
		int 21h

end start