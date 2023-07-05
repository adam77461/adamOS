;adam OS Kernel

BITS 16
[org 0]

mov ax,cs
mov ds,ax
mov es,ax
mov ax,0x7000
mov ss,ax
mov sp,ss
start:
	jmp jumphere
	command:
	jmp overregistration
	lines dw 0
	overregistration:
	
	
	
mov ebx, 0

	mov ebx, 0
	mov dh, 9			; First, draw red background box 
 	mov dl, 9 
 
        call os_move_cursor
 .blackbox:				; Loop to draw all lines of box 
 	call os_move_cursor 
 	pusha 
	mov ah, 09h 
	mov bh, 0 
	mov cx, 60 
 	mov bl, 14		; White on red 
 	mov al, ' ' 
 	int 10h 
 	popa 
 
 
 	inc dh 
 	cmp dh, 20 
 	je menuapps1 
 	jmp .blackbox 
	
 menuapps1:
	mov dh, 9			
 	mov dl, 9 
 
        call os_move_cursor
   mov si, welcome
   call print_string
 mainloop:
mov si, prompt
   call print_string
 
   mov di, buffer
   call get_string
 
   mov si, buffer
   cmp byte [si], 0  ; blank line?
   je mainloop       ; yes, ignore it
 
 


mov si, buffer
mov di, cmd_Shutdown
call strcmp
jc Shutdown
cmp edx, 4
jne nxt11

Shutdown:
cmp edx, 4
jne bb11
cmd_Shutdown db 'Shutdown', 0
bb11:


    mov ax, 0x1000
    mov ax, ss
    mov sp, 0xf000
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15

jmp mainloop
nxt11:
mov si, buffer
mov di, cmd_Restart
call strcmp
jc Restart
cmp edx, 4
jne nxt18

Restart:
cmp edx, 4
jne bb18
cmd_Restart db 'Restart', 0
bb18:


int 19h
	
jmp mainloop
nxt18:
mov si, buffer
mov di, cmd_Exit
call strcmp
jc Exit
cmp edx, 4
jne nxt25

Exit:
cmp edx, 4
jne bb25
cmd_Exit db 'exit()', 0
bb25:

call start


jmp mainloop
nxt25:
mov si, buffer
mov di, cmd_Time
call strcmp
jc Time
cmp edx, 4
jne nxt34

Time:
cmp edx, 4
jne bb34
cmd_Time db 'Time', 0
bb34:
add dh, 1
mov dl, 10
call os_move_cursor

	mov bx, tmp_string
	call os_get_time_string
	mov si, bx
	call os_print_string
	call os_print_newline
	

jmp mainloop
nxt34:
mov si, buffer
mov di, cmd_Date
call strcmp
jc Date
cmp edx, 4
jne nxt41

Date:
cmp edx, 4
jne bb41
cmd_Date db 'Date', 0
bb41:
add dh, 1
mov dl, 10
call os_move_cursor
	mov bx, tmp_string 
	call os_get_date_string 
 	mov si, bx 
 	call os_print_string 
 	call os_print_newline 
	

jmp mainloop
nxt41:
  mov si, buffer
   mov di, cmd_help  ; "help" command
   call strcmp
   jc .help



mov si,badcommand
   call print_string 
   jmp mainloop  
 


 .help:
   mov si, msg_help
   call print_string
 
   jmp mainloop

.python_2:
 mov si,cmd_py
 call print_string
 jmp mainloop

cmd_py db 'python27:>', 0
py db 'python', 0
welcome db 'adam_OS',0x0D,0x0A, 0
 badcommand db '         Bad command entered.', 0x0D, 0x0A, 0
 prompt db '         python27:>', 0
 cmd_help db 'help', 0
 msg_help db '         adam OS Commands: Shutdown, Restart, Exit, Date, Time', 0x0D, 0x0A, 0
 buffer times 64 db 0
 
 ; ================
 ; calls start here
 ; ================
 
 print_string:

   lodsb        ; grab a byte from SI
 
   or al, al  ; logical or AL by itself
   jz .done   ; if the result is zero, get out
 
   mov ah, 0x0E
   int 0x10      ; otherwise, print out the character!
 
   jmp print_string
 
 .done:
   ret
 
 get_string:
   xor cl, cl
 
 .loop:
   mov ah, 0
   int 0x16   ; wait for keypress
 
   cmp al, 0x08    ; backspace pressed?
   je .backspace   ; yes, handle it
 
   cmp al, 0x0D  ; enter pressed?
   je .done      ; yes, were done
 
   cmp cl, 0x3F  ; 63 chars inputted?
   je .loop      ; yes, only let in backspace and enter
 
   mov ah, 0x0E
   int 0x10      ; print out character
 
   stosb  ; put character in buffer
   inc cl
   jmp .loop
 
 .backspace:
   cmp cl, 0	; beginning of string?
   je .loop	; yes, ignore the key
 
   dec di
   mov byte [di], 0	; delete character
   dec cl		; decrement counter as well
 
   mov ah, 0x0E
   mov al, 0x08
   int 10h		; backspace on the screen
 
   mov al, ' '
   int 10h		; blank character out
 
   mov al, 0x08
   int 10h		; backspace again
 
   jmp .loop	; go to the main loop
 
 .done:
   mov al, 0	; null terminator
   stosb
	

