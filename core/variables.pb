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
; Defines variables of both emulator and game
;
; -> Importation of scripts
; -> Definition of variables
; -> Variable procedures
;
;----------------------------------

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Importation of scripts       >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Definition of variables      >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;-----------------------
;-- EMULATOR          --
;-----------------------
emulator_idle = #True                     ; If true, displays a splash screen

;-----------------------
;-- GAME              --
;-----------------------
Enumeration
  #beep_sound
EndEnumeration

Global *game_memory = AllocateMemory(32768)
Global sound_enabled = 0
Global tf$ ; rom filename

;-----------------------
;-- DRAWING           --
;-----------------------
Global screen_width = 512
Global screen_height = 280
Global screen_pwidth = 128
Global screen_pheight = 64
Global Dim screen_pixels(screen_pwidth,screen_pheight)

Procedure screen_ClearScreen()
    Global Dim screen_pixels(screen_pwidth,screen_pheight)
    ;ResizeWindow(#viewport_window,#PB_Ignore,#PB_Ignore,screen_width,screen_height)
    ;For x=0 To screen_width  do this again if no more dim screen_pixels
    ;  For y = 0 To screen_height
    ;    screen_pixels(x,y) = #Black
    ;  Next
    ;Next
EndProcedure

; SYSTEM SPRITES

Enumeration
  #system_sprite_blackfill                ; Represents a black sprite covering the screen
  #system_test_cube                       ; Represents a test cube for testing purposes
  #system_00labs_logo                     ; Represents 00laboratories logo for splash screen
  #game_pixel_box
  #game_pixel_box2
EndEnumeration

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Variable procedures          >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Procedure.l Hex2Dec(h$)
  h$=UCase(h$)
  For r=1 To Len(h$)
    d<<4 : a$=Mid(h$, r, 1)
    If Asc(a$)>60
      d+Asc(a$)-55
    Else
      d+Asc(a$)-48
    EndIf
  Next
  ProcedureReturn d
EndProcedure
; IDE Options = PureBasic 5.41 LTS (Windows - x86)
; CursorPosition = 73
; FirstLine = 34
; Folding = -
; EnableXP