;
;- 'intepreter.pb' Header, generated at 15:40:29 25/01/2015.
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
;--  00SChip8 project              --
;----------------------------------
;
; Most important, the intepreter, cpu emulation, memory accessing, game execution
;
; -> Importation of scripts
; -> Definition of variables
; -> Definition of procedures
; -> Opcode intepreter
;
;----------------------------------
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Importation of scripts       >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Definition of variables      >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;     -- General Purpose Registers --
;     -- Special Purpose Registers --
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Definition of procedures     >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Declare intepreter_ResetIntepreter()
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Opcode intepreter            >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Declare intepreter_NextOpcode()
;           intepreter_GPR_RV(15)=0
;           dheight = Hex2Dec(op_i4)
;           dv_i2 = intepreter_GPR_RV(Hex2Dec(op_i2))
;           dv_i3 = intepreter_GPR_RV(Hex2Dec(op_i3))
;           ; ---------------------
;           ; --  CHIP8 DRAWING  --
;           ; ---------------------
;           
;           If dheight > 0 ; not superchip drawing
;           
;             For i2 = 0 To dheight-1
;               sprite.s = Bin(memory_GetValue(intepreter_SPR_I+i2))
;               offsetx.b = 8 - Len(sprite.s)
;               For i3 = 1 To Len(sprite.s)
;       
;                 If Mid(sprite.s,i3,1) = "1"
;                   
;                   x=( dv_i2 +offsetx.b+i3)-1
;                   y=( dv_i3 +i2)
;                   
;                   ; -----------------------
;                   ; --  Screen wrapping  --
;                   ; -----------------------
;                   While y >= screen_pheight
;                     y = y-screen_pheight
;                   Wend
;                   While x >= screen_pwidth
;                     x = x-screen_pwidth
;                   Wend
;                   While y < 0
;                     y = y+screen_pheight
;                   Wend
;                   While x < 0
;                     x = x+screen_pwidth
;                   Wend
;                   
;                   If x<=screen_width And y<=screen_height And x>=0 And y>=0
;                     If screen_pixels( x, y ) = #Black
;                       screen_pixels( x, y ) = #White
;                       ;intepreter_GPR_RV(15)=0 ; Pixel went from unset, to set
;                     ElseIf screen_pixels( x, y ) = #White
;                       screen_pixels( x, y ) = #Black
;                       intepreter_GPR_RV(15)=1 ; Pixel went from set, to unset
;                     EndIf
;                   EndIf
;       
;                 EndIf
;               Next
;             Next
;             
;             ;force_redraw() ; Always redraw instantly in chip8 mode  [S L O W]
;           
;           ; -------------------------
;           ; --  SUPERCHIP DRAWING  --
;           ; -------------------------
;           
;         Else ; draw 16x16 sprite instead
;           dheight=16
;           di2=0
;             For i2 = 0 To dheight-1
;               sprite.s = RSet(Bin(memory_GetValue(intepreter_SPR_I+di2)),8,"0")+RSet(Bin(memory_GetValue(intepreter_SPR_I+di2+1)),8,"0")
;               di2=di2+2
;               offsetx.b = 16 - Len(sprite.s)
;               For i3 = 1 To Len(sprite.s)
;       
;                 If Mid(sprite.s,i3,1) = "1"
;                   
;                   x=( dv_i2 +offsetx.b+i3)-1
;                   y=( dv_i3 +i2)
;                   
;                   ; -----------------------
;                   ; --  Screen wrapping  --
;                   ; -----------------------
;                   While y >= screen_pheight
;                     y = y-screen_pheight
;                   Wend
;                   While x >= screen_pwidth
;                     x = x-screen_pwidth
;                   Wend
;                   While y < 0
;                     y = y+screen_pheight
;                   Wend
;                   While x < 0
;                     x = x+screen_pwidth
;                   Wend
;                   
;                   If x<=screen_pwidth And y<=screen_pheight And x>=0 And y>=0
;                     If screen_pixels( x, y ) = #Black
;                       screen_pixels( x, y ) = #White
;                       ;intepreter_GPR_RV(15)=0 ; Pixel went from unset, to set
;                     ElseIf screen_pixels( x, y ) = #White
;                       screen_pixels( x, y ) = #Black
;                       intepreter_GPR_RV(15)=1 ; Pixel went from set, to unset
;                     EndIf
;                   EndIf
;       
;                 EndIf
;               Next
;             Next
; 
;         EndIf
;       For i=0 To 15
;         While intepreter_GPR_RV(i) < 0
;           intepreter_GPR_RV(i) + 256
;         Wend
;         While intepreter_GPR_RV(i) > 255
;           intepreter_GPR_RV(i) - 256
;         Wend
;       Next
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 712
; FirstLine = 675
; Folding = -
; EnableXP
