format binary as 'img'

org 07c00h

mov ax,0x13
int 10h

CLI
XOR AX,AX
MOV GS,AX
MOV AX,key
MOV [GS:9*4],AX
MOV [GS:9*4+2],CS
MOV AX,timer
MOV [GS:8*4],AX
MOV [GS:8*4+2],CS
STI
mov edi,0xa0000+320*155+110


mov [color], 53 ;celeste
mov [largo], 85
mov [ancho], 100
call cuadrado
;-----------------------/\
mov [color],42 ;naranja
mov [largo],25
add di,50 ;offset right to put el techo derecho
call triangulo

mov di,320*155+160-15 ;button left corner door home


mov [color],26 ;gris
mov [ancho],30
mov [largo],50
call cuadrado


add di,320*12-30 ;caminate a la mitad izquierda de la puerta 

mov [ancho],25
mov [largo],25
call cuadrado
;----------------------------segunda ventana
add di,320*25+(25+5+30+5)
call cuadrado


;Perilla
mov di,320*155+160+10 ;button almost right corner door home FOR PERILLA
sub di,320*24
mov [edi],word 0f0fh
add di,320
mov [edi],word 0f0fh



jmp $
;-----------------------------------------------------------SUBRUTINES

 timer:dec [cont]
	 jnz salir
	 
	call Print
	 mov  [cont],4
	 salir:mov	al,20h			; fin de interrupcion hardware
		out	20h,al			; al pic maestro
	iret
	key:
		in al, 60h
		cmp al, 127
		ja fin_key
		cmp al, 30 ;scan de a
			jnz o1
			mov [flag],2
		jmp fin_key

		o1:cmp al,18 ;scan e
		   jnz o2
		   mov [flag], 3
		   jmp fin_key
		o2:cmp al,25
			jnz fin_key
			mov [flag],0
		fin_key: mov al,20h
				out 20h,al
			iret

;---------------------------------------------

Print:
    cmp [flag],0
    je opaco
    cmp [flag],2
    je opaco
    mov [color],44  ;brillante
    jmp normal
    opaco:
    mov [color],116
    normal: 
    mov edi, 0xa0000+25710+50 ;seria en la parte izq del cuadrado azul a 75 de altura para luego moverme a la derecha 50
    
    mov [largo],3
    call triangulo
    mov [ancho],(13) ;6
    mov [largo],6
    add di,320*9-6 ; pabajo 3 luego 6 para darle espacio al rectangulo
    call cuadrado
    
    add di,320*7+6
    mov [largo],3
    inc [mirror]
    call triangulo
    cmp [flag],3
    je fin
    cmp [flag],2
    je fin
    xor [flag],1
    
fin:dec [mirror]
ret

cuadrado:
    mov bl, [largo]
    mov cx, bx
    mov al, [color]
    primer_bucle:
        push cx
        mov bl, [ancho]
        mov cx, bx
        segundo_bucle:
            mov [edi], byte al
            inc di
        loop segundo_bucle
        
        sub di,bx
        sub di,320
        pop cx
    loop primer_bucle

ret

triangulo:
    
    mov bl, [largo]
    mov cx, bx
    
    mov al, bl  ;trabajo para multiplicar por 2 el largo del triangulo
    mov bl,2
    mul bl 
    mov bx,ax
    mov al, [color]
    triang1:
        push cx
        mov cx,bx
        triang2:
            mov [edi], byte al
            dec di
        loop triang2
        
        add di,bx
        ;---------------------correccion mirror
        cmp [mirror], 1
        jne abajo0
        add di, 320
        jmp continue0
        abajo0:sub di, 320
        continue0:
        sub bx,2
        pop cx
    loop triang1

    ;-------------------------------------------------correccion de posicion di en dos triangulos
    mov cl, [largo]
    sum:                            cmp [mirror],1
                                    jne abajo
        sub di,320
                                    jmp continue
                                    abajo:add di,320
                                    continue:
    loop sum
    

    
    
    mov bl, [largo]
    mov cx, bx
    
    mov al, bl
    mov bl,2
    mul bl 
    mov bx,ax
    mov al, [color]
    triang3:
        push cx
        mov cx,bx
        triang4:
            mov [edi], byte al
            inc di    ;----CHANGE
        loop triang4
        
        sub di,bx     ;----CHANGE

        ;----------------------correccion mirror
        cmp [mirror], 1
        jne abajo1
        add di, 320
        jmp continue1
        abajo1:sub di, 320
        continue1:
        
        sub bx,2
        pop cx
    loop triang3


ret



ancho db 0
largo db 0
color db 1001b
mirror db 0
cont db 1
flag db 2

times 510-($-$$) db 0
dw 0xaa55
