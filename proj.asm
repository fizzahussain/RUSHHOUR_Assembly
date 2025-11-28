TITLE Rush Hour Taxi Game - Complete Implementation
INCLUDE Irvine32.inc

; ============================================================================
; CONSTANTS
; ============================================================================
.data
    BOARD_SIZE      EQU 20
    MAX_PASSENGERS  EQU 5
    MAX_OBSTACLES   EQU 10
    MAX_CARS        EQU 8
    MAX_BONUS       EQU 5
    
; ============================================================================
; GAME STATE DATA
; ============================================================================
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
    moveCounter     DWORD 0
    
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
    carSpeed        DWORD 3
    
    ; Bonus items
    bonusX          BYTE 5 DUP(0)
    bonusY          BYTE 5 DUP(0)
    bonusActive     BYTE 5 DUP(0)
    bonusCount      DWORD 0
    
    ; Frame counter
    frameCount      DWORD 0
    inputChar       BYTE ?
    playerName      BYTE 30 DUP(?)
    
    ; Menu
    menuChoice      BYTE 0
    difficulty      BYTE 1
    
    ; File handling
    fileHandle      DWORD ?
    saveFilename    BYTE "savegame.txt", 0
    hsFilename      BYTE "highscores.txt", 0
    bytesWritten    DWORD ?
    
    ; Leaderboard
    highScores      DWORD 10 DUP(0)
    highNames       BYTE 300 DUP(?)
    tempScore       DWORD ?

; ============================================================================
; UI STRINGS (NO 0Ah ALLOWED)
; ============================================================================
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
    
    taxiArt1        BYTE "                    .---------------.", 0
    taxiArt2        BYTE "                   /  .-------------. \\", 0
    taxiArt3        BYTE "                  /  /   TAXI      \\ \\", 0
    taxiArt4        BYTE "                 .  '---------------'  .", 0
    taxiArt5        BYTE "                 |  .---------------.  |", 0
    taxiArt6        BYTE "                  \\ | O           O | /", 0
    taxiArt7        BYTE "                   '._._._._._._._._.'", 0
    
    ; Menu options
    menuOpt1        BYTE "            1. Start New Game", 0
    menuOpt2        BYTE "            2. Continue Game", 0
    menuOpt3        BYTE "            3. Change Difficulty", 0
    menuOpt4        BYTE "            4. View Leaderboard", 0
    menuOpt5        BYTE "            5. Instructions", 0
    menuOpt6        BYTE "            6. Exit", 0
    menuPrompt      BYTE "            Use Arrow Keys to select, Enter to confirm", 0
    
    ; Instructions
    inst1           BYTE "CONTROLS:", 0
    inst2           BYTE "  W/A/S/D - Move taxi", 0
    inst3           BYTE "  SPACE - Pick up/drop passenger", 0
    inst4           BYTE "  P - Pause game", 0
    inst5           BYTE "  X - Exit to menu", 0
    inst6           BYTE "OBJECTIVE:", 0
    inst7           BYTE "  Pick up stick figures (O|)", 0
    inst8           BYTE "  Drop at GREEN destinations (DST)", 0
    inst9           BYTE "  +10 points per successful delivery", 0
    inst10          BYTE "  Collect $ for bonus +10 points", 0
    inst11          BYTE "  Avoid obstacles and cars!", 0
    inst12          BYTE "YELLOW TAXI:", 0
    inst13          BYTE "  Faster movement", 0
    inst14          BYTE "  Obstacle damage: -4 points", 0
    inst15          BYTE "  Car collision: -2 points", 0
    inst16          BYTE "RED TAXI:", 0
    inst17          BYTE "  Slower but tougher", 0
    inst18          BYTE "  Obstacle damage: -2 points", 0
    inst19          BYTE "  Car collision: -3 points", 0
    inst20          BYTE "Hit passenger: -5 points", 0
    inst21          BYTE "Every 2 deliveries = Faster cars!", 0
    inst22          BYTE "Press any key to continue...", 0
    
    ; Difficulty
    diff1           BYTE "DIFFICULTY LEVELS:", 0
    diff2           BYTE "1. Easy   - 1000 Fuel, 5 Obstacles, Slow Cars", 0
    diff3           BYTE "2. Medium - 500 Fuel, 7 Obstacles, Normal Cars", 0
    diff4           BYTE "3. Hard   - 300 Fuel, 10 Obstacles, Fast Cars", 0
    diff5           BYTE "Select (1-3): ", 0
    
    ; Leaderboard
    lb1             BYTE "TOP 10 HIGH SCORES:", 0
    lb2             BYTE "Rank  Name                          Score", 0
    lb3             BYTE "----  ----------------------------  -----", 0
    lb4             BYTE "No scores yet!", 0
    lb5             BYTE "Press any key to continue...", 0
    
    ; Game prompts
    namePrompt      BYTE "Enter your name: ", 0
    taxiPrompt      BYTE "Choose taxi (1=Yellow, 2=Red, 3=Random): ", 0
    
    ; HUD strings
    strScore        BYTE "Score: ", 0
    strFuel         BYTE " | Fuel: ", 0
    strPass         BYTE " | Active: ", 0
    strJobs         BYTE " | Delivered: ", 0
    
    carryMsg        BYTE ">>> Carrying passenger! Go to GREEN destination! <<<", 0
    legendMsg       BYTE "Taxi=[T]  Passenger=O|  Tree=TR  Box=BOX  Car=[C]  Bonus=$", 0
    
    ; Game over
    gameOver1       BYTE "GAME OVER!", 0
    gameOver2       BYTE "Reason: Out of Fuel!", 0
    gameOver3       BYTE "Reason: Score went negative!", 0
    finalScoreMsg   BYTE "Final Score: ", 0
    thankMsg        BYTE "Thanks for playing!", 0
    
    ; Save/load
    saveMsg1        BYTE "Game saved!", 0
    loadMsg1        BYTE "Game loaded!", 0
    loadMsg2        BYTE "No save file found!", 0
    tempBuffer      BYTE 100 DUP(?)


.code
; ============================================================================
; MAIN PROCEDURE (FIXED)
; ============================================================================
main PROC
    call Randomize
    call LoadHighScores
    
MainMenuLoop:
    call ShowMainMenu
    
    xor eax, eax
    mov al, menuChoice

    cmp al, 1
    je StartNew
    cmp al, 2
    je ContinueGame
    cmp al, 3
    je ChangeDiff
    cmp al, 4
    je ShowLeader
    cmp al, 5
    je ShowInst
    cmp al, 6
    je ExitProgram
    
    jmp MainMenuLoop
    
