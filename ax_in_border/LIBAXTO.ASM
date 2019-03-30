;   write al in videomemory in hex 

.code

color	= 4eh


write_ax        proc
        push    bp
        mov     bp, sp

        mov     ax, 0b800h
        mov es, ax
        mov di, 80*5*2 + 16*2
        std         ; di decreases

	mov	ax, [bp + 4]
        mov dl, 16d  ; divide by 10d
continue:    
		div dl
        mov	dh, al	; remeber quotient

        cmp ah, 10
        jl numeral
        jmp letter

write:		
		xor al, ah
		xor ah, al
		xor al, ah	; swop al, ah

		mov ah, color ; 

		stosw			; mov es:[di], ax / di = di - 2
		mov	al, dh		; write quotient
		xor	ah, ah		; ah = 0

		cmp	al, 0
		jne continue
        jmp done

numeral:
        add ah, 48d
        jmp write
letter:
        add ah, 'A' - 10d
        jmp write

done:
        pop bp
	ret
        endp
