
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

    
    titleMsg        BYTE "╔════════════════════════════════════════════════╗", 0Ah
                    BYTE "║         RUSH HOUR - TAXI GAME v1.0            ║", 0Ah
                    BYTE "╚════════════════════════════════════════════════╝", 0Ah, 0
    
    instructMsg     BYTE 0Ah, "╔═══════════ INSTRUCTIONS ═══════════╗", 0Ah
                    BYTE "║ CONTROLS:                          ║", 0Ah
                    BYTE "║ • W/A/S/D - Move taxi              ║", 0Ah
                    BYTE "║ • SPACE - Pick up/drop passenger   ║", 0Ah
                    BYTE "║ • P - Pause game                   ║", 0Ah
                    BYTE "║ • X - Exit to menu                 ║", 0Ah
                    BYTE "║                                    ║", 0Ah
                    BYTE "║ OBJECTIVE:                         ║", 0Ah
                    BYTE "║ • Pick up stick figures            ║", 0Ah
                    BYTE "║ • Drop at GREEN destinations       ║", 0Ah
                    BYTE "║ • +10 points per delivery          ║", 0Ah
                    BYTE "║ • Avoid obstacles and cars!        ║", 0Ah
                    BYTE "║                                    ║", 0Ah
                    BYTE "║ YELLOW TAXI:                       ║", 0Ah
                    BYTE "║ • Obstacle damage: -4 points       ║", 0Ah
                    BYTE "║ • Car collision: -2 points         ║", 0Ah
                    BYTE "║                                    ║", 0Ah
                    BYTE "║ RED TAXI:                          ║", 0Ah
                    BYTE "║ • Obstacle damage: -2 points       ║", 0Ah
                    BYTE "║ • Car collision: -3 points         ║", 0Ah
                    BYTE "║                                    ║", 0Ah
                    BYTE "║ Every 2 deliveries = More cars!    ║", 0Ah
                    BYTE "╚════════════════════════════════════╝", 0Ah, 0Ah
                    BYTE "Press any key to continue...", 0
    
    namePrompt      BYTE "Enter your name: ", 0
    taxiPrompt      BYTE "Choose taxi (1=Yellow, 2=Red, 3=Random): ", 0
    
    strScore        BYTE "Score: ", 0
    strFuel         BYTE " | Fuel: ", 0
    strPass         BYTE " | Active: ", 0
    strJobs         BYTE " | Delivered: ", 0
    
    carryMsg        BYTE ">>> Carrying passenger! Go to GREEN destination! <<<", 0
    legendMsg       BYTE "Taxi=[  ]  Passenger=StickFig  Tree=♠  Box=■  Car=[o]", 0
    
    gameOverMsg     BYTE 0Ah, 0Ah, "╔════════════════════════════════╗", 0Ah
                    BYTE "║        GAME OVER!              ║", 0Ah
                    BYTE "╚════════════════════════════════╝", 0Ah, 0
    
    fuelMsg         BYTE "Reason: Out of Fuel!", 0Ah, 0
    scoreNegMsg     BYTE "Reason: Score went negative!", 0Ah, 0
    finalScoreMsg   BYTE "Final Score: ", 0
    thankMsg        BYTE 0Ah, "Thanks for playing!", 0Ah, 0

; ============================================================================
; MAIN PROCEDURE
; ============================================================================
.code
main PROC
    call Randomize
    call Clrscr
    
    ; Show title
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov edx, OFFSET titleMsg
    call WriteString
    
    ; Show instructions
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET instructMsg
    call WriteString
    call ReadChar
    call Clrscr
    
    ; Get player name
    mov edx, OFFSET namePrompt
    call WriteString
    mov edx, OFFSET playerName
    mov ecx, 30
    call ReadString
    
    ; Choose taxi
    mov edx, OFFSET taxiPrompt
    call WriteString
    call ReadChar
    
    cmp al, '1'
    je SetYellow
    cmp al, '2'
    je SetRed
    
    ; Random
    mov eax, 2
    call RandomRange
    mov taxiColor, al
    jmp StartGame
    
