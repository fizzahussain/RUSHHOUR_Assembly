# Rush Hour — Technical Notes

This document expands on the implementation in `proj.asm`. It describes the existing code as written; it does not propose or apply source-code changes.

## 1. Program Structure

The project is implemented in one 32-bit MASM source file and uses `Irvine32.inc` for common console, timing, random-number, and file operations. `winmm.lib` is linked for the Windows `PlaySound` API.

The main control flow begins in `main PROC`, which loads existing high scores and repeatedly displays the main menu. Menu choices branch into new-game setup, save-game continuation, difficulty configuration, leaderboard display, instructions, or exit.

Important procedures include:

| Procedure | Responsibility |
|---|---|
| `main` | Top-level menu and session control |
| `DISPLAY` | Main menu rendering and input |
| `Playerinfo_get` | Player name and taxi selection |
| `initialize_newgame` | Reset state and create a fresh game |
| `difficulty_apply` | Apply fuel, obstacle, and NPC-speed settings |
| `generateBoard` | Create the 20 × 20 road/building map |
| `road_position_find` | Find a usable road tile for spawning |
| `the_gameloop_main` | Main input/update/render loop |
| `moveup_try` / `movedown_try` / `moveleft_try` / `moveright_try` | Player movement |
| `is_position_occupied` | Test a tile against active entities |
| `check_for_collisions` | Passenger, NPC, and bonus collision handling |
| `pickup_dropoff_handling` | Passenger pickup and destination completion |
| `npc_car_move` | Update NPC traffic positions |
| `PASSENGERS_RESPAWN` | Keep passenger tasks available |
| `spawn_more_cars` | Add traffic during difficulty progression |
| `gamemode_selection` | Career, Time, and Endless selection |
| `endless_difficulty_inc` | Endless-mode progression |
| `savegame` / `load_game_fromsaved` | Persist and restore game state |
| `highscores_load` / `update_highscores` / `savehighscores_infile` | Persistent Top 10 scores |

## 2. Board Representation

`BOARD_SIZE` is defined as `20`, and the board is stored as:

```asm
board BYTE 400 DUP(1)
```

Each byte represents one grid cell. The current implementation uses the board primarily to distinguish road cells from building cells.

`generateBoard` begins with all 400 cells marked as roads, performs random building placement, then guarantees road corridors along every fifth row and column. The `(0, 0)` cell is explicitly preserved as a road for the player start.

## 3. Entity Storage

Game entities are stored in parallel fixed-size arrays rather than dynamically allocated structures.

### Player

Key player state includes:

- `playerX`, `playerY`
- `playerscore`
- `fuel_amt`
- `taxicolor`
- `carrying`
- `total_dropsoffs`

### Passengers

Up to five passenger jobs are represented through arrays for:

- pickup positions
- destination positions
- active state
- picked-up state

The `carrying` variable stores the index of the currently carried passenger, or `-1` when the taxi is empty.

### NPC Traffic

Up to eight cars use arrays for position, direction, and active state. `npc_speed` controls how frequently the traffic update occurs.

### Obstacles and Bonuses

Obstacles are capped at ten and bonus items at five. Position and state are again stored in fixed arrays.

## 4. Random Placement

`road_position_find` searches for a valid road location. It makes repeated random attempts, avoids the player start/current position, rejects occupied cells, and falls back to a predefined location if the attempt budget is exhausted.

Most spawns are biased toward the regular road corridors generated around multiples of five, which makes objects more likely to appear near navigable routes.

## 5. Player Movement

Movement is handled by four dedicated procedures. Each procedure validates the destination tile before committing movement.

On a successful move, the game can:

1. update the player's coordinate
2. reduce fuel outside Endless Mode
3. check post-move collisions
4. apply obstacle or traffic penalties
5. process bonus collection

The yellow and red taxis use different movement/collision behavior as encoded by `taxicolor`.

## 6. Passenger Jobs

`pickup_dropoff_handling` handles both phases of a passenger job.

When the taxi is empty, the routine scans active passengers and checks distance from the player. When close enough, it records that passenger as the active carried job.

When carrying a passenger, the routine compares the player's coordinates with that passenger's destination. A successful match:

- deactivates the completed passenger
- adds 10 score points
- clears the carrying state
- respawns passenger jobs as needed
- updates difficulty progression

## 7. Game Modes

`gamemode_selection` writes the selected mode to `currentMode`.

### Career (`currentMode = 0`)

Career has no countdown timer and uses normal fuel consumption.

### Time (`currentMode = 1`)

Time Mode initializes:

```asm
timerSeconds = 120
timerActive  = 1
```

The player attempts to maximize score before the two-minute countdown finishes.

### Endless (`currentMode = 2`)

Endless Mode disables the normal timer and effectively removes fuel pressure. Difficulty increases over time through `endless_difficulty_inc` and the normal delivery progression logic.

## 8. Difficulty

`difficulty_apply` maps the selected difficulty to three main parameters:

| Difficulty | Fuel | Obstacles | `npc_speed` |
|---|---:|---:|---:|
| Easy | 1000 | 5 | 5 |
| Medium | 500 | 7 | 3 |
| Hard | 300 | 10 | 2 |

A smaller `npc_speed` value causes traffic movement updates to occur more frequently in the current loop design.

## 9. Save / Load Format

`savegame` writes binary state data into a file named `savegame.txt` despite the `.txt` extension. The values are written sequentially using Irvine32 file routines.

Stored state includes the player, board, passengers, obstacle arrays, traffic arrays, and bonus arrays. `load_game_fromsaved` reads these values back in the same order.

Because the file format depends on write/read ordering, both routines must stay synchronized if the state layout is ever changed.

## 10. High Scores

The game stores up to ten names and scores in `highscores.txt`. On program start, `highscores_load` attempts to restore the saved table. After eligible sessions, `update_highscores` inserts the new result into leaderboard order before the table is persisted again.

Endless Mode tracks a separate in-session best score and skips the normal leaderboard update path when a new game session ends.

## 11. Audio

The source declares the Windows `PlaySound` function and links `winmm.lib`.

Referenced audio filenames are:

- `start.wav`
- `collision.wav`
- `pickup.wav`
- `bonus_collect.wav`
- `gameover.wav`
- `pause.wav`

These files are not present in the current repository, so audio requires them to be placed in the program's working directory.

## 12. Complexity Notes

The game uses small fixed-size structures, so most costs are bounded in the current build.

Conceptually:

- board rendering is `O(R × C)`
- NPC updates are `O(C)`
- passenger scans are `O(P)`
- collision/occupancy tests are `O(P + O + C + B)`
- leaderboard insertion is `O(H)`
- save/load is linear in the amount of stored state

With the current constants (`20 × 20` board, at most 5 passengers, 10 obstacles, 8 cars, 5 bonuses, and 10 scores), these scans remain small.
