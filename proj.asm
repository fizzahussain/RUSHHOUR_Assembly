INCLUDE Irvine32.inc
includelib winmm.lib



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
        framecount      DWORD 0; ANIMATION
        inputchar       BYTE ?
        play_name      BYTE 30 DUP(? )
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
        diff1           BYTE "DIFFICULTY LEVELS :  ", 0
        diff3           BYTE "2. Medium - 500 Fuel, 7 Obstacles & Normal Cars", 0
        diff4           BYTE "3. Hard   - 300 Fuel, 10 Obstacles & Fast Cars", 0
        diff2           BYTE "1. Easy    - 1000 Fuel, 5 Obstacles &  Slow Cars", 0
        diff5           BYTE "Select (1-3) : ", 0
        ; File
        filehandle      DWORD ?
        savegamefilenametxt    BYTE "savegame.txt", 0
        filenametxt      BYTE "highscores.txt", 0
        bytes_written     DWORD ?
        ; Leaderboard
        highScores      DWORD 10 DUP(0)
        highNames       BYTE 300 DUP(? )
        tempScore       DWORD ?
        ; instructions menu
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

        ; top of screen
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

        ;sounds
        PlaySound PROTO, pszSound:PTR BYTE, hmod:DWORD, fdwSound:DWORD
        start db "start.wav", 0
        carCrash db "collision.wav",0
        pickup_sound   db "pickup.wav",0
        bonus_collect   db "bonus_collect.wav", 0
        gameover_sound   db "gameover.wav", 0
        pause_sound  db "pause.wav", 0

       SND_SYNC        equ 0h
       SND_ASYNC       equ 1h
       SND_NODEFAULT   equ 2h
       SND_MEMORY      equ 4h
       SND_LOOP        equ 8h
       SND_NOSTOP      equ 10h
       SND_NOWAIT      equ 2000h
       SND_ALIAS       equ 10000h
       SND_FILENAME    equ 20000h
            


            



;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


.code

; main: yahan se program start hota hai, menu dikhata hai,
;user se option leta hai (new game, continue, difficulty, leaderboard, instructions, exit) 
;aur phir wohi functions call karta hai. Pure game ka main control yahin hai.

main PROC
    call Randomize
    call highscores_load
    
menu_choiceLOOP: ;DISPLAY MENU AND TAKE CHOICE INPUT
    call DISPLAY
    xor eax, eax
    mov al, menuinput
    cmp al, 1
    je start_newgame
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
start_newgame:
    call Playerinfo_get
    call gamemode_selection
    mov al, currentMode
    cmp al, 2
    jne not_endlessstart
    mov endless_session_high, 0
    
not_endlessstart:
    call initialize_newgame 
    call the_gameloop_main
    mov al, currentMode
    cmp al, 2
    je SkipLeaderboardUpdate
    call update_highscores
    
SkipLeaderboardUpdate:
jmp menu_choiceLOOP
    
ContinueGame:

    call load_game_fromsaved
    jc menu_choiceLOOP
    call the_gameloop_main
    call update_highscores
    jmp menu_choiceLOOP
    
DIFFICULTY_OPT:

    call ChangeDifficulty
    jmp menu_choiceLOOP
    
ShowLeader:

    call leaderboard_display

    jmp menu_choiceLOOP
    
show_instructions:

    call ShowInstructions

    jmp menu_choiceLOOP
    


END_ALL:

    call Clrscr
    mov eax, yellow + (black * 16)
    call settextcolor

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

; DISPLAY: start wala main menu screen draw karta hai (title taxi, options 1?6)
;phir user ki choice character read karke menuinput variable me save karta hai

DISPLAY PROC
   
   push eax
    push edx
    
    call Clrscr
    
    mov eax,  magenta + (black * 16)
    call settextcolor
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
    call settextcolor
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
    call settextcolor
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
    call settextcolor
    mov edx, offset opt7
    call WriteString
    call Crlf
    ;prompt
    mov eax, white + (black * 16)
    call settextcolor
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
    call settextcolor
    
    mov edx, OFFSET inst1
    call WriteString
    call Crlf
    mov eax, white + (black * 16)
    call settextcolor
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
    call settextcolor
    mov edx, offset inst6
    call WriteString
    call Crlf
    mov eax, white + (black * 16)
    call settextcolor
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
    call settextcolor
    mov edx, offset inst12
    call WriteString
    call Crlf
    mov eax, white + (black * 16)
    call settextcolor
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
    call settextcolor
    mov edx, offset inst16
    call WriteString
    call Crlf
    mov eax, white + (black * 16)
    call settextcolor
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

    pop edx
    pop eax
    ret
ShowInstructions ENDP
;--------------------------------------------------------------------------------------------------------------------------------------------------------------
; Playerinfo_get: pehle thoda sa fancy frame / text draw karta hai, phir player ka naam read karta hai aur usko play_name me store karta hai.
;Uske baad player ko taxi color choose karwata hai (yellow, red, ya random)
;aur taxicolor variable set karta hai.

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
    call settextcolor
    mov al, '-'

    mov ecx, 30


PrintTopBorder:
  call WriteChar
  loop PrintTopBorder



    mov dh, 9
    mov dl, 30
    call Gotoxy
    mov eax, magenta + (black * 16)
    call settextcolor
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
    call settextcolor


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
    call settextcolor
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
    call settextcolor
    mov al, ' '
    mov ecx, 30


name_printBox:

    call WriteChar
    loop name_printBox
    

  
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
    call settextcolor
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
    call settextcolor
    mov al, ' '
    call WriteChar
    mov al, '1'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov eax, white + (black * 16)
    call settextcolor
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
    call settextcolor
    mov al, ' '
    call WriteChar
    mov al, '2'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov eax, white + (black * 16)
    call settextcolor
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
    call settextcolor
    mov al, ' '
    call WriteChar
    mov al, '3'
    call WriteChar
    mov al, ' '
    call WriteChar
    
    mov eax, white + (black * 16)
    call settextcolor
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
    call settextcolor
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
    call settextcolor
    mov al, '['
    call WriteChar
    mov al, 'T'
    call WriteChar
    mov al, ']'


    call WriteChar

    jmp delaystart
    

showyellow:

    mov eax, black + (yellow * 16)
    call settextcolor
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
; initialize_newgame: naya game shuru karne se pehle sari cheezen reset karta hai (player position 0,0; score, dropoffs, carrying, framecount, move_speed_counter). 
;Difficulty apply karta hai,
;board generate karta hai, passengers, obstacles, NPC cars aur bonus items random jagahon pe spawn karta hai

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
    
  

    call difficulty_apply
    call generateBoard
    
 

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

    skip_obs :
        mov eax, obstaclecount
        cmp eax, 0
        je skip_obspawn

        mov ecx, eax
        xor esi, esi

    spawn_obs :
        cmp ecx, 0
        je obst_placed
        cmp esi, 10
        jge obst_placed

        push ecx

    find_obsposition :
        call road_position_find
        cmp al, 0
        jne obst_pos_ok
        cmp ah, 0
        jne obst_pos_ok
        jmp find_obsposition

    obst_pos_ok :
        ; if position is free
            mov bl, al
            mov bh, ah
            push eax
            call is_position_occupied
            pop eax
            cmp al, 1
            je find_obsposition; alr occ find something else
            mov al, bl
            mov ah, bh
            push eax
            mov eax, 2
            call RandomRange

            mov edi, offset obsttype
            add edi, esi
            mov[edi], al; tree
            cmp al, 1
            jne store_obstacle
            pop eax
            push eax
            mov bl, al
            mov bh, ah
            inc bh
            cmp bh, 19
            jg find_obsposition;bohat close neechay
            push esi
            call is_position_occupied
            pop esi
            cmp al, 1
            je find_obsposition;overlap with trunk

    store_obstacle :
        pop eax
        mov edi, offset obstX

        add edi, esi
        mov[edi], al
        mov edi, offset obstY
        add edi, esi
        mov[edi], ah
        inc esi
        pop ecx
        dec ecx
        
        jmp spawn_obs

    
    obst_placed:
    skip_obspawn:
        ; Spawn 5 cars (continue with existing car spawn code)
        mov npc_count, 5
        mov ecx, 5
        xor esi, esi
    
    spawncar:
        cmp ecx, 0
        je car_done
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
        je dir_up
        cmp eax, 1
        je dir_down
        cmp eax, 2
        je dir_left
    


dir_right:
    mov edi, offset npc_dirX
    add edi, esi
    mov BYTE PTR [edi], 1
    mov edi, offset npc_dirY
    add edi, esi
    mov BYTE PTR [edi], 0
    jmp dir_done
    
dir_up:
    mov edi, offset npc_dirX
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, offset npc_dirY
    add edi, esi
    mov BYTE PTR [edi], -1
    jmp dir_done
    
dir_down:
    mov edi, offset npc_dirX
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, offset npc_dirY
    add edi, esi
    mov BYTE PTR [edi], 1
    jmp dir_done
    
