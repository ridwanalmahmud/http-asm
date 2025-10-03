section .data
    sockaddr:
        .family: dw 2
        .port: dw 0x5000
        .addr: dd 0

section .text
    global _start

_start:
    ; socket(AF_INET, SOCK_STREAM, 0)
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    mov rdx, 0
    syscall

    ; bind(sock_fd)
    mov rdi, rax
    mov rsi, sockaddr
    mov rdx, 16
    mov rax, 49
    syscall

    ; exit(0)
    mov rax, 60
    mov rdi, 0
    syscall