add ebx, 1
 cmp ebx, 10
jg command

		
   mov ah, 0x0E
   mov al, 0x0D
   int 0x10
   mov al, 0x0A
   int 0x10		; newline
 
   ret
 
 strcmp:
 .loop:
   mov al, [si]   ; grab a byte from SI
   mov bl, [di]   ; grab a byte from DI
   cmp al, bl     ; are they equal?
   jne .notequal  ; nope, were done.
 
   cmp al, 0  ; are both bytes (they were equal before) null?
   je .done   ; yes, were done.
 
   inc di     ; increment DI
   inc si     ; increment SI
   jmp .loop  ; loop!
 
 .notequal:
   clc  ; not equal, clear the carry flag
   ret
 
 .done: 	
   stc  ; equal, set the carry flag
   ret
	jumphere:
	mov dh,0x0           ; y cordinate
	mov dl,0x0           ; x cordinate
	int 0x10
	mov ebx, 4
	mov al,03h 
	mov ah,0 
	int 10h 

 mov ah, 09h
 mov cx, 1000h
 mov al, 20h

mov bl, 91
int 10h

     mov ah, 09h
     mov cx, 80d
     mov al, 20h
     
mov bl, 14
int 10h

	mov si, msg9
call write
call nnn
msg9 db 'adam_OS                                                                 ' , 0
nnn:
print_time:
	
	mov bx, tmp_string
	call os_get_time_string
	mov si, bx
	call os_print_string
	call os_print_newline





call mouselib_install_driver
mov ax, 0
mov bx, 0
mov cx, 79
mov dx, 24
call mouselib_range
mov dh, 3
mov dl, 2
call mouselib_scale

main:
	call mouselib_freemove
	jc keypress

	push dx
	mov dx, 0
	call os_move_cursor
	mov si, filler
	call os_printt_string
	call os_move_cursor
	
	pop dx
	
	
	cmp dx, 4
	jg start
	cmp cx, 11
	jg start	
	
	cmp ebx, 12
	jne asknext3
	cmp dx, 1
	je asknext
	jmp asknext1
	asknext:
	cmp cx, 11
	jl shutdown
	
	asknext1:
	
	cmp dx, 2
	je asknext2
	jmp asknext3
	asknext2:
	cmp cx, 11
	jl restart
	
	asknext3:
	cmp dx, 3
	je asknext4
	jmp asknext5
	asknext4:
	cmp cx, 11
	jl command
	

	asknext5:
	cmp dx, 4
	je asknext6
	jmp asknext7
	asknext6:
	cmp cx, 11
	jl sleep

	asknext7:
	cmp cx, 0
	jg uuu
        uuu:
	cmp dx, 0
	jne main
	cmp cx, 11
	jl rest	

   	jmp main
jmp nxtxt
rest:


        mov dh, 1			; First, draw red background box 
 	mov dl, 0 
 
 
 .redbox:				; Loop to draw all lines of box 
 	call os_move_cursor 
 
 
 	pusha 
	mov ah, 09h 
	MOV BH, 0    ; YellowOnBlue
	mov cx, 11 
 	mov bl, 14		; White on red 
 	mov al, ' ' 
 	int 10h 
 	popa 
 
 
 	inc dh 
 	cmp dh, 5 
 	je menuapps 
 	jmp .redbox 
	jmp start
	menuapps:
	
	mov dh, 0			; First, draw red background box 
 	mov dl, 0
	call os_move_cursor
		mov si, msg12
call write
call rrr
msg12 db 10,13,'SHUTDOWN',10,13,'REBOOT',10,13,'PYTHON27',10,13,'SLEEP',0
rrr:
	mov ebx, 12
	jmp main
	shutdown:
	
    mov ax, 0x1000
    mov ax, ss
    mov sp, 0xf000
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15
	restart:
	int 19h
	jmp start

	sleep:
	mov ax,0x13         ;clears the screen
	int 0x10
	mov ax,0x00             ; get keyboard input
	int 0x16                ; hold for input
	cmp ah,0x1C             ; compare input is enter(1C) or not
    je start
nxtxt:	
keypress:
	cmp al, 27
	je exit
	
	jmp main

exit:
	call mouselib_remove_driver
	ret
	jmp main
	os_move_cursor:
	pusha

	mov bh, 0
	mov ah, 2
	int 10h				; BIOS interrupt to move cursor

	popa
	ret
	os_printt_string:
	pusha

	mov ah, 0Eh			; int 10h teletype function