dir_left:
    mov edi, offset npc_dirX
    add edi, esi
    mov BYTE PTR [edi], -1
    mov edi, offset npc_dirY
    add edi, esi
    mov BYTE PTR [edi], 0
    
dir_done:
    mov edi, offset npc_active
    add edi, esi
    mov BYTE PTR [edi], 1
    
    inc esi
    pop ecx
    dec ecx
    jmp spawncar
    


car_done:
    mov eax, 3 ;spawn 3-5 bonus
    call RandomRange
    add eax, 3
    mov bonuscount, eax
    mov ecx, eax
    xor esi, esi
    
spawn_bonus:
    cmp ecx, 0
    je bonus_done
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
    jmp spawn_bonus
    



bonus_done:

    pop esi
    pop ecx
    pop ebx
    pop eax

    ret



initialize_newgame  ENDP
 

;--------------------------------------------------------------------------------------------------------------------------------------------------


difficulty_apply PROC
    push eax
    
    mov al, difficulty
    cmp al, 0
    je seteasy
    cmp al, 1
    je setmedium
    


sethard:
    mov fuel_amt, 300
    mov obstaclecount, 10
    mov npc_speed, 2
    jmp difficultydone
    

setmedium:
    mov fuel_amt, 500
    mov obstaclecount, 7
    mov npc_speed, 3
    jmp difficultydone
    
seteasy:
    mov fuel_amt, 1000
    mov obstaclecount, 5
    mov npc_speed, 5
    


difficultydone:
    pop eax
    ret



difficulty_apply ENDP

;----------------------------------------------------------------------------------------------------------------------------------------------------

generateBoard PROC

    push eax
    push ebx
    push ecx
    push edx
    push esi
   
    mov esi, offset board ;initializ all as roads --- as 1
    mov ecx, 400
   
   
initialize_allroads:
    mov BYTE PTR [esi], 1
    inc esi
    loop initialize_allroads    
    mov ecx, 140;random 140 buildings
    
board_make:
    mov eax, 20 ; generate random 0 to 19 row
    call RandomRange
    mov ebx, eax
    mov eax, 20 ; col
    call RandomRange
    

    ;index= row * 20 + col
    push eax
    mov eax, ebx
    mov edx, 20
    mul edx
    mov ebx, eax
    pop eax
    add ebx, eax
    

    cmp ebx, 0
    je skip_tonext
    cmp ebx, 399
    jg skip_tonext
    
    
    cmp ebx, 0 ; no building at 0 ,0
    je skip_tonext
    
    mov esi, offset board ; alr building?
    add esi, ebx
    cmp BYTE PTR [esi], 0
    je skip_tonext
    mov BYTE PTR [esi], 0 ; put building
    jmp nextbuilding
    
skip_tonext:
    inc ecx
    
nextbuilding:

    loop board_make
    mov esi, offset board ; 0 , 0 wala check again to see road hi hai
    mov BYTE PTR [esi], 1
    mov ebx, 0 ;  guaranteed road 5th row takay always place to pick pass
    
ensure_rowroads:
    cmp ebx, 20
    jge ensure_colroads
    mov eax, ebx
    xor edx, edx
    mov ecx, 5
    div ecx
    cmp edx, 0
    jne skiprow
    
    push ebx;roads 
    mov eax, ebx
    mov edx, 20
    mul edx
    mov esi, offset board
    add esi, eax
    
    mov ecx, 20

makecolroad:

    mov BYTE PTR [esi], 1
    inc esi
    loop makecolroad
    
    pop ebx
    
skiprow:
    inc ebx
    jmp ensure_rowroads
    
ensure_colroads:

    mov ebx, 0 ; every 5th col
    
colroad_loop:

    cmp ebx, 20
    jge board_generate_hogaya_pls
   
    mov eax, ebx ;col road
    xor edx, edx
    mov ecx, 5
    div ecx
    cmp edx, 0
    jne skipcol
    
  
    push ebx
    mov esi, offset board
    add esi, ebx
    mov ecx, 20


make_colroad:

    mov BYTE PTR [esi], 1
    add esi, 20
    loop make_colroad
    
    pop ebx
    
skipcol:
    inc ebx
    jmp colroad_loop
    


board_generate_hogaya_pls:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret


generateBoard ENDP
;---------------------------------------------------------------------------------------------------------------------------------------------------
 ;road_position_find: yeh function kisi random road cell ka (x,y) nikalta hai jo board par valid ho.
 ;Start position, player ki current position, aur occupied positions avoid karta hai
 ;isliye spawning ke liye safe road tile return karta hai

road_position_find PROC
    push ebx
    push ecx
    push edx
    push esi
    
    mov ecx, 500 ;try 500 times
    
find_loop:

    cmp ecx, 0
    je use_fallback
   
    push ecx
    mov eax, 100
    call RandomRange
    pop ecx
    cmp eax, 80
    jl spawnnewcorr


    
spawnanywhere:
    mov eax, 20
    call RandomRange
    mov bl, al
    mov eax, 20
    call RandomRange
    mov bh, al
    jmp pos_check
    
spawnnewcorr:
    mov eax, 4
    call RandomRange

    mov edx, 5
    mul dl
    mov bl, al  
    push ebx
    mov eax, 3
    call RandomRange

    dec al
    pop ebx
    add bl, al
    cmp bl, 0
    jl spawnanywhere
    cmp bl, 19
    jg spawnanywhere
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
    jl spawnanywhere
    cmp bh, 19
    jg spawnanywhere
    
pos_check:
    cmp bl, 0
    jne playernot_atstart
    cmp bh, 0
    je retry
    
playernot_atstart:
    cmp bl, playerX
    jne not_currpos
    cmp bh, playerY
    je retry

not_currpos:
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
    jne retry

    cmp bl, 1
    jl retry
    cmp bl, 18
    jg retry
    cmp bh, 1
    jl retry
    cmp bh, 18
    jg retry
    ;occupied?

    push ecx
    call is_position_occupied

    pop ecx
    cmp al, 1
    je retry ;occupiedtry again
    push ebx
    inc bh;one row below
    cmp bh, 19
    jg skip_trunk_check    
    push ecx
    call is_position_occupied
    pop ecx
    pop ebx
    cmp al, 1
    je retry  ;trunt conflict

    jmp road_found
    
skip_trunk_check:
    pop ebx

    jmp road_found
   
retry:
    dec ecx
    jmp find_loop
  
use_fallback:
    mov bl, 5
    mov bh, 5
    
road_found:
    mov al, bl
    mov ah, bh
    
    pop esi
    pop edx
    pop ecx
    pop ebx

    ret


road_position_find ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------=
;simple check karta hai ke diya gaya (x,y) tile road corridor ke kareeb hai ya nahi. 
;Basically dekh raha hota hai ke yeh position game mein realistically approachable hai ya bohat side mein fas gayi ha

reachable PROC
    push ebx
    push ecx
    
    mov bl, al;x
    mov bh, ah;y
    xor ah, ah
    mov al, bl
    mov cl, 5
    div cl
    cmp ah, 0
    je near_corridor
    cmp ah, 1
    je near_corridor
    cmp ah, 4
    je near_corridor
    ;y
    mov al, bh
    xor ah, ah
    mov cl, 5
    div cl
    cmp ah, 0
    je near_corridor
    cmp ah, 1
    je near_corridor
    cmp ah, 4
    je near_corridor
   
    mov al, 0
    jmp reachabledone
    
near_corridor:
    mov al, 1;reachable
    
reachabledone:
    pop ecx
    pop ebx

    ret



reachable ENDP
    ;in al = x, ah = y output: al = 1 if reachable 0 if not and simple check position must be within 10 tiles of a road corridor

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Screen redraw, input handle WASD, space, P, L, X timer/update logic, NPC car movement, collisions ka flow sab yahin se control hota hai jab tak game over ya exit na ho jaye

the_gameloop_main PROC

    push eax
    push ebx
    push ecx
    push edx
    mov framecount, 0

   menugameloop:
    call Clrscr
    call game_make
    call draw_game_full
    
input_gameloop:

    mov al, currentMode
    cmp al, 1 
    je time_inp
    
career_endless_inp:
    mov eax, 100 ;delau
    call Delay
    inc framecount
    mov eax, framecount
    mov ebx, npc_speed
    xor edx, edx
    div ebx
    cmp edx, 0
    jne car_skip_updcareer

    call npc_car_move
    
car_skip_updcareer:
    call ReadChar
    mov inputchar, al
    jmp keys_input
    
    
time_inp:
    mov eax, 500 
    call Delay
    inc framecount
    mov eax, framecount
    and eax, 1
    cmp eax, 0

    jne timerupdate_skip
    
    mov eax, timerSeconds
    cmp eax, 0
    jle time_complete
    dec timerSeconds
    

timerupdate_skip:
    mov eax, framecount
    mov ebx, npc_speed
    xor edx, edx
    div ebx
    cmp edx, 0
    jne carupdateT_skip
    call npc_car_move
    
carupdateT_skip:
    call ReadKey
    jz nothing_pressed  ;redraw
    mov inputchar, al
    jmp keys_input
    
nothing_pressed:
    jmp menugameloop
    