StartNew:
    call GetPlayerInfo
    call InitGame
    call GameLoop
    call UpdateHighScores
    jmp MainMenuLoop
    
ContinueGame:
    call LoadGame
    jc MainMenuLoop
    call GameLoop
    call UpdateHighScores
    jmp MainMenuLoop
    
ChangeDiff:
    call ChangeDifficulty
    jmp MainMenuLoop
    
ShowLeader:
    call ShowLeaderboard
    jmp MainMenuLoop
    
ShowInst:
    call ShowInstructions
    jmp MainMenuLoop
    
ExitProgram:
    call Clrscr
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov al, 'T'
    call WriteChar
    mov al, 'h'
    call WriteChar
    mov al, 'a'
    call WriteChar
    mov al, 'n'
    call WriteChar
    mov al, 'k'
    call WriteChar
    mov al, 's'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 'f'
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, 'r'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 'p'
    call WriteChar
    mov al, 'l'
    call WriteChar
    mov al, 'a'
    call WriteChar
    mov al, 'y'
    call WriteChar
    mov al, 'i'
    call WriteChar
    mov al, 'n'
    call WriteChar
    mov al, 'g'
    call WriteChar
    mov al, '!'
    call WriteChar
    call Crlf
    call WaitMsg
    exit
main ENDP
; ============================================================================
; SHOW MAIN MENU (SIMPLE NUMBER SELECTION)
; ============================================================================
ShowMainMenu PROC
    push eax
    push edx
    
    call Clrscr
    
    ; Title
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    
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
    
    ; Taxi art
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    mov edx, OFFSET taxiArt1
    call WriteString
    call Crlf
    mov edx, OFFSET taxiArt2
    call WriteString
    call Crlf
    mov edx, OFFSET taxiArt3
    call WriteString
    call Crlf
    mov edx, OFFSET taxiArt4
    call WriteString
    call Crlf
    mov edx, OFFSET taxiArt5
    call WriteString
    call Crlf
    mov edx, OFFSET taxiArt6
    call WriteString
    call Crlf
    mov edx, OFFSET taxiArt7
    call WriteString
    call Crlf
    call Crlf
    
    ; Menu options
    mov eax, white + (black * 16)
    call SetTextColor
    
    mov edx, OFFSET menuOpt1
    call WriteString
    call Crlf
    mov edx, OFFSET menuOpt2
    call WriteString
    call Crlf
    mov edx, OFFSET menuOpt3
    call WriteString
    call Crlf
    mov edx, OFFSET menuOpt4
    call WriteString
    call Crlf
    mov edx, OFFSET menuOpt5
    call WriteString
    call Crlf
    mov edx, OFFSET menuOpt6
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov edx, OFFSET menuPrompt
    call WriteString
    call Crlf
    
    ; Simple prompt
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, '>'
    call WriteChar
    mov al, ' '
    call WriteChar
    
    ; Wait for number input
    call ReadChar
    
    cmp al, '1'
    je Set1
    cmp al, '2'
    je Set2
    cmp al, '3'
    je Set3
    cmp al, '4'
    je Set4
    cmp al, '5'
    je Set5
    cmp al, '6'
    je Set6
    
    ; Invalid, default to 1
    mov menuChoice, 1
    jmp MenuDone
    
Set1:
    mov menuChoice, 1
    jmp MenuDone
Set2:
    mov menuChoice, 2
    jmp MenuDone
Set3:
    mov menuChoice, 3
    jmp MenuDone
Set4:
    mov menuChoice, 4
    jmp MenuDone
Set5:
    mov menuChoice, 5
    jmp MenuDone
Set6:
    mov menuChoice, 6
    jmp MenuDone
    
MenuDone:
    pop edx
    pop eax
    ret
ShowMainMenu ENDP

; ============================================================================
; GET PLAYER INFO (FIXED - NO EXTRA WAIT)
; ============================================================================
GetPlayerInfo PROC
    push eax
    push ecx
    push edx
    
    call Clrscr
    
    ; Get name
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET namePrompt
    call WriteString
    mov edx, OFFSET playerName
    mov ecx, 29
    call ReadString
    call Crlf
    
    ; Choose taxi
    mov edx, OFFSET taxiPrompt
    call WriteString
    
GetTaxiInput:
    call ReadChar
    call WriteChar
    call Crlf
    
    cmp al, '1'
    je SetYellow
    cmp al, '2'
    je SetRed
    cmp al, '3'
    je SetRandom
    
    ; Invalid input, ask again
    call Crlf
    mov edx, OFFSET taxiPrompt
    call WriteString
    jmp GetTaxiInput
    
SetRandom:
    mov eax, 2
    call RandomRange
    mov taxiColor, al
    jmp InfoDone
    
SetYellow:
    mov taxiColor, 0
    jmp InfoDone
    
SetRed:
    mov taxiColor, 1
    
InfoDone:
    ; NO EXTRA WAIT - GO DIRECTLY TO GAME
    pop edx
    pop ecx
    pop eax
    ret
GetPlayerInfo ENDP

; ============================================================================
; INITIALIZE GAME
; ============================================================================
    
; ============================================================================
; INITIALIZE GAME (CLEAN VERSION)
; ============================================================================
InitGame PROC
    push eax
    push ebx
    push ecx
    push esi
    
    ; Reset state
    mov playerX, 0
    mov playerY, 0
    mov playerScore, 0
    mov jobsDone, 0
    mov targetPass, -1
    mov frameCount, 0
    mov moveCounter, 0
    
    ; Apply difficulty
    call ApplyDifficulty
    
    ; Generate board
    call GenerateBoard
    
    ; Make sure starting position is a road
    mov esi, OFFSET board
    mov BYTE PTR [esi], 1
    
   ; Spawn 3-5 passengers
    mov eax, 3
    call RandomRange
    add eax, 3
    
    mov ecx, eax
    xor esi, esi
    
SpawnPass:
    cmp ecx, 0
    je PassDone
    cmp esi, MAX_PASSENGERS
    jge PassDone
    
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
    jmp SpawnPass
    
PassDone:
    ; Initialize remaining slots as inactive
    mov ecx, MAX_PASSENGERS
    sub ecx, esi
    
ClearRest:
    cmp ecx, 0
    je SkipObstacles
    
    mov edi, OFFSET passActive
    add edi, esi
    mov BYTE PTR [edi], 0
    
    inc esi
    dec ecx
    jmp ClearRest
    

SkipObstacles:
    ; Spawn 5 cars
    mov carCount, 5
    mov ecx, 5
    xor esi, esi
    
