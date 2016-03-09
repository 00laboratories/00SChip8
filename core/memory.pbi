;
;- 'memory.pb' Header, generated at 15:38:27 25/01/2015.
;

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
;--  00SChip8 project            --
;----------------------------------
;
; Handles and emulates memory unit
;
; -> Importation of scripts
; -> Memory handling
;
;----------------------------------
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Importation of scripts       >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Memory handling              >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Declare.a memory_GetValue(pointer)
Declare.a memory_SetValue(pointer,char)
Declare.a memory_BSetValue(*buffer,pointer,char)
; Clear game memory, always do this before loading a new ROM image
Declare memory_ClearMemory()
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 41
; FirstLine = 13
; Folding = -
; EnableXP