keys_input:
    cmp inputchar, 'x'
    je finito
    cmp inputchar, 'X'
    je finito
    cmp inputchar, 'w'
    je moveup
    cmp inputchar, 'W'
    je moveup
    cmp inputchar, 's'
    je movedown
    cmp inputchar, 'S'
    je movedown
    cmp inputchar, 'a'
    je moveleft
    cmp inputchar, 'A'
    je moveleft
    
    cmp inputchar, 'd'
    je moveright
    cmp inputchar, 'D'
    je moveright
    cmp inputchar, ' '
    je spacbar_func
    cmp inputchar, 'p'
    je pausegame
    cmp inputchar, 'P'
    je pausegame

    cmp inputchar, 'l'
    je save_game
    cmp inputchar, 'L'
    je save_game
    mov al, currentMode
    cmp al, 1
    je nothing_pressed  ;no clrscr wala 
    jmp input_gameloop 

    
checkredraw:
    mov eax, framecount
    and eax, 3 
    cmp eax, 0
    je menugameloop
    jmp input_gameloop

time_complete:
    call Clrscr
    mov eax, red + (black * 16)
    call settextcolor
    mov edx, OFFSET timeUp
    call WriteString
    call Crlf
    call Crlf
    mov eax, white + (black * 16)
    call settextcolor
    mov edx, OFFSET final_score
    call WriteString
    mov eax, playerscore
    call WriteInt
    call Crlf

    call WaitMsg
    jmp finito




moveup:
    call moveup_try
    jmp gameover_check
    
movedown:
    call movedown_try
    jmp gameover_check
    
moveleft:
    call moveleft_try
    jmp gameover_check
    
moveright:
    call moveright_try
    jmp gameover_check
    



spacbar_func:
    call pickup_dropoff_handling
    jmp gameover_check

        pausegame:
    invoke PlaySound, addr pause_sound, 0, SND_ASYNC + SND_FILENAME
    call Pause_display
    

pause_screen_wait:
    call ReadChar
    
    cmp al, 'p'
    je resume
    cmp al, 'P'
    je resume
    cmp al, 'x'
    je finito
    cmp al, 'X'
    je finito
    
    jmp pause_screen_wait
    
    

resume:
    jmp menugameloop

save_game:
    call savegame
    jmp menugameloop
    
gameover_check:
    mov al, currentMode
    cmp al, 2 
    je skipfuel_check
    mov eax, fuel_amt
    cmp eax, 0
    jle fuel_finito
    
skipfuel_check:
    mov eax, playerscore
    cmp eax, 0
    jl score_negative
    jmp menugameloop
    
fuel_finito:

    call Clrscr
    invoke PlaySound, addr gameover_sound, 0, SND_ASYNC + SND_FILENAME
    mov eax, red + (black * 16)
    call settextcolor
    mov edx, offset gameover1
    call WriteString
    call Crlf
    

    call Crlf
    mov eax, white + (black * 16)
    call settextcolor
    mov edx, offset gameover2
    call WriteString
    call Crlf
    jmp finalstats
    

score_negative:
    call Clrscr
    invoke PlaySound, addr gameover_sound, 0, SND_ASYNC + SND_FILENAME
    mov eax, red + (black * 16)
    call settextcolor
    mov edx, offset gameover1
    call WriteString
    

    call Crlf
    call Crlf
    mov eax, white + (black * 16)
    call settextcolor
    mov edx, offset gameover3
    call WriteString
    call Crlf

    

finalstats:
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
    jmp finito
    

finito:
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

the_gameloop_main ENDP

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Movement_try 
; - Kaam: Player ko given direction me move karna, sirf agar next tile valid ho.
; - Logic flow:
; 1) Next cell nikaalna (current X,Y se +/– 1).
; 2) Boundary check (bahar to nahi ja raha?
; 3) Road check is_road = 1 hona chahiye; building par move nahi
; 4) Obstacle check (has_obstacle = 0 chahiye; box/tree block kare to ruk)
; 5) Option Occupied check (NPC/bonus/passenger overlap avoid)
; 6) Commit move (playerX, playerY update)
; 7) Fuel adjust (har successful move pe fuel --)
; 8) Speed/colour effects (agar koi slow/fast rule hai)
; 9) Post move collisions (NPC hit, bonus pickup, passenger overlap)
; 10) Redraw baad me main loop karega (yahan sirf state update)

; ----------------------------------------
moveup_try PROC
    push eax
    push ebx
    inc move_speed_counter
    mov al, taxicolor
    cmp al, 0
    je allowmoveup
    mov eax, move_speed_counter
    and eax, 1
    cmp eax, 1
    je move_fail_up

    allowmoveup :
        mov al, playerY
        cmp al, 0
        je move_fail_up

        dec al
        mov bh, al
        mov bl, playerX
        call is_road; check for road
        cmp al, 0
        je move_fail_up
        call has_obstacle
        cmp al, 1
        je hit_obstacle_up
        dec playerY
        push eax
        mov al, currentMode
        cmp al, 2
        je skip_fuel_up
        dec fuel_amt

    skip_fuel_up :
        pop eax

        call check_for_collisions
        jmp move_fail_up

        hit_obstacle_up :
        mov al, taxicolor;obstacle dont move on it
        cmp al, 0
        je yellow_hit_up
        sub playerscore, 2;Red
        invoke PlaySound, addr carCrash, 0, SND_ASYNC + SND_FILENAME
        jmp move_fail_up

    yellow_hit_up :
        sub playerscore, 4;Yellow
        invoke PlaySound, addr carCrash, 0, SND_ASYNC + SND_FILENAME
       

    move_fail_up :
        pop ebx
        pop eax
        ret


moveup_try ENDP


; ----------------------------------------
       
movedown_try PROC

        push eax
        push ebx
        inc move_speed_counter
        mov al, taxicolor
        cmp al, 0
        je allowmovedown
        mov eax, move_speed_counter
        and eax, 1
        cmp eax, 1
        je move_fail_down

        allowmovedown :
            mov al, playerY
            cmp al, 19
            jge move_fail_down
            inc al
            mov bh, al
            mov bl, playerX
            call is_road
            cmp al, 0
            je move_fail_down
            call has_obstacle;obstacles
            cmp al, 1
            je hit_obstacle_down

            inc playerY
            push eax
            mov al, currentMode
            cmp al, 2
            je skip_fuel_down
            dec fuel_amt

    skip_fuel_down :
            pop eax

            call check_for_collisions
            jmp move_fail_down

   hit_obstacle_down :
        mov al, taxicolor
        cmp al, 0
        je yellow_hit_down
        sub playerscore, 2
       invoke PlaySound, addr carCrash, 0, SND_ASYNC + SND_FILENAME
        
        jmp move_fail_down

   yellow_hit_down :
        sub playerscore, 4
        invoke PlaySound, addr carCrash, 0, SND_ASYNC + SND_FILENAME

   move_fail_down :
        pop ebx
        pop eax
        ret


movedown_try ENDP

; -------------------------------------------- -
moveleft_try PROC
     push eax
     push ebx
     inc move_speed_counter

     mov al, taxicolor
     cmp al, 0
     je allowmoveleft
     mov eax, move_speed_counter
     and eax, 1
     cmp eax, 1
     je move_fail_left

  allowmoveleft :
        mov al, playerX
        cmp al, 0
        je move_fail_left

        dec al
        mov bl, al
        mov bh, playerY

        call is_road
        cmp al, 0
        je move_fail_left
        call has_obstacle
        cmp al, 1
        je hit_obstacle_left
        dec playerX
        push eax
        mov al, currentMode
        cmp al, 2
        je skip_fuel_left
        dec fuel_amt

   skip_fuel_left :
        pop eax

        call check_for_collisions
        jmp move_fail_left


   hit_obstacle_left :
        mov al, taxicolor
        cmp al, 0
        je yellow_hit_left
        sub playerscore, 2
        invoke PlaySound, addr carCrash, 0, SND_ASYNC + SND_FILENAME
        jmp move_fail_left

   yellow_hit_left :
        sub playerscore, 4
        invoke PlaySound, addr carCrash, 0, SND_ASYNC + SND_FILENAME

   move_fail_left :
        pop ebx
        pop eax
        ret


moveleft_try ENDP

; ------------------------------------------ -
moveright_try PROC
    push eax
    push ebx

   inc move_speed_counter
    mov al, taxicolor
    cmp al, 0
    je allowmoveright
    mov eax, move_speed_counter
    and eax, 1
    cmp eax, 1
    je move_fail_right

    allowmoveright :
        mov al, playerX
        cmp al, 19
        jge move_fail_right

        inc al
        mov bl, al
        mov bh, playerY
        call is_road
        cmp al, 0
        je move_fail_right
        call has_obstacle
        cmp al, 1
        je hit_obstacle_right
        inc playerX
        push eax
        mov al, currentMode
        cmp al, 2
        je skip_fuel_right
        dec fuel_amt

    skip_fuel_right :
         pop eax

        call check_for_collisions
        jmp move_fail_right

    hit_obstacle_right :
        mov al, taxicolor
        cmp al, 0
        je yellow_hit_right
        sub playerscore, 2
        invoke PlaySound, addr carCrash, 0, SND_ASYNC + SND_FILENAME
        jmp move_fail_right

    yellow_hit_right :
        sub playerscore, 4
        invoke PlaySound, addr carCrash, 0, SND_ASYNC + SND_FILENAME

    move_fail_right :
        pop ebx
        pop eax
        ret


        moveright_try ENDP
 ; ----------------------------------------
 ;given x = bl, y = bh ke liye board index nikalta hai aur board array se check karta hai ke yeh cell road (1) hai ya building (0)
 ;Return AL me 1 ya 0 deta hai