SetYellow:
    mov taxiColor, 0
    jmp StartGame
    
SetRed:
    mov taxiColor, 1
    
StartGame:
    call InitGame
    
GameLoop:
    ; DON'T clear screen every frame - only draw once then update
    call DrawGame
    call DrawHUD
    
GameUpdateLoop:
    ; Small delay
    mov eax, 100
    call Delay
    
    ; Update cars every 3 frames
    inc frameCount
    mov eax, frameCount
    mov ebx, 3
    xor edx, edx
    div ebx
    cmp edx, 0
    jne SkipCarUpdate
    call UpdateCars
    
SkipCarUpdate:
    ; Non-blocking input
    mov eax, 1
    call ReadKey
    jz NoInput
    
    mov inputChar, al
    
    cmp inputChar, 'x'
    je ExitGame
    cmp inputChar, 'X'
    je ExitGame
    
    cmp inputChar, 'w'
    je MoveUp
    cmp inputChar, 'W'
    je MoveUp
    
    cmp inputChar, 's'
    je MoveDown
    cmp inputChar, 'S'
    je MoveDown
    
    cmp inputChar, 'a'
    je MoveLeft
    cmp inputChar, 'A'
    je MoveLeft
    
    cmp inputChar, 'd'
    je MoveRight
    cmp inputChar, 'D'
    je MoveRight
    
    cmp inputChar, ' '
    je HandleSpace
    
    jmp NoInput
    
MoveUp:
    call TryMoveUp
    ; Redraw only after movement
    call Clrscr
    jmp GameLoop
    
MoveDown:
    call TryMoveDown
    call Clrscr
    jmp GameLoop
    
MoveLeft:
    call TryMoveLeft
    call Clrscr
    jmp GameLoop
    
MoveRight:
    call TryMoveRight
    call Clrscr
    jmp GameLoop
    
HandleSpace:
    call HandlePickupDrop
    call Clrscr
    jmp GameLoop
    
NoInput:
    ; Check game over
    mov eax, playerFuel
    cmp eax, 0
    jle GameOverFuel
    
    mov eax, playerScore
    cmp eax, 0
    jl GameOverNegative
    
    jmp GameUpdateLoop
    
GameOverFuel:
    call Clrscr
    mov edx, OFFSET gameOverMsg
    call WriteString
    mov edx, OFFSET fuelMsg
    call WriteString
    jmp ShowFinal
    
GameOverNegative:
    call Clrscr
    mov edx, OFFSET gameOverMsg
    call WriteString
    mov edx, OFFSET scoreNegMsg
    call WriteString
    
ShowFinal:
    mov edx, OFFSET finalScoreMsg
    call WriteString
    mov eax, playerScore
    call WriteInt
    call Crlf
    mov edx, OFFSET thankMsg
    call WriteString
    call WaitMsg
    
ExitGame:
    exit
main ENDP

; ============================================================================
; INITIALIZE GAME
; ============================================================================
InitGame PROC
    push eax
    push ebx
    push ecx
    push esi
    
    ; Reset state
    mov playerX, 0
    mov playerY, 0
    
    ; Generate board (35% buildings, 65% roads)
    call GenerateBoard
    
    ; Spawn 3-5 passengers
    mov eax, 3
    call RandomRange
    add eax, 3
    mov passengerCount, eax
    
    mov ecx, eax
    xor esi, esi
    
SpawnPass:
    push ecx
    
    call FindRoadPosition
    mov edi, OFFSET passX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET passY
    add edi, esi
    mov [edi], ah
    
    call FindRoadPosition
    mov edi, OFFSET passDestX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET passDestY
    add edi, esi
    mov [edi], ah
    
    mov edi, OFFSET passPicked
    add edi, esi
    mov BYTE PTR [edi], 0
    
    mov edi, OFFSET passActive
    add edi, esi
    mov BYTE PTR [edi], 1
    
    inc esi
    pop ecx
    dec ecx
    cmp ecx, 0
    jne SpawnPass
    
    ; Spawn 7 obstacles
    mov obstacleCount, 7
    mov ecx, 7
    xor esi, esi
    
