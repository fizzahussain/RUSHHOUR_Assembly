INCLUDE Irvine32.inc



.data


    ; equ for constants 
    BOARD_SIZE      EQU 20 
    MAX_PASSENGERS  EQU 5
    MAX_OBSTACLES   EQU 10
    MAX_CARS        EQU 8
    MAX_BONUS       EQU 5
    board           BYTE 400 DUP(1) ; 20X20 GRID
    taxicolor       BYTE 0 ; 0 Y & 1 R
    playerX         BYTE 0; TAXI
    playerY         BYTE 0
    playerscore     DWORD 0
    fuel_amt      DWORD 500
    total_dropsoffs        DWORD 0
    passengercount  DWORD 0
    carrying      SDWORD -1 ;NONE RN CARRYING


    nameprompt      BYTE "Enter your name: ", 0
    taxiprompt      BYTE "Choose taxi (1=Yellow or  2=Red or 3=Random): ", 0


    ;start menu
    opt1        BYTE "            1. Start New Game", 0
    opt2        BYTE "            2. Continue Game", 0
    opt3        BYTE "            3. Change Difficulty", 0
    opt4        BYTE "            4. View Leaderboard", 0
    opt5        BYTE "            5. Instructions", 0
    opt6        BYTE "            6. Exit", 0
    opt7      BYTE "            ", 0
    ;design 


    ground BYTE "--------------------------------------------------------------------------------",0
    ui1      BYTE "          ____  _   _ ____  _   _   _   _  ___  _   _ ____  ", 0
    ui2      BYTE "         |  _ \| | | / ___|| | | | | | | |/ _ \| | | |  _ \ ", 0
    ui3      BYTE "         | |_) | | | \___ \| |_| | | |_| | | | | | | | |_) |", 0
    ui4      BYTE "         |  _ <| |_| |___) |  _  | |  _  | |_| | |_| |  _ < ", 0
    ui5      BYTE "         |_| \\\___/|____/|_| |_| |_| |_|\___/ \___/|_| \_\\ ", 0
    ui6      BYTE "                                                              ", 0
    ui7      BYTE "                     _____  __    __  __ ___                  ", 0
    ui8      BYTE "                    |_   _|/ /\\ \\ \\/ \\|_ _|                 ", 0
    ui9      BYTE "                      | | / /\\ \\\\ /\\ \\| |                  ", 0
    ui10     BYTE "                      |_|/_/  \\_\\_||_/___|                  ", 0

   ; ui1      BYTE "    ####   #  #  ###  #  #   #  #  ####  #  #  ####", 0
   ; ui2      BYTE "    #  #   #  # #     #  #   #  # #    # #  #  #  #", 0
    ;ui3      BYTE "    ####   #  #  ##   ####   #### #    # #  #  ####", 0
    ;ui4      BYTE "    # #    #  #    #  #  #   #  # #    # #  #  # # ", 0
   ; ui5      BYTE "    #  #    ##  ###   #  #   #  #  ####   ##   #  #", 0
    ;ui6      BYTE "          ", 0
    ;ui7      BYTE "                   ##### ###  #  # ####             ", 0
    ;ui8      BYTE "                     #   #  #  ##   ##              ", 0
    ;ui9      BYTE "                     #   ###    #   ##              ", 0
    ;ui10     BYTE "                     #   #  #  ##  ####             ", 0
    taxi1        BYTE "                    .---------------.", 0
    taxi2        BYTE "                   /  .-------------. \\", 0
    taxi3        BYTE "                  /  /   TAXI      \\ \\", 0
    taxi4        BYTE "                 .  '---------------'  .", 0
    taxi5        BYTE "                 |  .---------------.  |", 0
    taxi6        BYTE "                  \\ | O           O | /", 0
    taxi7        BYTE "                   '._._._._._._._._.'", 0
    

    carX            BYTE 8 DUP(0)
    carY            BYTE 8 DUP(0)
    npc_dirX         SBYTE 8 DUP(0)
    npc_dirY         SBYTE 8 DUP(0)
    npc_active       BYTE 8 DUP(1)
    npc_count        DWORD 0
    npc_speed        DWORD 3

    ;RED TAXI KI SPEED CONTROL 
    move_speed_counter     DWORD 0
    buffer_temp      BYTE 100 DUP(?)


    passX           BYTE 5 DUP(0) ; PASS ARRAY 5 EACH FOR POSITION , DESTINATION , ACTIVE AND CARRYING
    passY           BYTE 5 DUP(0)
    passdestX       BYTE 5 DUP(0)
    passdestY       BYTE 5 DUP(0)
    pass_picked      BYTE 5 DUP(0)
    pass_active      BYTE 5 DUP(0)
    obstX           BYTE 10 DUP(0)
    obstY           BYTE 10 DUP(0)
    obsttype        BYTE 10 DUP(0)
    obstaclecount   DWORD 0
    


    gamesaveprompt        BYTE "Game saved!", 0
    gameloadprompt        BYTE "Game loaded!", 0
    gameloadprompt1        BYTE "No save file found!", 0
    bonusX          BYTE 5 DUP(0)
    bonusY          BYTE 5 DUP(0)
    bonusonboard     BYTE 5 DUP(0)
    bonuscount      DWORD 0
    framecount      DWORD 0 ; ANIMATION
    inputchar       BYTE ?
    play_name      BYTE 30 DUP(?)
    menuinput      BYTE 0
    difficulty      BYTE 1


    currentMode     BYTE 0  
    timerSeconds    DWORD 0  
    timerActive     BYTE 0   
    mode1           BYTE "1. Career Mode ;- Complete deliveries to progress while the fuel doesnt run out", 0
    mode2           BYTE "2. Time Mode :- Score as much as possible in 120 seconds", 0
    mode3           BYTE "3. Endless Mode :- Play forever while increasing difficulty PRESS x to exit", 0

    mode4           BYTE "Select Mode (1-3): ", 0
    modeTitle       BYTE "GAME MODE SELECTION", 0

    
   


    ; end of game over
    gameover1       BYTE "GAME OVER!", 0
    gameover2       BYTE "Reason: Out of Fuel!", 0
    gameover3       BYTE "Reason: Score went negative!", 0
    final_score   BYTE "Final Score: ", 0
    end_game        BYTE "Thanks for playing!", 0
     ; difficulty
    diff1           BYTE "DIFFICULTY LEVELS :  " , 0
    diff3           BYTE "2. Medium - 500 Fuel, 7 Obstacles & Normal Cars", 0
    diff4           BYTE "3. Hard   - 300 Fuel, 10 Obstacles & Fast Cars", 0
    diff2           BYTE "1. Easy    - 1000 Fuel, 5 Obstacles &  Slow Cars", 0    
    diff5           BYTE "Select (1-3) : ", 0
    ;File
    filehandle      DWORD ?
    savegamefilenametxt    BYTE "savegame.txt", 0
    filenametxt      BYTE "highscores.txt", 0
    bytes_written     DWORD ?
    ;Leaderboard
    highScores      DWORD 10 DUP(0)
    highNames       BYTE 300 DUP(?)
    tempScore       DWORD ?
    ;instructions menu
    inst1           BYTE "instructions : ", 0
    
    inst12          BYTE "YELLOW TAXI MODE:", 0
    inst13          BYTE "  Faster movement", 0
    inst14          BYTE "  Obstacle damage -4 points", 0
    inst15          BYTE "  Car collision -2 points", 0
    inst2           BYTE "  W/A/S/D - Move taxi", 0
    inst3           BYTE "  SPACEbar - Pick up/drop passenger", 0
    inst4           BYTE "  P - Pause game & L - to save", 0
    inst5           BYTE "  X - Exit to menu", 0
    inst6           BYTE "OBJECTIVE:", 0
    inst7           BYTE "  Pick up stick figures (\O/)", 0
    inst8           BYTE "  Drop at GREEN destinations (*DST)", 0
    inst9           BYTE "  +10 points per delivery", 0
    inst10          BYTE "  Collect gems and other precious items for bonus +10 points", 0
    inst11          BYTE "  Avoid obstacles and other cars!", 0

    inst16          BYTE "RED TAXI:", 0
    inst17          BYTE "  Slower but tougher", 0
    inst18          BYTE "  Obstacle damage -2 points", 0
    inst19          BYTE "  Car collision -3 points", 0
    inst20          BYTE "Hit passenger -5 points", 0
    inst21          BYTE "After every 2 deliveries you get Faster cars! ", 0
    inst22          BYTE "Press any key to continue", 0
    ; leaderboard
    lb1             BYTE "TOP 10 HIGH SCORES: ", 0
    lb2             BYTE "Rank   Name                         Score", 0
    lb3             BYTE "------------------------------------------", 0
    lb4             BYTE "No scores yet  ", 0
    lb5             BYTE "Press any key to continue", 0
    
    ;top of screen
     timeRemaining   BYTE " |  Time: ", 0
    timeUp          BYTE "TIME'S UP!", 0
    score_display        BYTE "Score: ", 0
    fuel_display         BYTE " | Fuel: ", 0
    pass_display         BYTE " | Active: ", 0
    mode_display         BYTE " | Mode: ", 0
    mode_career_txt      BYTE "Career", 0
    mode_time_txt        BYTE "Time", 0
    mode_endless_txt     BYTE "Endless", 0
    donedropped_display         BYTE " | Delivered: ", 0
    carrying_display        BYTE ">>> Carrying passenger!!!! Go to GREEN destination NOWW! (you cannot pickup another till you dropoff) <<<", 0
    items_on_board       BYTE "Taxi=[T]  Passenger=\O/  Tree=TR  Box=[#]  Car=[C]  Bonus=$ , <> , etc. ", 0
    endless_session_high    DWORD 0
    endless_high_msg        BYTE " | Session Best: ", 0
    
     pauseTitle      BYTE "=== GAME PAUSED ===", 0
    pauseMsg1       BYTE "Press P to Resume", 0
    pauseMsg2       BYTE "Press X to Exit to Menu", 0






