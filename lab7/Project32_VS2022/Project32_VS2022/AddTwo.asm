include irvine32.inc
.code
main proc
mov ax,0ff2eh
mov bx,09f78h
mov cx,03266h
mov dx,0aa11h

add al,bl
add bl,cl
add cl,dl
sub bl,cl
sub al,bl
mov eax,0
movzx bx,al
call writeint
invoke exitprocess,0
main endp 
end main