is_road PROC
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


is_road ENDP
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;check karta hai ke koi bhi entity  is (x,y) position pe already hai ya nahi
;Agar kuch mila to AL = 1 warna AL = 0 return karta hai

is_position_occupied PROC
    push ebx
    push ecx
    push esi
    push edi
    mov ecx, obstaclecount
    xor esi, esi

    check_obstacles :
           cmp esi, ecx
           jge check_passengers_pos

            mov edi, OFFSET obstX
            add edi, esi
            mov al, [edi]
            cmp al, bl
            jne next_obst_check
            mov edi, OFFSET obstY
            add edi, esi
            mov al, [edi]
            cmp al, bh
            je position_occupied
            ;treetrunk y+1
            mov edi, OFFSET obsttype
            add edi, esi
            cmp BYTE PTR[edi], 1; is it a tree ?
            jne next_obst_check
            mov edi, OFFSET obstY
            add edi, esi
            mov al, [edi]
            inc al; Trunk at Y + 1
            cmp al, bh
            je position_occupied

         next_obst_check :
            inc esi
            jmp check_obstacles

            check_passengers_pos :
            mov ecx, MAX_PASSENGERS
            xor esi, esi

            check_pass_loop :
            cmp esi, ecx
            jge check_cars_pos
            mov edi, OFFSET pass_active
            add edi, esi

            cmp BYTE PTR[edi], 0
            je next_pass_check

            mov edi, OFFSET pass_picked
            add edi, esi
            cmp BYTE PTR[edi], 1
            je next_pass_check
            mov edi, OFFSET passX

            add edi, esi
            mov al, [edi]
            cmp al, bl
            jne check_pass_dest
            mov edi, OFFSET passY
            add edi, esi
            mov al, [edi]
            cmp al, bh
            je position_occupied

        check_pass_dest :
            mov edi, OFFSET pass_picked
            add edi, esi
            cmp BYTE PTR[edi], 1
            jne next_pass_check
            mov edi, OFFSET passdestX
            add edi, esi
            mov al, [edi]
            cmp al, bl
            jne next_pass_check
            mov edi, OFFSET passdestY
            add edi, esi

            mov al, [edi]
            cmp al, bh
            je position_occupied

        next_pass_check :
            inc esi
            jmp check_pass_loop

        check_cars_pos :
            mov ecx, npc_count
            xor esi, esi

        check_cars_loop :
            cmp esi, ecx
            jge check_bonus_pos
            mov edi, OFFSET npc_active
            add edi, esi
            cmp BYTE PTR[edi], 0
            je next_car_check
            mov edi, OFFSET carX
            add edi, esi
            mov al, [edi]
            cmp al, bl
            jne next_car_check
            mov edi, OFFSET carY
            add edi, esi
            mov al, [edi]

            cmp al, bh
            je position_occupied

        next_car_check :
            inc esi
            jmp check_cars_loop

        check_bonus_pos :
            mov ecx, bonuscount
            xor esi, esi

        check_bonus_loop :
            cmp esi, ecx
            jge check_player_pos
            mov edi, OFFSET bonusonboard
            add edi, esi
            cmp BYTE PTR[edi], 0
            je next_bonus_check
            mov edi, OFFSET bonusX
            add edi, esi
            mov al, [edi]

            cmp al, bl
            jne next_bonus_check
            mov edi, OFFSET bonusY
            add edi, esi
            mov al, [edi]
            cmp al, bh
            je position_occupied

         next_bonus_check :
            inc esi
            jmp check_bonus_loop

        check_player_pos :
            mov al, playerX
            cmp al, bl
            jne position_free

            mov al, playerY
            cmp al, bh
            je position_occupied

        position_free :
            mov al, 0
            jmp pos_check_done

         position_occupied :
            mov al, 1

      pos_check_done :
            pop edi
            pop esi
            pop ecx
            pop ebx

            ret
  
            
 is_position_occupied ENDP


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

has_obstacle PROC
    push ebx
    push ecx
    push esi
    push edi

    mov ecx, obstaclecount
    xor esi, esi

    check_obstacle_loop :
         cmp esi, ecx
         jge no_obstacle_found
         push ecx

        ;obstacle X & Y match check
         mov edi, OFFSET obstX
         add edi, esi
         mov al, [edi]
         cmp al, bl
         jne next_obstacle
         mov edi, OFFSET obstY
         add edi, esi
         mov al, [edi]

         cmp al, bh
         je obstacle_found_at_main_pos

        ; check for tree
         mov edi, OFFSET obsttype
         add edi, esi
         mov al, [edi]
         cmp al, 1; 1 = tree
         jne next_obstacle

        ;one row below the tree check
         mov edi, OFFSET obstY
         add edi, esi
         mov al, [edi]
         inc al; trunk is Y + 1
         cmp al, bh
         jne next_obstacle

         obstacle_found_at_main_pos :
         pop ecx
         mov al, 1; obstacle found
        jmp obstacle_check_done



     next_obstacle :
         inc esi
         pop ecx
         jmp check_obstacle_loop

         no_obstacle_found :
         mov al, 0; no obstacle


     obstacle_check_done :
         pop edi
         pop esi
         pop ecx
         pop ebx
         ret


has_obstacle ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

; removed passenger collision because how  will the car pick up the passenger without hitting them so tried the functionality to pick them from the side but still gonna remove the pick fromside functionality as maybe there might be and issue with that 
check_for_collisions  PROC

    push eax
    push ebx
    push ecx
    push esi
    mov ecx, MAX_PASSENGERS
    xor esi, esi

    check_passenger_collision :
        cmp esi, ecx
        jge carcollisions
        push ecx

        mov edi, offset pass_active
        add edi, esi
        cmp BYTE PTR[edi], 0
        je next_passenger

        mov edi, offset pass_picked
        add edi, esi
        cmp BYTE PTR[edi], 1;skip if carrying pass
        je next_passenger
        mov edi, offset passX
        add edi, esi
        mov al, [edi]
        cmp al, playerX
        jne next_passenger

        mov edi, offset passY
        add edi, esi
        mov al, [edi]
        cmp al, playerY
        jne next_passenger
        sub playerscore, 5; passenger hit
        invoke PlaySound, addr carCrash, 0, SND_ASYNC + SND_FILENAME
       

    next_passenger :
        inc esi
        pop ecx
        jmp check_passenger_collision

    carcollisions :
        mov ecx, npc_count
        xor esi, esi

    check_carcollision :
       cmp esi, ecx
        jge bonus_pick
        push ecx
        mov edi, offset npc_active
        add edi, esi
        cmp BYTE PTR[edi], 0
        je next_car

        mov edi, offset carX
        add edi, esi
        mov al, [edi]
        cmp al, playerX
        jne next_car
        mov edi, offset carY
        add edi, esi
        mov al, [edi]
        cmp al, playerY
        jne next_car
        mov al, taxicolor; car col
        cmp al, 0
        je yellow_car
        sub playerscore, 3;red
        invoke PlaySound, addr carCrash, 0, SND_ASYNC + SND_FILENAME
        jmp next_car

    yellow_car :
        sub playerscore, 2;yellow
        invoke PlaySound, addr carCrash, 0, SND_ASYNC + SND_FILENAME

     next_car :
         inc esi
        pop ecx
        jmp check_carcollision

     bonus_pick :
        mov ecx, bonuscount
        xor esi, esi

     bonus_pickLoop :
        cmp esi, ecx
            jge collsions_complete
            push ecx
            mov edi, offset bonusonboard
            add edi, esi
            cmp BYTE PTR[edi], 0
            je next_bonus

            mov edi, offset bonusX
            add edi, esi
            mov al, [edi]
            cmp al, playerX
            jne next_bonus
            mov edi, offset bonusY
            add edi, esi
            mov al, [edi]

            cmp al, playerY
            jne next_bonus
            add playerscore, 10
            invoke PlaySound, addr bonus_collect, 0, SND_ASYNC + SND_FILENAME
            mov edi, offset bonusonboard
            add edi, esi
            mov BYTE PTR[edi], 0
            call MaintainBonusItems

   next_bonus :
        inc esi
        pop ecx
        jmp bonus_pickLoop

   collsions_complete :
        pop esi
        pop ecx
        pop ebx
        pop eax
        ret


 check_for_collisions  ENDP