SpawnObst:
    push ecx
    
    call FindRoadPosition
    mov edi, OFFSET obstX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET obstY
    add edi, esi
    mov [edi], ah
    
    mov eax, 2
    call RandomRange
    mov edi, OFFSET obstType
    add edi, esi
    mov [edi], al
    
    inc esi
    pop ecx
    dec ecx
    cmp ecx, 0
    jne SpawnObst
    
    ; Spawn 5 cars
    mov carCount, 5
    mov ecx, 5
    xor esi, esi
    
SpawnCar:
    push ecx
    
    call FindRoadPosition
    mov edi, OFFSET carX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET carY
    add edi, esi
    mov [edi], ah
    
    mov eax, 4
    call RandomRange
    
    cmp eax, 0
    je DirUp
    cmp eax, 1
    je DirDown
    cmp eax, 2
    je DirLeft
    
DirRight:
    mov edi, OFFSET carDirX
    add edi, esi
    mov BYTE PTR [edi], 1
    mov edi, OFFSET carDirY
    add edi, esi
    mov BYTE PTR [edi], 0
    jmp DirDone
    
DirUp:
    mov edi, OFFSET carDirX
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, OFFSET carDirY
    add edi, esi
    mov BYTE PTR [edi], -1
    jmp DirDone
    
DirDown:
    mov edi, OFFSET carDirX
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, OFFSET carDirY
    add edi, esi
    mov BYTE PTR [edi], 1
    jmp DirDone
    
DirLeft:
    mov edi, OFFSET carDirX
    add edi, esi
    mov BYTE PTR [edi], -1
    mov edi, OFFSET carDirY
    add edi, esi
    mov BYTE PTR [edi], 0
    
DirDone:
    mov edi, OFFSET carActive
    add edi, esi
    mov BYTE PTR [edi], 1
    
    inc esi
    pop ecx
    dec ecx
    cmp ecx, 0
    jne SpawnCar
    
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
InitGame ENDP

; ============================================================================
; GENERATE BOARD
; ============================================================================
GenerateBoard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    mov ecx, 400
    mov esi, OFFSET board
    
GenLoop:
    push ecx
    
    mov eax, 400
    sub eax, ecx
    mov ebx, 20
    xor edx, edx
    div ebx
    
    ; Roads every 5th row
    push edx
    mov ebx, 5
    xor edx, edx
    div ebx
    cmp edx, 0
    pop edx
    je MakeRoad
    
    ; Roads every 5th column
    push eax
    mov eax, edx
    mov ebx, 5
    xor edx, edx
    div ebx
    cmp edx, 0
    pop eax
    je MakeRoad
    
    ; 35% buildings
    push eax
    push edx
    mov eax, 100
    call RandomRange
    cmp eax, 35
    pop edx
    pop eax
    jl MakeBuilding
    
MakeRoad:
    mov BYTE PTR [esi], 1
    jmp NextTile
    
MakeBuilding:
    mov BYTE PTR [esi], 0
    
NextTile:
    inc esi
    pop ecx
    dec ecx
    cmp ecx, 0
    jne GenLoop
    
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
GenerateBoard ENDP

; ============================================================================
; FIND RANDOM ROAD POSITION
; ============================================================================
FindRoadPosition PROC
    push ebx
    push ecx
    push esi
    
FindLoop:
    mov eax, 20
    call RandomRange
    mov bl, al
    
    mov eax, 20
    call RandomRange
    mov bh, al
    
    ; Check if road
    mov al, bh
    xor ah, ah
    mov cl, 20
    mul cl
    xor ch, ch
    mov cl, bl
    add ax, cx
    
    mov esi, OFFSET board
    add esi, eax
    cmp BYTE PTR [esi], 1
    jne FindLoop
    
    mov al, bl
    mov ah, bh
    
    pop esi
    pop ecx
    pop ebx
    ret
