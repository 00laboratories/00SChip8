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
; Handles some drawing functions that couldn't be added elsewhere due to errors
;
; -> Importation of scripts
; -> Drawing procedures
;
;----------------------------------

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Importation of scripts       >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>> Drawing procedures           >>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Procedure force_redraw()
  ; -----------------------
  ; --  BUFFER HANDLING  --
  ; -----------------------
  
  FlipBuffers() ; Flip the buffers
  ClearScreen(RGB(0, 0, 0)) ; ClearScreen does not always work on all platforms, to prevent this, draw a black sprite
  DisplaySprite(#system_sprite_blackfill, 0, 0) ; black sprite covering buffer
  
  ; -----------------------
  ; --  DRAW GAME        --
  ; -----------------------
  
  For x=0 To screen_pwidth
    For y = 0 To screen_pheight
      If screen_pixels(x,y)
        If screen_pixels(x,y) = #White
          DisplaySprite(#game_pixel_box, (x*4), y*4)
        EndIf
      EndIf
    Next
  Next
  
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 29
; FirstLine = 16
; Folding = -
; EnableXP