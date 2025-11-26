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

    call WriteString
    call Crlf
    mov edx, OFFSET titleLine2
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine3
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine5
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine6
    call WriteString
    call Crlf
    mov edx, OFFSET titleLine8
    call WriteString
    call Crlf
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


END main

