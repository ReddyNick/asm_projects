.model tiny
.code
org 100h

start:
        call    draw_border
        
        mov     si, offset msg
        call    write_msg

        mov     ax, 0abh
        push    ax
        call    write_ax
        add     sp, 2

        mov     ax, 4c00h
        int     21h

include libaxto.asm
include border.asm
.data
msg     db      'Hey dude!$'

end start