FindRoadPosition ENDP

; ============================================================================
; MOVEMENT PROCEDURES
; ============================================================================
TryMoveUp PROC
    push eax
    push ebx
    
    mov al, playerY
    cmp al, 0
    je MoveFailUp
    
    dec al
    mov bh, al
    mov bl, playerX
    call IsRoad
    cmp al, 0
    je MoveFailUp
    
    dec playerY
    dec playerFuel
    call CheckCollisions
    
MoveFailUp:
    pop ebx
    pop eax
    ret
TryMoveUp ENDP

TryMoveDown PROC
    push eax
    push ebx
    
    mov al, playerY
    cmp al, 19
    jge MoveFailDown
    
    inc al
    mov bh, al
    mov bl, playerX
    call IsRoad
    cmp al, 0
    je MoveFailDown
    
    inc playerY
    dec playerFuel
    call CheckCollisions
    
MoveFailDown:
    pop ebx
    pop eax
    ret
TryMoveDown ENDP

TryMoveLeft PROC
    push eax
    push ebx
    
    mov al, playerX
    cmp al, 0
    je MoveFailLeft
    
    dec al
    mov bl, al
    mov bh, playerY
    call IsRoad
    cmp al, 0
    je MoveFailLeft
    
    dec playerX
    dec playerFuel
    call CheckCollisions
    
MoveFailLeft:
    pop ebx
    pop eax
    ret
TryMoveLeft ENDP

TryMoveRight PROC
    push eax
    push ebx
    
    mov al, playerX
    cmp al, 19
    jge MoveFailRight
    
    inc al
    mov bl, al
    mov bh, playerY
    call IsRoad
    cmp al, 0
    je MoveFailRight
    
    inc playerX
    dec playerFuel
    call CheckCollisions
    
MoveFailRight:
    pop ebx
    pop eax
    ret
TryMoveRight ENDP

IsRoad PROC
    push ebx
    push ecx
    push esi
    
    mov al, bh
    xor ah, ah
    mov cl, 20
    mul cl
    xor ch, ch
    mov cl, bl
    add ax, cx
    
    mov esi, OFFSET board
    add esi, eax
    mov al, [esi]
    
    pop esi
    pop ecx
    pop ebx
    ret
IsRoad ENDP

; ============================================================================
; DRAW GAME WITH AMAZING GRAPHICS
; ============================================================================
DrawGame PROC
    push eax
    push ebx
    push ecx
    push edx
    
    ; Draw LARGE 20x20 grid - each cell is 4 chars wide
    xor ebx, ebx
    
DrawRows:
    cmp ebx, 20
    jge DrawEntities
    
    xor ecx, ecx
    
DrawCols:
    cmp ecx, 20
    jge NextRow
    
    ; Position: each cell is 4 chars wide, 1 char tall
    mov dh, bl
    add dh, 2
    
    mov al, cl
    mov dl, 4
    mul dl
    mov dl, al
    add dl, 2
    call Gotoxy
    
    ; Get tile type
    mov al, bl
    xor ah, ah
    mov ch, 20
    mul ch
    add al, cl
    xor ah, ah
    
    mov esi, OFFSET board
    add esi, eax
    mov al, [esi]
    
    cmp al, 1
    je DrawRoadCell
    
    ; BLACK BUILDING - Very obvious
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, 219  ; █
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    jmp NextCol
    