.repeat:
	lodsb				; Get char from string
	cmp al, 0
	je .done			; If char is zero, end of string

	int 10h				; Otherwise, print it
	jmp .repeat			; And move on to next char

.done:
	popa
	ret
os_int_to_string:
	pusha

	mov cx, 0
	mov bx, 10			; Set BX 10, for division and mod
	mov di, .t			; Get our pointer ready

.push:
	mov dx, 0
	div bx				; Remainder in DX, quotient in AX
	inc cx				; Increase pop loop counter
	push dx				; Push remainder, so as to reverse order when popping
	test ax, ax			; Is quotient zero?
	jnz .push			; If not, loop again
.pop:
	pop dx				; Pop off values in reverse order, and add 48 to make them digits
	add dl, '0'			; And save them in the string, increasing the pointer each time
	mov [di], dl
	inc di
	dec cx
	jnz .pop

	mov byte [di], 0		; Zero-terminate string

	popa
	mov ax, .t			; Return location of string
	ret


	.t times 7 db 0

jmp overmousemessages
filler db '', 0
message db 'Mouse click at X: ', 0
seperator db ' Y: ', 0


mouselib_install_driver:
	pusha
	cli
	
	; Enable the auxiliary mouse device
	call mouselib_int_wait_1
	mov al, 0xA8
	out 0x64, al
	
	; Enable the interrupts
	call mouselib_int_wait_1
	mov al, 0x20
	out 0x64, al
	call mouselib_int_wait_0
	in al, 0x60
	or al, 0x02
	mov bl, al
	call mouselib_int_wait_1
	mov al, 0x60
	out 0x64, al
	call mouselib_int_wait_1
	mov al, bl
	out 0x60, al
	
	; Tell the mouse to use default settings
	mov ah, 0xF6
	call mouselib_int_write
	call mouselib_int_read		; Acknowledge
	
	; Enable the mouse
	mov ah, 0xF4
	call mouselib_int_write
	call mouselib_int_read		; Acknowledge
	
	; Setup the mouse handler
	cli
	push es
	mov ax, 0x0000
	mov es, ax
	
	mov ax, [es:0x01D0]
	mov [mouselib_int_originalhandler], ax
	mov ax, [es:0x01D2]
	mov [mouselib_int_originalseg], ax
	
	mov word [es:0x01D0], mouselib_int_handler
	mov word [es:0x01D2], 0x2000
	pop es
	sti
	
	popa
	ret
	
; ---------------------------------

mouselib_int_wait_0:
	mov cx, 65000
	mov dx, 0x64
.wait:
	in al, dx
	bt ax, 0
	jc .okay
	loop .wait
.okay:
	ret
	
; ---------------------------------

mouselib_int_wait_1:
	mov cx, 65000
	mov dx, 0x64
.wait:
	in al, dx
	bt ax, 1
	jnc .okay
	loop .wait
.okay:
	ret

; -----------------------------------------------------
; mouselib_int_write --- write a value to the mouse controller
; IN: AH = byte to send

mouselib_int_write:
	; Wait to be able to send a command
	call mouselib_int_wait_1
	; Tell the mouse we are sending a command
	mov al, 0xD4
	out 0x64, al
	; Wait for the final part
	call mouselib_int_wait_1
	; Finally write
	mov al, ah
	out 0x60, al
	ret
	
; -----------------------------------------------------
; mouselib_int_read --- read a value from the mouse controller
; OUT: AL = value

mouselib_int_read:
	; Get the response from the mouse
	call mouselib_int_wait_0
	in al, 0x60
	ret


	
; ----------------------------------------
; TachyonOS Mouse Driver
	
mouselib_int_handler:
	cli
	
	pusha
	push ds
	mov ax, 0x2000
	mov ds, ax
	
	; Check which byte number this is 
	cmp byte [.number], 0
	je .data_byte
	
	cmp byte [.number], 1
	je .x_byte
	
	cmp byte [.number], 2
	je .y_byte

.data_byte:
	; Collect data byte - contains buttons, overflow flags, alignment bit and negative delta flags
	in al, 0x60
 	mov [mouselib_int_data], al
 	
;  	bt ax, 3
;  	jc .alignment
 	
 	; The next byte will be X-delta
 	mov byte [.number], 1
 	jmp .finish
 	
.alignment:
	mov byte [.number], 0
	jmp .finish
 	
.x_byte:
	; Collect X-delta byte - contains left-right mouse movement
	in al, 0x60
	mov [mouselib_int_delta_x], al
	; The next byte will be Y-delta
	mov byte [.number], 2
	jmp .finish
	
.y_byte:
	; Collect Y-delta byte - contains up-down mouse movement
	in al, 0x60
	mov [mouselib_int_delta_y], al
	; The next byte will byte the data byte
	mov byte [.number], 0