;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pickup_dropoff_handling PROC
    push eax
    push ebx
    push ecx
    push esi
    push edi
    mov eax, carrying
    cmp eax, -1
    jne dropoff_try
    mov ecx, passengercount
    xor esi, esi

pickup_loop:
    cmp esi, MAX_PASSENGERS

    jge pickedup_complete
    push ecx
    
    mov edi, offset pass_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    je pickup_next
    
    mov edi, offset pass_picked
    add edi, esi
    cmp BYTE PTR [edi], 1
    je pickup_next
    mov edi, offset passX ;get pass pos
    add edi, esi
    mov bl, [edi]
    mov edi, offset passY
    add edi, esi
    mov bh, [edi]
   
   
    mov al, playerX
    sub al, bl
    jge x_positive
    neg al


x_positive:
    mov cl, al
    mov al, playerY
    sub al, bh
    jge y_positive
    neg al

y_positive:
    mov ch, al
    add cl, ch ;total distance
    cmp cl, 1
    jg pickup_next
    mov eax, esi
    mov carrying, eax
    mov edi, offset pass_picked
    add edi, esi
    mov BYTE PTR [edi], 1
    pop ecx
    jmp pickedup_complete
    

pickup_next:
    inc esi
    pop ecx
    jmp pickup_loop


    
dropoff_try:
    mov esi, eax
        mov edi, offset passdestX
        add edi, esi
        mov al, [edi]
        cmp al, playerX
        jne pickedup_complete
        mov edi, offset passdestY
        add edi, esi
        mov al, [edi]
        cmp al, playerY
        jne pickedup_complete

        mov edi, offset pass_active; dropped
        add edi, esi
        mov BYTE PTR[edi], 0
        add playerscore, 10
        mov carrying, -1
        
    
    
    mov al, currentMode
    cmp al, 2
    jne NOT_endless
    mov eax, playerscore
    cmp eax, endless_session_high
    jle NOT_endless
    mov endless_session_high, eax
    
NOT_endless:
    call PASSENGERS_RESPAWN

    mov al, currentMode
    cmp al, 2
    jne difficulty_endless_increase
    call endless_difficulty_inc
    
difficulty_endless_increase:
    mov eax, total_dropsoffs
    mov eax, total_dropsoffs;2 dropoff speed
    mov ebx, 2
    xor edx, edx
    div ebx
    cmp edx, 0
    jne NoSpeedIncrease
    mov eax, npc_speed;npc speed
    cmp eax, 1
    jle NoSpeedIncrease
    dec npc_speed
    mov eax, npc_count;more cars
    cmp eax, MAX_CARS
    jge NoSpeedIncrease
    call spawn_more_cars
    
NoSpeedIncrease:
    

pickedup_complete:
invoke PlaySound, addr pickup_sound, 0, SND_ASYNC + SND_FILENAME
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax

    ret


pickup_dropoff_handling ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

game_make PROC
    push eax
    push ebx
    push ecx
    push edx
    
    ; Draw 20x20 grid
    xor ebx, ebx
rows_draw:
    cmp ebx, 20
    jge drawentities
    
    xor ecx, ecx
    
cols_draw:
    cmp ecx, 20
    jge row_next
    mov dh, bl;pos code
    add dh, 2

    push eax
    mov al, cl
    mov dl, 4
    mul dl
    add al, 2
    mov dl, al
    pop eax
    call Gotoxy
   
    push ebx
    push ecx
    mov al, bl;board index
    xor ah, ah
    mov dl, 20
    mul dl
    add ax, cx
    mov esi, offset board;boardindex
    xor edx, edx
    mov dx, ax
    add esi, edx
    mov al, [esi]
    pop ecx
    pop ebx
    cmp al, 1
    je draw_roadcell
    
    mov eax, black + (black * 16);building
    call settextcolor
    mov al, 219
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    jmp col_next
    


draw_roadcell:
    mov eax, black + (white * 16)
    call settextcolor
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    
col_next:
    inc ecx
    jmp cols_draw
    
row_next:
    inc ebx
    jmp rows_draw
    
drawentities:
    mov ecx, obstaclecount
    xor esi, esi
    
drawobst:
       cmp esi, ecx
        jge draw_cars

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
        je draw_box
        push dx; save top position and make trunk
        mov eax, lightGreen + (white * 16)
        call SetTextColor
        mov al, '/'
        call WriteChar
        mov al, '@'
        call WriteChar
        mov al, '@'
        call WriteChar
        mov al, '\'
        call WriteChar
        pop dx; restore top X, Y
        inc dh; move one row down same col
        call Gotoxy
        mov eax, brown + (white * 16)
        call SetTextColor
        mov al, ' ';trunk
        call WriteChar
        mov al, '|'
        call WriteChar
        mov al, '|'
        call WriteChar
        mov al, ' '
        call WriteChar
        jmp next_obst

 draw_box:
    mov eax, yellow + (brown * 16)
    call settextcolor
    mov al, '['
    call WriteChar
    mov al, '#'
    call WriteChar
    mov al, ']'
    call WriteChar
    
next_obst:
    inc esi
    pop ecx
    jmp drawobst
    
draw_cars:
    mov ecx, npc_count
    xor esi, esi
    
draw_car_loop:
    cmp esi, ecx
    jge bonus_draw
    
    push ecx
    
    mov edi, OFFSET npc_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    je car_skip
    
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
        mov eax, white + (magenta * 16)
        call SetTextColor

        mov al, '['
        call WriteChar
        mov al, '>'
        call WriteChar
        mov al, ']'
        call WriteChar
    
car_skip:
    inc esi
    pop ecx
    jmp draw_car_loop
    
bonus_draw:
    mov ecx, bonuscount
    xor esi, esi
    
bonus_drawLoop:
    cmp esi, ecx
    jge passenger_draw
    
    push ecx
    mov edi, OFFSET bonusonboard
    add edi, esi
    cmp BYTE PTR [edi], 0
    je bonus_skip
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
    push eax
    mov eax, esi
    mov ebx, 4
    xor edx, edx
    div ebx
    pop eax
    
    cmp edx, 0
    je dollar_draw
    cmp edx, 1
    je star_draw
    cmp edx, 2
    je gem_draw
    
coin_draw:
    mov eax, yellow + (white * 16)
    call settextcolor
    mov al, '('
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, ')'
    call WriteChar
    jmp bonus_skip
    
dollar_draw:
    mov eax, lightGreen + (white * 16)
    call settextcolor
    mov al, ' '
    call WriteChar
    mov al, '$'
    call WriteChar
    mov al, ' '
    call WriteChar
    jmp bonus_skip
    


star_draw:
    mov eax, red + (white * 16)
    call settextcolor
    mov al, ' '
    call WriteChar
    mov al, '*'
    call WriteChar
    mov al, ' '
    call WriteChar
    jmp bonus_skip
    
gem_draw:
    mov eax, lightCyan + (white * 16)
    call settextcolor
    mov al, '<'
    call WriteChar
    mov al, '>'
    call WriteChar
    mov al, ' '
    call WriteChar
    
bonus_skip:
    inc esi
    pop ecx
    jmp bonus_drawLoop


passenger_draw:
    mov ecx, MAX_PASSENGERS
    xor esi, esi
    
passenger_drawLoop:
    cmp esi, ecx
    jge destination_draw
    
    push ecx
    mov edi, OFFSET pass_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    je pssenger_skip
    mov edi, OFFSET pass_picked
    add edi, esi
    cmp BYTE PTR [edi], 1
    je pssenger_skip
    
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

    ; Person waving
    mov eax, BLACK + (white * 16)
    call settextcolor
    mov al, '\'
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, '/'

    call WriteChar
    
pssenger_skip:
    inc esi
    pop ecx
    jmp passenger_drawLoop


    
destination_draw:
    
    mov eax, carrying
    cmp eax, -1
    je player_draw
    
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
    mov eax, white + (green * 16)
    call settextcolor
    mov al, '*'
    call WriteChar
    mov al, 'D'
    call WriteChar
    mov al, 'S'
    call WriteChar
    mov al, 'T'
    call WriteChar
    
player_draw:
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
    je taxiYELLOW_draw
    mov eax, yellow + (red * 16)
    call settextcolor
    mov al, '['
    call WriteChar
    mov al, 'T'
    call WriteChar
    mov al, ']'
    call WriteChar
    jmp taxi_complete
    
taxiYELLOW_draw:
    mov eax, black + (yellow * 16)
    call settextcolor
    mov al, '['
    call WriteChar
    mov al, 'T'
    call WriteChar
    mov al, ']'
    call WriteChar
    
taxi_complete:
    mov eax, white + (black * 16)
    call settextcolor
    pop edx
    pop ecx
    pop ebx
    pop eax


    ret


game_make ENDP
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 draw_game_full PROC
    push eax
    push ebx
    push ecx
    push edx
    
    mov dh, 0
    mov dl, 0
    call Gotoxy
    mov eax, white + (black * 16)
    call settextcolor
    mov edx, OFFSET score_display
    call WriteString
    mov eax, playerscore
    call WriteInt
    
    mov al, currentMode
    cmp al, 2 
    je no_fuel_displayforendless
    mov edx, offset fuel_display
    call WriteString
    mov eax, fuel_amt
    call WriteDec
    jmp continue_displayofgame
    