DrawRoadCell:
    ; WHITE ROAD - Very obvious
    mov eax, lightGray + (white * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    
NextCol:
    inc ecx
    jmp DrawCols
    
NextRow:
    inc ebx
    jmp DrawRows
    
DrawEntities:
    ; Draw obstacles - BIGGER
    mov ecx, obstacleCount
    xor esi, esi
    
DrawObst:
    cmp esi, ecx
    jge DrawCars
    
    push ecx
    
    mov edi, OFFSET obstX
    add edi, esi
    xor eax, eax
    mov al, [edi]
    mov dl, 4
    mul dl
    add al, 2
    mov dl, al
    
    mov edi, OFFSET obstY
    add edi, esi
    mov dh, [edi]
    add dh, 2
    
    call Gotoxy
    
    mov edi, OFFSET obstType
    add edi, esi
    mov al, [edi]
    
    cmp al, 0
    je DrawBox
    
    ; Green tree - BIGGER
    mov eax, green + (white * 16)
    call SetTextColor
    mov al, 6  ; ♠
    call WriteChar
    mov al, 'T'
    call WriteChar
    mov al, 'R'
    call WriteChar
    jmp NextObst
    
DrawBox:
    ; Brown box - BIGGER
    mov eax, brown + (white * 16)
    call SetTextColor
    mov al, 'B'
    call WriteChar
    mov al, 'O'
    call WriteChar
    mov al, 'X'
    call WriteChar
    
NextObst:
    inc esi
    pop ecx
    jmp DrawObst
    
DrawCars:
    ; Draw cars - BIGGER
    mov ecx, carCount
    xor esi, esi
    
DrawCarLoop:
    cmp esi, ecx
    jge DrawPass
    
    push ecx
    
    mov edi, OFFSET carActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    je SkipCar
    
    mov edi, OFFSET carX
    add edi, esi
    xor eax, eax
    mov al, [edi]
    mov dl, 4
    mul dl
    add al, 2
    mov dl, al
    
    mov edi, OFFSET carY
    add edi, esi
    mov dh, [edi]
    add dh, 2
    
    call Gotoxy
    
    ; Blue car - BIGGER
    mov eax, lightCyan + (white * 16)
    call SetTextColor
    mov al, '['
    call WriteChar
    mov al, 'C'
    call WriteChar
    mov al, ']'
    call WriteChar
    
SkipCar:
    inc esi
    pop ecx
    jmp DrawCarLoop
    
DrawPass:
    ; Draw passengers - BIGGER
    mov ecx, passengerCount
    xor esi, esi
    
DrawPassLoop:
    cmp esi, ecx
    jge DrawDest
    
    push ecx
    
    mov edi, OFFSET passActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    je SkipPass
    
    mov edi, OFFSET passPicked
    add edi, esi
    cmp BYTE PTR [edi], 1
    je SkipPass
    
    mov edi, OFFSET passX
    add edi, esi
    xor eax, eax
    mov al, [edi]
    mov dl, 4
    mul dl
    add al, 2
    mov dl, al
    
    mov edi, OFFSET passY
    add edi, esi
    mov dh, [edi]
    add dh, 2
    
    call Gotoxy
    
    ; Stick figure - BIGGER
    mov eax, black + (white * 16)
    call SetTextColor
    mov al, 'O'
    call WriteChar
    mov al, '|'
    call WriteChar
    mov al, ' '
    call WriteChar
    
SkipPass:
    inc esi
    pop ecx
    jmp DrawPassLoop
    
DrawDest:
    ; Draw destination - BIGGER
    mov eax, targetPass
    cmp eax, -1
    je DrawPlayer
    
    mov esi, eax
    
    mov edi, OFFSET passDestX
    add edi, esi
    xor eax, eax
    mov al, [edi]
    mov dl, 4
    mul dl
    add al, 2
    mov dl, al
    
    mov edi, OFFSET passDestY
    add edi, esi
    mov dh, [edi]
    add dh, 2
    
    call Gotoxy
    
    ; Green destination - BIGGER
    mov eax, lightGreen + (white * 16)
    call SetTextColor
    mov al, 'D'
    call WriteChar
    mov al, 'S'
    call WriteChar
    mov al, 'T'
    call WriteChar
    
DrawPlayer:
    ; Draw taxi - BIGGER
    xor eax, eax
    mov al, playerX
    mov dl, 4
    mul dl
    add al, 2
    mov dl, al
    
    mov dh, playerY
    add dh, 2
    call Gotoxy
    
    mov al, taxiColor
    cmp al, 0
    je DrawYellowTaxi
    
    ; Red taxi - BIGGER
    mov eax, yellow + (red * 16)
    call SetTextColor
    mov al, '['
    call WriteChar
    mov al, 'T'
    call WriteChar
    mov al, ']'
    call WriteChar
    jmp TaxiDone
    
DrawYellowTaxi:
    ; Yellow taxi - BIGGER
    mov eax, black + (yellow * 16)
    call SetTextColor
    mov al, '['
    call WriteChar
    mov al, 'T'
    call WriteChar
    mov al, ']'
    call WriteChar
    
TaxiDone:
    mov eax, white + (black * 16)
    call SetTextColor
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DrawGame ENDP

; ============================================================================
; DRAW HUD
; ============================================================================
DrawHUD PROC
    push eax
    push ebx
    push ecx
    push edx
    
    mov dh, 0
    mov dl, 0
    call Gotoxy
    
    mov edx, OFFSET strScore
    call WriteString
    mov eax, playerScore
    call WriteInt
    
    mov edx, OFFSET strFuel
    call WriteString
    mov eax, playerFuel
    call WriteDec
    
    mov edx, OFFSET strPass
    call WriteString
    
    ; Count active
    xor eax, eax
    xor ecx, ecx
    
CountLoop:
    mov ebx, passengerCount
    cmp ecx, ebx
    jge CountDone
    
    push ecx
    mov esi, ecx
    
    mov edi, OFFSET passActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    je SkipCount
    
    mov edi, OFFSET passPicked
    add edi, esi
    cmp BYTE PTR [edi], 1
    je SkipCount
    
    inc eax
    
SkipCount:
    pop ecx
    inc ecx
    jmp CountLoop
    
CountDone:
    call WriteDec
    
    mov edx, OFFSET strJobs
    call WriteString
    mov eax, jobsDone
    call WriteDec
    
    ; Line 1
    mov dh, 1
    mov dl, 0
    call Gotoxy
    
    mov eax, targetPass
    cmp eax, -1
    je ShowLegend
    
    mov edx, OFFSET carryMsg
    call WriteString
    jmp HUDDone
    
ShowLegend:
    mov edx, OFFSET legendMsg
    call WriteString
    
HUDDone:
    ; Ground
    mov dh, 22
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET ground
    call WriteString
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DrawHUD ENDP

; ============================================================================
; UPDATE CARS
; ============================================================================
UpdateCars PROC
    push eax
    push ebx
    push ecx
    push esi
    
    mov ecx, carCount
    xor esi, esi
    
UpdateLoop:
    cmp esi, ecx
    jge UpdateDone
    
    push ecx
    
    mov edi, OFFSET carActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    je SkipUpdate
    
    ; Get X
    mov edi, OFFSET carX
    add edi, esi
    mov bl, [edi]
    
    mov edi, OFFSET carDirX
    add edi, esi
    mov al, [edi]
    add bl, al
    
    cmp bl, 0
    jl Reverse
    cmp bl, 19
    jg Reverse
    
    ; Check road
    push esi
    mov edi, OFFSET carY
    add edi, esi
    mov bh, [edi]
    call IsRoad
    pop esi
    cmp al, 0
    je Reverse
    
    ; Update X
    mov edi, OFFSET carX
    add edi, esi
    mov [edi], bl
    
    ; Get Y
    mov edi, OFFSET carY
    add edi, esi
    mov bl, [edi]
    
    mov edi, OFFSET carDirY
    add edi, esi
    mov al, [edi]
    add bl, al
    
    cmp bl, 0
    jl Reverse
    cmp bl, 19
    jg Reverse
    
    ; Check road
    push esi
    mov bh, bl
    mov edi, OFFSET carX
    add edi, esi
    mov bl, [edi]
    call IsRoad
    pop esi
    cmp al, 0
    je Reverse
    
    ; Update Y
    mov edi, OFFSET carY
    add edi, esi
    mov [edi], bh
    
    jmp SkipUpdate
    
Reverse:
    mov edi, OFFSET carDirX
    add edi, esi
    mov al, [edi]
    neg al
    mov [edi], al
    
    mov edi, OFFSET carDirY
    add edi, esi
    mov al, [edi]
    neg al
    mov [edi], al
    
SkipUpdate:
    inc esi
    pop ecx
    jmp UpdateLoop
    
UpdateDone:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
UpdateCars ENDP

; ============================================================================
; CHECK COLLISIONS
; ============================================================================
CheckCollisions PROC
    push eax
    push ebx
    push ecx
    push esi
    
    ; Check obstacles
    mov ecx, obstacleCount
    xor esi, esi
    
CheckObstLoop:
    cmp esi, ecx
    jge CheckCars
    
    push ecx
    
    mov edi, OFFSET obstX
    add edi, esi
    mov al, [edi]
    cmp al, playerX
    jne NextObst
    
    mov edi, OFFSET obstY
    add edi, esi
    mov al, [edi]
    cmp al, playerY
    jne NextObst
    
    ; Collision!
    mov al, taxiColor
    cmp al, 0
    je YellowObst
    
    ; Red: -2
    sub playerScore, 2
    jmp NextObst
    
YellowObst:
    ; Yellow: -4
    sub playerScore, 4
    
NextObst:
    inc esi
    pop ecx
    jmp CheckObstLoop
    
CheckCars:
    ; Check car collisions
    mov ecx, carCount
    xor esi, esi
    
CheckCarLoop:
    cmp esi, ecx
    jge CollisionDone
    
    push ecx
    
    mov edi, OFFSET carActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    je NextCar
    
    mov edi, OFFSET carX
    add edi, esi
    mov al, [edi]
    cmp al, playerX
    jne NextCar
    
    mov edi, OFFSET carY
    add edi, esi
    mov al, [edi]
    cmp al, playerY
    jne NextCar
    
    ; Collision!
    mov al, taxiColor
    cmp al, 0
    je YellowCar
    
    ; Red: -3
    sub playerScore, 3
    jmp NextCar
    
YellowCar:
    ; Yellow: -2
    sub playerScore, 2
    
NextCar:
    inc esi
    pop ecx
    jmp CheckCarLoop
    
CollisionDone:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
CheckCollisions ENDP

; ============================================================================
; HANDLE PICKUP/DROP
; ============================================================================
HandlePickupDrop PROC
    push eax
    push ebx
    push ecx
    push esi
    
    mov eax, targetPass
    cmp eax, -1
    jne TryDrop
    
    ; Try pickup
    mov ecx, passengerCount
    xor esi, esi
    
PickupLoop:
    cmp esi, ecx
    jge PickupDone
    
    push ecx
    
    mov edi, OFFSET passActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    je NextPickup
    
    mov edi, OFFSET passPicked
    add edi, esi
    cmp BYTE PTR [edi], 1
    je NextPickup
    
    mov edi, OFFSET passX
    add edi, esi
    mov al, [edi]
    cmp al, playerX
    jne NextPickup
    
    mov edi, OFFSET passY
    add edi, esi
    mov al, [edi]
    cmp al, playerY
    jne NextPickup
    
    ; Pickup!
    mov eax, esi
    mov targetPass, eax
    
    mov edi, OFFSET passPicked
    add edi, esi
    mov BYTE PTR [edi], 1
    
    ; +10 points
    add playerScore, 10
    
    pop ecx
    jmp PickupDone
    
NextPickup:
    inc esi
    pop ecx
    jmp PickupLoop
    
TryDrop:
    ; Try drop
    mov esi, eax
    
    mov edi, OFFSET passDestX
    add edi, esi
    mov al, [edi]
    cmp al, playerX
    jne PickupDone
    
    mov edi, OFFSET passDestY
    add edi, esi
    mov al, [edi]
    cmp al, playerY
    jne PickupDone
    
    ; Drop!
    mov edi, OFFSET passActive
    add edi, esi
    mov BYTE PTR [edi], 0
    
    mov targetPass, -1
    
    ; +10 points
    add playerScore, 10
    
    ; Increment jobs
    inc jobsDone
    
    ; Maintain passengers
    call MaintainPassengers
    
    ; Every 2 jobs: add car
    mov eax, jobsDone
    mov ebx, 2
    xor edx, edx
    div ebx
    cmp edx, 0
    jne PickupDone
    
    ; Add new car
    mov eax, carCount
    cmp eax, MAX_CARS
    jge PickupDone
    
    call SpawnNewCar
    
PickupDone:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
HandlePickupDrop ENDP

; ============================================================================
; MAINTAIN PASSENGERS (Keep 3-5 active)
; ============================================================================
MaintainPassengers PROC
    push eax
    push ebx
    push ecx
    push esi
    
    ; Count active
    xor eax, eax
    xor ecx, ecx
    
CountActive:
    mov ebx, passengerCount
    cmp ecx, ebx
    jge CheckSpawn
    
    push ecx
    mov esi, ecx
    
    mov edi, OFFSET passActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    je SkipActive
    
    mov edi, OFFSET passPicked
    add edi, esi
    cmp BYTE PTR [edi], 1
    je SkipActive
    
    inc eax
    
SkipActive:
    pop ecx
    inc ecx
    jmp CountActive
    
CheckSpawn:
    ; If < 3, spawn
    cmp eax, 3
    jge NoSpawn
    
    mov eax, passengerCount
    cmp eax, MAX_PASSENGERS
    jge NoSpawn
    
    ; Spawn new
    mov esi, eax
    
    call FindRoadPosition
    mov edi, OFFSET passX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET passY
    add edi, esi
    mov [edi], ah
    
    call FindRoadPosition
    mov edi, OFFSET passDestX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET passDestY
    add edi, esi
    mov [edi], ah
    
    mov edi, OFFSET passPicked
    add edi, esi
    mov BYTE PTR [edi], 0
    
    mov edi, OFFSET passActive
    add edi, esi
    mov BYTE PTR [edi], 1
    
    inc passengerCount
    
NoSpawn:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
MaintainPassengers ENDP

; ============================================================================
; SPAWN NEW CAR
; ============================================================================
SpawnNewCar PROC
    push eax
    push esi
    
    mov esi, carCount
    cmp esi, MAX_CARS
    jge NoSpawn2
    
    call FindRoadPosition
    
    mov edi, OFFSET carX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET carY
    add edi, esi
    mov [edi], ah
    
    ; Random direction
    mov eax, 4
    call RandomRange
    
    cmp eax, 0
    je NewUp
    cmp eax, 1
    je NewDown
    cmp eax, 2
    je NewLeft
    
NewRight:
    mov edi, OFFSET carDirX
    add edi, esi
    mov BYTE PTR [edi], 1
    mov edi, OFFSET carDirY
    add edi, esi
    mov BYTE PTR [edi], 0
    jmp NewDone
    
NewUp:
    mov edi, OFFSET carDirX
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, OFFSET carDirY
    add edi, esi
    mov BYTE PTR [edi], -1
    jmp NewDone
    
NewDown:
    mov edi, OFFSET carDirX
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, OFFSET carDirY
    add edi, esi
    mov BYTE PTR [edi], 1
    jmp NewDone
    
NewLeft:
    mov edi, OFFSET carDirX
    add edi, esi
    mov BYTE PTR [edi], -1
    mov edi, OFFSET carDirY
    add edi, esi
    mov BYTE PTR [edi], 0
    
NewDone:
    mov edi, OFFSET carActive
    add edi, esi
    mov BYTE PTR [edi], 1
    
    inc carCount
    
NoSpawn2:
    pop esi
    pop eax
    ret
SpawnNewCar ENDP

END main

