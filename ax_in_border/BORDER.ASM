; 	draw border with text
.model tiny
X 		 = 10
Y	  	 = 7
videomem = 0b800h
color    = 4Eh
width	 = 18h

.code
;------------------------------
;Draw border around area
;Destr: ax, bx, cx, dx, di, si
;------------------------------
public draw_border
draw_border	proc		
		mov	ax, videomem
		mov	es, ax		; es -> videomem

		mov	di, (X + Y * 80) * 2    ; coordinates

;_______LU_CORNER____________________________
		mov	ax, 4EC9h
		stosw
		
;______DRAW_UPPER_BORDER_____________________		
		mov	cx, width
		mov	al, 0CDh
upper_border:	
		stosw			;/ mov es:[di], ax / di = di + 2
		loop	upper_border
;______RU_CORNER_____________________________
		mov	al, 0bbh
		stosw	

;______DRAW_BODY_____________________________
		mov	di, (X + (Y+1) * 80) * 2    ; next line
		xor	si, si						; si = 0
		mov	bx, 3						; while (si < bi)
loop_body:
		mov	al, 0Bah	
		stosw

		;______DRAW__LINE__________________________
		mov	cx, width
		mov	al, 0h 
loop_line:
		stosw
		loop	loop_line
		;____________________________________________

		mov	al, 0Bah	
		stosw

		add	di,	(80 - width - 2)*2
		inc	si
		cmp	si, bx
		jne	loop_body
;________________________________________________
		
;_______LOWER__BODER________
		mov	al, 0c8h
		stosw
;______DRAW_LOWER_BORDER_____________________		
		mov	cx, width
		mov	al, 0cdh
lower_border:	
		stosw
		loop	lower_border

		mov	al, 0bch
		stosw

		ret
		endp
;_____WRITE_MSG__________________________
;draw message in border
;Entry: si - addres of message
;Destr: ax, di, si
;-----------------------------------------
public write_msg
write_msg	proc
		mov	di, (X + 5 + (Y+2) * 80) * 2	;line for the message
		
		
		lodsb
msg_loop:
		stosw
		lodsb
		cmp	al, 24h		; until '$'
		jne	msg_loop

		ret
		endp
;______________________________________	
	end
		 