SpawnCar:
    cmp ecx, 0
    je CarDone
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
    jmp SpawnCar
    
CarDone:
    ; Spawn 3-5 bonus items
    mov eax, 3
    call RandomRange
    add eax, 3
    mov bonusCount, eax
    
    mov ecx, eax
    xor esi, esi
    
SpawnBonus:
    cmp ecx, 0
    je BonusDone
    push ecx
    
    call FindRoadPosition
    mov edi, OFFSET bonusX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET bonusY
    add edi, esi
    mov [edi], ah
    
    mov edi, OFFSET bonusActive
    add edi, esi
    mov BYTE PTR [edi], 1
    
    inc esi
    pop ecx
    dec ecx
    jmp SpawnBonus
    
BonusDone:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
InitGame ENDP
 

; ============================================================================
; APPLY DIFFICULTY
; ============================================================================
ApplyDifficulty PROC
    push eax
    
    mov al, difficulty
    
    cmp al, 0
    je SetEasy
    cmp al, 1
    je SetMedium
    
SetHard:
    mov playerFuel, 300
    mov obstacleCount, 10
    mov carSpeed, 2
    jmp DiffDone
    
SetMedium:
    mov playerFuel, 500
    mov obstacleCount, 7
    mov carSpeed, 3
    jmp DiffDone
    
SetEasy:
    mov playerFuel, 1000
    mov obstacleCount, 5
    mov carSpeed, 5
    
DiffDone:
    pop eax
    ret
ApplyDifficulty ENDP

; ============================================================================
; GENERATE BOARD - NEW VERSION WITH VISIBLE BUILDINGS
; ============================================================================
GenerateBoard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    ; First, initialize all as roads (1)
    mov esi, OFFSET board
    mov ecx, 400
    
InitAllRoads:
    mov BYTE PTR [esi], 1
    inc esi
    loop InitAllRoads
    
    ; Place 140 buildings randomly (0 = building)
    mov ecx, 140
    
BuildLoop:
    ; Generate random row (0-19)
    mov eax, 20
    call RandomRange
    mov ebx, eax
    
    ; Generate random column (0-19)
    mov eax, 20
    call RandomRange
    
    ; Calculate index: row * 20 + col
    imul ebx, 20
    add ebx, eax
    
    ; Safety checks
    cmp ebx, 0
    je SkipBuilding
    cmp ebx, 399
    jg SkipBuilding
    
    ; Don't place building at player start (0,0)
    cmp ebx, 0
    je SkipBuilding
    
    ; Check if already a building
    mov esi, OFFSET board
    add esi, ebx
    cmp BYTE PTR [esi], 0
    je SkipBuilding
    
    ; Place building (0 = building)
    mov BYTE PTR [esi], 0
    jmp NextBuilding
    
SkipBuilding:
    ; If we skipped, try another iteration
    inc ecx
    
NextBuilding:
    loop BuildLoop
    
    ; Ensure player starting position (0,0) is always a road
    mov esi, OFFSET board
    mov BYTE PTR [esi], 1
    
    ; Create guaranteed road corridors (every 5th row)
    mov ebx, 0
    
EnsureRowRoads:
    cmp ebx, 20
    jge EnsureColRoads
    
    ; Check if this row should be a road (every 5th: 0, 5, 10, 15)
    mov eax, ebx
    xor edx, edx
    mov ecx, 5
    div ecx
    cmp edx, 0
    jne SkipThisRow
    
    ; Make entire row into roads
    push ebx
    mov eax, ebx
    imul eax, 20
    mov esi, OFFSET board
    add esi, eax
    
    mov ecx, 20
MakeRowRoad:
    mov BYTE PTR [esi], 1
    inc esi
    loop MakeRowRoad
    
    pop ebx
    
SkipThisRow:
    inc ebx
    jmp EnsureRowRoads
    
EnsureColRoads:
    ; Create guaranteed road corridors (every 5th column)
    mov ebx, 0
    
ColRoadLoop:
    cmp ebx, 20
    jge BoardGenDone
    
    ; Check if this column should be a road (every 5th: 0, 5, 10, 15)
    mov eax, ebx
    xor edx, edx
    mov ecx, 5
    div ecx
    cmp edx, 0
    jne SkipThisCol
    
    ; Make entire column into roads
    push ebx
    mov esi, OFFSET board
    add esi, ebx
    
    mov ecx, 20
MakeColRoad:
    mov BYTE PTR [esi], 1
    add esi, 20
    loop MakeColRoad
    
    pop ebx
    
SkipThisCol:
    inc ebx
    jmp ColRoadLoop
    
BoardGenDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
GenerateBoard ENDP
; ============================================================================
; FIND RANDOM ROAD POSITION (WITH TIMEOUT)
; ============================================================================
FindRoadPosition PROC
    push ebx
    push ecx
    push esi
    
    mov ecx, 1000  ; Maximum 1000 attempts
    
FindLoop:
    cmp ecx, 0
    je UseFallback
    
    mov eax, 20
    call RandomRange
    mov bl, al
    
    mov eax, 20
    call RandomRange
    mov bh, al
    
    ; Check if road
    push ecx
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
    pop ecx
    je FoundRoad
    
    dec ecx
    jmp FindLoop
    
UseFallback:
    ; Use position (1,1) as fallback
    mov bl, 1
    mov bh, 1
    
FoundRoad:
    mov al, bl
    mov ah, bh
    
    pop esi
    pop ecx
    pop ebx
    ret
FindRoadPosition ENDP


; ============================================================================
; GAME LOOP (FULLY FUNCTIONAL)
; ============================================================================
GameLoop PROC
    push eax
    push ebx
    push ecx
    push edx
    
MainGameLoop:
    call Clrscr
    call DrawGame
    call DrawHUD
    
GameInputLoop:
    ; Small delay
    mov eax, 50
    call Delay
    
    ; Update cars every few frames
    inc frameCount
    mov eax, frameCount
    mov ebx, carSpeed
    xor edx, edx
    div ebx
    cmp edx, 0
    jne SkipCarUpdate
    call UpdateCars
    
SkipCarUpdate:
    ; Read input
    call ReadChar
    mov inputChar, al
    
    ; Check for exit
    cmp inputChar, 'x'
    je ExitGame
    cmp inputChar, 'X'
    je ExitGame
    
    ; Check for movement keys
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
    
    cmp inputChar, 'p'
    je PauseGame
    cmp inputChar, 'P'
    je PauseGame
    
    ; Invalid key, just wait for next input
    jmp GameInputLoop
    