;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


.code

main PROC
    call Randomize
    call LoadHighScores
    
menu_choiceLOOP: ;DISPLAY MENU AND TAKE CHOICE INPUT
    call DISPLAY
    xor eax, eax
    mov al, menuinput
    cmp al, 1
    je StartNew
    cmp al, 2
    je ContinueGame
    cmp al, 3
    je DIFFICULTY_OPT
    cmp al, 4
    je ShowLeader
    cmp al, 5
    je show_instructions
    cmp al, 6
    je END_ALL
    jmp menu_choiceLOOP
    


    ;CHOICE LEIKAR APPROPRIATE FLOW FOLLOW OR CALL 
StartNew:
    call Playerinfo_get
    call SelectGameMode
    
    ; *** Reset endless session high if endless mode ***
    mov al, currentMode
    cmp al, 2
    jne NotEndlessStart
    mov endless_session_high, 0
    
NotEndlessStart:
    call initialize_newgame 
    call GameLoop
    
    ; *** Only update leaderboard if NOT endless ***
    mov al, currentMode
    cmp al, 2
    je SkipLeaderboardUpdate
    call UpdateHighScores
    
SkipLeaderboardUpdate:
jmp menu_choiceLOOP
    
ContinueGame:

    call LoadGame
    jc menu_choiceLOOP
    call GameLoop
    call UpdateHighScores
    jmp menu_choiceLOOP
    
DIFFICULTY_OPT:

    call ChangeDifficulty
    jmp menu_choiceLOOP
    
ShowLeader:

    call ShowLeaderboard

    jmp menu_choiceLOOP
    
show_instructions:

    call ShowInstructions

    jmp menu_choiceLOOP
    


END_ALL:

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

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DISPLAY PROC
   
   push eax
    push edx
    
    call Clrscr
    
    mov eax,  magenta + (black * 16)
    call SetTextColor
    ;rushhour bara display
    mov edx, OFFSET ui1
    call WriteString
    call Crlf
    mov edx, offset ui2
    call WriteString
    call Crlf
    mov edx, offset ui3
    call WriteString
    call Crlf
    mov edx, offset ui4
    call WriteString
    call Crlf
    mov edx, offset ui5
    call WriteString
    call Crlf
    mov edx, offset ui6
    call WriteString
    call Crlf
    mov edx, offset ui7
    call WriteString
    call Crlf
    mov edx, offset ui8
    call WriteString
    call Crlf
    mov edx, offset ui9
    call WriteString
    call Crlf
    mov edx, offset ui10
    call WriteString
    call Crlf
    call Crlf
    mov eax, cyan + (black * 16)
    call SetTextColor
    ;car dummy display 
    mov edx, offset taxi1
    call WriteString
    call Crlf
    mov edx, offset taxi2
    call WriteString
    call Crlf
    mov edx, offset taxi3
    call WriteString
    call Crlf
    mov edx, offset taxi4
    call WriteString
    call Crlf
    mov edx, offset taxi5
    call WriteString
    call Crlf
    mov edx, offset taxi6
    call WriteString
    call Crlf
    mov edx, offset taxi7
    call WriteString
    call Crlf
    call Crlf
    ;options
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset opt1
    call WriteString
    call Crlf
    mov edx, offset opt2
    call WriteString
    call Crlf
    mov edx, offset opt3
    call WriteString
    call Crlf
    mov edx, offset opt4
    call WriteString
    call Crlf
    mov edx, offset opt5
    call WriteString
    call Crlf
    mov edx, offset opt6
    call WriteString
    call Crlf
    call Crlf


    
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov edx, offset opt7
    call WriteString
    call Crlf
    ;prompt
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, '>'
    call WriteChar
    mov al, ' '
    call WriteChar



    ;choice input
    call ReadChar
    


    cmp al, '1'
    je option1
    cmp al, '2'
    je option2
    cmp al, '3'
    je option3
    cmp al, '4'
    je option4
    cmp al, '5'
    je option5
    cmp al, '6'
    je option6
    
    ;invalid so default 1 start new game
    mov menuinput, 1
    jmp option_done
    


option1:
    mov menuinput, 1
    jmp option_done

option2:
    mov menuinput, 2
    jmp option_done

option3:
    mov menuinput, 3
    jmp option_done

option4:
    mov menuinput, 4
    jmp option_done
option5:
    mov menuinput, 5
    jmp option_done
option6:
    mov menuinput, 6
    jmp option_done
    


option_done:
    pop edx
    pop eax
    ret



DISPLAY ENDP




;------------------------------------------------------------------------------------------------------------------------------------------------------------------
ShowInstructions PROC
    push eax
    push edx
    
    call Clrscr
    mov eax, green + (black * 16)
    call SetTextColor
    
    mov edx, OFFSET inst1
    call WriteString
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET inst2
    call WriteString
    call Crlf
    mov edx, offset inst3
    call WriteString
    call Crlf
    mov edx, offset inst4
    call WriteString
    call Crlf
    mov edx, offset inst5
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov edx, offset inst6
    call WriteString
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset inst7
    call WriteString
    call Crlf
    mov edx, offset inst8
    call WriteString
    call Crlf
    mov edx, offset inst9
    call WriteString
    call Crlf
    mov edx, offset inst10
    call WriteString
    call Crlf
    mov edx, offset inst11
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov edx, offset inst12
    call WriteString
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset inst13
    call WriteString
    call Crlf
    mov edx, offset inst14
    call WriteString
    call Crlf
    mov edx, offset inst15
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, red + (black * 16)
    call SetTextColor
    mov edx, offset inst16
    call WriteString
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset inst17
    call WriteString
    call Crlf
    mov edx, offset inst18
    call WriteString
    call Crlf
    mov edx, offset inst19
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, offset inst20
    call WriteString
    call Crlf
    mov edx, OFFSET inst21
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET inst22
    call WriteString
    call ReadChar
    
    ; *** FIX #4: Properly restore registers and return ***
    pop edx
    pop eax
    ret
ShowInstructions ENDP
;--------------------------------------------------------------------------------------------------------------------------------------------------------------
Playerinfo_get PROC

    push eax
    push ecx
    push edx
    
    call Clrscr
    
    ;graphics
    mov dh, 8
    mov dl, 25
    call Gotoxy
    mov eax, cyan + (black * 16)
    call SetTextColor
    mov al, '-'

    mov ecx, 30


PrintTopBorder:
  call WriteChar
  loop PrintTopBorder



    mov dh, 9
    mov dl, 30
    call Gotoxy
    mov eax, magenta + (black * 16)
    call SetTextColor
    mov al, 'P'
    call WriteChar
    mov al, 'L'
    call WriteChar
    mov al, 'A'
    call WriteChar
    mov al, 'Y'
    call WriteChar
    mov al, 'E'
    call WriteChar
    mov al, 'R'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 'S'
    call WriteChar
    mov al, 'E'
    call WriteChar
    mov al, 'T'
    call WriteChar
    mov al, 'U'
    call WriteChar
    mov al, 'P'
    call WriteChar
    mov dh, 10
    mov dl, 25
    call Gotoxy
    mov eax, cyan + (black * 16)
    call SetTextColor


    mov al, '-'
    mov ecx, 30


PrintBottomBorder:

    call WriteChar
    loop PrintBottomBorder
    

    ; Name input prompt
    mov dh, 13
    mov dl, 28
    call Gotoxy
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, 'E'
    call WriteChar
    mov al, 'n'
    call WriteChar
    mov al, 't'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, 'r'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 'Y'
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, 'u'
    call WriteChar
    mov al, 'r'
    call WriteChar


    mov al, ' '
    call WriteChar


    mov al, 'N'
    call WriteChar
    mov al, 'a'
    call WriteChar
    mov al, 'm'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, ':'
    call WriteChar
    
    ;-----------
    ;box for name input
    mov dh, 14
    mov dl, 25
    call Gotoxy
    mov eax, black + (lightGray * 16)
    call SetTextColor
    mov al, ' '
    mov ecx, 30


