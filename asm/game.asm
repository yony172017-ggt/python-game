; Assembly Game - x86-64 Linux
; Simple game mechanics in pure assembly

section .data
    player_name: db "Hero", 0
    player_health: dq 100
    player_score: dq 0
    player_level: dq 1
    
    welcome_msg: db "=== Assembly Game ===", 10, "Welcome to the x86-64 Game!", 10, 10, 0
    health_msg: db "Health: ", 0
    score_msg: db " | Score: ", 0
    level_msg: db " | Level: ", 0
    newline: db 10, 0
    
section .text
    global _start

_start:
    ; Print welcome message
    lea rsi, [rel welcome_msg]
    call print_string
    
    ; Initialize game loop
    mov r8, 100          ; health in r8
    mov r9, 0            ; score in r9
    mov r10, 1           ; level in r10
    mov r11, 0           ; x position in r11
    mov r12, 0           ; y position in r12

game_loop:
    ; Check if health <= 0
    cmp r8, 0
    jle game_over
    
    ; Display status
    lea rsi, [rel health_msg]
    call print_string
    mov rax, r8
    call print_number
    
    lea rsi, [rel score_msg]
    call print_string
    mov rax, r9
    call print_number
    
    lea rsi, [rel level_msg]
    call print_string
    mov rax, r10
    call print_number
    
    lea rsi, [rel newline]
    call print_string
    
    ; Simulate random event
    rdtsc                ; Get timestamp
    mov rax, rdx
    xor rdx, rdx
    mov rcx, 10
    div rcx
    
    cmp rdx, 2           ; 20% chance of enemy attack
    jl enemy_attack
    cmp rdx, 5           ; 30% chance of gaining points
    jl gain_points
    jmp game_loop

enemy_attack:
    ; Enemy does 5-15 damage
    rdtsc
    mov rax, rdx
    xor rdx, rdx
    mov rcx, 11
    div rcx
    add rax, 5
    sub r8, rax          ; Reduce health
    jmp game_loop

gain_points:
    ; Gain 10-30 points
    rdtsc
    mov rax, rdx
    xor rdx, rdx
    mov rcx, 21
    div rcx
    add rax, 10
    add r9, rax          ; Add to score
    
    ; Check for level up (score >= 50)
    cmp r9, 50
    jl game_loop
    inc r10              ; Level up
    mov r9, 0            ; Reset score
    mov r8, 100          ; Reset health
    jmp game_loop

game_over:
    lea rsi, [rel newline]
    call print_string
    lea rsi, [rel game_over_msg]
    call print_string
    lea rsi, [rel score_msg]
    call print_string
    mov rax, r9
    call print_number
    lea rsi, [rel newline]
    call print_string
    
    ; Exit
    mov rax, 60          ; sys_exit
    xor rdi, rdi         ; Exit code 0
    syscall

print_string:
    ; rsi = pointer to string
    push rdi
    xor rcx, rcx
    
count_loop:
    mov al, byte [rsi + rcx]
    cmp al, 0
    je write_string
    inc rcx
    jmp count_loop

write_string:
    mov rax, 1           ; sys_write
    mov rdi, 1           ; stdout
    mov rdx, rcx         ; length
    syscall
    pop rdi
    ret

print_number:
    ; rax = number to print
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    
    mov rbx, 10
    xor rcx, rcx
    
digit_loop:
    xor rdx, rdx
    div rbx
    push rdx
    inc rcx
    cmp rax, 0
    jne digit_loop
    
print_loop:
    pop rax
    add al, '0'
    mov [rel temp_digit], al
    lea rsi, [rel temp_digit]
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    syscall
    loop print_loop
    
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

section .data
    game_over_msg: db "GAME OVER! Final Score: ", 0
    temp_digit: db 0
