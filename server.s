section .data
    sockaddr:
        .family: dw 2
        .port: dw 0x5000
        .addr: dd 0
        .zero: dq 0

section .data
    okresp: db `HTTP/1.0 200 OK\r\n\r\n`
    okresp_len equ $ - okresp

section .bss
    req_buffer resb 1024
    filename resb 256
    file_buffer resb 4096

section .text
    global _start

_start:
    ; socket(AF_INET, SOCK_STREAM, 0)
    mov rdi, 2
    mov rsi, 1
    mov rdx, 0
    mov rax, 41
    syscall

    mov r8, rax ; sock_fd

    ; bind(sock_fd, &sockaddr, 16)
    mov rdi, r8
    mov rsi, sockaddr
    mov rdx, 16
    mov rax, 49
    syscall

    ; listen(sock_fd, 0)
    mov rsi, 0
    mov rax, 50
    syscall

    ; accept(sock_fd, 0, 0)
    mov rsi, 0
    mov rdx, 0
    mov rax, 43
    syscall

    mov r9, rax ; client_fd

    ; read(client_fd, req_buffer, 1024)
    mov rdi, r9
    mov rsi, req_buffer
    mov rdx, 1024
    mov rax, 0
    syscall

    lea rsi, [req_buffer + 4]
    mov rdi, filename

; copy filename from req_buffer to filename
copy_filename_loop:
    mov al, [rsi]
    cmp al, " "
    je copy_done
    cmp al, 0
    je copy_done
    mov [rdi], al
    inc rsi
    inc rdi
    jmp copy_filename_loop

copy_done:
    mov byte [rdi], 0

    ; open(filename, O_RDONLY)
    mov rdi, filename
    mov rsi, 0
    mov rax, 2
    syscall

    mov r10, rax ; file_fd

    ; read(file_fd, file_buffer, 4096)
    mov rdi, r10
    mov rsi, file_buffer
    mov rdx, 4096
    mov rax, 0
    syscall

    ; DEBUG: when r11 is used instead of rbx it does not work. WHY?!
    ; DEBUG: instead of writing the read bytes it writes the whole file_buffer
    mov rbx, rax ; bytes_read

    ; close(file_fd)
    mov rax, 3
    syscall

    ; write(client_fd, okresp, okresp_len)
    mov rdi, r9
    mov rsi, okresp
    mov rdx, okresp_len
    mov rax, 1
    syscall

    ; write(client_fd, file_buffer, bytes_read)
    mov rsi, file_buffer
    mov rdx, rbx
    mov rax, 1
    syscall

    ; close(client_fd)
    mov rax, 3
    syscall

    ; exit(0)
    mov rax, 60
    mov rdi, 0
    syscall