; Now we have the entire packet it is time to process its data.
; We want to figure out the new X and Y co-ordinents and which buttons are pressed.
	
.process_packet:
	mov ax, 0
	mov bx, 0
	mov bl, [mouselib_int_data]
	test bx, 0x00C0			; If x-overflow or y-overflow is set ignore packet
	jnz .finish

	mov byte [mouselib_int_changed], 1 	; Mark there has been a mouse update for functions awaiting mouse input
	
	; Get the movement values
	mov cx, 0
	mov cl, [mouselib_int_delta_x]
	mov dx, 0
	mov dl, [mouselib_int_delta_y]
	
	; Check data byte for the X sign flag
	bt bx, 4
	jc .negative_delta_x

	; Right Movement - Add the X-delta to the raw X position
	add [mouselib_int_x_raw], cx
	jmp .scale_x
	
.negative_delta_x:
	; Left movement - Invert the X-delta and subtract it from the raw X position
	xor cl, 0xFF
	inc cl

	; Verify that the number to be subtract is greater than the total to avoid an underflow.
	cmp cx, [mouselib_int_x_raw]
	jg .zero_x
	
	sub [mouselib_int_x_raw], cx
	
.scale_x:
	; We have the new 'raw' position
	; Now shift it according to the mouse scale factor to find the 'scaled' position
	; The mouse position is based of the raw position but functions read the scaled position
	mov cx, [mouselib_int_x_raw]
	
	mov ax, cx
	mov cl, [mouselib_int_x_scale]
	shr ax, cl
	mov cx, ax
	mov [mouselib_int_x_position], cx
	
.check_x_boundries:
	; Make sure the new scaled position does not exceed the boundries set by the operating system
	cmp cx, [mouselib_int_x_minimum]
	jl .fix_x_minimum
	
	cmp cx, [mouselib_int_x_limit]
	jg .fix_x_limit
	
.find_y_position:
	; Now do everything again to process the Y-delta
	bt bx, 5			; Check data byte for the Y sign flag
	jc .negative_delta_y
	
	cmp dx, [mouselib_int_y_raw]
	jg .zero_y
	
	; Upward movememnt, take Y-delta from the raw Y position
	sub [mouselib_int_y_raw], dx
	jmp .scale_y
	
.negative_delta_y:
	; Downward movement, invert Y-delta and add it to the raw Y position
	xor dl, 0xFF
	inc dl
		
	add [mouselib_int_y_raw], dx
	
.scale_y:
	mov dx, [mouselib_int_y_raw]
	
	mov cl, [mouselib_int_y_scale]
	shr dx, cl
	mov [mouselib_int_y_position], dx
	
.check_y_boundries:
	cmp dx, [mouselib_int_y_minimum]
	jl .fix_y_minimum
	
	cmp dx, [mouselib_int_y_limit]
	jg .fix_y_limit
	
.check_buttons:
	; Movement is complete, now to update the button press status
	; These can be taken from the lower bits of data byte
	; Bit 0 = Left Mouse
	; Bit 1 = Right Mouse
	; Bit 2 = Middle Mouse
	
	bt bx, 0
	jc .left_mouse_pressed
	
	mov byte [mouselib_int_button_left], 0		; If a button is not pressed, set it's status to zero
	
	bt bx, 2
	jc .middle_mouse_pressed
	
	mov byte [mouselib_int_button_middle], 0
	
	bt bx, 1
	jc .right_mouse_pressed
	
	mov byte [mouselib_int_button_right], 0
	
.finish:
	; For IRQ 8-15 we MUST send and End Of Interrupt command to both the master and slave PIC
	; Otherwise we will not get any more interrupts and lockup our mouse and keyboard
	mov al, 0x20				; End Of Interrupt (EOI) command
	out 0x20, al				; Send EOI to master PIC
	out 0xa0, al				; Send EOI to slave PIC
	
	; And that's all for now
	pop ds
	popa
	sti
	iret
	
	.number				db 0
	
.zero_x:
	; If the value we want to take is greater to the total, just set the position as zero and continue
	mov word [mouselib_int_x_raw], 0
	jmp .scale_x
	
.fix_x_minimum:
	; If the scale position is less than the minimum, set it to the minimum
	mov cx, [mouselib_int_x_minimum]
	mov [mouselib_int_x_position], cx
	
	; Now reverse the shift to find the corrosponding raw position, because that is the the one that gets updated
	mov ax, cx
	mov cl, [mouselib_int_x_scale]
	shl ax, cl
	mov [mouselib_int_x_raw], ax

	jmp .find_y_position
	
.fix_x_limit:
	; If the scale postion is greater than the limit just set it to the limit
	mov cx, [mouselib_int_x_limit]
	mov [mouselib_int_x_position], cx
	
	mov ax, cx
	mov cl, [mouselib_int_x_scale]
	shl ax, cl
	mov [mouselib_int_x_raw], ax
	
	jmp .find_y_position
	