MoveUp:
    call TryMoveUp
    jmp CheckGameOver
    
MoveDown:
    call TryMoveDown
    jmp CheckGameOver
    
MoveLeft:
    call TryMoveLeft
    jmp CheckGameOver
    
MoveRight:
    call TryMoveRight
    jmp CheckGameOver
    
HandleSpace:
    call HandlePickupDrop
    jmp CheckGameOver
    
PauseGame:
    ; Wait for another key press
    call ReadChar
    jmp MainGameLoop
    
CheckGameOver:
    ; Check fuel
    mov eax, playerFuel
    cmp eax, 0
    jle GameOverFuel
    
    ; Check score
    mov eax, playerScore
    cmp eax, 0
    jl GameOverNegative
    
    ; Continue game - redraw
    jmp MainGameLoop
    
GameOverFuel:
    call Clrscr
    mov eax, red + (black * 16)
    call SetTextColor
    mov edx, OFFSET gameOver1
    call WriteString
    call Crlf
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET gameOver2
    call WriteString
    call Crlf
    jmp ShowFinal
    
GameOverNegative:
    call Clrscr
    mov eax, red + (black * 16)
    call SetTextColor
    mov edx, OFFSET gameOver1
    call WriteString
    call Crlf
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET gameOver3
    call WriteString
    call Crlf
    
ShowFinal:
    mov edx, OFFSET finalScoreMsg
    call WriteString
    mov eax, playerScore
    call WriteInt
    call Crlf
    call Crlf
    mov edx, OFFSET thankMsg
    call WriteString
    call Crlf
    call WaitMsg
    jmp ExitGame
    
ExitGame:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
GameLoop ENDP


; ============================================================================
; TRY MOVE UP (FIXED RED TAXI SPEED)
; ============================================================================
TryMoveUp PROC
    push eax
    push ebx
    
    ; Increment move counter first
    inc moveCounter
    
    ; Check if red taxi needs to wait (speed control)
    mov al, taxiColor
    cmp al, 0
    je AllowMoveUp  ; Yellow taxi always moves
    
    ; Red taxi: only move on even moveCounter values
    mov eax, moveCounter
    and eax, 1
    cmp eax, 1
    je MoveFailUp  ; Odd number = skip this move
    
AllowMoveUp:
    ; Check boundary
    mov al, playerY
    cmp al, 0
    je MoveFailUp
    
    ; Check if destination is a road
    dec al
    mov bh, al
    mov bl, playerX
    call IsRoad
    cmp al, 0
    je MoveFailUp
    
    ; Move is valid
    dec playerY
    dec playerFuel
    call CheckCollisions
    
MoveFailUp:
    pop ebx
    pop eax
    ret
TryMoveUp ENDP

; ============================================================================
; TRY MOVE DOWN (FIXED RED TAXI SPEED)
; ============================================================================
TryMoveDown PROC
    push eax
    push ebx
    
    inc moveCounter
    
    mov al, taxiColor
    cmp al, 0
    je AllowMoveDown
    
    mov eax, moveCounter
    and eax, 1
    cmp eax, 1
    je MoveFailDown
    
AllowMoveDown:
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

; ============================================================================
; TRY MOVE LEFT (FIXED RED TAXI SPEED)
; ============================================================================
TryMoveLeft PROC
    push eax
    push ebx
    
    inc moveCounter
    
    mov al, taxiColor
    cmp al, 0
    je AllowMoveLeft
    
    mov eax, moveCounter
    and eax, 1
    cmp eax, 1
    je MoveFailLeft
    
AllowMoveLeft:
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

; ============================================================================
; TRY MOVE RIGHT (FIXED RED TAXI SPEED)
; ============================================================================
TryMoveRight PROC
    push eax
    push ebx
    
    inc moveCounter
    
    mov al, taxiColor
    cmp al, 0
    je AllowMoveRight
    
    mov eax, moveCounter
    and eax, 1
    cmp eax, 1
    je MoveFailRight
    
AllowMoveRight:
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
; CHECK COLLISIONS (OBSTACLES, CARS, PASSENGERS, BONUS)
; ============================================================================
; ============================================================================
; CHECK COLLISIONS (FIXED - NO PENALTY FOR VALID PICKUPS)
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
    
    ; Collision with obstacle!
    mov al, taxiColor
    cmp al, 0
    je YellowObst
    
    ; Red taxi: -2 points
    sub playerScore, 2
    jmp NextObst
    
YellowObst:
    ; Yellow taxi: -4 points
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
    jge CheckBonus
    
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
    
    ; Collision with car!
    mov al, taxiColor
    cmp al, 0
    je YellowCar
    
    ; Red taxi: -3 points
    sub playerScore, 3
    jmp NextCar
    
YellowCar:
    ; Yellow taxi: -2 points
    sub playerScore, 2
    
NextCar:
    inc esi
    pop ecx
    jmp CheckCarLoop
    
CheckBonus:
    ; Check bonus item collection (NO PENALTY - JUST COLLECT)
    mov ecx, bonusCount
    xor esi, esi
    
CheckBonusLoop:
    cmp esi, ecx
    jge CollisionDone
    
    push ecx
    
    mov edi, OFFSET bonusActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    je NextBonus
    
    mov edi, OFFSET bonusX
    add edi, esi
    mov al, [edi]
    cmp al, playerX
    jne NextBonus
    
    mov edi, OFFSET bonusY
    add edi, esi
    mov al, [edi]
    cmp al, playerY
    jne NextBonus
    
    ; Collected bonus! +10 points
    add playerScore, 10
    
    ; Deactivate this bonus
    mov edi, OFFSET bonusActive
    add edi, esi
    mov BYTE PTR [edi], 0
    
    ; Maintain bonus items (respawn)
    call MaintainBonusItems
    
NextBonus:
    inc esi
    pop ecx
    jmp CheckBonusLoop
    
CollisionDone:
    ; NOTE: We removed passenger collision penalty entirely
    ; Passengers are only picked up with SPACE, not by running into them
    
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
CheckCollisions ENDP

; ============================================================================
; HANDLE PICKUP/DROP (PICKUP FROM ADJACENT TILES)
; ============================================================================
HandlePickupDrop PROC
    push eax
    push ebx
    push ecx
    push esi
    push edi
    
    mov eax, targetPass
    cmp eax, -1
    jne TryDrop
    
    ; Try pickup - check if passenger is adjacent (within 1 tile)
    mov ecx, passengerCount
    xor esi, esi
