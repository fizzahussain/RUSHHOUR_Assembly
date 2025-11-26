INCLUDE Irvine32.inc
.data
    BOARD_SIZE      EQU 20
    MAX_PASSENGERS  EQU 5
    MAX_OBSTACLES   EQU 10
    MAX_CARS        EQU 8
    
    ; Board grid (1=road, 0=building)
    board           BYTE 400 DUP(1)
    
    ; Player state
    playerX         BYTE 0
    playerY         BYTE 0
    playerScore     DWORD 0
    playerFuel      DWORD 500
    taxiColor       BYTE 0
    targetPass      SDWORD -1
    jobsDone        DWORD 0
    passengerCount  DWORD 0
    
    ; Passengers
    passX           BYTE 5 DUP(0)
    passY           BYTE 5 DUP(0)
    passDestX       BYTE 5 DUP(0)
    passDestY       BYTE 5 DUP(0)
    passPicked      BYTE 5 DUP(0)
    passActive      BYTE 5 DUP(0)
    
    ; Obstacles
    obstX           BYTE 10 DUP(0)
    obstY           BYTE 10 DUP(0)
    obstType        BYTE 10 DUP(0)
    obstacleCount   DWORD 0
    
    ; Other cars
    carX            BYTE 8 DUP(0)
    carY            BYTE 8 DUP(0)
    carDirX         SBYTE 8 DUP(0)
    carDirY         SBYTE 8 DUP(0)
    carActive       BYTE 8 DUP(1)
    carCount        DWORD 0
    
    ; Frame counter
    frameCount      DWORD 0
    inputChar       BYTE ?
    playerName      BYTE 30 DUP(?)


     ground BYTE "================================================================================",0
    
    ; Title
    titleLine1      BYTE "          ____  _   _ ____  _   _   _   _  ___  _   _ ____  ", 0
    titleLine2      BYTE "         |  _ \| | | / ___|| | | | | | | |/ _ \| | | |  _ \ ", 0
    titleLine3      BYTE "         | |_) | | | \___ \| |_| | | |_| | | | | | | | |_) |", 0
    titleLine4      BYTE "         |  _ <| |_| |___) |  _  | |  _  | |_| | |_| |  _ < ", 0
    titleLine5      BYTE "         |_| \_\\___/|____/|_| |_| |_| |_|\___/ \___/|_| \_\\", 0
    titleLine6      BYTE "                                                              ", 0
    titleLine7      BYTE "                     _____  __    __  __ ___                  ", 0
    titleLine8      BYTE "                    |_   _|/ /\\ \\ \\/ \\|_ _|                 ", 0
    titleLine9      BYTE "                      | | / /\\ \\\\ /\\ \\| |                  ", 0
    titleLine10     BYTE "                      |_|/_/  \\_\\_||_/___|                  ", 0
     menuOpt1        BYTE "            1. Start New Game", 0
    menuOpt2        BYTE "            2. Continue Game", 0
    menuOpt3        BYTE "            3. Change Difficulty", 0
    menuOpt4        BYTE "            4. View Leaderboard", 0
    menuOpt5        BYTE "            5. Instructions", 0
    menuOpt6        BYTE "            6. Exit", 0
    menuPrompt      BYTE "            Use Arrow Keys to select, Enter to confirm", 0



.code
main PROC
  
    call Clrscr
    call ShowTitle
    call ShowMenu
    exit
main ENDP



ShowTitle PROC
    mov edx, OFFSET titleLine1
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine2
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine3
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine4
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine5
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine6
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine7
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine8
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine9
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine10
    call WriteString
    call Crlf
    call Crlf
    ret
ShowTitle ENDP



ShowMenu PROC
    mov ecx, 6             ; number of menu options
    mov ebx, 1             ; current selection index
MenuLoop:
    call Clrscr
    call ShowTitle

    mov esi, 1
PrintOptions:
    cmp esi, ebx
    jne NotSelected
    mov eax, yellow + (black * 16)
    call SetTextColor
    jmp PrintItem
NotSelected:
    mov eax, white + (black * 16)
    call SetTextColor

PrintItem:
    mov edx, OFFSET menuOpt1
    cmp esi, 1
    je PrintDone
    mov edx, OFFSET menuOpt2
    cmp esi, 2
    je PrintDone
    mov edx, OFFSET menuOpt3
    cmp esi, 3
    je PrintDone
    mov edx, OFFSET menuOpt4
    cmp esi, 4
    je PrintDone
    mov edx, OFFSET menuOpt5
    cmp esi, 5
    je PrintDone
    mov edx, OFFSET menuOpt6
