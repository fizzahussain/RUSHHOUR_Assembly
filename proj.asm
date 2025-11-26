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

.code
main PROC
  

END main