PickupLoop:
    cmp esi, MAX_PASSENGERS
    jge PickupDone
    
    push ecx
    
    ; Check if passenger is active and not picked
    mov edi, OFFSET passActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    je NextPickup
    
    mov edi, OFFSET passPicked
    add edi, esi
    cmp BYTE PTR [edi], 1
    je NextPickup
    
    ; Get passenger position
    mov edi, OFFSET passX
    add edi, esi
    mov bl, [edi]
    
    mov edi, OFFSET passY
    add edi, esi
    mov bh, [edi]
    
    ; Check if within 1 tile (adjacent or same position)
    ; Calculate distance: abs(playerX - passX) + abs(playerY - passY)
    
    ; X distance
    mov al, playerX
    sub al, bl
    jge XPositive
    neg al
XPositive:
    mov cl, al
    
    ; Y distance
    mov al, playerY
    sub al, bh
    jge YPositive
    neg al
YPositive:
    mov ch, al
    
    ; Total distance = CL + CH
    add cl, ch
    cmp cl, 1
    jg NextPickup
    
    ; Pickup passenger!
    mov eax, esi
    mov targetPass, eax
    
    mov edi, OFFSET passPicked
    add edi, esi
    mov BYTE PTR [edi], 1
    
    pop ecx
    jmp PickupDone
    
NextPickup:
    inc esi
    pop ecx
    jmp PickupLoop


    
TryDrop:
    ; Try drop - must be at exact destination
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
    
    ; Successfully dropped passenger!
    mov edi, OFFSET passActive
    add edi, esi
    mov BYTE PTR [edi], 0
    
    mov targetPass, -1
    
    ; +10 points ONLY on successful drop-off
    add playerScore, 10
    
    ; Increment jobs done
    inc jobsDone
    
    ; Maintain passengers (keep 3-5 active)
    call MaintainPassengers
    
    ; Every 2 jobs: increase speed
    mov eax, jobsDone
    mov ebx, 2
    xor edx, edx
    div ebx
    cmp edx, 0
    jne NoSpeedIncrease
    
    ; Decrease carSpeed (faster cars)
    mov eax, carSpeed
    cmp eax, 1
    jle NoSpeedIncrease
    dec carSpeed
    
    ; Also try to spawn new car
    mov eax, carCount
    cmp eax, MAX_CARS
    jge NoSpeedIncrease
    call SpawnNewCar
    
NoSpeedIncrease:
    
PickupDone:
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
HandlePickupDrop ENDP


; ============================================================================
; DRAW GAME
; ============================================================================
DrawGame PROC
    push eax
    push ebx
    push ecx
    push edx
    
    ; Draw 20x20 grid
    xor ebx, ebx
DrawRows:
    cmp ebx, 20
    jge DrawEntities
    
    xor ecx, ecx
    
DrawCols:
    cmp ecx, 20
    jge NextRow
    
    ; Position cursor
    mov dh, bl
    add dh, 2
    
    ; Calculate X position (each cell is 4 characters wide)
    push eax
    mov al, cl
    mov dl, 4
    mul dl
    add al, 2
    mov dl, al
    pop eax
    call Gotoxy
    
    ; Get tile type from board array
    push ebx
    push ecx
    
    ; Calculate board index: row * 20 + col
    mov al, bl
    xor ah, ah
    mov dl, 20
    mul dl
    add ax, cx
    
    ; Access board[index]
    mov esi, OFFSET board
    xor edx, edx
    mov dx, ax
    add esi, edx
    mov al, [esi]
    
    pop ecx
    pop ebx
    
    ; Check if road (1) or building (0)
    cmp al, 1
    je DrawRoadCell
    
    ; Building - BLACK text on BLACK background (solid black)
    mov eax, black + (black * 16)
    call SetTextColor
    mov al, 219  ; Solid block character
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    jmp NextCol
    
DrawRoadCell:
    ; Road - BLACK text on WHITE background (white road)
    mov eax, black + (white * 16)
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
    ; Draw obstacles
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
    
    ; Tree
    mov eax, green + (white * 16)
    call SetTextColor
    mov al, 6
    call WriteChar
    mov al, 'T'
    call WriteChar
    mov al, 'R'
    call WriteChar
    jmp NextObst
    
DrawBox:
    ; Box
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
    ; Draw NPC cars
    mov ecx, carCount
    xor esi, esi
    
DrawCarLoop:
    cmp esi, ecx
    jge DrawBonus
    
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
    
    ; Blue car
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
    
DrawBonus:
    ; Draw bonus items
    mov ecx, bonusCount
    xor esi, esi
    
DrawBonusLoop:
    cmp esi, ecx
    jge DrawPass
    
    push ecx
    
    mov edi, OFFSET bonusActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    je SkipBonus
    
    mov edi, OFFSET bonusX
    add edi, esi
    xor eax, eax
    mov al, [edi]
    mov dl, 4
    mul dl
    add al, 2
    mov dl, al
    
    mov edi, OFFSET bonusY
    add edi, esi
    mov dh, [edi]
    add dh, 2
    
    call Gotoxy
    
    ; Yellow dollar sign
    mov eax, yellow + (white * 16)
    call SetTextColor
    mov al, '$'
    call WriteChar
    mov al, ' '
    call WriteChar
    call WriteChar
    
SkipBonus:
    inc esi
    pop ecx
    jmp DrawBonusLoop
DrawPass:
    ; Draw passengers
    mov ecx, MAX_PASSENGERS
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
    
    ; Stick figure
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
    ; Draw destination (green)
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
    
    ; Green destination
    mov eax, lightGreen + (white * 16)
    call SetTextColor
    mov al, 'D'
    call WriteChar
    mov al, 'S'
    call WriteChar
    mov al, 'T'
    call WriteChar
    
DrawPlayer:
    ; Draw taxi
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
    
    ; Red taxi
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
    ; Yellow taxi
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
    
    ; Count active passengers
    xor eax, eax
    xor ecx, ecx
    
CountLoop:
    mov ebx, MAX_PASSENGERS
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
; MAINTAIN PASSENGERS (KEEP 3-5 ACTIVE) - FIXED VERSION
; ============================================================================
MaintainPassengers PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    ; Count active passengers (not picked up and not delivered)
    xor eax, eax
    xor ecx, ecx
    
CountActive:
    cmp ecx, MAX_PASSENGERS
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
    ; If less than 3 active, spawn until we have at least 3
SpawnLoop:
    cmp eax, 3
    jge CheckMax
    
    ; Find first inactive slot
    xor esi, esi
    