.zero_y:
	mov word [mouselib_int_y_raw], 0
	jmp .scale_y
	
.fix_y_minimum:
	mov dx, [mouselib_int_y_minimum]
	mov [mouselib_int_y_position], dx
	
	mov cl, [mouselib_int_y_scale]
	shl dx, cl
	mov [mouselib_int_y_raw], dx
	
	jmp .check_buttons
	
.fix_y_limit:
	mov dx, [mouselib_int_y_limit]
	mov [mouselib_int_y_position], dx
	
	mov cl, [mouselib_int_y_scale]
	shl dx, cl
	mov [mouselib_int_y_raw], dx
	
	jmp .check_buttons
	
.left_mouse_pressed:
	; When a button is pressed, set a marker to make it easy for the API
	mov byte [mouselib_int_button_left], 1
	
	; Check for other buttons - all must be updated
	bt bx, 2
	jc .middle_mouse_pressed
	
	mov byte [mouselib_int_button_middle], 0
	
	bt bx, 1
	jc .right_mouse_pressed
	
	mov byte [mouselib_int_button_right], 0
	
	jmp .finish
	
.middle_mouse_pressed:
	mov byte [mouselib_int_button_middle], 1
	
	bt bx, 1
	jc .right_mouse_pressed
	
	mov byte [mouselib_int_button_right], 0
	
	jmp .finish
	
.right_mouse_pressed:
	mov byte [mouselib_int_button_right], 1
	
	jmp .finish
	
	
; --------------------------------------------------
; mouselib_locate -- return the mouse co-ordinents
; IN: none
; OUT: CX = Mouse X, DX = Mouse Y
	
mouselib_locate:
	; Move the scale mouse positions into the registers
	mov cx, [mouselib_int_x_position]
	mov dx, [mouselib_int_y_position]
	
	ret

	
; --------------------------------------------------
; mouselib_move -- set the mouse co-ordinents
; IN: CX = Mouse X, DX = Mouse Y
; OUT: none

mouselib_move:
	pusha
	
	; Set the scale mouse position
	mov ax, cx
	mov [mouselib_int_x_position], ax
	mov [mouselib_int_y_position], dx
	
	; To move the mouse we must set the raw position
	; If we don't the next mouse update will simple overwrite our scale position
	; So shift the mouse position by the scale factor
	mov cl, [mouselib_int_x_scale]
	shl ax, cl
	mov [mouselib_int_x_raw], ax
	
	mov cl, [mouselib_int_y_scale]
	shl dx, cl
	mov [mouselib_int_y_raw], dx
	
	popa
	ret


; --------------------------------------------------
; mouselib_show -- shows the cursor at current position
; IN: none
; OUT: none

mouselib_show:
	; THIS DOES NOT WORK IN GRAPHICS MODE!
	push ax
	
	; Basically show and hide just invert the current character
	; We use mouselib_int_cursor_x so that we can remember where we put the cursor
	; just in case it changes before we can hide it
	cmp byte [mouselib_int_cursor_on], 1
	je .already_on
	
	mov ax, [mouselib_int_x_position]
	mov [mouselib_int_cursor_x], ax
	
	mov ax, [mouselib_int_y_position]
	mov [mouselib_int_cursor_y], ax
	
	call mouselib_int_toggle
	
	mov byte [mouselib_int_cursor_on], 1
	
	pop ax
	
.already_on:
	ret
	

; --------------------------------------------------
; mouselib_hide -- hides the cursor
; IN: none
; OUT: none
	
mouselib_hide:
	cmp byte [mouselib_int_cursor_on], 0
	je .already_off
	
	call mouselib_int_toggle
	
	mov byte [mouselib_int_cursor_on], 0
	
.already_off:
	ret
	

mouselib_int_toggle:
	pusha
	
	; Move the cursor into mouse position
	mov ah, 02h
	mov bh, 0
	mov dh, [mouselib_int_cursor_y]
	mov dl, [mouselib_int_cursor_x]
	int 10h
	
	; Find the colour of the character
	mov ah, 08h
	mov bh, 0
	int 10h
	
	; Invert it to get its opposite
	not ah
	
	; Display new character
	mov bl, ah
	mov ah, 09h
	mov bh, 0
	mov cx, 1
	int 10h
	
	popa
	ret

; --------------------------------------------------
; mouselib_range -- sets the range maximum and 
;	minimum positions for mouse movement
; IN: AX = min X, BX = min Y, CX = max X, DX = max Y
; OUT: none

mouselib_range:
	; Just activate the range registers, the driver will handler the rest
	mov [mouselib_int_x_minimum], ax
	mov [mouselib_int_y_minimum], bx
	mov [mouselib_int_x_limit], cx
	mov [mouselib_int_y_limit], dx
	
	ret
	
	
