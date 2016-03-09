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

Global intepreter_SkipOpcode

;     -- General Purpose Registers --
Global Dim intepreter_GPR_RV.a(15)              ;CPU Registers
Global Dim intepreter_GPR_ST(32)                ;Program stack in depth of 32, for subprocedures
Global intepreter_GPR_SC                        ;Stack pointer
;     -- Special Purpose Registers --
Global intepreter_SPR_PC                        ;Program Counter (PC) 	Holds the memory address of the current CPU instruction
Global intepreter_SPR_I                         ;Memory pointer
Global intepreter_SPR_DT.d                      ;Delay timer, while > 0 delay execution
Global intepreter_SPR_ST                        ;Sound timer, while > 0 play sound
Global intepreter_SPR_SPRW                      ;Sprite width, used in megachip
Global intepreter_SPR_SPRH                      ;Sprite height, used in megachip


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Definition of procedures     >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Procedure intepreter_ResetIntepreter()
  intepreter_SPR_PC = 512                       ;Holds the memory address of the current CPU instruction, reset to 512
  ;Clear registers 0 through F(16)
  For i=0 To 15
    intepreter_GPR_RV(i) = 0
  Next
  ;Clear stack 0 through 32
  For i=0 To 32
    intepreter_GPR_ST(i) = 0
  Next
  ;Reset stack pointer
  intepreter_GPR_SC = 0
  ;Reset memory pointer
  intepreter_SPR_I = 0
  ;Reset intepreter variables
  intepreter_SkipOpcode = #False
  ;Reset SPR Timers
  intepreter_SPR_DT.d=20 ; add delay timer value to prevent ultra speed boost at loading
  intepreter_SPR_ST=0
  ;Clear screen
  screen_ClearScreen()
