org 0x7C00
jmp start
;Настройка сегмента стека
start:
    cli                 ;Отключить прерывания
    mov ax, 0           ;Инициализация сегмента стека
    mov ss, ax
    mov sp, 0xFFFF      ;Установка указателя стека на верх
    sti                 ;Включить прерывания
    mov ax, 0x13        ;режим 320x200 256-цвета
    int 0x10
    mov ax, 0x0010
    int 0x10
    ;Рисование треугольника
    mov cx, 290          ;Х координата
    mov dx, 20           ;Y координата
    mov bx, 125          ;Высота
    call draw_triangle
    ;цвет фона
    mov ah, 0x0B        ;Функция для установки цвета фона
    mov bl, 0x04        ;Красный цвет фона
    int 0x10

    ;Вывод текста
    mov ah, 0x13        ;Функция для вывода текста
    mov al, 0
    mov bh, 0
    mov bl, 10          ;Цвет текста
    mov dl, 34          ;Колонка
    mov dh, 21          ;Строка
    push cs
    pop es
    mov bp, msg
    mov cx, 8
    int 0x10
    mov ah, 0x13        ;Функция для вывода текста
    mov al, 0
    mov bh, 0
    mov bl, 10          ;Цвет текста
    mov dl, 34          ;Колонка
    mov dh, 22          ;Строка
    push cs
    pop es
    mov bp, msg2
    mov cx, 5
    int 0x10
    mov ah, 0x13        ;Функция для вывода текста
    mov al, 0
    mov bh, 0
    mov bl, 10          ;Цвет текста
    mov dl, 34          ;Колонка
    mov dh, 23          ;Строка
    push cs
    pop es
    mov bp, msg1
    mov cx, 9
    int 0x10
    mov ah, 0x13        ;Функция для вывода текста
    mov al, 0
    mov bh, 0
    mov bl, 10          ;Цвет текста
    mov dl, 34          ;Колонка
    mov dh, 24          ;Строка
    push cs
    pop es
    mov bp, msg3
    mov cx, 10
    int 0x10

hang:
    jmp hang


    ;Рисование треугольника
draw_triangle:
    pusha
    mov bp, cx            ;bp сохраним оригинал x координаты для сравнения

    ;Цикл отрисовки треугольника
triangle_loop:
    push cx
    mov ax, bx            ;ax для рисования линий уменьшающейся длины по очереди
    shr ax, 1
    sub cx, ax            ;Вычитание для получения начальной x координаты
    add ax, bp            ;Сложение для получения конечной x координаты

    ;Рисование горизонтальной линии
draw_line:
    cmp cx, ax            ;Проверка если начальный x (cx) меньше чем конечный x (ax)
    jae line_done         ;Если достигнут или пройден конец, линия закончена
    push ax
    push bx
    push dx

    mov ah, 0x0C          ;отрисовка пикселя
    mov al, 0x0F
    int 0x10

    pop dx
    pop bx
    pop ax
    inc cx                ;Переход к пикселю справа
    jmp draw_line         ;Повтор цикла для следующего пикселя

line_done:
    pop cx
    add dx, 1             ;строка выше
    add cx, 1             ;Смещение начального x на один пиксель вправо
    dec bx                ;Уменьшение оставшейся высоты
    jnz triangle_loop     ;Континуум

    popa                   ;Восстановление регистров
    ret
msg db "Korotkov", 0
msg1 db "Artemovich", 0
msg2 db "Yurii", 0
msg3 db "NMT-313901", 0


;Заполнение оставшейся части загрузочного сектора нулями
times 510-($-$$) db 0
dw 0xAA55