no_fuel_displayforendless:
    mov al, ' '
    mov ecx, 15


spaceLOOP:
    call WriteChar
    loop spaceLOOP
    
continue_displayofgame:
    mov edx, offset pass_display
    call WriteString
    xor eax, eax ; activde pass count
    xor ecx, ecx
    
counter_loop:
    mov ebx, MAX_PASSENGERS
    cmp ecx, ebx
    jge counter_complete
    push ecx
    mov esi, ecx
    mov edi, offset pass_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    je counter_skip
    
        mov edi, offset pass_picked
        add edi, esi
        cmp BYTE PTR [edi], 1
        je counter_skip
        inc eax
    


counter_skip:
    pop ecx
    inc ecx
    jmp counter_loop
    
counter_complete:
        call WriteDec
        mov edx, offset donedropped_display
        call WriteString
        mov eax, total_dropsoffs
        call WriteDec
        mov edx, offset donedropped_display
        call WriteString
        mov eax, total_dropsoffs
        call WriteDec
   
    mov edx, OFFSET mode_display
    call WriteString
    
    mov al, currentMode
    cmp al, 0
    je career_display
    cmp al, 1
    je timer_display
    mov eax, lightGreen + (black * 16)
    call settextcolor
    mov edx, OFFSET mode_endless_txt
    call WriteString
    mov eax, white + (black * 16)
    call settextcolor
    jmp after_mode_display
    
career_display:
    mov eax, yellow + (black * 16)
    call settextcolor
    mov edx, OFFSET mode_career_txt
    call WriteString
    mov eax, white + (black * 16)
    call settextcolor
    jmp after_mode_display
    
timer_display:
    mov eax, cyan + (black * 16)
    call settextcolor
    mov edx, OFFSET mode_time_txt
    call WriteString
    mov eax, white + (black * 16)
    call settextcolor


;session best try    
after_mode_display:
    mov al, currentMode
    cmp al, 2
    jne other_thanendless_display
    mov edx, OFFSET endless_high_msg
    call WriteString
    mov eax, endless_session_high
    call WriteDec
    
other_thanendless_display:
    mov al, currentMode
    cmp al, 1
    jne timer_skip
    mov edx, OFFSET timeRemaining; timer
    call WriteString
    mov eax, timerSeconds
    call WriteDec
    mov al, 's'

    call WriteChar
    
timer_skip:
    mov dh, 1
    mov dl, 0
    call Gotoxy
    mov dh, 1;l1
    mov dl, 0
    call Gotoxy
    mov eax, carrying
    cmp eax, -1
    je show_ITEMS
    mov edx, offset carrying_display
    call WriteString

    jmp DISPLAY_DONE
    

show_ITEMS:
    mov edx, OFFSET items_on_board
    call WriteString
    
DISPLAY_DONE:
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



draw_game_full ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

npc_car_move PROC

    push eax
    push ebx
    push ecx
    push esi
    mov ecx, npc_count
    xor esi, esi  ;OR MOVZX
    
move_loop:
    cmp esi, ecx
    jge npc_movemnet_complete
    
    push ecx
    
    mov edi, OFFSET npc_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    je movement_skip
    mov edi, OFFSET carX
    add edi, esi
    mov bl, [edi]
    mov edi, OFFSET npc_dirX
    add edi, esi
    mov al, [edi]
    add bl, al
    
    cmp bl, 0
    jl movement_back
    cmp bl, 19
    jg movement_back
    push esi;check road
    mov edi, offset carY
    add edi, esi
    mov bh, [edi]
    call is_road
    pop esi
    cmp al, 0
    je movement_back
    mov edi, offset carX;update
    add edi, esi
    mov [edi], bl
    ;y
    mov edi, offset carY
    add edi, esi
    mov bl, [edi]
    mov edi, OFFSET npc_dirY
    add edi, esi
    mov al, [edi]
    add bl, al
    cmp bl, 0
    jl movement_back
    cmp bl, 19
    jg movement_back
    push esi;road check
    mov bh, bl
    mov edi, OFFSET carX
    add edi, esi
    mov bl, [edi]
    call is_road
    pop esi
    cmp al, 0
    je movement_back
    mov edi, OFFSET carY;update
    add edi, esi

    mov [edi], bh
    
    jmp movement_skip
    

movement_back:
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
    
movement_skip:

    inc esi
    pop ecx
    jmp move_loop
    
npc_movemnet_complete:

    pop esi
    pop ecx
    pop ebx
    pop eax
    ret


npc_car_move ENDP

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PASSENGERS_RESPAWN PROC

    push eax
    push ebx
    push ecx
    push edx
    push esi
    xor eax, eax
    xor ecx, ecx
    
ACTIVE_COUNT:
    cmp ecx, MAX_PASSENGERS
    jge SPAWN_CHECK
    push ecx
    mov esi, ecx
    mov edi, offset pass_active
    add edi, esi
    cmp BYTE PTR [edi], 0
    je ACTIVE_SKIP
    mov edi, offset pass_picked
    add edi, esi
    cmp BYTE PTR [edi], 1
    je ACTIVE_SKIP
    inc eax
    
ACTIVE_SKIP:
    pop ecx
    inc ecx
    jmp ACTIVE_COUNT
 
SPAWN_CHECK:
spawnloop:
    cmp eax, 3
    jge max_check
    xor esi, esi
    
slot_find:
    cmp esi, MAX_PASSENGERS
    jge NoSpawn
    push esi
    mov edi, offset pass_active
    add edi, esi

    cmp BYTE PTR [edi], 0
    pop esi
    je FoundSlot
    
    inc esi
    jmp slot_find
    
FoundSlot:
    push eax
    push esi
    mov ecx, 100  ;try 100 times
    
find_pass_pos:
    cmp ecx, 0
    je failed_pass_spawn
    push ecx
    call road_position_find 
    mov bl, al
    mov bh, ah
    ;occupied?
    push eax
    call is_position_occupied
    pop eax
    pop ecx
    cmp al, 1

    je retry_pass_pos
    ;passenger pos store
    pop esi
    push esi
    mov edi, OFFSET passX
    add edi, esi
    mov [edi], bl
    mov edi, OFFSET passY
    add edi, esi
    mov [edi], bh
    mov ecx, 100;find destination
    
find_dest_pos:
    cmp ecx, 0
    je failed_pass_spawn
    push ecx
    call road_position_find
    mov bl, al
    mov bh, ah
    push eax
    call is_position_occupied
    pop eax
    pop ecx
    cmp al, 1
    je retry_dest_pos
    pop esi
    push esi
    mov edi, OFFSET passdestX
    add edi, esi
    mov [edi], bl
    mov edi, OFFSET passdestY
    add edi, esi
    mov [edi], bh
    mov edi, OFFSET pass_picked
    add edi, esi

    mov BYTE PTR [edi], 0
    mov edi, OFFSET pass_active

    add edi, esi
    mov BYTE PTR [edi], 1
    pop esi
    pop eax
    inc eax
    jmp spawnloop
    
retry_dest_pos:
    dec ecx
    jmp find_dest_pos
    
retry_pass_pos:
    dec ecx
    jmp find_pass_pos
    
failed_pass_spawn:
    pop esi
    pop eax
    jmp max_check

max_check:
    cmp eax, 5
    jge NoSpawn
    push eax
    mov eax, 100
    call RandomRange
    cmp eax, 30
    pop eax
    jg NoSpawn
   
    xor esi, esi
    
slot_find2:
    cmp esi, MAX_PASSENGERS
    jge NoSpawn
    push esi
    mov edi, OFFSET pass_active

    add edi, esi
    cmp BYTE PTR [edi], 0
    pop esi
    je slot_found2
    inc esi
    jmp slot_find2
    
slot_found2:
    push eax
    push esi
    mov ecx, 100
    
find_pass_pos2:
    cmp ecx, 0
    je failed_spawn2
    push ecx
    call road_position_find
    mov bl, al
    mov bh, ah
    push eax
    call is_position_occupied
    pop eax
    pop ecx
    cmp al, 1
    je retry_pos2  
    pop esi
    push esi
    mov edi, OFFSET passX

    add edi, esi
    mov [edi], bl
    mov edi, OFFSET passY
    add edi, esi
    mov [edi], bh 
    mov ecx, 100
    
find_dest_pos2:
    cmp ecx, 0
    je failed_spawn2
    push ecx
    call road_position_find
    mov bl, al
    mov bh, ah
    push eax
    call is_position_occupied
    pop eax
    pop ecx
    cmp al, 1

    je retry_dest2
    pop esi
    push esi
    mov edi, OFFSET passdestX
    add edi, esi
    mov [edi], bl
    mov edi, OFFSET passdestY
    add edi, esi
    mov [edi], bh
    mov edi, OFFSET pass_picked
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, OFFSET pass_active

    add edi, esi
    mov BYTE PTR [edi], 1
    pop esi
    pop eax
    inc eax
    jmp max_check
    