PrintNameBox:

    call WriteChar
    loop PrintNameBox
    

  
    mov dh, 14;name input leina
    mov dl, 26
    call Gotoxy
    mov edx, offset play_name
    mov ecx, 28
    call ReadString
    mov dh, 17;Taxi choices red or yellow wala display
    mov dl, 27
    call Gotoxy
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov al, 'C'
    call WriteChar
    mov al, 'h'
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, 's'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 'Y'
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, 'u'
    call WriteChar
    mov al, 'r'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 'T'
    call WriteChar
    mov al, 'a'
    call WriteChar
    mov al, 'x'
    call WriteChar
    mov al, 'i'
    call WriteChar
    mov al, ':'
    call WriteChar

    ;yelow then red hen random taxi in display to choose from 


    mov dh, 19
    mov dl, 23
    call Gotoxy
    mov eax, black + (yellow * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, '1'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, 'Y'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, 'l'
    call WriteChar
    mov al, 'l'
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, 'w'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, '('
    call WriteChar
    mov al, 'F'
    call WriteChar
    mov al, 'a'
    call WriteChar
    mov al, 's'
    call WriteChar
    mov al, 't'
    call WriteChar
    mov al, ')'
    call WriteChar
    


    
    mov dh, 20;red wali taxi
    mov dl, 23
    call Gotoxy
    mov eax, yellow + (red * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, '2'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, 'R'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, 'd'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, '('
    call WriteChar
    mov al, 'T'
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, 'u'
    call WriteChar
    mov al, 'g'
    call WriteChar
    mov al, 'h'
    call WriteChar
    mov al, ')'
    call WriteChar
    
    


    mov dh, 21;random
    mov dl, 23
    call Gotoxy
    mov eax, white + (blue * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, '3'
    call WriteChar
    mov al, ' '
    call WriteChar
    
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, 'R'
    call WriteChar
    mov al, 'a'
    call WriteChar
    mov al, 'n'
    call WriteChar
    mov al, 'd'
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, 'm'
    call WriteChar
  


  ; ------------------------
  ;take input taxi

    mov dh, 23
    mov dl, 27
    call Gotoxy
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov al, 'P'
    call WriteChar
    mov al, 'r'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, 's'
    call WriteChar
    mov al, 's'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, '1'
    call WriteChar
    mov al, ','
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, '2'
    call WriteChar
    mov al, ','
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, 'r'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, '3'
    call WriteChar
    mov al, ':'
    call WriteChar
    mov al, ' '
    call WriteChar
   
   

taxi_input:

    call ReadChar
    
    cmp al, '1'
    je yellow_select
    cmp al, '2'
    je red_select
    cmp al, '3'
    je random_select
    
    ;invalid 
    ;so wait for when proper

    jmp taxi_input
    



random_select:

    mov eax, 2
    call RandomRange

    mov taxicolor, al
    jmp show_selected_taxi
    

yellow_select:

    mov taxicolor, 0
    jmp show_selected_taxi
  
  

red_select:

    mov taxicolor, 1


show_selected_taxi:

    mov dh, 23
    mov dl, 45
    call Gotoxy
    mov al, taxicolor
    cmp al, 0
    je showyellow
    mov eax, yellow + (red * 16)
    call SetTextColor
    mov al, '['
    call WriteChar
    mov al, 'T'
    call WriteChar
    mov al, ']'


    call WriteChar

    jmp delaystart
    

showyellow:

    mov eax, black + (yellow * 16)
    call SetTextColor
    mov al, '['
    call WriteChar
    mov al, 'T'
    call WriteChar

    mov al, ']'
    call WriteChar
    
delaystart:
    
    mov eax, 500;delay slecetion 
    call Delay
    
    pop edx
    pop ecx
    pop eax
    ret


    
Playerinfo_get ENDP

    
; --------------------------------------------------------------------------------------------------------------------------------------------------------------

initialize_newgame  PROC

    push eax
    push ebx
    push ecx
    push esi
    


   mov playerX, 0; start from start 0,0
    mov playerY, 0


    mov playerscore, 0
    mov total_dropsoffs, 0

    ; not carrying anything shurro mai
    mov carrying, -1 
    mov framecount, 0
    mov move_speed_counter, 0
    
  

    call ApplyDifficulty
    call GenerateBoard
    
 

    mov esi, offset board; start wali jaga road honi chahiye 
    mov BYTE PTR [esi], 1
    
  
    mov eax, 3;spawn pass
    call RandomRange
    add eax, 3
    

    mov ecx, eax
    xor esi, esi
    

SpawnPass:

    cmp ecx, 0

    je passengers_placed
    cmp esi, MAX_PASSENGERS 
    jge passengers_placed
    
    push ecx
    
    
passengers_position_find :

    call road_position_find  ;find position for passenger (not at 0,0)
    cmp al, 0 ;doublecheck kay 0,0 par spawn nah ho

    jne passenger_pos_isfine
    cmp ah, 0

    jne passenger_pos_isfine

    jmp passengers_position_find 
    


passenger_pos_isfine:
    mov edi, offset passX
    add edi, esi
    mov [edi], al
    
    mov edi, offset passY
    add edi, esi
    mov [edi], ah
    
    
destination_position_find :
    
    call road_position_find 
    
  
    cmp al, 0
    jne dest_notsame_aspick
    cmp ah, 0
    jne dest_notsame_aspick
    jmp destination_position_find 
    


dest_notsame_aspick:
    mov edi, offset passX
    add edi, esi
    cmp al, [edi]

    jne destination_ok
    mov edi, offset passY
    add edi, esi
    cmp ah, [edi]
    je destination_position_find 
    
destination_ok:

    mov edi, offset passdestX
    add edi, esi
    mov [edi], al
    mov edi, offset passdestY
    add edi, esi
    mov [edi], ah
    mov edi, offset pass_picked
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, offset pass_active
    add edi, esi
    mov BYTE PTR [edi], 1
  
    inc esi
    pop ecx
    dec ecx
    jmp SpawnPass
    


passengers_placed:
    mov ecx, MAX_PASSENGERS
    sub ecx, esi
    

clear_sab:

    cmp ecx, 0
    je skip_obs
    
    mov edi, offset pass_active
    add edi, esi
    mov BYTE PTR [edi], 0
    
    inc esi
    dec ecx
    jmp clear_sab


skip_obs:

    mov eax, obstaclecount
    cmp eax, 0
    je skip_obspawn
    
    mov ecx, eax
    xor esi, esi
    

spawn_obs:
    cmp ecx, 0
    je ObstDone
    cmp esi, 10 ;total 10 or max 10
    jge ObstDone
    
    push ecx
    
    
FindObstaclePos:
    call road_position_find 
  
    cmp al, 0 ; 0 ,0 check
    jne ObstPosOK
    cmp ah, 0
    jne ObstPosOK
   
    jmp FindObstaclePos    ; (0,0) so find another position
    
ObstPosOK:
    mov edi, offset obstX
    add edi, esi
    mov [edi], al
    
    mov edi, offset obstY
    add edi, esi
    mov [edi], ah
    
    mov eax, 2
    call RandomRange
    mov edi, offset obsttype
    add edi, esi
    mov [edi], al
    
    inc esi
    pop ecx
    dec ecx
    jmp spawn_obs
    
ObstDone:
skip_obspawn:
    ; Spawn 5 cars (continue with existing car spawn code)
    mov npc_count, 5
    mov ecx, 5
    xor esi, esi
    
SpawnCar:
    cmp ecx, 0
    je CarDone
    push ecx
    
    call road_position_find 
    mov edi, offset carX
    add edi, esi
    mov [edi], al
    
    mov edi, offset carY
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
    mov edi, offset npc_dirX
    add edi, esi
    mov BYTE PTR [edi], 1
    mov edi, offset npc_dirY
    add edi, esi
    mov BYTE PTR [edi], 0
    jmp DirDone
    
DirUp:
    mov edi, offset npc_dirX
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, offset npc_dirY
    add edi, esi
    mov BYTE PTR [edi], -1
    jmp DirDone
    
DirDown:
    mov edi, offset npc_dirX
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, offset npc_dirY
    add edi, esi
    mov BYTE PTR [edi], 1
    jmp DirDone
    
DirLeft:
    mov edi, offset npc_dirX
    add edi, esi
    mov BYTE PTR [edi], -1
    mov edi, offset npc_dirY
    add edi, esi
    mov BYTE PTR [edi], 0
    
DirDone:
    mov edi, offset npc_active
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
    mov bonuscount, eax
    
    mov ecx, eax
    xor esi, esi
    
SpawnBonus:
    cmp ecx, 0
    je BonusDone
    push ecx
    
    call road_position_find 
    mov edi, offset bonusX
    add edi, esi
    mov [edi], al
    
    mov edi, offset bonusY
    add edi, esi
    mov [edi], ah
    
    mov edi, offset bonusonboard
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
initialize_newgame  ENDP
 

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
    mov fuel_amt, 300
    mov obstaclecount, 10
    mov npc_speed, 2
    jmp DiffDone
    
SetMedium:
    mov fuel_amt, 500
    mov obstaclecount, 7
    mov npc_speed, 3
    jmp DiffDone
    
SetEasy:
    mov fuel_amt, 1000
    mov obstaclecount, 5
    mov npc_speed, 5
    
DiffDone:
    pop eax
    ret
ApplyDifficulty ENDP

; ============================================================================
; GENERATE BOARD 
; ============================================================================
GenerateBoard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    ; First, initialize all as roads (1)
    mov esi, offset board
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
    
push eax
mov eax, ebx
mov edx, 20
mul edx
mov ebx, eax
pop eax
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
    mov esi, offset board
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
    mov esi, offset board
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
mov edx, 20
mul edx
mov esi, offset board
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
    mov esi, offset board
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

road_position_find  PROC
    push ebx
    push ecx
    push edx
    push esi
    
    mov ecx, 500  ; Try 500 times
    
FindLoop:
    cmp ecx, 0
    je UseFallback
    
    ; 80% chance: spawn near a road corridor (guaranteed reachable)
    push ecx
    mov eax, 100
    call RandomRange
    pop ecx
    
    cmp eax, 80
    jl SpawnNearCorridor
    
SpawnAnywhere:
    ; 20% chance: spawn anywhere on a road
    mov eax, 20
    call RandomRange
    mov bl, al
    
    mov eax, 20
    call RandomRange
    mov bh, al
    jmp CheckPosition
    
SpawnNearCorridor:
    ; Pick a corridor (0, 5, 10, or 15)
    mov eax, 4
    call RandomRange
    mov edx, 5
    mul dl
    mov bl, al  ; X on corridor
    
    ; Add random offset -1 to +1
    push ebx
    mov eax, 3
    call RandomRange
    dec al  ; -1, 0, or +1
    pop ebx
    add bl, al
    
    ; Clamp to 0-19
    cmp bl, 0
    jl SpawnAnywhere
    cmp bl, 19
    jg SpawnAnywhere
    
    ; Do same for Y
    mov eax, 4
    call RandomRange
    mov edx, 5
    mul dl
    mov bh, al
    
    push ebx
    mov eax, 3
    call RandomRange
    dec al
    pop ebx
    add bh, al
    
    cmp bh, 0
    jl SpawnAnywhere
    cmp bh, 19
    jg SpawnAnywhere
    
CheckPosition:
    ; Check 1: Not at player starting position (0,0)
    cmp bl, 0
    jne NotPlayerStart
    cmp bh, 0
    je TryAgain
    
NotPlayerStart:
    ; Check 2: Not at current player position
    cmp bl, playerX
    jne NotCurrentPos
    cmp bh, playerY
    je TryAgain
    
NotCurrentPos:
    ; Check 3: Must be a road tile
    push ecx
    push ebx
    mov al, bh
    xor ah, ah
    mov dl, 20
    mul dl
    xor ch, ch
    mov cl, bl
    add ax, cx
    
    mov esi, offset board
    add esi, eax
    cmp BYTE PTR [esi], 1
    pop ebx
    pop ecx
    jne TryAgain
    
    ; Check 4: Not too close to edges (avoid isolated corners)
    cmp bl, 1
    jl TryAgain
    cmp bl, 18
    jg TryAgain
    cmp bh, 1
    jl TryAgain
    cmp bh, 18
    jg TryAgain
    
    ; Position is valid!
    jmp FoundRoad
    
TryAgain:
    dec ecx
    jmp FindLoop
    
UseFallback:
    ; Use a guaranteed safe position on a corridor
    mov bl, 5
    mov bh, 5
    
FoundRoad:
    mov al, bl
    mov ah, bh
    
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
road_position_find  ENDP

; ============================================================================
; CHECK IF POSITION IS REACHABLE FROM (0,0) 
; ============================================================================
IsReachable PROC
    ; Input: AL = X, AH = Y
    ; Output: AL = 1 if reachable, 0 if not
    ; Uses a simple check: position must be within 10 tiles of a road corridor
    push ebx
    push ecx
    
    mov bl, al  ; X
    mov bh, ah  ; Y
    
    ; Check if on or near a guaranteed road corridor (every 5th row/col)
    ; Check X coordinate
    xor ah, ah
    mov al, bl
    mov cl, 5
    div cl
    cmp ah, 0
    je NearCorridor
    cmp ah, 1
    je NearCorridor
    cmp ah, 4
    je NearCorridor
    
    ; Check Y coordinate
    mov al, bh
    xor ah, ah
    mov cl, 5
    div cl
    cmp ah, 0
    je NearCorridor
    cmp ah, 1
    je NearCorridor
    cmp ah, 4
    je NearCorridor
    
    ; Not near a corridor, might be isolated
    mov al, 0
    jmp ReachDone
    
NearCorridor:
    ; Near a corridor, should be reachable
    mov al, 1
    
ReachDone:
    pop ecx
    pop ebx
    ret
IsReachable ENDP






;=============================================================================
; GAME LOOP - FIXED VERSION
;=============================================================================
GameLoop PROC
    push eax
    push ebx
    push ecx
    push edx
    
    ; Reset frame counter at start
    mov framecount, 0
    
MainGameLoop:
    ; *** Update timer BEFORE drawing ***
    mov al, timerActive
    cmp al, 0
    je SkipTimerUpdate
    
    ; Decrement timer every 20 frames (1 second at ~20 FPS)
    mov eax, framecount
    and eax, 19  ; Check if framecount % 20 == 0
    cmp eax, 0
    jne SkipTimerUpdate
    
    ; Decrement timer
    mov eax, timerSeconds
    cmp eax, 0
    jle TimeExpired
    dec timerSeconds
    
SkipTimerUpdate:
    ; Draw the screen (once per main loop)
    ;call Clrscr
    call DrawGame
    call DrawHUD
    
GameInputLoop:
    ; Small delay for smoother gameplay
    mov eax, 50
    call Delay
    
    ; Increment frame counter
    inc framecount
    
    ; Update cars based on npc_speed
    mov eax, framecount
    xor edx, edx
    mov ebx, npc_speed
    div ebx
    cmp edx, 0
    jne SkipCarUpdate
    call UpdateCars
    
SkipCarUpdate:
    ; Check for key press (NON-BLOCKING)
    mov eax, 1  ; 1ms timeout
    call Delay
    
    call ReadKey
    jz CheckRedraw  ; No key pressed, check if we need to redraw
    
    mov inputchar, al
    
    ; Check for exit
    cmp inputchar, 'x'
    je ExitGame
    cmp inputchar, 'X'
    je ExitGame
    
    ; Check for movement keys
    cmp inputchar, 'w'
    je MoveUp
    cmp inputchar, 'W'
    je MoveUp
    
    cmp inputchar, 's'
    je MoveDown
    cmp inputchar, 'S'
    je MoveDown
    
    cmp inputchar, 'a'
    je MoveLeft
    cmp inputchar, 'A'
    je MoveLeft
    
    cmp inputchar, 'd'
    je MoveRight
    cmp inputchar, 'D'
    je MoveRight
    
    cmp inputchar, ' '
    je HandleSpace
    
    cmp inputchar, 'p'
    je PauseGame
    cmp inputchar, 'P'
    je PauseGame

    cmp inputchar, 'l'
    je SaveGameNow
    cmp inputchar, 'L'
    je SaveGameNow
    
CheckRedraw:
    ; Check if we need to redraw (every 3-5 frames or on car update)
    mov eax, framecount
    and eax, 3  ; Redraw every 4 frames
    cmp eax, 0
    je MainGameLoop  ; Redraw
    
    ; Otherwise continue input loop
    jmp GameInputLoop

TimeExpired:
    ; Time's up!
    call Clrscr
    mov eax, red + (black * 16)
    call SetTextColor
    mov edx, OFFSET timeUp
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET final_score
    call WriteString
    mov eax, playerscore
    call WriteInt
    call Crlf
    call WaitMsg
    jmp ExitGame

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
    call DrawPauseOverlay
    
PauseWait:
    call ReadChar
    
    cmp al, 'p'
    je ResumeGame
    cmp al, 'P'
    je ResumeGame
    
    cmp al, 'x'
    je ExitGame
    cmp al, 'X'
    je ExitGame
    
    jmp PauseWait
    
ResumeGame:
    jmp MainGameLoop

SaveGameNow:
    call SaveGame
    jmp MainGameLoop
    
CheckGameOver:
    ; Only check fuel for Career and Time modes
    mov al, currentMode
    cmp al, 2  ; Endless mode
    je SkipFuelCheck
    
    ; Check fuel for Career and Time modes
    mov eax, fuel_amt
    cmp eax, 0
    jle GameOverFuel
    
SkipFuelCheck:
    ; Check score
    mov eax, playerscore
    cmp eax, 0
    jl GameOverNegative
    
    ; Continue game - redraw immediately after move
    jmp MainGameLoop
    
GameOverFuel:
    call Clrscr
    mov eax, red + (black * 16)
    call SetTextColor
    mov edx, offset gameover1
    call WriteString
    call Crlf
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset gameover2
    call WriteString
    call Crlf
    jmp ShowFinal
    
GameOverNegative:
    call Clrscr
    mov eax, red + (black * 16)
    call SetTextColor
    mov edx, offset gameover1
    call WriteString
    call Crlf
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, offset gameover3
    call WriteString
    call Crlf
    
ShowFinal:
    mov edx, offset final_score
    call WriteString
    mov eax, playerscore
    call WriteInt
    call Crlf
    call Crlf
    mov edx, offset end_game
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

;=============================================================================
; TRY MOVE UP - FIXED (NO FUEL IN ENDLESS MODE)
;=============================================================================
TryMoveUp PROC
    push eax
    push ebx
    
    inc move_speed_counter
    
    mov al, taxicolor
    cmp al, 0
    je AllowMoveUp
    
    mov eax, move_speed_counter
    and eax, 1
    cmp eax, 1
    je MoveFailUp
    
AllowMoveUp:
    mov al, playerY
    cmp al, 0
    je MoveFailUp
    
    dec al
    mov bh, al
    mov bl, playerX
    call IsRoad
    cmp al, 0
    je MoveFailUp
    
    ; Move is valid
    dec playerY
    
    ; *** FIX #3: Only consume fuel if NOT endless mode ***
    push eax
    mov al, currentMode
    cmp al, 2  ; Endless mode = 2
    je SkipFuelUp
    dec fuel_amt
SkipFuelUp:
    pop eax
    
    call CheckCollisions
    
MoveFailUp:
    pop ebx
    pop eax
    ret
TryMoveUp ENDP

;=============================================================================
; TRY MOVE DOWN - FIXED (NO FUEL IN ENDLESS MODE)
;=============================================================================
TryMoveDown PROC
    push eax
    push ebx
    
    inc move_speed_counter
    
    mov al, taxicolor
    cmp al, 0
    je AllowMoveDown
    
    mov eax, move_speed_counter
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
    
    ; *** FIX #3: Only consume fuel if NOT endless mode ***
    push eax
    mov al, currentMode
    cmp al, 2
    je SkipFuelDown
    dec fuel_amt
SkipFuelDown:
    pop eax
    
    call CheckCollisions
    
MoveFailDown:
    pop ebx
    pop eax
    ret
TryMoveDown ENDP

;=============================================================================
; TRY MOVE LEFT - FIXED (NO FUEL IN ENDLESS MODE)
;=============================================================================
TryMoveLeft PROC
    push eax
    push ebx
    
    inc move_speed_counter
    
    mov al, taxicolor
    cmp al, 0
    je AllowMoveLeft
    
    mov eax, move_speed_counter
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
    
    ; *** FIX #3: Only consume fuel if NOT endless mode ***
    push eax
    mov al, currentMode
    cmp al, 2
    je SkipFuelLeft
    dec fuel_amt
SkipFuelLeft:
    pop eax
    
    call CheckCollisions
    
MoveFailLeft:
    pop ebx
    pop eax
    ret
TryMoveLeft ENDP

;=============================================================================
; TRY MOVE RIGHT - FIXED (NO FUEL IN ENDLESS MODE)
;=============================================================================
TryMoveRight PROC
    push eax
    push ebx
    
    inc move_speed_counter
    
    mov al, taxicolor
    cmp al, 0
    je AllowMoveRight
    
    mov eax, move_speed_counter
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
    
    ; *** FIX #3: Only consume fuel if NOT endless mode ***
    push eax
    mov al, currentMode
    cmp al, 2
    je SkipFuelRight
    dec fuel_amt
SkipFuelRight:
    pop eax
    
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

mov esi, offset board
add esi, eax
mov al, [esi]

pop esi
pop ecx
pop ebx
ret
IsRoad ENDP



; ============================================================================
; CHECK COLLISIONS 
; ============================================================================
CheckCollisions PROC
    push eax
    push ebx
    push ecx
    push esi
    
    ; Check obstacles
    mov ecx, obstaclecount
    xor esi, esi
    
CheckObstLoop:
    cmp esi, ecx
    jge CheckCars
    
    push ecx
    
    mov edi, offset obstX
    add edi, esi
    mov al, [edi]
    cmp al, playerX
    jne NextObst
    
    mov edi, offset obstY
    add edi, esi
    mov al, [edi]
    cmp al, playerY
    jne NextObst
    
    ; Collision with obstacle!
    mov al, taxicolor
    cmp al, 0
    je YellowObst
    
    ; Red taxi: -2 points
    sub playerscore, 2
    jmp NextObst
    
YellowObst:
    ; Yellow taxi: -4 points
    sub playerscore, 4
    
NextObst:
    inc esi
    pop ecx
    jmp CheckObstLoop
    
CheckCars:
    ; Check car collisions
    mov ecx, npc_count
    xor esi, esi
    
CheckCarLoop:
    cmp esi, ecx
    jge CheckBonus
    
    push ecx
    
    mov edi, offset npc_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    je NextCar
    
    mov edi, offset carX
    add edi, esi
    mov al, [edi]
    cmp al, playerX
    jne NextCar
    
    mov edi, offset carY
    add edi, esi
    mov al, [edi]
    cmp al, playerY
    jne NextCar
    
    ; Collision with car!
    mov al, taxicolor
    cmp al, 0
    je YellowCar
    
    ; Red taxi: -3 points
    sub playerscore, 3
    jmp NextCar
    
YellowCar:
    ; Yellow taxi: -2 points
    sub playerscore, 2
    
NextCar:
    inc esi
    pop ecx
    jmp CheckCarLoop
    
CheckBonus:
    ; Check bonus item collection (NO PENALTY - JUST COLLECT)
    mov ecx, bonuscount
    xor esi, esi
    
CheckBonusLoop:
    cmp esi, ecx
    jge CollisionDone
    
    push ecx
    
    mov edi, offset bonusonboard
    add edi, esi
    cmp BYTE PTR [edi], 0
    je NextBonus
    
    mov edi, offset bonusX
    add edi, esi
    mov al, [edi]
    cmp al, playerX
    jne NextBonus
    
    mov edi, offset bonusY
    add edi, esi
    mov al, [edi]
    cmp al, playerY
    jne NextBonus
    
    ; Collected bonus! +10 points
    add playerscore, 10
    
    ; Deactivate this bonus
    mov edi, offset bonusonboard
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
    
    mov eax, carrying
    cmp eax, -1
    jne TryDrop
    
    ; Try pickup - check if passenger is adjacent (within 1 tile)
    mov ecx, passengercount
    xor esi, esi


PickupLoop:
    cmp esi, MAX_PASSENGERS
    jge PickupDone
    
    push ecx
    
    ; Check if passenger is active and not picked
    mov edi, offset pass_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    je NextPickup
    
    mov edi, offset pass_picked
    add edi, esi
    cmp BYTE PTR [edi], 1
    je NextPickup
    
    ; Get passenger position
    mov edi, offset passX
    add edi, esi
    mov bl, [edi]
    
    mov edi, offset passY
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
    mov carrying, eax
    
    mov edi, offset pass_picked
    add edi, esi
    mov BYTE PTR [edi], 1

;    call SoundPickup
    
    pop ecx
    jmp PickupDone
    
NextPickup:
    inc esi
    pop ecx
    jmp PickupLoop


    
TryDrop:
    ; Try drop - must be at exact destination
    mov esi, eax
    
    mov edi, offset passdestX
    add edi, esi
    mov al, [edi]
    cmp al, playerX
    jne PickupDone
    
    mov edi, offset passdestY
    add edi, esi
    mov al, [edi]
    cmp al, playerY
    jne PickupDone
    
    ; Successfully dropped passenger!
    mov edi, offset pass_active
    add edi, esi
    mov BYTE PTR [edi], 0
    
    mov carrying, -1
    
  ; *** Update endless session high score ***
    mov al, currentMode
    cmp al, 2
    jne NotEndlessSession
    
    mov eax, playerscore
    cmp eax, endless_session_high
    jle NotEndlessSession
    mov endless_session_high, eax
    
NotEndlessSession:
    
    ; Maintain passengers (keep 3-5 active)
    call MaintainPassengers


    mov al, currentMode
    cmp al, 2
    jne NoEndlessScale
    call EndlessDifficultyIncrease
    
NoEndlessScale:
    ; Every 2 jobs: increase speed
    mov eax, total_dropsoffs
    
    ; Every 2 jobs: increase speed
    mov eax, total_dropsoffs
    mov ebx, 2
    xor edx, edx
    div ebx
    cmp edx, 0
    jne NoSpeedIncrease
    
    ; Decrease npc_speed (faster cars)
    mov eax, npc_speed
    cmp eax, 1
    jle NoSpeedIncrease
    dec npc_speed
    
    ; Also try to spawn new car
    mov eax, npc_count
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
    mov esi, offset board
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
    mov ecx, obstaclecount
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
    
    mov edi, OFFSET obsttype
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
    ; Brown box - small box design
    mov eax, yellow + (brown * 16)
    call SetTextColor
    mov al, '['
    call WriteChar
    mov al, 'B'
    call WriteChar
    mov al, ']'
    call WriteChar
    
NextObst:
    inc esi
    pop ecx
    jmp DrawObst
    
DrawCars:
    ; Draw NPC cars
    mov ecx, npc_count
    xor esi, esi
    
DrawCarLoop:
    cmp esi, ecx
    jge DrawBonus
    
    push ecx
    
    mov edi, OFFSET npc_active
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
    mov ecx, bonuscount
    xor esi, esi
    
DrawBonusLoop:
    cmp esi, ecx
    jge DrawPass
    
    push ecx
    
    mov edi, OFFSET bonusonboard
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
    
    ; Random bonus types - use esi as seed
    push eax
    mov eax, esi
    mov ebx, 4
    xor edx, edx
    div ebx
    pop eax
    
    cmp edx, 0
    je DrawDollar
    cmp edx, 1
    je DrawStar
    cmp edx, 2
    je DrawGem
    
DrawCoin:
    ; Gold coin
    mov eax, yellow + (white * 16)
    call SetTextColor
    mov al, '('
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, ')'
    call WriteChar
    jmp SkipBonus
    
DrawDollar:
    ; Dollar sign
    mov eax, lightGreen + (white * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, '$'
    call WriteChar
    mov al, ' '
    call WriteChar
    jmp SkipBonus
    
DrawStar:
    ; Star
    mov eax, yellow + (white * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, '*'
    call WriteChar
    mov al, ' '
    call WriteChar
    jmp SkipBonus
    
DrawGem:
    ; Diamond/Gem
    mov eax, lightCyan + (white * 16)
    call SetTextColor
    mov al, '<'
    call WriteChar
    mov al, '>'
    call WriteChar
    mov al, ' '
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
    
    mov edi, OFFSET pass_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    je SkipPass
    
    mov edi, OFFSET pass_picked
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
    ; Person waving
    mov eax, BLACK + (white * 16)
    call SetTextColor
    mov al, '\'
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, '/'
    call WriteChar
    
SkipPass:
    inc esi
    pop ecx
    jmp DrawPassLoop


    
DrawDest:
    ; Draw destination (GREEN BACKGROUND)
    mov eax, carrying
    cmp eax, -1
    je DrawPlayer
    
    mov esi, eax
    
    mov edi, OFFSET passdestX
    add edi, esi
    xor eax, eax
    mov al, [edi]
    mov dl, 4
    mul dl
    add al, 2
    mov dl, al
    
    mov edi, OFFSET passdestY
    add edi, esi
    mov dh, [edi]
    add dh, 2
    
    call Gotoxy
    
    ; Green destination with green background
    mov eax, white + (green * 16)
    call SetTextColor
    mov al, '*'
    call WriteChar
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
    
    mov al, taxicolor
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


 DrawHUD PROC
    push eax
    push ebx
    push ecx
    push edx
    
    mov dh, 0
    mov dl, 0
    call Gotoxy
    
    ; Display Score
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET score_display
    call WriteString
    mov eax, playerscore
    call WriteInt
    
    ; *** ONLY show fuel if NOT Endless mode ***
    mov al, currentMode
    cmp al, 2  ; Endless mode = 2
    je SkipFuelDisplay
    
    ; Display fuel for Career and Time modes
    mov edx, offset fuel_display
    call WriteString
    mov eax, fuel_amt
    call WriteDec
    jmp ContinueHUD
    
SkipFuelDisplay:
    ; Add spacing to align properly
    mov al, ' '
    mov ecx, 15
SpacingLoop:
    call WriteChar
    loop SpacingLoop
    
ContinueHUD:
    
    mov edx, offset pass_display
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
    
    mov edi, offset pass_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    je SkipCount
    
    mov edi, offset pass_picked
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
    
    mov edx, offset donedropped_display
    call WriteString
    mov eax, total_dropsoffs
    call WriteDec
    

    mov edx, offset donedropped_display
    call WriteString
    mov eax, total_dropsoffs
    call WriteDec
    
    ; *** NEW: Show current game mode ***
    mov edx, OFFSET mode_display
    call WriteString
    
    mov al, currentMode
    cmp al, 0
    je ShowCareerHUD
    cmp al, 1
    je ShowTimeHUD
    
    ; Endless Mode
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov edx, OFFSET mode_endless_txt
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    jmp AfterModeHUD
    
ShowCareerHUD:
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov edx, OFFSET mode_career_txt
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    jmp AfterModeHUD
    
ShowTimeHUD:
    mov eax, cyan + (black * 16)
    call SetTextColor
    mov edx, OFFSET mode_time_txt
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    
AfterModeHUD:
    ; *** Show session high if Endless mode ***
    mov al, currentMode
    cmp al, 2
    jne NotEndlessHUD
    
    mov edx, OFFSET endless_high_msg
    call WriteString
    mov eax, endless_session_high
    call WriteDec
    
NotEndlessHUD:
    ; Show timer if Time Mode
    mov al, currentMode
    cmp al, 1
    jne SkipTimer
    
    ; Display timer
    mov edx, OFFSET timeRemaining
    call WriteString
    mov eax, timerSeconds
    call WriteDec
    mov al, 's'
    call WriteChar
    
SkipTimer:
    ; Continue with rest of HUD
    mov dh, 1
    mov dl, 0
    call Gotoxy


    ; Line 1
    mov dh, 1
    mov dl, 0
    call Gotoxy
    
    mov eax, carrying
    cmp eax, -1
    je ShowLegend
    
    mov edx, offset carrying_display
    call WriteString
    jmp HUDDone
    
ShowLegend:
    mov edx, OFFSET items_on_board
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
    
    mov ecx, npc_count
    xor esi, esi
    
UpdateLoop:
    cmp esi, ecx
    jge UpdateDone
    
    push ecx
    
    mov edi, OFFSET npc_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    je SkipUpdate
    
    ; Get X
    mov edi, OFFSET carX
    add edi, esi
    mov bl, [edi]
    
    mov edi, OFFSET npc_dirX
    add edi, esi
    mov al, [edi]
    add bl, al
    
    cmp bl, 0
    jl Reverse
    cmp bl, 19
    jg Reverse
    
    ; Check road
    push esi
    mov edi, offset carY
    add edi, esi
    mov bh, [edi]
    call IsRoad
    pop esi
    cmp al, 0
    je Reverse
    
    ; Update X
    mov edi, offset carX
    add edi, esi
    mov [edi], bl
    
    ; Get Y
    mov edi, offset carY
    add edi, esi
    mov bl, [edi]
    
    mov edi, OFFSET npc_dirY
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
    mov edi, OFFSET npc_dirX
    add edi, esi
    mov al, [edi]
    neg al
    mov [edi], al
    
    mov edi, OFFSET npc_dirY
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
    
    mov edi, offset pass_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    je SkipActive
    
    mov edi, offset pass_picked
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
    mov edi, offset pass_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    pop esi
    je FoundSlot
    
    inc esi
    jmp FindSlot
    
FoundSlot:
    ; Spawn new passenger at this slot
    push eax
    call road_position_find 
    mov edi, OFFSET passX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET passY
    add edi, esi
    mov [edi], ah
    
    call road_position_find 
    mov edi, OFFSET passdestX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET passdestY
    add edi, esi
    mov [edi], ah
    
    mov edi, OFFSET pass_picked
    add edi, esi
    mov BYTE PTR [edi], 0
    
    mov edi, OFFSET pass_active
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
    mov edi, OFFSET pass_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    pop esi
    je FoundSlot2
    
    inc esi
    jmp FindSlot2
    
FoundSlot2:
    ; Spawn new passenger
    push eax
    call road_position_find 
    mov edi, OFFSET passX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET passY
    add edi, esi
    mov [edi], ah
    
    call road_position_find 
    mov edi, OFFSET passdestX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET passdestY
    add edi, esi
    mov [edi], ah
    
    mov edi, OFFSET pass_picked
    add edi, esi
    mov BYTE PTR [edi], 0
    
    mov edi, OFFSET pass_active
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
; SPAWN NEW CAR
; ============================================================================
SpawnNewCar PROC
    push eax
    push esi
    
    mov esi, npc_count
    cmp esi, MAX_CARS
    jge NoSpawn2
    
    call road_position_find 
    
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
    mov edi, OFFSET npc_dirX
    add edi, esi
    mov BYTE PTR [edi], 1
    mov edi, OFFSET npc_dirY
    add edi, esi
    mov BYTE PTR [edi], 0
    jmp NewDone
    
NewUp:
    mov edi, OFFSET npc_dirX
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, OFFSET npc_dirY
    add edi, esi
    mov BYTE PTR [edi], -1
    jmp NewDone
    
NewDown:
    mov edi, OFFSET npc_dirX
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, OFFSET npc_dirY
    add edi, esi
    mov BYTE PTR [edi], 1
    jmp NewDone
    
NewLeft:
    mov edi, OFFSET npc_dirX
    add edi, esi
    mov BYTE PTR [edi], -1
    mov edi, OFFSET npc_dirY
    add edi, esi
    mov BYTE PTR [edi], 0
    
NewDone:
    mov edi, OFFSET npc_active
    add edi, esi
    mov BYTE PTR [edi], 1
    
    inc npc_count
    
NoSpawn2:
    pop esi
    pop eax
    ret
SpawnNewCar ENDP


;============================================================================
; SELECT GAME MODE
;============================================================================
SelectGameMode PROC
    push eax
    push edx
    
    call Clrscr
    
    mov dh, 8
    mov dl, 30
    call Gotoxy
    mov eax, cyan + (black * 16)
    call SetTextColor
    
    mov edx, OFFSET modeTitle
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, white + (black * 16)
    call SetTextColor
    
    mov dh, 11
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET mode1
    call WriteString
    call Crlf
    
    mov dh, 13
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET mode2
    call WriteString
    call Crlf
    
    mov dh, 15
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET mode3
    call WriteString
    call Crlf
    call Crlf
    
    mov dh, 18
    mov dl, 30
    call Gotoxy
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov edx, OFFSET mode4
    call WriteString
    
GetModeInput:
    call ReadChar
    
    cmp al, '1'
    je SetCareer
    cmp al, '2'
    je SetTime
    cmp al, '3'
    je SetEndless
    
    jmp GetModeInput
    
SetCareer:
    mov currentMode, 0
    mov timerActive, 0
    jmp ModeDone
    
SetTime:
    mov currentMode, 1
    mov timerSeconds, 120  ; *** 120 seconds as per spec ***
    mov timerActive, 1
    jmp ModeDone
    
SetEndless:
    mov currentMode, 2
    mov timerActive, 0
    ; *** Set high fuel for endless (won't be consumed anyway) ***
    mov fuel_amt, 9999
    
ModeDone:
    mov dh, 20
    mov dl, 35
    call Gotoxy
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    
    mov al, currentMode
    cmp al, 0
    je ShowCareer
    cmp al, 1
    je ShowTime
    
    mov al, 'E'
    call WriteChar
    mov al, 'n'
    call WriteChar
    mov al, 'd'
    call WriteChar
    mov al, 'l'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, 's'
    call WriteChar
    mov al, 's'
    call WriteChar
    jmp WaitMode
    
ShowCareer:
    mov al, 'C'
    call WriteChar
    mov al, 'a'
    call WriteChar
    mov al, 'r'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, 'r'
    call WriteChar
    jmp WaitMode
    
ShowTime:
    mov al, 'T'
    call WriteChar
    mov al, 'i'
    call WriteChar
    mov al, 'm'
    call WriteChar
    mov al, 'e'
    call WriteChar
    
WaitMode:
    mov eax, 800
    call Delay
    call clrscr
    
    pop edx
    pop eax
    ret

SelectGameMode ENDP

;============================================================================
; ENDLESS MODE DIFFICULTY INCREASE
;============================================================================
EndlessDifficultyIncrease PROC
    push eax
    push ebx
    push esi
    
    ; Every 3 deliveries, increase difficulty
    mov eax, total_dropsoffs
    mov ebx, 3
    xor edx, edx
    div ebx
    cmp edx, 0
    jne NoEndlessIncrease
    
    ; Increase car speed
    mov eax, npc_speed
    cmp eax, 1
    jle CheckObstacles
    dec npc_speed
    
CheckObstacles:
    ; Add more obstacles (up to max)
    mov eax, obstaclecount
    cmp eax, MAX_OBSTACLES
    jge TryAddCar
    inc obstaclecount
    
    ; Spawn the new obstacle
    push esi
    mov esi, obstaclecount
    dec esi
    
    call road_position_find
    mov edi, OFFSET obstX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET obstY
    add edi, esi
    mov [edi], ah
    
    mov eax, 2
    call RandomRange
    mov edi, OFFSET obsttype
    add edi, esi
    mov [edi], al
    
    pop esi

TryAddCar:
    ; Try to add more cars
    mov eax, npc_count
    cmp eax, MAX_CARS
    jge NoEndlessIncrease
    call SpawnNewCar
    
NoEndlessIncrease:
    pop esi
    pop ebx
    pop eax
    ret
EndlessDifficultyIncrease ENDP

;============================================================================
; DRAW PAUSE OVERLAY
;============================================================================
DrawPauseOverlay PROC
    push eax
    push ecx
    push edx
    
    ; Draw semi-transparent grey overlay (simulate with grey text)
    mov dh, 8
    mov dl, 0
    mov ecx, 10  ; 10 rows of grey
    
DrawGreyRows:
    push ecx
    push edx
    
    call Gotoxy
    mov eax, lightGray + (lightGray * 16)
    call SetTextColor
    
    mov ecx, 80
DrawGreyCols:
    mov al, ' '
    call WriteChar
    loop DrawGreyCols
    
    pop edx
    pop ecx
    inc dh
    loop DrawGreyRows
    
    ; Draw pause box
    mov dh, 10
    mov dl, 28
    call Gotoxy
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    mov al, '='
    mov ecx, 24
DrawTopBorder:
    call WriteChar
    loop DrawTopBorder
    
    ; Title
    mov dh, 11
    mov dl, 28
    call Gotoxy
    mov eax, white + (red * 16)
    call SetTextColor
    mov edx, OFFSET pauseTitle
    call WriteString
    
    ; Bottom border
    mov dh, 12
    mov dl, 28
    call Gotoxy
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    mov al, '='
    mov ecx, 24
DrawBottomBorder:
    call WriteChar
    loop DrawBottomBorder
    
    ; Instructions
    mov dh, 14
    mov dl, 30
    call Gotoxy
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov edx, OFFSET pauseMsg1
    call WriteString
    
    mov dh, 15
    mov dl, 28
    call Gotoxy
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov edx, OFFSET pauseMsg2
    call WriteString
    
    pop edx
    pop ecx
    pop eax
    ret
DrawPauseOverlay ENDP


; ============================================================================
; SAVE GAME
; ============================================================================
SaveGame PROC
    push eax
    push ecx
    push edx
    
    ; Create save file
    mov edx, OFFSET savegamefilenametxt
    call CreateOutputFile
    jc SaveFailed
    mov filehandle, eax
    
    ; Write player position (2 bytes)
    mov edx, OFFSET playerX
    mov ecx, 2
    call WriteToFile
    
    ; Write player score (4 bytes)
    mov edx, OFFSET playerscore
    mov ecx, 4
    call WriteToFile
    
    ; Write player fuel (4 bytes)
    mov edx, OFFSET fuel_amt
    mov ecx, 4
    call WriteToFile
    
    ; Write taxi color (1 byte)
    mov edx, OFFSET taxicolor
    mov ecx, 1
    call WriteToFile
    
    ; Write target passenger (4 bytes)
    mov edx, OFFSET carrying
    mov ecx, 4
    call WriteToFile
    
    ; Write jobs done (4 bytes)
    mov edx, OFFSET total_dropsoffs
    mov ecx, 4
    call WriteToFile
    
    ; Write passenger count (4 bytes)
    mov edx, OFFSET passengercount
    mov ecx, 4
    call WriteToFile
    
    ; Write car speed (4 bytes)
    mov edx, OFFSET npc_speed
    mov ecx, 4
    call WriteToFile
    
    ; Write difficulty (1 byte)
    mov edx, OFFSET difficulty
    mov ecx, 1
    call WriteToFile
    
    ; Write player name (30 bytes)
    mov edx, OFFSET play_name
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
    mov edx, OFFSET passdestX
    mov ecx, 5
    call WriteToFile
    mov edx, OFFSET passdestY
    mov ecx, 5
    call WriteToFile
    mov edx, OFFSET pass_picked
    mov ecx, 5
    call WriteToFile
    mov edx, OFFSET pass_active
    mov ecx, 5
    call WriteToFile
    
    ; Write obstacle data
    mov eax, filehandle
    mov edx, OFFSET obstaclecount
    mov ecx, 4
    call WriteToFile
    
    mov eax, filehandle
    mov edx, OFFSET obstX
    mov ecx, 10
    call WriteToFile
    
    mov eax, filehandle
    mov edx, OFFSET obstY
    mov ecx, 10
    call WriteToFile
    
    mov eax, filehandle
    mov edx, OFFSET obsttype
    mov ecx, 10
    call WriteToFile
    
    ; Write car data
    mov eax, filehandle
    mov edx, OFFSET npc_count
    mov ecx, 4
    call WriteToFile
    
    mov eax, filehandle
    mov edx, OFFSET carX
    mov ecx, 8
    call WriteToFile
    
    mov eax, filehandle
    mov edx, OFFSET carY
    mov ecx, 8
    call WriteToFile
    
    mov eax, filehandle
    mov edx, OFFSET npc_dirX
    mov ecx, 8
    call WriteToFile
    
    mov eax, filehandle
    mov edx, OFFSET npc_dirY
    mov ecx, 8
    call WriteToFile
    
    mov eax, filehandle
    mov edx, OFFSET npc_active
    mov ecx, 8
    call WriteToFile
    
    ; Write bonus data
    mov eax, filehandle
    mov edx, OFFSET bonuscount
    mov ecx, 4
    call WriteToFile
    
    mov eax, filehandle
    mov edx, OFFSET bonusX
    mov ecx, 5
    call WriteToFile
    
    mov eax, filehandle
    mov edx, OFFSET bonusY
    mov ecx, 5
    call WriteToFile
    
    mov eax, filehandle
    mov edx, OFFSET bonusonboard
    mov ecx, 5
    call WriteToFile
    
    ; Close file
    mov eax, filehandle
    call CloseFile
    
    call Clrscr
    mov edx, OFFSET gamesaveprompt
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
    mov edx, OFFSET savegamefilenametxt
    call OpenInputFile
    jc LoadFailed
    mov filehandle, eax
    
    ; Read player position
    mov edx, OFFSET playerX
    mov ecx, 2
    call ReadFromFile
    
    ; Read player score
    mov edx, OFFSET playerscore
    mov ecx, 4
    call ReadFromFile
    
    ; Read player fuel
    mov edx, OFFSET fuel_amt
    mov ecx, 4
    call ReadFromFile
    
    ; Read taxi color
    mov edx, OFFSET taxicolor
    mov ecx, 1
    call ReadFromFile
    
    ; Read target passenger
    mov edx, OFFSET carrying
    mov ecx, 4
    call ReadFromFile
    
    ; Read jobs done
    mov edx, OFFSET total_dropsoffs
    mov ecx, 4
    call ReadFromFile
    
    ; Read passenger count
    mov edx, OFFSET passengercount
    mov ecx, 4
    call ReadFromFile
    
    ; Read car speed
    mov edx, OFFSET npc_speed
    mov ecx, 4
    call ReadFromFile
    
    ; Read difficulty
    mov edx, OFFSET difficulty
    mov ecx, 1
    call ReadFromFile
    
    ; Read player name
    mov edx, OFFSET play_name
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
    mov edx, OFFSET passdestX
    mov ecx, 5
    call ReadFromFile
    mov edx, OFFSET passdestY
    mov ecx, 5
    call ReadFromFile
    mov edx, OFFSET pass_picked
    mov ecx, 5
    call ReadFromFile
    mov edx, OFFSET pass_active
    mov ecx, 5
    call ReadFromFile
    
   ; Read obstacle data
    mov eax, filehandle
    mov edx, OFFSET obstaclecount
    mov ecx, 4
    call ReadFromFile
    
    mov eax, filehandle
    mov edx, OFFSET obstX
    mov ecx, 10
    call ReadFromFile
    
    mov eax, filehandle
    mov edx, OFFSET obstY
    mov ecx, 10
    call ReadFromFile
    
    mov eax, filehandle
    mov edx, OFFSET obsttype
    mov ecx, 10
    call ReadFromFile
    
    ; Read car data
    mov eax, filehandle
    mov edx, OFFSET npc_count
    mov ecx, 4
    call ReadFromFile
    
    mov eax, filehandle
    mov edx, OFFSET carX
    mov ecx, 8
    call ReadFromFile
    
    mov eax, filehandle
    mov edx, OFFSET carY
    mov ecx, 8
    call ReadFromFile
    
    mov eax, filehandle
    mov edx, OFFSET npc_dirX
    mov ecx, 8
    call ReadFromFile
    
    mov eax, filehandle
    mov edx, OFFSET npc_dirY
    mov ecx, 8
    call ReadFromFile
    
    mov eax, filehandle
    mov edx, OFFSET npc_active
    mov ecx, 8
    call ReadFromFile
    
    ; Read bonus data
    mov eax, filehandle
    mov edx, OFFSET bonuscount
    mov ecx, 4
    call ReadFromFile
    
    mov eax, filehandle
    mov edx, OFFSET bonusX
    mov ecx, 5
    call ReadFromFile
    
    mov eax, filehandle
    mov edx, OFFSET bonusY
    mov ecx, 5
    call ReadFromFile
    
    mov eax, filehandle
    mov edx, OFFSET bonusonboard
    mov ecx, 5
    call ReadFromFile
    ; Reset frame counter and move counter
    mov framecount, 0
    mov move_speed_counter, 0
    
    call clrscr
    mov edx, OFFSET gameloadprompt
    call WriteString
    call Crlf
    call WaitMsg
    
    clc  ; Clear carry flag (success)
    jmp LoadDone
    
LoadFailed:
     call clrscr
    mov edx, OFFSET gameloadprompt1
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
    mov ebx, bonuscount
    cmp ecx, ebx
    jge CheckBonusSpawn
    
    push ecx
    mov esi, ecx
    
    mov edi, OFFSET bonusonboard
    add edi, esi
    cmp BYTE PTR [edi], 0
    je Skipbonuscount
    
    inc eax
    
Skipbonuscount:
    pop ecx
    inc ecx
    jmp CountBonus
    
CheckBonusSpawn:
    ; If less than 3 active, spawn new
    cmp eax, 3
    jge NoBonusSpawn
    
    mov eax, bonuscount
    cmp eax, MAX_BONUS
    jge NoBonusSpawn
    
    ; Spawn new bonus item
    mov esi, eax
    
    call road_position_find 
    mov edi, OFFSET bonusX
    add edi, esi
    mov [edi], al
    
    mov edi, OFFSET bonusY
    add edi, esi
    mov [edi], ah
    
    mov edi, OFFSET bonusonboard
    add edi, esi
    mov BYTE PTR [edi], 1
    
    inc bonuscount
    
NoBonusSpawn:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
MaintainBonusItems ENDP


; ============================================================================
; LOAD HIGH SCORES
; ============================================================================
LoadHighScores PROC
    push eax
    push ecx
    push edx
    push esi
    
    ; Try to open file
    mov edx, OFFSET filenametxt
    call OpenInputFile
    jc NoFile
    mov filehandle, eax
    
    ; Read 10 scores (4 bytes each = 40 bytes)
    mov edx, OFFSET highScores
    mov ecx, 40
    call ReadFromFile
    
    ; Read 10 names (30 bytes each = 300 bytes)
    mov edx, OFFSET highNames
    mov ecx, 300
    call ReadFromFile
    
    ; Close file
    mov eax, filehandle
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
    
    ; Check if score qualifies (must be > 0)
    mov eax, playerscore
    cmp eax, 0
    jle NoUpdate
    
    ; Find insertion position (check all 10 slots)
    mov ecx, 10
    mov esi, OFFSET highScores
    xor ebx, ebx  ; Position counter
    
FindPos:
    cmp ecx, 0
    je InsertAtEnd
    
    mov edx, [esi]
    
    ; If slot is empty (0) or our score is better, insert here
    cmp edx, 0
    je FoundPos
    
    cmp eax, edx
    jg FoundPos
    
    add esi, 4
    inc ebx
    dec ecx
    jmp FindPos
    
FoundPos:
    ; Check if we found a valid position (not beyond slot 9)
    cmp ebx, 10
    jge NoUpdate
    
    ; Shift scores down from position EBX
    push eax
    push ebx
    
    ; Calculate how many to shift
    mov eax, 9
    sub eax, ebx  ; Number of slots to shift
    cmp eax, 0
    jle NoShiftScores
    
    mov ecx, eax
    
    ; Start from bottom (slot 9), shift down
    mov esi, OFFSET highScores
    add esi, 36  ; Start at slot 9 (9 * 4)
    
ShiftScoresDown:
    push ecx
    mov edx, [esi - 4]
    mov [esi], edx
    sub esi, 4
    pop ecx
    loop ShiftScoresDown
    
NoShiftScores:
    pop ebx
    pop eax
    
    ; Insert new score at position EBX
    mov esi, OFFSET highScores
    push eax
    mov eax, ebx
    mov edx, 4
    mul edx
    add esi, eax
    pop eax
    mov [esi], eax
    
    ; Now shift names
    push eax
    push ebx
    
    ; Calculate how many names to shift
    mov eax, 9
    sub eax, ebx
    cmp eax, 0
    jle NoShiftNames
    
    mov ecx, eax
    
    ; Start from bottom name (slot 9)
    mov esi, OFFSET highNames
    add esi, 270  ; Start at slot 9 (9 * 30)
    
ShiftNamesLoop:
    push ecx
    push esi
    
    ; Copy 30 bytes from [esi-30] to [esi]
    mov edi, esi
    sub esi, 30
    mov ecx, 30
    
CopyNameBytes:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    loop CopyNameBytes
    
    pop esi
    sub esi, 30
    pop ecx
    loop ShiftNamesLoop
    
NoShiftNames:
    pop ebx
    pop eax
    
    ; Insert player name at position EBX
    mov esi, OFFSET highNames
    push eax
    mov eax, ebx
    mov edx, 30
    mul edx
    add esi, eax
    pop eax
    
    ; Copy player name (30 bytes)
    mov edi, esi
    mov esi, OFFSET play_name
    mov ecx, 30
    
Copyplay_name:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    loop Copyplay_name
    
    ; Save to file
    call SaveHighScores
    jmp NoUpdate
    
InsertAtEnd:
    ; Score didn't qualify
    
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
    
    ; Create file (overwrites if exists)
    mov edx, OFFSET filenametxt
    call CreateOutputFile
    jc SaveHSFailed
    mov filehandle, eax
    
    ; Write 10 scores (40 bytes)
    mov eax, filehandle
    mov edx, OFFSET highScores
    mov ecx, 40
    call WriteToFile
    jc CloseAndFail
    
    ; Write 10 names (300 bytes)
    mov eax, filehandle
    mov edx, OFFSET highNames
    mov ecx, 300
    call WriteToFile
    
CloseAndFail:
    ; Close file
    mov eax, filehandle
    call CloseFile
    jmp SaveHSDone
    
SaveHSFailed:
    ; File creation failed - could be permissions issue
    
SaveHSDone:
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



;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
    je difficulty_0
    cmp al, '2'
    je difficulty_1
    cmp al, '3'
    je difficulty_2
    
    ; Default to medium
    mov difficulty, 1
    jmp DiffDone
    



difficulty_0:
    mov difficulty, 0
    jmp DiffDone
    
difficulty_1:
    mov difficulty, 1
    jmp DiffDone
    
difficulty_2:
    mov difficulty, 2
    
DiffDone:
    pop edx
    pop eax
    ret
ChangeDifficulty ENDP



END main





