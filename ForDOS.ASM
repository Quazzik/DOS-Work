org 0x7C00
jmp start
;��������� �������� �����
start:
    cli                 ;��������� ����������
    mov ax, 0           ;������������� �������� �����
    mov ss, ax
    mov sp, 0xFFFF      ;��������� ��������� ����� �� ����
    sti                 ;�������� ����������
    mov ax, 0x13        ;����� 320x200 256-�����
    int 0x10
    mov ax, 0x0010
    int 0x10
    ;��������� ������������
    mov cx, 290          ;� ����������
    mov dx, 20           ;Y ����������
    mov bx, 125          ;������
    call draw_triangle
    ;���� ����
    mov ah, 0x0B        ;������� ��� ��������� ����� ����
    mov bl, 0x04        ;������� ���� ����
    int 0x10

    ;����� ������
    mov ah, 0x13        ;������� ��� ������ ������
    mov al, 0
    mov bh, 0
    mov bl, 10          ;���� ������
    mov dl, 34          ;�������
    mov dh, 21          ;������
    push cs
    pop es
    mov bp, msg
    mov cx, 8
    int 0x10
    mov ah, 0x13        ;������� ��� ������ ������
    mov al, 0
    mov bh, 0
    mov bl, 10          ;���� ������
    mov dl, 34          ;�������
    mov dh, 22          ;������
    push cs
    pop es
    mov bp, msg2
    mov cx, 5
    int 0x10
    mov ah, 0x13        ;������� ��� ������ ������
    mov al, 0
    mov bh, 0
    mov bl, 10          ;���� ������
    mov dl, 34          ;�������
    mov dh, 23          ;������
    push cs
    pop es
    mov bp, msg1
    mov cx, 9
    int 0x10
    mov ah, 0x13        ;������� ��� ������ ������
    mov al, 0
    mov bh, 0
    mov bl, 10          ;���� ������
    mov dl, 34          ;�������
    mov dh, 24          ;������
    push cs
    pop es
    mov bp, msg3
    mov cx, 10
    int 0x10

hang:
    jmp hang


    ;��������� ������������
draw_triangle:
    pusha
    mov bp, cx            ;bp �������� �������� x ���������� ��� ���������

    ;���� ��������� ������������
triangle_loop:
    push cx
    mov ax, bx            ;ax ��� ��������� ����� ������������� ����� �� �������
    shr ax, 1
    sub cx, ax            ;��������� ��� ��������� ��������� x ����������
    add ax, bp            ;�������� ��� ��������� �������� x ����������

    ;��������� �������������� �����
draw_line:
    cmp cx, ax            ;�������� ���� ��������� x (cx) ������ ��� �������� x (ax)
    jae line_done         ;���� ��������� ��� ������� �����, ����� ���������
    push ax
    push bx
    push dx

    mov ah, 0x0C          ;��������� �������
    mov al, 0x0F
    int 0x10

    pop dx
    pop bx
    pop ax
    inc cx                ;������� � ������� ������
    jmp draw_line         ;������ ����� ��� ���������� �������

line_done:
    pop cx
    add dx, 1             ;������ ����
    add cx, 1             ;�������� ���������� x �� ���� ������� ������
    dec bx                ;���������� ���������� ������
    jnz triangle_loop     ;���������

    popa                   ;�������������� ���������
    ret
msg db "Korotkov", 0
msg1 db "Artemovich", 0
msg2 db "Yurii", 0
msg3 db "NMT-313901", 0


;���������� ���������� ����� ������������ ������� ������
times 510-($-$$) db 0
dw 0xAA55