retry_dest2:
    dec ecx
    jmp find_dest_pos2
    
retry_pos2:
    dec ecx
    jmp find_pass_pos2
    
failed_spawn2:

    pop esi
    pop eax
    
    NoSpawn:
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret



PASSENGERS_RESPAWN ENDP

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

spawn_more_cars PROC
    push eax
    push esi
    
    mov esi, npc_count
    cmp esi, MAX_CARS
    jge no_spawning2
    call road_position_find 
    mov edi, OFFSET carX
    add edi, esi
    mov [edi], al
    mov edi, OFFSET carY
    add edi, esi
    mov [edi], ah
    
    mov eax, 4
   call RandomRange
    cmp eax, 0
     je up_new
    cmp eax, 1
    je down_new
   cmp eax, 2
    je left_new
    
right_new:
    mov edi, OFFSET npc_dirX
    add edi, esi
    mov BYTE PTR [edi], 1
    mov edi, OFFSET npc_dirY
    add edi, esi
    mov BYTE PTR [edi], 0
    jmp done_new
    
up_new:
    mov edi, OFFSET npc_dirX
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, OFFSET npc_dirY
    add edi, esi
    mov BYTE PTR [edi], -1
    jmp done_new
    
down_new:
    mov edi, OFFSET npc_dirX
    add edi, esi
    mov BYTE PTR [edi], 0
    mov edi, OFFSET npc_dirY
    add edi, esi
    mov BYTE PTR [edi], 1
    jmp done_new
    
left_new:
    mov edi, OFFSET npc_dirX
    add edi, esi
    mov BYTE PTR [edi], -1
    mov edi, OFFSET npc_dirY
    add edi, esi
    mov BYTE PTR [edi], 0
    
done_new:

    mov edi, OFFSET npc_active
    add edi, esi
    mov BYTE PTR [edi], 1
    inc npc_count
    
no_spawning2:
    pop esi
    pop eax
    ret


spawn_more_cars ENDP

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
gamemode_selection PROC
    push eax
    push edx
    call Clrscr
    mov dh, 8
    mov dl, 30
    call Gotoxy
    mov eax, cyan + (black * 16)
    call settextcolor
    
    mov edx, OFFSET modeTitle
    call WriteString
    call Crlf
    call Crlf    
    mov eax, white + (black * 16)
    call settextcolor
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
    call settextcolor
    mov edx, OFFSET mode4

    call WriteString
    
input_gamemode:
    call ReadChar
    cmp al, '1'
    je setcareer
    cmp al, '2'
    je settime
    cmp al, '3'
    je setendless
    
    jmp input_gamemode
    
setcareer:
    mov currentMode, 0
    mov timerActive, 0
    jmp mode_selected
    
settime:
    mov currentMode, 1
    mov timerSeconds, 120 ;120 secs
    mov timerActive, 1
    jmp mode_selected
    
setendless:
    mov currentMode, 2
    mov timerActive, 0
    mov fuel_amt, 9999 ; wont use
    
mode_selected:
    mov dh, 20
    mov dl, 35
    call Gotoxy
    mov eax, lightGreen + (black * 16)
    call settextcolor
    mov al, currentMode
    cmp al, 0
    je career_display
    cmp al, 1
    je time_display
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
    jmp wait_toload
    
career_display:
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
    jmp wait_toload
    
time_display:
    mov al, 'T'
    call WriteChar
    mov al, 'i'
    call WriteChar
    mov al, 'm'
    call WriteChar
    mov al, 'e'
    call WriteChar
    
wait_toload:
    mov eax, 800
    call Delay
    call clrscr
    pop edx
    pop eax
    ret


gamemode_selection ENDP

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

endless_difficulty_inc PROC
    push eax
    push ebx
    push esi
    mov eax, total_dropsoffs
    mov ebx, 3
    xor edx, edx
    div ebx
    cmp edx, 0
    jne finito
    mov eax, npc_speed
    cmp eax, 1
    jle obs_check
    dec npc_speed
    
obs_check:
    mov eax, obstaclecount
    cmp eax, MAX_OBSTACLES
    jge car_add
    inc obstaclecount
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


car_add:
    mov eax, npc_count
    cmp eax, MAX_CARS
    jge finito
    call spawn_more_cars
    
finito:
    pop esi
   pop ebx
    pop eax

    ret


endless_difficulty_inc ENDP


;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

savegame PROC
    push eax
    push ecx
    push edx
    mov edx, OFFSET savegamefilenametxt ;make save file
    call CreateOutputFile
    jc SaveFailed
    mov filehandle, eax
    mov edx, OFFSET playerX ;player position
    mov ecx, 2
    call WriteToFile
    mov edx, OFFSET playerscore;write player score
    mov ecx, 4
    call WriteToFile
    mov edx, OFFSET fuel_amt ;fuel
    mov ecx, 4
    call WriteToFile
    mov edx, OFFSET taxicolor ;taxi color
    mov ecx, 1
    call WriteToFile
    mov edx, OFFSET carrying;target pass
    mov ecx, 4
    call WriteToFile
    mov edx, OFFSET total_dropsoffs;completed
    mov ecx, 4
    call WriteToFile
    mov edx, OFFSET passengercount;pass on board
    mov ecx, 4
    call WriteToFile
    mov edx, OFFSET npc_speed;npc car speed
    mov ecx, 4
    call WriteToFile    
    mov edx, OFFSET difficulty;difficulty
    mov ecx, 1
    call WriteToFile
    
   


        mov edx, OFFSET play_name;playername
        mov ecx, 30
        call WriteToFile
    mov edx, OFFSET board;board
    mov ecx, 400
    call WriteToFile
   


    mov edx, OFFSET passX;passenger data
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
    mov eax, filehandle ;obst data
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
      mov eax, filehandle ;car dataa
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
    
   

   ;bonus data
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
    



  
    mov eax, filehandle;file close
    call CloseFile
    call Clrscr
    mov edx, OFFSET gamesaveprompt
    call WriteString

    call Crlf
    call WaitMsg

    jmp SaveDone
    
