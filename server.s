section .data
    sockaddr:
        .family: dw 2
        .port: dw 0x5000
        .addr: dd 0

section .data
    response: db `HTTP/1.0 200 OK\r\n\r\n`
    response_len equ $ - response

section .bss
    buffer resb 1024

section .text
    global _start

_start:
    ; socket(AF_INET, SOCK_STREAM, 0)
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    mov rdx, 0
    syscall

    mov r9, rax

    ; bind(sock_fd)
    mov rdi, r9
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

    mov r10, rax ; client_fd

    ; read(client_fd, buffer, 1024)
    mov rdi, r10
    mov rsi, buffer
    mov rdx, 1024
    mov rax, 0
    syscall

    ; write(client_fd, response, response_len)
    mov rsi, response
    mov rdx, response_len
    mov rax, 1
    syscall

    ; close(client_fd)
    mov rax, 3
    syscall

    ; exit(0)
    mov rax, 60
    mov rdi, 0
    syscall
