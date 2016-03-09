; -----------------------------------------------------------------------------------  ;
;   ______  ______ _            _                                      _               ;
;  / __   |/ __   | |          | |                     _              (_)              ;
; | | //| | | //| | |      ____| | _   ___   ____ ____| |_  ___   ____ _  ____   ___   ;
; | |// | | |// | | |     / _  | || \ / _ \ / ___) _  |  _)/ _ \ / ___) |/ _  ) /___)  ;
; |  /__| |  /__| | |____( ( | | |_) ) |_| | |  ( ( | | |_| |_| | |   | ( (/ / |___ |  ;
;  \_____/ \_____/|_______)_||_|____/ \___/|_|   \_||_|\___)___/|_|   |_|\____) (___/  ;
;                                                                                      ;
;  ----------------------------------------------------------------------------------  ;

;----------------------------------
;--  00SChip8 project              --
;----------------------------------
;
; Entry of application
;
; -> Importation of scripts
; -> Boot initialisation code
; -> Render loop
;
;----------------------------------


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Importation of scripts       >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Enumeration
  #viewport_window
EndEnumeration

IncludeFile("core/variables.pb")                ; Defines variables of both emulator and game
IncludeFile("core/memory.pb")                   ; Handles and emulates memory unit
IncludeFile("core/rom_examinor.pb")             ; Contains procedures for retreiving rom information
IncludeFile("core/rom_loader.pb")               ; Contains procedures for loading the rom into memory
IncludeFile("core/inputs.pb")                   ; Handles chip8 specific input controls
IncludeFile("core/force_draw.pb")
IncludeFile("core/intepreter.pb")               ; Most important, the intepreter, cpu emulation, memory accessing, game execution

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Boot initialisation code     >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Initialize all the sprite enviorment for later use
InitSprite()

; Initialize keyboard enviorment for later use
InitKeyboard()

; Initialize sound enviorment for later use
sound_enabled = InitSound()
;result = LoadSound(#beep_sound, "beep.wav") ; Load a beep sound for chip8
result = CatchSound(#beep_sound, ?BEEP)

; VIEWPORT WINDOW

Enumeration
  ;#viewport_window -> variables.pb
  #main_menu
  
  #menu_open_rom_image
  #menu_start_game
  #menu_reset_game
  #menu_speed_1
  #menu_speed_2
  #menu_speed_3
  #menu_speed_4
  #menu_speed_5
  #menu_speed_6
  #menu_speed_7
  #menu_speed_8
  #menu_speed_normal
  #menu_speed_n1
  #menu_speed_n2
  #menu_speed_n3
  #menu_speed_n4

  #menu_exit
  #menu_website
  #menu_about
EndEnumeration
  
If OpenWindow(#viewport_window, 100,100,  screen_width,screen_height, "00SChip8 - 00laboratories 2011-2016",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget )
  If CreateMenu(#main_menu, WindowID(#viewport_window))
    MenuTitle("&File")
    MenuItem(#menu_open_rom_image, "Open ROM image...")
    MenuBar()
    MenuItem(#menu_exit, "Exit")
    MenuTitle("&Game")
    MenuItem(#menu_start_game, "Start game")
    MenuItem(#menu_reset_game, "Reset game")
    MenuBar()
    OpenSubMenu("Game speed")
    MenuItem(#menu_speed_n4,"-4")
    MenuItem(#menu_speed_n3,"-3")
    MenuItem(#menu_speed_n2,"-2")
    MenuItem(#menu_speed_n1,"-1")
    MenuItem(#menu_speed_normal,"normal")
    MenuItem(#menu_speed_1,"+1")
    MenuItem(#menu_speed_2,"+2")
    MenuItem(#menu_speed_3,"+3")
    MenuItem(#menu_speed_4,"+4")
    MenuItem(#menu_speed_5,"+5")
    MenuItem(#menu_speed_6,"+6")
    MenuItem(#menu_speed_7,"+7")
    MenuItem(#menu_speed_8,"+8")
    CloseSubMenu()
    MenuTitle("&Help")
    MenuItem(#menu_website, "Website...")
    MenuItem(#menu_about, "About...")
  EndIf
  OpenWindowedScreen(WindowID(#viewport_window), 0,0, screen_width,screen_height, 1, 0, 0) ; Rendering screen
EndIf

; Created viewport_window, which is the main window of the emulator

; Set the framerate to 30
SetFrameRate(30)





; SYSTEM SPRITE -> #system_sprite_black256x240

CreateSprite(#system_sprite_blackfill, screen_width, screen_height)
If StartDrawing(SpriteOutput(#system_sprite_blackfill))
 Box(0, 0, screen_width, screen_height, RGB(0, 0, 0))
 StopDrawing()
EndIf

; SYSTEM SPRITE -> #system_test_cube

CreateSprite(#system_test_cube, 28, 20)
If StartDrawing(SpriteOutput(#system_test_cube))
 Box(0, 0, 28, 20, RGB(255, 0, 155))
 Box(5, 5, 10, 10, RGB(155, 0, 255))
 DrawText(0,0,"123") 
 StopDrawing()
EndIf

; SYSTEM SPRITE -> #system_test_cube

CreateSprite(#game_pixel_box, 4, 4)
If StartDrawing(SpriteOutput(#game_pixel_box))
 Box(0, 0, 4, 4, #White)
 StopDrawing()
EndIf

CreateSprite(#game_pixel_box2, 8, 8)
If StartDrawing(SpriteOutput(#game_pixel_box2))
 Box(0, 0, 8, 8, #White)
 StopDrawing()
EndIf

; SYSTEM SPRITE -> #system_00labs_logo

CatchSprite(#system_00labs_logo, ?IDLE_BACKGROUND)


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Render loop                  >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
TICKS_PER_SECOND = 60
SKIP_TICKS = 0;000 / TICKS_PER_SECOND
Global MAX_FRAMESKIP = 20
next_game_tick = ElapsedMilliseconds()
update_loops=0

; LOAD BIOS GAME
memory_ClearMemory() ; -> core/memory.pb
intepreter_ResetIntepreter() ; -> core/intepreter.pb
rom_loader_LoadBIOS()  ; -> core/rom_loader.pb
Global MAX_FRAMESKIP = 20 ; default game speed
emulator_idle = #False ; Not idle anymore, run intepreter again

Repeat
  ;
  ; It's very important to process all the events remaining in the queue at each frame
  ;
  Repeat
    Event = WindowEvent()
      
    Select Event 
      Case #PB_Event_Gadget
        If EventGadget() = 0
          End
        EndIf
      Case #PB_Event_CloseWindow
        End 
    EndSelect
    
    If Event = #PB_Event_Menu
      MenuEvent = EventMenu()
      Select MenuEvent
        Case #menu_start_game
          If tf$
            emulator_idle = #False ; Not idle anymore, run intepreter again
          Else
            MessageRequester("00SChip8","No game was loaded!")
          EndIf
          
        Case #menu_open_rom_image
          tf$=OpenFileRequester("00SChip8, please select a rom to emulate...",GetCurrentDirectory()+"games\","Chip8 ROM|*.*",0)
          If tf$
            memory_ClearMemory() ; -> core/memory.pb
            intepreter_ResetIntepreter() ; -> core/intepreter.pb
            rom_loader_LoadRomFile(tf$)  ; -> core/rom_loader.pb
            Global MAX_FRAMESKIP = 20 ; default game speed
            
            emulator_idle = #False ; Not idle anymore, run intepreter again
          EndIf
          
        Case #menu_about
          MessageRequester("About 00SChip8","Copyright © 00laboratories 2011-2016"+Chr(13)+Chr(10)+"http://www.00laboratories.com/")
          
        Case #menu_reset_game
          If tf$
            memory_ClearMemory() ; -> core/memory.pb
            intepreter_ResetIntepreter() ; -> core/intepreter.pb
            rom_loader_LoadRomFile(tf$) ; -> core/rom_loader.pb
            
            emulator_idle = #False ; Not idle anymore, run intepreter again
          Else
            MessageRequester("00SChip8","No game was loaded!")
          EndIf
          
        Case #menu_exit
          End
          
        Case #menu_website
          RunProgram("http://00laboratories.com/downloads/emulation/chip-8-emulator", "", "", #PB_Program_Wait)
        ; -------------------
        ; --- GAME SPEEDS ---
        ; -------------------
        Case #menu_speed_normal
          MAX_FRAMESKIP = 20
        Case #menu_speed_n1
          MAX_FRAMESKIP = 17
        Case #menu_speed_n2
          MAX_FRAMESKIP = 14
        Case #menu_speed_n3
          MAX_FRAMESKIP = 10
        Case #menu_speed_n4
          MAX_FRAMESKIP = 5
        Case #menu_speed_1
          MAX_FRAMESKIP = 30
        Case #menu_speed_2
          MAX_FRAMESKIP = 45
        Case #menu_speed_3
          MAX_FRAMESKIP = 60
        Case #menu_speed_4
          MAX_FRAMESKIP = 75
        Case #menu_speed_5
          MAX_FRAMESKIP = 90
        Case #menu_speed_6
          MAX_FRAMESKIP = 105
        Case #menu_speed_7
          MAX_FRAMESKIP = 120
        Case #menu_speed_8
          MAX_FRAMESKIP = 140
      EndSelect
    EndIf
    
  Until Event = 0
  
  ; -------------------------
  ; --  FRAME SKIP RESET   --
  ; -------------------------
  update_loops = 0
  

  While ElapsedMilliseconds() > next_game_tick And update_loops < MAX_FRAMESKIP
    next_game_tick = next_game_tick+SKIP_TICKS
    ; -----------------------
    ; --  UPDATE GAME      --
    ; -----------------------
    
    If emulator_idle = #True       ; Display idle splashScreen
      ;If Not direction : direction = 4 : EndIf
      ;x + direction
      ;If x > 240 : direction = -2 : EndIf
      ;If x < 0   : direction =  2 : EndIf
    Else
      
      intepreter_NextOpcode()
      
    EndIf
    
    update_loops = update_loops+1
  Wend
  
  ; -----------------------
  ; --  BUFFER HANDLING  --
  ; -----------------------
  
  FlipBuffers() ; Flip the buffers
  ClearScreen(RGB(0, 0, 0)) ; ClearScreen does not always work on all platforms, to prevent this, draw a black sprite
  DisplaySprite(#system_sprite_blackfill, 0, 0) ; black sprite covering buffer
  
  ; -----------------------
  ; --  DRAW GAME        --
  ; -----------------------
  
  If emulator_isbiosrunning = #True         ; Display idle splashScreen
    DisplaySprite(#system_00labs_logo, 0, 0)
    ;DisplaySprite(#system_test_cube, x, x)
  ;Else
  EndIf 
  
  If screen_width = 256 ; chip 8 mode
    For x=0 To screen_pwidth
      For y = 0 To screen_pheight
        If screen_pixels(x,y)
          If screen_pixels(x,y) = #White
            DisplaySprite(#game_pixel_box2, (x*8), y*8)
          EndIf
        EndIf
      Next
    Next
  Else                  ; super chip mode
    For x=0 To screen_pwidth
      For y = 0 To screen_pheight
        If screen_pixels(x,y)
          If screen_pixels(x,y) = #White
            DisplaySprite(#game_pixel_box, (x*4), y*4)
          EndIf
        EndIf
      Next
    Next
  EndIf

  ;EndIf

ForEver

MessageRequester("This was not supposed to happen", "We appologize for the inconvinience but like.. err, you.. broke out of an infinite loop which is 'impossible'.")

Delay(5000)

DataSection
  BIOS:
    IncludeBinary "resources/bios.ch8"
  IDLE_BACKGROUND:
    IncludeBinary "resources/00laboratories.bmp"
  BEEP:
    IncludeBinary "resources/beep.wav"
EndDataSection
; IDE Options = PureBasic 5.41 LTS (Windows - x86)
; CursorPosition = 325
; FirstLine = 290
; EnableXP