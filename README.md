# Практическая работа №1
## Выполнил: Коротков Юрий Артемович <br/> Академическая группа: НМТ-313901
В списке приложенных файлов ForDOS.ASM - файл с исходным кодом на flat assembler и ForDOS.img - готовый образ floppy для запуска на машине под DOS X86. <br/> Листинг кода представлен ниже:
``` assembler language
org 0x7C00
jmp start             ;перемещение к метке start

start:                ;точка входа в программу
    cli                 
    mov ax, 0           
    mov ss, ax
    mov sp, 0xFFFF      
    sti                 
    mov ax, 0x13        
    int 0x10
    mov ax, 0x0010
    int 0x10
   
    mov cx, 290          
    mov dx, 20           
    mov bx, 125          
    call draw_triangle
    mov ah, 0x0B      ;установка цвета фона   
    mov bl, 0x04      ;определение цвета фона
    int 0x10

    mov ah, 0x13       ;вывод текста      
    mov al, 0
    mov bh, 0
    mov bl, 10          ;определение цвета текста
    mov dl, 34          ;определение колонки текста
    mov dh, 21          ;поределение строки текста
    push cs
    pop es
    mov bp, msg
    mov cx, 8
    int 0x10
    mov ah, 0x13        
    mov al, 0
    mov bh, 0
    mov bl, 10          
    mov dl, 34          
    mov dh, 22         
    push cs
    pop es
    mov bp, msg2
    mov cx, 5
    int 0x10
    mov ah, 0x13       
    mov al, 0
    mov bh, 0
    mov bl, 10         
    mov dl, 34        
    mov dh, 23         
    push cs
    pop es
    mov bp, msg1
    mov cx, 9
    int 0x10
    mov ah, 0x13        
    mov al, 0
    mov bh, 0
    mov bl, 10         
    mov dl, 34         
    mov dh, 24        
    push cs
    pop es
    mov bp, msg3
    mov cx, 10
    int 0x10

hang:
    jmp hang

draw_triangle:
    pusha
    mov bp, cx         ;сохраняю текущаю позицию курсора   

triangle_loop:
    push cx
    mov ax, bx          ;ax для рисования линий с убывающей длинной по очереди
    shr ax, 1
    sub cx, ax          ;определение начальной координаты
    add ax, bp          ;определение конечной координаты

draw_line:              ;создание метки draw_line
    cmp cx, ax            
    jae line_done         
    push ax
    push bx
    push dx

    mov ah, 0x0C         ;отображение пикселя
    mov al, 0x0F
    int 0x10

    pop dx
    pop bx
    pop ax
    inc cx                ;перемещение курсора с кледующему пикселю
    jmp draw_line         ;возврат к метке draw_line для рисования следующей линии

line_done:
    pop cx
    add dx, 1            
    add cx, 1             
    dec bx                
    jnz triangle_loop   

    popa                   
    ret
msg db "Korotkov", 0
msg1 db "Artemovich", 0
msg2 db "Yurii", 0
msg3 db "NMT-313901", 0


times 510-($-$$) db 0     ;выравнивание объема файла до кратности 512 байт для заполнения всего сектора
dw 0xAA55
```