FindSlot:
    cmp esi, MAX_PASSENGERS
    jge NoSpawn
    
    push esi
    mov edi, OFFSET passActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    pop esi
    je FoundSlot
    
    inc esi
    jmp FindSlot
    
FoundSlot:
    ; Spawn new passenger at this slot
    push eax
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
    
    pop eax
    inc eax
    jmp SpawnLoop
    
CheckMax:
    ; Optionally spawn more up to 5 (30% chance for each)
    cmp eax, 5
    jge NoSpawn
    
    push eax
    mov eax, 100
    call RandomRange
    cmp eax, 30
    pop eax
    jg NoSpawn
    
    ; Find first inactive slot
    xor esi, esi
    
FindSlot2:
    cmp esi, MAX_PASSENGERS
    jge NoSpawn
    
    push esi
    mov edi, OFFSET passActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    pop esi
    je FoundSlot2
    
    inc esi
    jmp FindSlot2
    
FoundSlot2:
    ; Spawn new passenger
    push eax
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
    
    pop eax
    inc eax
    jmp CheckMax
    
NoSpawn:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
MaintainPassengers ENDP


; ============================================================================
; MAINTAIN BONUS ITEMS (KEEP 3-5 ACTIVE)
; ============================================================================
MaintainBonusItems PROC
    push eax
    push ebx
    push ecx
    push esi
    
    ; Count active bonus items
    xor eax, eax
    xor ecx, ecx
    
CountBonus:
    mov ebx, bonusCount
    cmp ecx, ebx
    jge CheckBonusSpawn
    
    push ecx
    mov esi, ecx
    
    mov edi, OFFSET bonusActive
    add edi, esi
    cmp BYTE PTR [edi], 0
    je SkipBonusCount
    
    inc eax
    
SkipBonusCount:
    pop ecx
    inc ecx
    jmp CountBonus
    
CheckBonusSpawn:
    ; If less than 3 active, spawn new
    cmp eax, 3
    jge NoBonusSpawn
    
    mov eax, bonusCount
    cmp eax, MAX_BONUS
    jge NoBonusSpawn
    
    ; Spawn new bonus item
    mov esi, eax
    
    call FindRoadPosition
    mov edi, OFFSET bonusX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET bonusY
    add edi, esi
    mov [edi], ah
    
    mov edi, OFFSET bonusActive
    add edi, esi
    mov BYTE PTR [edi], 1
    
    inc bonusCount
    
NoBonusSpawn:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
MaintainBonusItems ENDP

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


; ============================================================================
; SAVE GAME
; ============================================================================
SaveGame PROC
    push eax
    push ecx
    push edx
    
    ; Create save file
    mov edx, OFFSET saveFilename
    call CreateOutputFile
    jc SaveFailed
    mov fileHandle, eax
    
    ; Write player position (2 bytes)
    mov edx, OFFSET playerX
    mov ecx, 2
    call WriteToFile
    
    ; Write player score (4 bytes)
    mov edx, OFFSET playerScore
    mov ecx, 4
    call WriteToFile
    
    ; Write player fuel (4 bytes)
    mov edx, OFFSET playerFuel
    mov ecx, 4
    call WriteToFile
    
    ; Write taxi color (1 byte)
    mov edx, OFFSET taxiColor
    mov ecx, 1
    call WriteToFile
    
    ; Write target passenger (4 bytes)
    mov edx, OFFSET targetPass
    mov ecx, 4
    call WriteToFile
    
    ; Write jobs done (4 bytes)
    mov edx, OFFSET jobsDone
    mov ecx, 4
    call WriteToFile
    
    ; Write passenger count (4 bytes)
    mov edx, OFFSET passengerCount
    mov ecx, 4
    call WriteToFile
    
    ; Write car speed (4 bytes)
    mov edx, OFFSET carSpeed
    mov ecx, 4
    call WriteToFile
    
    ; Write difficulty (1 byte)
    mov edx, OFFSET difficulty
    mov ecx, 1
    call WriteToFile
    
    ; Write player name (30 bytes)
    mov edx, OFFSET playerName
    mov ecx, 30
    call WriteToFile
    
    ; Write board (400 bytes)
    mov edx, OFFSET board
    mov ecx, 400
    call WriteToFile
    
    ; Write passenger data (5*5 = 25 bytes)
    mov edx, OFFSET passX
    mov ecx, 5
    call WriteToFile
    mov edx, OFFSET passY
    mov ecx, 5
    call WriteToFile
    mov edx, OFFSET passDestX
    mov ecx, 5
    call WriteToFile
    mov edx, OFFSET passDestY
    mov ecx, 5
    call WriteToFile
    mov edx, OFFSET passPicked
    mov ecx, 5
    call WriteToFile
    mov edx, OFFSET passActive
    mov ecx, 5
    call WriteToFile
    
    ; Write obstacle data
    mov edx, OFFSET obstacleCount
    mov ecx, 4
    call WriteToFile
    mov edx, OFFSET obstX
    mov ecx, 10
    call WriteToFile
    mov edx, OFFSET obstY
    mov ecx, 10
    call WriteToFile
    mov edx, OFFSET obstType
    mov ecx, 10
    call WriteToFile
    
    ; Write car data
    mov edx, OFFSET carCount
    mov ecx, 4
    call WriteToFile
    mov edx, OFFSET carX
    mov ecx, 8
    call WriteToFile
    mov edx, OFFSET carY
    mov ecx, 8
    call WriteToFile
    mov edx, OFFSET carDirX
    mov ecx, 8
    call WriteToFile
    mov edx, OFFSET carDirY
    mov ecx, 8
    call WriteToFile
    mov edx, OFFSET carActive
    mov ecx, 8
    call WriteToFile
    
    ; Write bonus data
    mov edx, OFFSET bonusCount
    mov ecx, 4
    call WriteToFile
    mov edx, OFFSET bonusX
    mov ecx, 5
    call WriteToFile
    mov edx, OFFSET bonusY
    mov ecx, 5
    call WriteToFile
    mov edx, OFFSET bonusActive
    mov ecx, 5
    call WriteToFile
    
    ; Close file
    mov eax, fileHandle
    call CloseFile
    
    call Clrscr
    mov edx, OFFSET saveMsg1
    call WriteString
    call Crlf
    call WaitMsg
    jmp SaveDone
    
SaveFailed:
    ; Ignore error, just continue
    
SaveDone:
    pop edx
    pop ecx
    pop eax
    ret
SaveGame ENDP