; --------------------------------------------------
; mouselib_wait -- waits for a mouse event
; IN: none
; OUT: none

mouselib_wait:
	; The driver set the mouselib_int_changed flag every time there is a mouse update
	; So we can wait for an update by setting it to zero and waiting for it to change
	mov byte [mouselib_int_changed], 0
	
.wait:
	; This is a good opertunity to save power while nothing is happening.
	hlt
	cmp byte [mouselib_int_changed], 1
	je .done
	
	jmp .wait

.done:
	ret

	
; --------------------------------------------------
; mouselib_anyclick -- check if any mouse button is pressed
; IN: none
; OUT: none

mouselib_anyclick:
	cmp byte [mouselib_int_button_left], 1
	je .click
	
	cmp byte [mouselib_int_button_middle], 1
	je .click
	
	cmp byte [mouselib_int_button_right], 1
	je .click
	
	clc
	ret
	
.click:
	stc
	ret
	

; --------------------------------------------------
; mouselib_leftclick -- checks if the left mouse button is pressed
; IN: none
; OUT: CF = set if pressed, otherwise clear

mouselib_leftclick:
	cmp byte [mouselib_int_button_left], 1
	je .pressed
	
	clc
	ret
	
.pressed:
	stc
	ret


; --------------------------------------------------
; mouselib_middleclick -- checks if the middle mouse button is pressed
; IN: none
; OUT: CF = set if pressed, otherwise clear

mouselib_middleclick:
	cmp byte [mouselib_int_button_middle], 1
	je .pressed
	
	clc
	ret
	
.pressed:
	stc
	ret
	
	
; --------------------------------------------------
; mouselib_rightclick -- checks if the right mouse button is pressed
; IN: none
; OUT: CF = set if pressed, otherwise clear

mouselib_rightclick:
	cmp byte [mouselib_int_button_right], 1
	je .pressed
	
	clc
	ret
	
.pressed:
	stc
	ret
	
	
; ------------------------------------------------------------------
; mouselib_input_wait -- waits for mouse or keyboard input
; IN: none
; OUT: CF = set if keyboard, clear if mouse

mouselib_input_wait:
	push ax
	
	; Clear the mouse update flag so we can tell when the driver had updated it
	mov byte [mouselib_int_changed], 0
	
.input_wait:
	; Check with BIOS if there is a keyboard key available - but don't collect the key
	mov ah, 11h
	int 16h
	jnz .keyboard_input
	
	
	; Check if the mouse driver had recieved anything
	cmp byte [mouselib_int_changed], 1
	je .mouselib_int_input
	
	hlt
	
	jmp .input_wait
	
.keyboard_input:
	pop ax
	stc
	ret
	
.mouselib_int_input:
	pop ax
	clc
	ret
	
	
; ------------------------------------------------------------------
; mouselib_scale -- scale mouse movment speed as 1:2^X
; IN: DL = mouse X scale, DH = mouse Y scale

mouselib_scale:
	; Set the scale factor and let the driver handle the rest
	mov [mouselib_int_x_scale], dl
	mov [mouselib_int_y_scale], dh
	ret

	
; ------------------------------------------------------------------
; mouselib_remove_driver --- restores the original mouse handler
; IN: nothing
; OUT: nothing

mouselib_remove_driver:
	push ax
	push es
	cli
	
	; Restore the old handler on the interrupt vector table
	mov ax, 0x0000
	mov es, ax
	
	mov ax, [mouselib_int_originalhandler]
	mov [es:0x01D0], ax
	mov ax, [mouselib_int_originalseg]
	mov [es:0x01D2], ax

	pop es

	; Disable the mouse
	mov ah, 0xF5
	call mouselib_int_write
	call mouselib_int_read		; Acknowledge

	; Edit the PS/2 configureation to disable mouse interrupts
	call mouselib_int_wait_1
	mov al, 0x20
	out 0x64, al
	call mouselib_int_wait_0
	in al, 0x60
	and al, 0xFD
	mov bl, al
	call mouselib_int_wait_1
	mov al, 0x60
	out 0x64, al
	call mouselib_int_wait_1
	mov al, bl
	out 0x60, al
	
	; Disable the mouse device
	call mouselib_int_wait_1
	mov al, 0xA7
	out 0x64, al
	
	sti
	pop ax
	ret
	
; ------------------------------------------------------------------
; mouselib_freemove --- allows the user to move the mouse around the screen
;                       stops when a mouse click or keyboard event occurs
; IN: none
; OUT:  AX = key pressed or zero if mouse click
;	CX = mouse x, DX = mouse y, CF = set if key press, clear if mouse click

mouselib_freemove:
	call mouselib_show
	call mouselib_input_wait
	jc .keypress
	
	call mouselib_hide
	
	call mouselib_anyclick
	jc .mouseclick
	
	jmp mouselib_freemove
	
