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
; Handles chip8 specific input controls
;
; -> Importation of scripts
; -> Input procedures
;
;----------------------------------

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Importation of scripts       >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Input procedures             >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Procedure.c inputs_KeyPressed(code)
  ExamineKeyboard() ; Update keyboard values
  
  Select code
    Case 0
      If KeyboardPushed(#PB_Key_V)
        ProcedureReturn 1
      EndIf
    Case 1
      If KeyboardPushed(#PB_Key_3)
        ProcedureReturn 1
      EndIf
    Case 2
      If KeyboardPushed(#PB_Key_4)
        ProcedureReturn 1
      EndIf
    Case 3
      If KeyboardPushed(#PB_Key_5)
        ProcedureReturn 1
      EndIf
    Case 4
      If KeyboardPushed(#PB_Key_E)
        ProcedureReturn 1
      EndIf
    Case 5
      If KeyboardPushed(#PB_Key_R)
        ProcedureReturn 1
      EndIf
    Case 6
      If KeyboardPushed(#PB_Key_T)
        ProcedureReturn 1
      EndIf
    Case 7
      If KeyboardPushed(#PB_Key_D)
        ProcedureReturn 1
      EndIf
    Case 8
      If KeyboardPushed(#PB_Key_F)
        ProcedureReturn 1
      EndIf
    Case 9
      If KeyboardPushed(#PB_Key_G)
        ProcedureReturn 1
      EndIf
    Case 10
      If KeyboardPushed(#PB_Key_C)
        ProcedureReturn 1
      EndIf
    Case 11
      If KeyboardPushed(#PB_Key_B)
        ProcedureReturn 1
      EndIf
    Case 12
      If KeyboardPushed(#PB_Key_6)
        ProcedureReturn 1
      EndIf
    Case 13
      If KeyboardPushed(#PB_Key_Y) Or KeyboardPushed(#PB_Key_Z) ; german keyboard
        ProcedureReturn 1
      EndIf
    Case 14
      If KeyboardPushed(#PB_Key_H)
        ProcedureReturn 1 
      EndIf
    Case 15
      If KeyboardPushed(#PB_Key_N)
        ProcedureReturn 1
      EndIf
    Case 16
      If KeyboardPushed(#PB_Key_7)
        ProcedureReturn 1
      EndIf
  EndSelect
  
  ProcedureReturn 0
EndProcedure

Procedure.c inputs_KeyFind() ; Tries to find a pressed key and returns it, chip8
  ExamineKeyboard() ; Update keyboard values
  
      If KeyboardPushed(#PB_Key_V)
        ProcedureReturn 0
      EndIf
      If KeyboardPushed(#PB_Key_3)
        ProcedureReturn 1
      EndIf
      If KeyboardPushed(#PB_Key_4)
        ProcedureReturn 2
      EndIf
      If KeyboardPushed(#PB_Key_5)
        ProcedureReturn 3
      EndIf
      If KeyboardPushed(#PB_Key_E)
        ProcedureReturn 4
      EndIf
      If KeyboardPushed(#PB_Key_R)
        ProcedureReturn 5
      EndIf
      If KeyboardPushed(#PB_Key_T)
        ProcedureReturn 6
      EndIf
      If KeyboardPushed(#PB_Key_D)
        ProcedureReturn 7
      EndIf
      If KeyboardPushed(#PB_Key_F)
        ProcedureReturn 8
      EndIf
      If KeyboardPushed(#PB_Key_G)
        ProcedureReturn 9
      EndIf
      If KeyboardPushed(#PB_Key_C)
        ProcedureReturn 10
      EndIf
      If KeyboardPushed(#PB_Key_B)
        ProcedureReturn 11
      EndIf
      If KeyboardPushed(#PB_Key_6)
        ProcedureReturn 12
      EndIf
      If KeyboardPushed(#PB_Key_Y) Or KeyboardPushed(#PB_Key_Z) ; german keyboard
        ProcedureReturn 13
      EndIf
      If KeyboardPushed(#PB_Key_H)
        ProcedureReturn 14
      EndIf
      If KeyboardPushed(#PB_Key_N)
        ProcedureReturn 15
      EndIf
      If KeyboardPushed(#PB_Key_7)
        ProcedureReturn 16
      EndIf
  
  ProcedureReturn 255
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 150
; FirstLine = 123
; Folding = -
; EnableXP