; ============================================================================
; LOAD GAME
; ============================================================================
LoadGame PROC
    push eax
    push ecx
    push edx
    
    ; Open save file
    mov edx, OFFSET saveFilename
    call OpenInputFile
    jc LoadFailed
    mov fileHandle, eax
    
    ; Read player position
    mov edx, OFFSET playerX
    mov ecx, 2
    call ReadFromFile
    
    ; Read player score
    mov edx, OFFSET playerScore
    mov ecx, 4
    call ReadFromFile
    
    ; Read player fuel
    mov edx, OFFSET playerFuel
    mov ecx, 4
    call ReadFromFile
    
    ; Read taxi color
    mov edx, OFFSET taxiColor
    mov ecx, 1
    call ReadFromFile
    
    ; Read target passenger
    mov edx, OFFSET targetPass
    mov ecx, 4
    call ReadFromFile
    
    ; Read jobs done
    mov edx, OFFSET jobsDone
    mov ecx, 4
    call ReadFromFile
    
    ; Read passenger count
    mov edx, OFFSET passengerCount
    mov ecx, 4
    call ReadFromFile
    
    ; Read car speed
    mov edx, OFFSET carSpeed
    mov ecx, 4
    call ReadFromFile
    
    ; Read difficulty
    mov edx, OFFSET difficulty
    mov ecx, 1
    call ReadFromFile
    
    ; Read player name
    mov edx, OFFSET playerName
    mov ecx, 30
    call ReadFromFile
    
    ; Read board
    mov edx, OFFSET board
    mov ecx, 400
    call ReadFromFile
    
    ; Read passenger data
    mov edx, OFFSET passX
    mov ecx, 5
    call ReadFromFile
    mov edx, OFFSET passY
    mov ecx, 5
    call ReadFromFile
    mov edx, OFFSET passDestX
    mov ecx, 5
    call ReadFromFile
    mov edx, OFFSET passDestY
    mov ecx, 5
    call ReadFromFile
    mov edx, OFFSET passPicked
    mov ecx, 5
    call ReadFromFile
    mov edx, OFFSET passActive
    mov ecx, 5
    call ReadFromFile
    
    ; Read obstacle data
    mov edx, OFFSET obstacleCount
    mov ecx, 4
    call ReadFromFile
    mov edx, OFFSET obstX
    mov ecx, 10
    call ReadFromFile
    mov edx, OFFSET obstY
    mov ecx, 10
    call ReadFromFile
    mov edx, OFFSET obstType
    mov ecx, 10
    call ReadFromFile
    
    ; Read car data
    mov edx, OFFSET carCount
    mov ecx, 4
    call ReadFromFile
    mov edx, OFFSET carX
    mov ecx, 8
    call ReadFromFile
    mov edx, OFFSET carY
    mov ecx, 8
    call ReadFromFile
    mov edx, OFFSET carDirX
    mov ecx, 8
    call ReadFromFile
    mov edx, OFFSET carDirY
    mov ecx, 8
    call ReadFromFile
    mov edx, OFFSET carActive
    mov ecx, 8
    call ReadFromFile
    
    ; Read bonus data
    mov edx, OFFSET bonusCount
    mov ecx, 4
    call ReadFromFile
    mov edx, OFFSET bonusX
    mov ecx, 5
    call ReadFromFile
    mov edx, OFFSET bonusY
    mov ecx, 5
    call ReadFromFile
    mov edx, OFFSET bonusActive
    mov ecx, 5
    call ReadFromFile
    
    ; Close file
    mov eax, fileHandle
    call CloseFile
    
    ; Reset frame counter and move counter
    mov frameCount, 0
    mov moveCounter, 0
    
    call Clrscr
    mov edx, OFFSET loadMsg1
    call WriteString
    call Crlf
    call WaitMsg
    
    clc  ; Clear carry flag (success)
    jmp LoadDone
    
LoadFailed:
    call Clrscr
    mov edx, OFFSET loadMsg2
    call WriteString
    call Crlf
    call WaitMsg
    stc  ; Set carry flag (failure)
    
LoadDone:
    pop edx
    pop ecx
    pop eax
    ret
LoadGame ENDP


; ============================================================================
; LOAD HIGH SCORES
; ============================================================================
LoadHighScores PROC
    push eax
    push ecx
    push edx
    push esi
    
    ; Try to open file
    mov edx, OFFSET hsFilename
    call OpenInputFile
    jc NoFile
    mov fileHandle, eax
    
    ; Read 10 scores (4 bytes each = 40 bytes)
    mov edx, OFFSET highScores
    mov ecx, 40
    call ReadFromFile
    
    ; Read 10 names (30 bytes each = 300 bytes)
    mov edx, OFFSET highNames
    mov ecx, 300
    call ReadFromFile
    
    ; Close file
    mov eax, fileHandle
    call CloseFile
    jmp LoadHSDone
    
NoFile:
    ; Initialize empty leaderboard
    mov ecx, 10
    mov esi, OFFSET highScores
    xor eax, eax
    
ClearScores:
    mov [esi], eax
    add esi, 4
    dec ecx
    cmp ecx, 0
    jne ClearScores
    
LoadHSDone:
    pop esi
    pop edx
    pop ecx
    pop eax
    ret
LoadHighScores ENDP

; ============================================================================
; UPDATE HIGH SCORES
; ============================================================================
UpdateHighScores PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Check if score qualifies (must be > 0 and > lowest score)
    mov eax, playerScore
    cmp eax, 0
    jle NoUpdate
    
    mov esi, OFFSET highScores
    add esi, 36  ; Last score (index 9 * 4)
    mov ebx, [esi]
    cmp eax, ebx
    jle NoUpdate
    
    ; Find insertion position
    mov ecx, 10
    mov esi, OFFSET highScores
    
FindPos:
    cmp ecx, 0
    je InsertAtEnd
    
    mov ebx, [esi]
    cmp eax, ebx
    jg FoundPos
    
    add esi, 4
    dec ecx
    jmp FindPos
    
FoundPos:
    ; Shift scores down
    push esi
    push ecx
    
    ; Calculate how many to shift
    mov eax, ecx
    dec eax  ; Shift count
    cmp eax, 0
    jle NoShift
    
    mov ecx, eax
    
    ; Start from bottom, shift down
    mov esi, OFFSET highScores
    add esi, 36  ; Index 9
    
ShiftScoresDown:
    mov ebx, [esi - 4]
    mov [esi], ebx
    sub esi, 4
    dec ecx
    cmp ecx, 0
    jne ShiftScoresDown
    
NoShift:
    ; Shift names down
    pop ecx
    push ecx
    
    mov eax, ecx
    dec eax
    cmp eax, 0
    jle NoShiftNames
    
    mov ecx, eax
    
    mov esi, OFFSET highNames
    mov eax, 270  ; 9 * 30
    add esi, eax
    