.keypress:
	call mouselib_hide
	
	call mouselib_check_for_extkey
	
	cmp ax, 0
	je mouselib_freemove
	
	call mouselib_locate
	stc
	ret
	
.mouseclick:
	mov ax, 0
	call mouselib_locate
	clc
	ret
	
; ------------------------------------------------------------------
; mouselib_check_for_extkey --- checks for an extended keypress
; IN: nothing
; OUT: AX = key value (zero if no key pressed)

mouselib_check_for_extkey:
	mov ah, 11h
	int 16h
	jz .no_key
	
	mov ax, 10h
	int 16h
	ret
	
.no_key:
	mov ax, 0
	ret
	
	

; All the data needed by the mouse driver and API
mouselib_int_data				db 0
mouselib_int_delta_x				db 0
mouselib_int_delta_y				db 0
mouselib_int_x_raw				dw 0
mouselib_int_y_raw				dw 0
mouselib_int_x_scale				db 0
mouselib_int_y_scale				db 0
mouselib_int_x_position				dw 0
mouselib_int_y_position				dw 0
mouselib_int_x_minimum				dw 0
mouselib_int_x_limit				dw 0
mouselib_int_y_minimum				dw 0
mouselib_int_y_limit				dw 0
mouselib_int_button_left			db 0
mouselib_int_button_middle			db 0
mouselib_int_button_right			db 0
mouselib_int_cursor_on				db 0
mouselib_int_cursor_x				dw 0
mouselib_int_cursor_y				dw 0
mouselib_int_changed				db 0
mouselib_int_originalhandler			dw 0
mouselib_int_originalseg			dw 0


overmousemessages:

cmp eax , 4
jne noshowtime	
os_get_time_string:
	pusha

	mov di, bx			; Location to place time string

	clc				; For buggy BIOSes
	mov ah, 2			; Get time data from BIOS in BCD format
	int 1Ah
	jnc .read

	clc
	mov ah, 2			; BIOS was updating (~1 in 500 chance), so try again
	int 1Ah

.read:
	mov al, ch			; Convert hours to integer for AM/PM test
	call os_bcd_to_int
	mov dx, ax			; Save

	mov al,	ch			; Hour
	shr al, 4			; Tens digit - move higher BCD number into lower bits
	and ch, 0Fh			; Ones digit
	test byte [fmt_12_24], 0FFh
	jz .twelve_hr

	call .add_digit			; BCD already in 24-hour format
	mov al, ch
	call .add_digit
	jmp short .minutes

.twelve_hr:
	cmp dx, 0			; If 00mm, make 12 AM
	je .midnight

	cmp dx, 10			; Before 1000, OK to store 1 digit
	jl .twelve_st1

	cmp dx, 12			; Between 1000 and 1300, OK to store 2 digits
	jle .twelve_st2

	mov ax, dx			; Change from 24 to 12-hour format
	sub ax, 12
	mov bl, 10
	div bl
	mov ch, ah

	cmp al, 0			; 1-9 PM
	je .twelve_st1

	jmp short .twelve_st2		; 10-11 PM

.midnight:
	mov al, 1
	mov ch, 2

.twelve_st2:
	call .add_digit			; Modified BCD, 2-digit hour
.twelve_st1:
	mov al, ch
	call .add_digit

	mov al, ':'			; Time separator (12-hr format)
	stosb

.minutes:
	mov al, cl			; Minute
	shr al, 4			; Tens digit - move higher BCD number into lower bits
	and cl, 0Fh			; Ones digit
	call .add_digit
	mov al, cl
	call .add_digit

	mov al, ' '			; Separate time designation
	stosb

	mov si, .hours_string		; Assume 24-hr format
	test byte [fmt_12_24], 0FFh
	jnz .copy

	mov si, .pm_string		; Assume PM
	cmp dx, 12			; Test for AM/PM
	jg .copy

	mov si, .am_string		; Was actually AM

.copy:
	lodsb				; Copy designation, including terminator
	stosb
	cmp al, 0
	jne .copy

	popa
	ret


.add_digit:
	add al, '0'			; Convert to ASCII
	stosb				; Put into string buffer
	ret
	.hours_string	db 'hours', 0
	.am_string 	db 'AM', 0
	.pm_string 	db 'PM', 0

os_bcd_to_int:
pusha
mov bl, al	; Store entire number for now
and ax, 0Fh	; Zero-out high bits
mov cx, ax	; CH/CL = lower BCD number, zero extended
shr bl, 4	; Move higher BCD number into lower bits, zero fill msb
mov al, 10
mul bl	; AX = 10 * BL
add ax, cx	; Add lower BCD to 10*higher
mov [.tmp], ax
popa
mov ax, [.tmp]	; And return it in AX!
ret
.tmp	dw 0


os_print_newline:
	pusha

	mov ah, 0Eh			; BIOS output char code

	mov al, 13
	int 10h
	mov al, 10
	int 10h

	popa
	ret