PrintDone:
    call Crlf
    call WriteString
    inc esi
    cmp esi, 7
    jl PrintOptions

    call Crlf
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov edx, OFFSET menuPrompt
    call Crlf
    call WriteString

    call ReadKey
    cmp al, 0
    jne MenuLoop
    cmp ah, 72       ; Up arrow
    je MoveUp
    cmp ah, 80       ; Down arrow
    je MoveDown
    cmp ah, 28       ; Enter
    je ConfirmOption
    jmp MenuLoop

MoveUp:
    dec ebx
    cmp ebx, 1
    jge MenuLoop
    mov ebx, 6
    jmp MenuLoop

MoveDown:
    inc ebx
    cmp ebx, 6
    jle MenuLoop
    mov ebx, 1
    jmp MenuLoop

ConfirmOption:
    call Clrscr
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET ground
    call WriteString
    call Crlf
    mov edx, OFFSET menuOpt1
    cmp ebx, 1
    je StartGame
    mov edx, OFFSET menuOpt2
    cmp ebx, 2
    je ContinueGame
    mov edx, OFFSET menuOpt3
    cmp ebx, 3
    je ChangeDiff
    mov edx, OFFSET menuOpt4
    cmp ebx, 4
    je Leaderboard
    mov edx, OFFSET menuOpt5
    cmp ebx, 5
    je Instructions
    mov edx, OFFSET menuOpt6
    cmp ebx, 6
    je ExitGame
    ret

StartGame:
    mov edx, OFFSET menuOpt1
    call WriteString
    call Crlf
    call WaitMsg
    ret
ContinueGame:
    mov edx, OFFSET menuOpt2
    call WriteString
    call Crlf
    call WaitMsg
    ret
ChangeDiff:
    mov edx, OFFSET menuOpt3
    call WriteString
    call Crlf
    call WaitMsg
    ret
Leaderboard:
    mov edx, OFFSET menuOpt4
    call WriteString
    call Crlf
    call WaitMsg
    ret
Instructions:
    mov edx, OFFSET menuOpt5
    call WriteString
    call Crlf
    call WaitMsg
    ret
ExitGame:
    mov edx, OFFSET menuOpt6
    call WriteString
    call Crlf
    call WaitMsg
    ret
ShowMenu ENDP

 call Randomize
    call initializegrid
    call placebuildings
    call placeplayer
    call displayboard
    call WaitMsg
    exit
main ENDP

initializegrid PROC
    mov esi, 0
    mov ecx, 400
fill_loop:
    mov byte ptr grid[esi], '.'
    inc esi
    loop fill_loop
    ret
initializegrid ENDP

placebuildings PROC
    mov ecx, 140
build_loop:
    mov eax, 20
    call RandomRange
    mov ebx, eax
    mov eax, 20
    call RandomRange
    imul ebx, 20
    add ebx, eax
    cmp ebx, 0
    je skip_pos
    cmp ebx, 400
    jge skip_pos
    cmp byte ptr grid[ebx], 'B'
    je skip_pos
    mov byte ptr grid[ebx], 'B'
skip_pos:
    loop build_loop
    ret
placebuildings ENDP

placeplayer PROC
    mov byte ptr grid[0], 'P'
    ret
placeplayer ENDP

displayboard PROC
    call Clrscr
    
    mov esi, 0
    mov cl, 0
    
row_loop:
    mov ch, 0
    
col_loop:
    mov al, grid[esi]
    
    ; Check what to print
    cmp al, 'B'
    je print_building
    cmp al, 'P'
    je print_player
    jmp print_road
    
print_building:
    ; Black building - print 3 block characters
    mov eax, black + (black * 16)
    call SetTextColor
    mov al, 219
    call WriteChar
    call WriteChar
    call WriteChar
    jmp next_cell
    
print_player:
    ; Yellow player - print 3 characters wide
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov al, 'P'
    call WriteChar
    mov al, 'P'
    call WriteChar
    mov al, 'P'
    call WriteChar
    jmp next_cell
    
print_road:
    ; White road - print 3 spaces
    mov eax, white + (white * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    
next_cell:
    inc esi
    inc ch
    cmp ch, 20
    jl col_loop
    
    ; Reset color and new line
    mov eax, white + (black * 16)
    call SetTextColor
    call Crlf
    
    inc cl
    cmp cl, 20
    jl row_loop
    
    ; Final reset
    mov eax, white + (black * 16)
    call SetTextColor
    
    ret
displayboard ENDP

END main