ShiftNamesDown:
    push ecx
    push esi
    
    ; Copy 30 bytes
    mov ecx, 30
    mov edi, esi
    sub esi, 30
    
CopyName:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    cmp ecx, 0
    jne CopyName
    
    pop esi
    pop ecx
    sub esi, 30
    dec ecx
    cmp ecx, 0
    jne ShiftNamesDown
    
NoShiftNames:
    pop ecx
    pop esi
    
    ; Insert new score
    mov eax, playerScore
    mov [esi], eax
    
    ; Calculate name position
    mov eax, 10
    sub eax, ecx
    mov ebx, 30
    mul ebx
    mov esi, OFFSET highNames
    add esi, eax
    
    ; Copy player name
    mov edi, esi
    mov esi, OFFSET playerName
    mov ecx, 30
    
CopyPlayerName:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    cmp ecx, 0
    jne CopyPlayerName
    
    ; Save to file
    call SaveHighScores
    jmp NoUpdate
    
InsertAtEnd:
    ; Should not reach here if logic is correct
    
NoUpdate:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
UpdateHighScores ENDP

; ============================================================================
; SAVE HIGH SCORES
; ============================================================================
SaveHighScores PROC
    push eax
    push ecx
    push edx
    
    ; Create file
    mov edx, OFFSET hsFilename
    call CreateOutputFile
    jc SaveHSFailed
    mov fileHandle, eax
    
    ; Write 10 scores
    mov edx, OFFSET highScores
    mov ecx, 40
    call WriteToFile
    
    ; Write 10 names
    mov edx, OFFSET highNames
    mov ecx, 300
    call WriteToFile
    
    ; Close file
    mov eax, fileHandle
    call CloseFile
    
SaveHSFailed:
    pop edx
    pop ecx
    pop eax
    ret
SaveHighScores ENDP

; ============================================================================
; SHOW LEADERBOARD
; ============================================================================
ShowLeaderboard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    call Clrscr
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov edx, OFFSET lb1
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET lb2
    call WriteString
    call Crlf
    mov edx, OFFSET lb3
    call WriteString
    call Crlf
    
    ; Check if any scores exist
    mov esi, OFFSET highScores
    mov eax, [esi]
    cmp eax, 0
    je NoScores
    
    ; Display top 10
    mov ecx, 10
    xor ebx, ebx
    mov esi, OFFSET highScores
    
DisplayLoop:
    push ecx
    
    ; Check if score is 0 (empty slot)
    mov eax, [esi]
    cmp eax, 0
    je SkipDisplay
    
    ; Display rank
    mov eax, ebx
    inc eax
    call WriteDec
    
    ; Spacing
    cmp eax, 10
    jge NoExtraSpace
    mov al, ' '
    call WriteChar
    
NoExtraSpace:
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    
    ; Display name
    push esi
    mov eax, ebx
    mov edx, 30
    mul edx
    mov esi, OFFSET highNames
    add esi, eax
    
    mov ecx, 30
PrintName:
    mov al, [esi]
    cmp al, 0
    je DoneName
    call WriteChar
    inc esi
    dec ecx
    cmp ecx, 0
    jne PrintName
    
DoneName:
    ; Pad spaces
PadName:
    cmp ecx, 0
    je DonePad
    mov al, ' '
    call WriteChar
    dec ecx
    jmp PadName
    
DonePad:
    pop esi
    
    ; Display score
    mov al, ' '
    call WriteChar
    call WriteChar
    mov eax, [esi]
    call WriteDec
    call Crlf
    
SkipDisplay:
    add esi, 4
    inc ebx
    pop ecx
    dec ecx
    cmp ecx, 0
    jne DisplayLoop
    
    jmp ShowLBDone
    
NoScores:
    mov edx, OFFSET lb4
    call WriteString
    call Crlf
    
ShowLBDone:
    call Crlf
    mov edx, OFFSET lb5
    call WriteString
    call ReadChar
    
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
ShowLeaderboard ENDP


; ============================================================================
; SHOW INSTRUCTIONS
; ============================================================================
ShowInstructions PROC
    push eax
    push edx
    
    call Clrscr
    
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    
    mov edx, OFFSET inst1
    call WriteString
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET inst2
    call WriteString
    call Crlf
    mov edx, OFFSET inst3
    call WriteString
    call Crlf
    mov edx, OFFSET inst4
    call WriteString
    call Crlf
    mov edx, OFFSET inst5
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov edx, OFFSET inst6
    call WriteString
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET inst7
    call WriteString
    call Crlf
    mov edx, OFFSET inst8
    call WriteString
    call Crlf
    mov edx, OFFSET inst9
    call WriteString
    call Crlf
    mov edx, OFFSET inst10
    call WriteString
    call Crlf
    mov edx, OFFSET inst11
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov edx, OFFSET inst12
    call WriteString
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET inst13
    call WriteString
    call Crlf
    mov edx, OFFSET inst14
    call WriteString
    call Crlf
    mov edx, OFFSET inst15
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, red + (black * 16)
    call SetTextColor
    mov edx, OFFSET inst16
    call WriteString
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET inst17
    call WriteString
    call Crlf
    mov edx, OFFSET inst18
    call WriteString
    call Crlf
    mov edx, OFFSET inst19
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET inst20
    call WriteString
    call Crlf
    mov edx, OFFSET inst21
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET inst22
    call WriteString
    call ReadChar
    
    pop edx
    pop eax
    ret
ShowInstructions ENDP

; ============================================================================
; CHANGE DIFFICULTY
; ============================================================================
ChangeDifficulty PROC
    push eax
    push edx
    
    call Clrscr
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov edx, OFFSET diff1
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET diff2
    call WriteString
    call Crlf
    mov edx, OFFSET diff3
    call WriteString
    call Crlf
    mov edx, OFFSET diff4
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET diff5
    call WriteString
    call ReadChar
    
    cmp al, '1'
    je SetDiff0
    cmp al, '2'
    je SetDiff1
    cmp al, '3'
    je SetDiff2
    
    ; Default to medium
    mov difficulty, 1
    jmp DiffDone
    
SetDiff0:
    mov difficulty, 0
    jmp DiffDone
    
SetDiff1:
    mov difficulty, 1
    jmp DiffDone
    
SetDiff2:
    mov difficulty, 2
    
DiffDone:
    pop edx
    pop eax
    ret
ChangeDifficulty ENDP



END main