os_print_string:
	pusha

	mov ah, 0Eh			; int 10h teletype function

.repeat:
	lodsb				; Get char from string
	cmp al, 0
	je .done			; If char is zero, end of string

	int 10h				; Otherwise, print it
	jmp .repeat			; And move on to next char

.done:
	popa
	ret

fmt_12_24	db 0
fmt_date db 0, '/'

tmp_string	times 15 db 0

os_get_date_string:
	pusha

	mov di, bx			; Store string location for now
	mov bx, [fmt_date]		; BL = format code
	and bx, 7F03h			; BH = separator, 0 = use month names

	clc				; For buggy BIOSes
	mov ah, 4			; Get date data from BIOS in BCD format
	int 1Ah
	jnc .read

	clc
	mov ah, 4			; BIOS was updating (~1 in 500 chance), so try again
	int 1Ah

.read:
	cmp bl, 2			; YYYY/MM/DD format, suitable for sorting
	jne .try_fmt1

	mov ah, ch			; Always provide 4-digit year
	call .add_2digits
	mov ah, cl
	call .add_2digits		; And '/' as separator
	mov al, '/'
	stosb

	mov ah, dh			; Always 2-digit month
	call .add_2digits
	mov al, '/'			; And '/' as separator
	stosb

	mov ah, dl			; Always 2-digit day
	call .add_2digits
	jmp short .done

.try_fmt1:
	cmp bl, 1			; D/M/Y format (military and Europe)
	jne .do_fmt0

	mov ah, dl			; Day
	call .add_1or2digits

	mov al, bh
	cmp bh, 0
	jne .fmt1_day

	mov al, ' '			; If ASCII months, use space as separator

.fmt1_day:
	stosb				; Day-month separator

	mov ah,	dh			; Month
	cmp bh, 0			; ASCII?
	jne .fmt1_month

	call .add_month			; Yes, add to string
	mov ax, ', '
	stosw
	jmp short .fmt1_century

.fmt1_month:
	call .add_1or2digits		; No, use digits and separator
	mov al, bh
	stosb

.fmt1_century:
	mov ah,	ch			; Century present?
	cmp ah, 0
	je .fmt1_year

	call .add_1or2digits		; Yes, add it to string (most likely 2 digits)

.fmt1_year:
	mov ah, cl			; Year
	call .add_2digits		; At least 2 digits for year, always

	jmp short .done

.do_fmt0:				; Default format, M/D/Y (US and others)
	mov ah,	dh			; Month
	cmp bh, 0			; ASCII?
	jne .fmt0_month

	call .add_month			; Yes, add to string and space
	mov al, ' '
	stosb
	jmp short .fmt0_day

.fmt0_month:
	call .add_1or2digits		; No, use digits and separator
	mov al, bh
	stosb

.fmt0_day:
	mov ah, dl			; Day
	call .add_1or2digits

	mov al, bh
	cmp bh, 0			; ASCII?
	jne .fmt0_day2

	mov al, ','			; Yes, separator = comma space
	stosb
	mov al, ' '

.fmt0_day2:
	stosb

.fmt0_century:
	mov ah,	ch			; Century present?
	cmp ah, 0
	je .fmt0_year

	call .add_1or2digits		; Yes, add it to string (most likely 2 digits)

.fmt0_year:
	mov ah, cl			; Year
	call .add_2digits		; At least 2 digits for year, always


.done:
	mov ax, 0			; Terminate date string
	stosw

	popa
	ret


.add_1or2digits:
	test ah, 0F0h
	jz .only_one
	call .add_2digits
	jmp short .two_done
.only_one:
	mov al, ah
	and al, 0Fh
	call .add_digit
.two_done:
	ret

.add_2digits:
	mov al, ah			; Convert AH to 2 ASCII digits
	shr al, 4
	call .add_digit
	mov al, ah
	and al, 0Fh
	call .add_digit
	ret

.add_digit:
	add al, '0'			; Convert AL to ASCII
	stosb				; Put into string buffer
	ret

.add_month:
	push bx
	push cx
	mov al, ah			; Convert month to integer to index print table
	call os_bcd_to_int
	dec al				; January = 0
	mov bl, 4			; Multiply month by 4 characters/month
	mul bl
	mov si, .months
	add si, ax
	mov cx, 4
	rep movsb
	cmp byte [di-1], ' '		; May?
	jne .done_month			; Yes, eliminate extra space
	dec di
.done_month:
	pop cx
	pop bx
	ret


	.months db 'Jan.Feb.Mar.Apr.May JuneJulyAug.SeptOct.Nov.Dec.'
noshowtime:
write: 
mov bp,sp 
cont: 
lodsb 
or al,al 
jz dne 
mov ah,0x0e 
mov bx,0 
int 10h 
jmp cont 

dne: 
mov sp,bp 
ret 

	

ret

