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
; Contains procedures for loading the rom into memory
;
; -> Importation of scripts
; -> Definition of procedures
;
;----------------------------------

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Importation of scripts       >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;IncludeFile("core/memory.pb")

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Definition of procedures     >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Global emulator_isbiosrunning = #False

Procedure rom_loader_LoadRomFile(File.s)
  emulator_isbiosrunning = #False
  
  If ReadFile(0, File.s) ; check if file exists and is readable
    
    ; Set screen size to default chip8
    screen_width = 256
    screen_height = 150
    screen_pwidth = 64
    screen_pheight = 32
    screen_ClearScreen()
    
    ReadData(0, *game_memory+512, Lof(0)) ; read rom file content into game_memory starting at position 512
    
    CloseFile(0)
    
  Else ; file does not exist or is in use then:
    MessageRequester("00SChip8 issue detected","The selected file does not exist anymore or is not accessable.")
  EndIf
EndProcedure

Procedure rom_loader_LoadBIOS()
  emulator_isbiosrunning = #True
  
  ; Set screen size to default chip8
  screen_width = 256
  screen_height = 150
  screen_pwidth = 64
  screen_pheight = 32
  screen_ClearScreen()
  
  CopyMemory(?BIOS, *game_memory+512, 291)
EndProcedure
; IDE Options = PureBasic 5.41 LTS (Windows - x86)
; CursorPosition = 42
; FirstLine = 7
; Folding = -
; EnableXP