SaveFailed:
    ;idek ab kia karon :,(
    
SaveDone:

    pop edx
    pop ecx
    pop eax

    ret


savegame ENDP

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Pause_display PROC

    push eax
    push ecx
    push edx
    mov dh, 8;transparent sa effect
    mov dl, 0
    mov ecx, 10; 10 r grey
    
grey_rows:
    push ecx
    push edx
    
    call Gotoxy
    mov eax, lightGray + (lightGray * 16)
    call settextcolor
    
    mov ecx, 80

grey_cols:
    mov al, ' '
    call WriteChar
    loop grey_cols
    pop edx
    pop ecx
    inc dh
    loop grey_rows
    mov dh, 10;box
    mov dl, 28
    call Gotoxy
    mov eax, yellow + (black * 16)
    call settextcolor
    mov al, '='
    mov ecx, 24


box_top:
    call WriteChar
    loop box_top
    
    mov dh, 11
    mov dl, 28
    call Gotoxy
    mov eax, white + (red * 16)
    call settextcolor
    mov edx, OFFSET pauseTitle
    call WriteString
    mov dh, 12
    mov dl, 28
    call Gotoxy
    mov eax, yellow + (black * 16)
    call settextcolor
    mov al, '='
    mov ecx, 24

box_bottom:
     call WriteChar
    loop box_bottom
    mov dh, 14
    mov dl, 30
    call Gotoxy
    mov eax, lightGreen + (black * 16)
    call settextcolor
    mov edx, OFFSET pauseMsg1
   call WriteString
    mov dh, 15
    mov dl, 28
    call Gotoxy
    mov eax, lightGreen + (black * 16)
    call settextcolor
    mov edx, OFFSET pauseMsg2
    call WriteString
    
    pop edx
    pop ecx
    pop eax

    ret


Pause_display ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

load_game_fromsaved PROC

    push eax
    push ecx
    push edx
    mov edx, OFFSET savegamefilenametxt ;from save file
    call OpenInputFile
    jc couldnt_load
    mov filehandle, eax
    
    ; Read sab
    mov edx, OFFSET playerX
    mov ecx, 2
    call ReadFromFile
    mov edx, OFFSET playerscore
    mov ecx, 4
    call ReadFromFile
    mov edx, OFFSET fuel_amt
    mov ecx, 4
    call ReadFromFile
    mov edx, OFFSET taxicolor
    mov ecx, 1
    call ReadFromFile
    mov edx, OFFSET carrying
    mov ecx, 4
    call ReadFromFile
    mov edx, OFFSET total_dropsoffs
    mov ecx, 4
    call ReadFromFile
    mov edx, OFFSET passengercount
    mov ecx, 4
    call ReadFromFile
    
 


   mov edx, OFFSET npc_speed
    mov ecx, 4
     call ReadFromFile
    mov edx, OFFSET difficulty
    mov ecx, 1
    call ReadFromFile
    mov edx, OFFSET play_name
    mov ecx, 30
    call ReadFromFile
    mov edx, OFFSET board
    mov ecx, 400
    call ReadFromFile
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
    mov framecount, 0 ;reset the frame counter
    mov move_speed_counter, 0
    



    call clrscr
      mov edx, OFFSET gameloadprompt
    call WriteString
    call Crlf
    call WaitMsg
    
    clc  ;clear carry flag parha tha in ror rol sar sal

    jmp loaded
    
couldnt_load:
     call clrscr
    mov edx, OFFSET gameloadprompt1
    call WriteString
    call Crlf
    call WaitMsg
    stc  ; Set carry flag (failure)
    
loaded:
    pop edx
    pop ecx
    pop eax
    ret


load_game_fromsaved ENDP

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;yeh remove to just have some on board dekhlo;TODO

MaintainBonusItems PROC
push eax
push ebx
push ecx
push esi

xor eax, eax
xor ecx, ecx

CountBonus :
       mov ebx, bonuscount
        cmp ecx, ebx
        jge bonus_pickSpawn
        push ecx
        mov esi, ecx
        mov edi, OFFSET bonusonboard
        add edi, esi
        cmp BYTE PTR[edi], 0
        je bonus_counter_skip

        inc eax

   bonus_counter_skip :
        pop ecx
        inc ecx
        jmp CountBonus


   bonus_pickSpawn :
         cmp eax, 3
        jge NoBonusSpawn
        mov eax, bonuscount
        cmp eax, MAX_BONUS
        jge NoBonusSpawn
        mov esi, eax
        push esi
        mov ecx, 100;try 100 times

   find_free_bonus_pos :
        cmp ecx, 0
        je NoBonusSpawn_pop
        push ecx
        call road_position_find
        mov bl, al
        mov bh, ah
        ; pos free
        push eax
        call is_position_occupied
        pop eax
        pop ecx
        cmp al, 1
        je try_again_bonus
       ; bonus place
        pop esi
        mov edi, OFFSET bonusX
        add edi, esi
        mov[edi], bl
        mov edi, OFFSET bonusY
   
         add edi, esi
        mov[edi], bh
        mov edi, OFFSET bonusonboard
        add edi, esi
        mov BYTE PTR[edi], 1
        inc bonuscount
        jmp NoBonusSpawn

    try_again_bonus :
        dec ecx
        jmp find_free_bonus_pos

   NoBonusSpawn_pop :
         pop esi

   NoBonusSpawn :
         pop esi
        pop ecx
        pop ebx
        pop eax
        ret


 MaintainBonusItems ENDP

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
highscores_load PROC
    push eax
    push ecx
    push edx
    push esi
    mov edx, OFFSET filenametxt
    call OpenInputFile
     jc empty_none
    mov filehandle, eax
    mov edx, OFFSET highScores
   mov ecx, 40 ; 4 bytes each 10 scores
    call ReadFromFile
    mov edx, OFFSET highNames
    mov ecx, 300
    call ReadFromFile
 
        mov eax, filehandle
        call CloseFile
        jmp highscores_loaded

    
empty_none:
    mov ecx, 10
    mov esi, OFFSET highScores
    xor eax, eax
    
clearscores:
    mov [esi], eax
    add esi, 4
    dec ecx
    cmp ecx, 0
    jne clearscores
    
highscores_loaded:

    pop esi
    pop edx
    pop ecx
    pop eax
    ret



highscores_load ENDP

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

update_highscores PROC

    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    mov eax, playerscore ; score >0 to store warna nai
    cmp eax, 0
    jle nothing_to_update 
    mov ecx, 10;kahan fit in
    mov esi, OFFSET highScores
    xor ebx, ebx;pos counter
    
position_find:
    cmp ecx, 0
    je insertatend
    mov edx, [esi]
    cmp edx, 0;if slots empty and score acha hai then tu place here
    je place_here
    cmp eax, edx
    jg place_here
    add esi, 4
    inc ebx
    dec ecx

    jmp position_find
    
place_here:
    cmp ebx, 10 ; valid?
    jge nothing_to_update 
   
   push eax;shift scores down
     push ebx
    ;calc shift kitna
    mov eax, 9
    sub eax, ebx;no. to shift
   cmp eax, 0
    jle no_shifting
    mov ecx, eax
   mov esi, OFFSET highScores; neechay say start shift 9 
     add esi, 36 ;(9 * 4) slot 9
    
shift_down:
    push ecx
    mov edx, [esi - 4]

    mov [esi], edx
    sub esi, 4
    pop ecx
    loop shift_down
    
no_shifting:
    pop ebx
    pop eax
    mov esi, OFFSET highScores;insert at ebx pos
    push eax
    mov eax, ebx
    mov edx, 4
    mul edx
    add esi, eax
    pop eax
    mov [esi], eax
    push eax;shift names
    push ebx
    mov eax, 9;calc how many names to shift
    sub eax, ebx
    cmp eax, 0
    jle noshifting_names
    mov ecx, eax
    
    mov esi, OFFSET highNames;start from bottom or 9
    add esi, 270 
    


shift_name_loop:
    push ecx
    push esi
    
    ; Copy 30 bytes from [esi-30] to [esi]
    mov edi, esi
    sub esi, 30
    mov ecx, 30
    
name_copy:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    loop name_copy
        pop esi
        sub esi, 30
        pop ecx
        loop shift_name_loop
    
noshifting_names:
    pop ebx
    pop eax
   mov esi, OFFSET highNames
    push eax
    mov eax, ebx
    mov edx, 30
     mul edx
    add esi, eax
    pop eax
    mov edi, esi
    mov esi, OFFSET play_name
   mov ecx, 30
    
playername_copy:
    mov al, [esi]

    mov [edi], al
    inc esi
    inc edi
    loop playername_copy

        call savehighscores_infile
        jmp nothing_to_update 
    
insertatend:
    ;daalna hi nai not worth it 
    
nothing_to_update :

    pop edi
    pop esi
    pop edx
    pop ecx

    pop ebx
    pop eax

    ret


update_highscores ENDP
 
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
savehighscores_infile PROC

    push eax
    push ecx
    push edx
    mov edx, OFFSET filenametxt ;make file
    call CreateOutputFile
    jc filenotmade
    mov filehandle, eax
    mov eax, filehandle
    mov edx, OFFSET highScores
    mov ecx, 40;10 scores 4*10
    call WriteToFile
    jc close_file
    mov eax, filehandle
    mov edx, OFFSET highNames
    mov ecx, 300;10 names 10*30
    call WriteToFile
    
close_file:
    mov eax, filehandle

    call CloseFile
    jmp savedfile
    
filenotmade:
   
    
savedfile:

    pop edx
    pop ecx
    pop eax
    ret


savehighscores_infile ENDP



;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

leaderboard_display PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    call Clrscr
    
    mov eax, yellow + (black * 16)
    call settextcolor
    mov edx, OFFSET lb1
    call WriteString
    call Crlf
    call Crlf
    mov eax, white + (black * 16)
    call settextcolor
    mov edx, OFFSET lb2
    call WriteString
    call Crlf
    mov edx, OFFSET lb3
    call WriteString
    call Crlf
    mov esi, OFFSET highScores;if not empty
    mov eax, [esi]
    cmp eax, 0
    je empty_scores
    mov ecx, 10;top 10
    xor ebx, ebx
    mov esi, OFFSET highScores
    
display_loop:
    push ecx
    mov eax, [esi];score 0
    cmp eax, 0
    je display_skip
    mov eax, ebx;rank
    inc eax
    call WriteDec
    cmp eax, 10;spacing
    jge space_noextra
    mov al, ' '
    call WriteChar
    
space_noextra:
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar


    push esi;display name
    mov eax, ebx
    mov edx, 30
    mul edx
    mov esi, OFFSET highNames
    add esi, eax
    mov ecx, 30

name_print:
    mov al, [esi]
    cmp al, 0
    je nameprinted
    call WriteChar
    inc esi
    dec ecx

    cmp ecx, 0
    jne name_print
    


nameprinted:
  
name_format:
    cmp ecx, 0
    je formatted
    mov al, ' '
    call WriteChar
    dec ecx
    jmp name_format
    
formatted:
    pop esi
    mov al, ' '
    call WriteChar
    call WriteChar
    mov eax, [esi]
    call WriteDec
    call Crlf
    
display_skip:
    add esi, 4
    inc ebx
    pop ecx
    dec ecx
    cmp ecx, 0
    jne display_loop
    jmp leaderboard_done
    


empty_scores:
    mov edx, OFFSET lb4
    call WriteString
    call Crlf
    
leaderboard_done:
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



leaderboard_display ENDP



;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ChangeDifficulty PROC
    push eax
    push edx
    
    call Clrscr
    
    mov eax, yellow + (black * 16)
    call settextcolor
    mov edx, OFFSET diff1
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, white + (black * 16)
    call settextcolor
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
    jmp difficultydone
    



difficulty_0:
    mov difficulty, 0
    jmp difficultydone
    
difficulty_1:
    mov difficulty, 1
    jmp difficultydone
    
difficulty_2:
    mov difficulty, 2
    
difficultydone:
    pop edx
    pop eax
    ret
ChangeDifficulty ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

END main