EndProcedure


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Opcode intepreter            >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Procedure intepreter_NextOpcode()
  
    If intepreter_SPR_DT.d <= 0 ; Only inteprets next command if delay timer finished
    
      ; Create Hex value out of 2 bytes, with a length of 4 character 'FF0A'
      ino_opcode.s = RSet(Hex(memory_GetValue(intepreter_SPR_PC)), 2, "0")+RSet(Hex(memory_GetValue(intepreter_SPR_PC+1)), 2, "0")
      op_i1.s = Mid(ino_opcode.s,1,1)
      op_i2.s = Mid(ino_opcode.s,2,1)
      op_i3.s = Mid(ino_opcode.s,3,1)
      op_i4.s = Mid(ino_opcode.s,4,1)
      
      op_understood = #False ; A value to check if the emulator found an unknown opcode
      
      Select op_i1
          
        Case "0"
          
          Select op_i2
              
            Case "0"
              
              Select op_i3
                  
                Case "1"
                  
                  Select op_i4
                      
                    Case "0"                                        ; Megachip OFF
                      op_understood = #True
                      Global MAX_FRAMESKIP = 20                              ; Slower FPS
                      screen_width = 256
                      screen_height = 150
                      screen_pwidth = 64
                      screen_pheight = 32
                      screen_ClearScreen()
                      MessageRequester("MegaMadness","WHO deactivated megachip?!")
                    Case "1"                                        ; Megachip ON
                      op_understood = #True
                      Global MAX_FRAMESKIP = 75                              ; Higher FPS
                      screen_width = 512
                      screen_height = 280
                      screen_pwidth = 128
                      screen_pheight = 64
                      screen_ClearScreen()
                      MessageRequester("MegaMadness","WHO activated megachip?! I don´t even..")
                  EndSelect
                  
                Case "B"                                              ; Scroll display Value lines up
                  op_understood = #True
                  ; Loop through all vertical pixels from top to bottom
                  h=Hex2Dec(op_i4)
                  For x=0 To screen_pwidth
                    For y = h To screen_pheight
                      screen_pixels(x,y-h) = screen_pixels(x,y)
                      screen_pixels(x,y) = #Black
                    Next
                  Next
                  
                Case "C"                                              ; Scroll display Value lines down
                  op_understood = #True
                  ; Loop through all vertical pixels from bottom to top
                  h=Hex2Dec(op_i4)
                  For x=0 To screen_pwidth
                    For y = 0 To screen_pheight-h
                      ny=(screen_pheight-h)-y ; reverse
                      ;If screen_pixels(x,ny)
                        screen_pixels(x,ny+h) = screen_pixels(x,ny)
                        screen_pixels(x,ny) = #Black
                      ;EndIf
                    Next
                  Next
                  
                Case "E"
                  
                  Select op_i4
                      
                    Case "0"                                          ; Clear the screen
                      op_understood = #True
                      ;Clear screen
                      screen_ClearScreen()
                    Case "E"                                          ; Return from a subroutine
                      op_understood = #True
                      ; Decrement Stack pointer
                      intepreter_GPR_SC = intepreter_GPR_SC-1
                      ; Set current Program Counter to pop of Stack
                      intepreter_SPR_PC = intepreter_GPR_ST(intepreter_GPR_SC)
                  EndSelect
                  
                Case "F"
                  
                  Select op_i4
                      
                    Case "B"                                          ; Scroll display 4 pixels right
                      op_understood = #True
                      ; Loop through all vertical pixels from right to left
                      For x=4 To screen_pwidth
                        For y = 0 To screen_pheight
                            nx=screen_pwidth-x ; reverse
                            screen_pixels(nx+4,y) = screen_pixels(nx,y)
                            screen_pixels(nx,y) = #Black
                        Next
                      Next
                    Case "C"                                          ; Scroll display 4 pixels left
                      op_understood = #True
                      ; Loop through all vertical pixels from left to right
                      For x=4 To screen_pwidth
                        For y = 0 To screen_pheight
                            screen_pixels(x-4,y) = screen_pixels(x,y)
                            screen_pixels(x,y) = #Black
                        Next
                      Next
                      
                    Case "D"                                          ; Exit CHIP interpreter
                      op_understood = #True
                      ; I guess this is a reboot, let's reboot
                      memory_ClearMemory() ; -> core/memory.pb
                      intepreter_ResetIntepreter() ; -> core/intepreter.pb
                      rom_loader_LoadRomFile(tf$) ; -> core/rom_loader.pb
                    Case "E"                                          ; Disable extended screen mode
                      op_understood = #True
                      Global MAX_FRAMESKIP = 20                              ; Slower FPS
                      screen_width = 256
                      screen_height = 150
                      screen_pwidth = 64
                      screen_pheight = 32
                      screen_ClearScreen()
                    Case "F"                                          ; Enable extended screen mode for full-screen graphics
                      op_understood = #True
                      Global MAX_FRAMESKIP = 75                              ; Higher FPS
                      screen_width = 512
                      screen_height = 280
                      screen_pwidth = 128
                      screen_pheight = 64
                      screen_ClearScreen()
                  EndSelect
                  
              EndSelect
              
            Case "1"                                                  ; [MEGA] I=(nn<<16)+nnnn , PC+=2;	(LDHI  I,nnnnnn , always follow LDHI with a NOP)
              op_understood = #True
              
            Case "2"                                                  ; [MEGA] Load nn-colors palette at I    (LDPAL nn)
              op_understood = #True
              
            Case "3"                                                  ; [MEGA] Set Sprite-width to nn		(SPRW  nn)
              op_understood = #True
              
            Case "4"                                                  ; [MEGA] Set Sprite-height to nn	(SPRH  nn)
              op_understood = #True
              
            Case "5"                                                  ; [MEGA] Set Screenalpha to nn		(ALPHA nn, will become FADE nn)
              op_understood = #True
              
            Case "6"                                                  ; [MEGA] Play digitised sound at I	(DIGISND), will add n for loop/noloop
              op_understood = #True
              
            Case "7"                                                  ; [MEGA] Stop digitised sound 		(STOPSND)
              op_understood = #True
              
            Case "8"                                                  ; [MEGA] Set sprite blendmode 		(BMODE n) (0=normal,1=25%,2=50%,3=75%,4=addative,5=multiply)
              op_understood = #True
              
          EndSelect
          
        Case "1"                                                      ; Jump to address
          op_understood = #True
          intepreter_SPR_PC = Hex2Dec(op_i2+op_i3+op_i4)
          ; Don't go to next opcode
          intepreter_SkipOpcode = #True
        Case "2"                                                      ; Call subroutine
          op_understood = #True
          ; Store current Program Counter in Stack
          intepreter_GPR_ST(intepreter_GPR_SC) = intepreter_SPR_PC
          ; Increment Stack pointer
          intepreter_GPR_SC = intepreter_GPR_SC+1
          ; Jump to subprocedure memory location
          intepreter_SPR_PC = Hex2Dec(op_i2+op_i3+op_i4)
          ; Don't go to next opcode
          intepreter_SkipOpcode = #True
        Case "3"                                                      ; Skip the next instruction if RV equals Value
          op_understood = #True
          If intepreter_GPR_RV(Hex2Dec(op_i2)) = Hex2Dec(op_i3+op_i4)
            ; Increase the Program Counter, skipping the next OpCode
            intepreter_SPR_PC = intepreter_SPR_PC + 2
          EndIf
        Case "4"                                                      ; Skip the next instruction if RV doesn't equal Value
          op_understood = #True
          If intepreter_GPR_RV(Hex2Dec(op_i2)) <> Hex2Dec(op_i3+op_i4)
            ; Increase the Program Counter, skipping the next OpCode
            intepreter_SPR_PC = intepreter_SPR_PC + 2
          EndIf
        Case "5"                                                      ; Skip the next instruction if RV equals other RV
          op_understood = #True
          If intepreter_GPR_RV(Hex2Dec(op_i2)) = intepreter_GPR_RV(Hex2Dec(op_i3))
            ; Increase the Program Counter, skipping the next OpCode
            intepreter_SPR_PC = intepreter_SPR_PC + 2
          EndIf
        Case "6"                                                      ; Set RV to Value
          op_understood = #True
          ; Set Register Variable to Value
          intepreter_GPR_RV(Hex2Dec(op_i2)) = Hex2Dec(op_i3+op_i4)
        Case "7"                                                      ; Add Value to RV
          op_understood = #True
          vx.a = intepreter_GPR_RV(Hex2Dec(op_i2))
          vy.a = Hex2Dec(op_i3+op_i4)
          
          ! MOV AL, [p.v_vx]
          ! ADD [p.v_vy], AL
          
          intepreter_GPR_RV(Hex2Dec(op_i2)) = vy ; result
        Case "8"
          
          Select op_i4
              
            Case "0"                                                  ; Set RV to an other RV
              op_understood = #True
              ; Set Register Variable to an other Register Variable
              intepreter_GPR_RV(Hex2Dec(op_i2)) = intepreter_GPR_RV(Hex2Dec(op_i3))
            Case "1"                                                  ; Set RV to RV "or" an other RV
              op_understood = #True
              intepreter_GPR_RV(Hex2Dec(op_i2)) = intepreter_GPR_RV(Hex2Dec(op_i2)) | intepreter_GPR_RV(Hex2Dec(op_i3))
            Case "2"                                                  ; Set RV to RV "and" an other RV
              op_understood = #True
              intepreter_GPR_RV(Hex2Dec(op_i2)) = intepreter_GPR_RV(Hex2Dec(op_i2)) & intepreter_GPR_RV(Hex2Dec(op_i3))
            Case "3"                                                  ; Set RV to RV "Xor" an other RV
              op_understood = #True
              intepreter_GPR_RV(Hex2Dec(op_i2)) = intepreter_GPR_RV(Hex2Dec(op_i2)) ! intepreter_GPR_RV(Hex2Dec(op_i3))
            Case "4"                                                  ; Add RV to an other RV. RV(15) is set to 1 when there's a carry, And To 0 when there isn't
              op_understood = #True
              vx.a = intepreter_GPR_RV(Hex2Dec(op_i2))
              vy.a = intepreter_GPR_RV(Hex2Dec(op_i3))
              
              ! MOV AL, [p.v_vx]
              ! ADD byte [p.v_vy], AL
              ! JC ll_intepreter_nextopcode_op8xx4_carry
              
              ; NO CARRY:
              intepreter_GPR_RV(15) = 0
              Goto OP8XX4_FINISH
              
              OP8XX4_CARRY:
              intepreter_GPR_RV(15) = 1
              Goto OP8XX4_FINISH
              
              OP8XX4_FINISH:
              intepreter_GPR_RV(Hex2Dec(op_i2)) = vy ; result
              
            Case "5"                                                  ; Subtract an other RV from RV. RV(15) is set to 0 when there's a borrow, and to 1 when there isn't
              op_understood = #True
              vx.a = intepreter_GPR_RV(Hex2Dec(op_i3))
              vy.a = intepreter_GPR_RV(Hex2Dec(op_i2))
              
              ! MOV AL, [p.v_vx]
              ! SUB byte [p.v_vy], AL
              ! JC ll_intepreter_nextopcode_op8xx5_carry
              
              ; NO CARRY:
              intepreter_GPR_RV(15) = 1
              Goto OP8XX5_FINISH
              
              OP8XX5_CARRY:
              intepreter_GPR_RV(15) = 0
              Goto OP8XX5_FINISH
              
              OP8XX5_FINISH:
              intepreter_GPR_RV(Hex2Dec(op_i2)) = vy ; result

            Case "6"                                                  ; Shift RV right by one. RV(15) is set to the value of the least significant bit of RV before the shift
              op_understood = #True
              vx.a = intepreter_GPR_RV(Hex2Dec(op_i2))
              intepreter_GPR_RV(15) = intepreter_GPR_RV(Hex2Dec(op_i2)) & %00000001
              
              ! MOV AL, [p.v_vx]
              ! SHR AL, 1
              ! MOV byte [p.v_vx], AL
              
              intepreter_GPR_RV(Hex2Dec(op_i2)) = vx ; result
              
            Case "7"                                                  ; Sets RV to RV minus other RV. RV(15) is set to 0 when there's a borrow, and 1 when there isn't.
              op_understood = #True
              vx.a = intepreter_GPR_RV(Hex2Dec(op_i2))
              vy.a = intepreter_GPR_RV(Hex2Dec(op_i3))
              
              ! MOV AL, [p.v_vx]
              ! SUB byte [p.v_vy], AL
              ! JC ll_intepreter_nextopcode_op8xx7_carry
              
              ; NO CARRY:
              intepreter_GPR_RV(15) = 1
              Goto OP8XX7_FINISH
              
              OP8XX7_CARRY:
              intepreter_GPR_RV(15) = 0
              Goto OP8XX7_FINISH
              
              OP8XX7_FINISH:
              intepreter_GPR_RV(Hex2Dec(op_i2)) = vy ; result
              
            Case "E"                                                  ; Shift RV left by one. RV(15) is set to the value of the most significant bit of RV before the shift
              op_understood = #True
              vx.a = intepreter_GPR_RV(Hex2Dec(op_i2))
              intepreter_GPR_RV(15) = Bool((intepreter_GPR_RV(Hex2Dec(op_i2)) & %10000000) > 0)
              
              ! MOV AL, [p.v_vx]
              ! SHL AL, 1
              ! MOV byte [p.v_vx], AL
              
              intepreter_GPR_RV(Hex2Dec(op_i2)) = vx ; result
          EndSelect
          
        Case "9"                                                      ; Skip the next instruction if RV doesn't equal other RV
          op_understood = #True
          If intepreter_GPR_RV(Hex2Dec(op_i2)) <> intepreter_GPR_RV(Hex2Dec(op_i3))
            ; Increase the Program Counter, skipping the next OpCode
            intepreter_SPR_PC = intepreter_SPR_PC + 2
          EndIf
        Case "A"                                                      ; Set memory pointer to adress
          op_understood = #True
          intepreter_SPR_I = Hex2Dec(op_i2+op_i3+op_i4)
        Case "B"                                                      ; Jump to an address plus RV(0)
          op_understood = #True
          intepreter_SPR_PC = Hex2Dec(op_i2+op_i3+op_i4) + intepreter_GPR_RV(0)
          ; Don't go to next opcode
          intepreter_SkipOpcode = #True
        Case "C"                                                      ; Set RV to a random number and Value
          op_understood = #True
          R = Random(255) & Hex2Dec(op_i3+op_i4)
          intepreter_GPR_RV(Hex2Dec(op_i2)) = R
        Case "D"                                                      ; Draw pixel/sprite, RV(16) is set to 1 if any screen pixels are flipped from set to unset when the sprite is drawn, and to 0 if that doesn't happen
          op_understood = #True
          
          intepreter_GPR_RV(15)=0
          
          If Hex2Dec(op_i4) = 0
            For y = 0 To 15
              ; Get Next binary line of the sprite in memory
              MI.l = intepreter_SPR_I + (y * 2)
              Binary$ = RSet(Bin(memory_GetValue(MI)), 8, "0") + RSet(Bin(memory_GetValue(MI +1)), 8, "0")
              
              For x = 0 To 15
                If Mid(Binary$, x+1, 1) = "1"
                  draw_x.l = intepreter_GPR_RV(Hex2Dec(op_i2)) + x
                  draw_y.l = intepreter_GPR_RV(Hex2Dec(op_i3)) + y
                  
                  While draw_x >= screen_pwidth
                    draw_x - screen_pwidth
                  Wend
                  While draw_y >= screen_pheight
                    draw_y - screen_pheight
                  Wend
                  
                  If screen_pixels( draw_x, draw_y ) = #Black
                    screen_pixels( draw_x, draw_y ) = #White
                    ;intepreter_GPR_RV(15)=0 ; Pixel went from unset, to set
                  ElseIf screen_pixels( draw_x, draw_y ) = #White
                    screen_pixels( draw_x, draw_y ) = #Black
                    intepreter_GPR_RV(15)=1 ; Pixel went from set, to unset
                  EndIf
                  
                EndIf
              Next
            Next
          Else
            For y = 0 To Hex2Dec(op_i4)-1
              ; Get Next binary line of the sprite in memory
              MI.l = intepreter_SPR_I + y
              Binary$ = RSet(Bin(memory_GetValue(MI)), 8, "0")
              For x = 0 To 7
                If Mid(Binary$, x+1, 1) = "1"
                  draw_x.l = intepreter_GPR_RV(Hex2Dec(op_i2)) + x
                  draw_y.l = intepreter_GPR_RV(Hex2Dec(op_i3)) + y
                  
                  While draw_x >= screen_pwidth
                    draw_x - screen_pwidth
                  Wend
                  While draw_y >= screen_pheight
                    draw_y - screen_pheight
                  Wend
                  
                  If screen_pixels( draw_x, draw_y ) = #Black
                    screen_pixels( draw_x, draw_y ) = #White
                    ;intepreter_GPR_RV(15)=0 ; Pixel went from unset, to set
                  ElseIf screen_pixels( draw_x, draw_y ) = #White
                    screen_pixels( draw_x, draw_y ) = #Black
                    intepreter_GPR_RV(15)=1 ; Pixel went from set, to unset
                  EndIf
                 
                EndIf
              Next
            Next
          EndIf
          
          
          
          

          
          
          
          
          
          
          
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
          
          
        Case "E"
          
          Select op_i3
              
            Case "9"
              
              Select op_i4
                  
                Case "E"                                            ; Skip the next instruction if the key stored in RV is pressed
                  op_understood = #True
                  If inputs_KeyPressed(intepreter_GPR_RV(Hex2Dec(op_i2))) = 1
                    ; Increase the Program Counter, skipping the next OpCode
                    intepreter_SPR_PC = intepreter_SPR_PC + 2
                  EndIf
                    
              EndSelect
                
            Case "A"
              
              Select op_i4
                  
                Case "1"                                            ; Skip the next instruction if the key stored in RV isn't pressed
                  op_understood = #True
                  If inputs_KeyPressed(intepreter_GPR_RV(Hex2Dec(op_i2))) = 0
                    ; Increase the Program Counter, skipping the next OpCode
                    intepreter_SPR_PC = intepreter_SPR_PC + 2
                  EndIf
                    
              EndSelect
              
          EndSelect
          
        Case "F"
          
          Select op_i3
              
            Case "0"
              
              Select op_i4
                  
                Case "7"                                              ; Set RV to the value of the delay timer
                  op_understood = #True
                  intepreter_GPR_RV(Hex2Dec(op_i2)) = Round(intepreter_SPR_DT.d,#PB_Round_Nearest)
                Case "A"                                              ; A key press is awaited, and then stored in RV
                  op_understood = #True
                  result = inputs_KeyFind()
                  If result < 255 ; nothing found = 255
                    intepreter_GPR_RV(Hex2Dec(op_i2)) = result
                  Else
                      ; Decrease the Program Counter, returning to previous OpCode
                      intepreter_SPR_PC = intepreter_SPR_PC - 2
                  EndIf
              EndSelect
              
            Case "1"
              
              Select op_i4
                  
                Case "5"                                              ; Set the delay timer to RV
                  op_understood = #True
                  intepreter_SPR_DT.d = intepreter_GPR_RV(Hex2Dec(op_i2))
                Case "8"                                              ; Set the sound timer to RV
                  op_understood = #True
                  intepreter_SPR_ST = intepreter_GPR_RV(Hex2Dec(op_i2))
                Case "E"                                              ; Add RV to memory pointer
                  op_understood = #True
                  intepreter_SPR_I = intepreter_SPR_I + intepreter_GPR_RV(Hex2Dec(op_i2))
                         ;Check FX1E (I = I + VX) buffer overflow. If buffer overflow, register 
                         ;VF must be set To 1, otherwise 0. As a result, register VF Not set To 1.
                         ;This undocumented feature of the Chip-8 And used by Spacefight 2019! 
                         ;game.
                  If intepreter_SPR_I >= 4096
                    intepreter_GPR_RV(15)=1
                  Else
                    intepreter_GPR_RV(15)=0
                  EndIf
              EndSelect
              
            Case "2"
              
              Select op_i4
                  
                Case "9"                                              ; Set the memory pointer to the location of the sprite for the character in RV. Characters 0-F (in hexadecimal) are represented by a 4x5 font
                  op_understood = #True
                  intepreter_SPR_I = intepreter_GPR_RV(Hex2Dec(op_i2))*5 ; starting at 0, then val*5
              EndSelect
              
            Case "3"
              
              Select op_i4
                  
                Case "0"                                             ; Set the memory pointer to 10-byte font sprite for digit RV (0..9) henry: also added A..F
                  op_understood = #True
                  intepreter_SPR_I = 80+(intepreter_GPR_RV(Hex2Dec(op_i2))*10) ; skip to 80 because of other sprites
                  
                Case "3"                                             ; Store the Binary-coded decimal representation of RV, with the most significant of three digits at the address in the memory pointer, the middle digit at the memory pointer plus 1, and the least significant digit at the memory pointer plus 2
                  op_understood = #True
                  
                  number.s = RSet(Str(intepreter_GPR_RV(Hex2Dec(op_i2))),3,"0")
                  memory_SetValue(intepreter_SPR_I,Val(Mid(number.s,1,1)))
                  memory_SetValue(intepreter_SPR_I+1,Val(Mid(number.s,2,1)))
                  memory_SetValue(intepreter_SPR_I+2,Val(Mid(number.s,3,1)))
                  
              EndSelect
              
            Case "5"
              
              Select op_i4
                  
                Case "5"                                              ; Stores RV(0) to RV in memory starting at address pointed to by memory pointer.
                  op_understood = #True
                  ; Loop through variables 0 to requested RV ( id )
                  For i=0 To Hex2Dec(op_i2)
                    memory_SetValue(intepreter_SPR_I+i, intepreter_GPR_RV(i)) ; Change value in memory
                  Next
                  
              EndSelect
              
            Case "6"
              
              Select op_i4
                  
                Case "5"                                              ; Fills RV(0) to RV with memory starting at address pointed to by memory pointer.
                  op_understood = #True
                  ; Loop through variables 0 to requested RV ( id )
                  For i=0 To Hex2Dec(op_i2)
                    intepreter_GPR_RV(i) = memory_GetValue(intepreter_SPR_I+i) ; Retreive value from memory
                  Next
                  
              EndSelect
              
            Case "7"
              
              Select op_i4
                  
                  Case "5"                                            ; Store RV(0)..RV in RPL user flags (X <= 7)
                  op_understood = #True
                  ; Loop through variables 0 to requested RV ( id )
                  For i=0 To Hex2Dec(op_i2)
                    memory_SetValue(240+i, intepreter_GPR_RV(i)) ; Change value in memory
                  Next
                    
              EndSelect
              
            Case "8"
              
              Select op_i4
                  
                  Case "5"                                            ; Read RV(0)..RV in RPL user flags (X <= 7)
                  op_understood = #True
                  ; Loop through variables 0 to requested RV ( id )
                  For i=0 To Hex2Dec(op_i2)
                    intepreter_GPR_RV(i) = memory_GetValue(240+i) ; Retreive value from memory
                  Next
                    
              EndSelect
              
          EndSelect
          
          
      EndSelect
      
      If op_understood = #False ; this happends on detecting an unknown opcode
        If op_i1+op_i2+op_i3+op_i4 <> "0000" ; stop being dumb
          Debug "unknown opcode: "+op_i1+op_i2+op_i3+op_i4
        EndIf
      EndIf
      
      ; If allowed to jump to next opcode, we increase the Program Counter
      If intepreter_SkipOpcode = #False
        intepreter_SPR_PC = intepreter_SPR_PC + 2
      EndIf
      intepreter_SkipOpcode = #False ; Set to false again
      
      If intepreter_SPR_ST > 0
        intepreter_SPR_ST = intepreter_SPR_ST - 1 ; Decrease sound timer
        SetSoundFrequency(#beep_sound, 45000+(intepreter_SPR_ST*100))
        PlaySound(#beep_sound,0,25); Play beep sound
      EndIf
      
      ; -- keep registers within range
;       For i=0 To 15
;         While intepreter_GPR_RV(i) < 0
;           intepreter_GPR_RV(i) + 256
;         Wend
;         While intepreter_GPR_RV(i) > 255
;           intepreter_GPR_RV(i) - 256
;         Wend
;       Next
      
      
    Else  
      intepreter_SPR_DT.d = intepreter_SPR_DT.d - 0.1 ; Decrease delay timer
    EndIf

EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 712
; FirstLine = 675
; Folding = -
; EnableXP