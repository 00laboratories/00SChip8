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


Procedure.a memory_GetValue(pointer)
  ProcedureReturn PeekA(*game_memory+pointer)
EndProcedure

Procedure.a memory_SetValue(pointer,char)
  PokeA(*game_memory+pointer,char)
EndProcedure

Procedure.a memory_BSetValue(*buffer,pointer,char)
  PokeA(*buffer+pointer,char)
EndProcedure

; Clear game memory, always do this before loading a new ROM image
Procedure memory_ClearMemory()
  FillMemory(*game_memory, 32768) ; Clear game_memory
  
  ;Store the Default digits in memory, used by some games for ingame representation
  ;0
  memory_SetValue(0,Val("%11110000"))
  memory_SetValue(1,Val("%10010000"))
  memory_SetValue(2,Val("%10010000"))
  memory_SetValue(3,Val("%10010000"))
  memory_SetValue(4,Val("%11110000"))
  ;1
  memory_SetValue(5,Val("%00100000"))
  memory_SetValue(6,Val("%01100000"))
  memory_SetValue(7,Val("%00100000"))
  memory_SetValue(8,Val("%00100000"))
  memory_SetValue(9,Val("%01110000"))
  ;2
  memory_SetValue(10,Val("%11110000"))
  memory_SetValue(11,Val("%00010000"))
  memory_SetValue(12,Val("%11110000"))
  memory_SetValue(13,Val("%10000000"))
  memory_SetValue(14,Val("%11110000"))
  ;3
  memory_SetValue(15,Val("%11110000"))
  memory_SetValue(16,Val("%00010000"))
  memory_SetValue(17,Val("%11110000"))
  memory_SetValue(18,Val("%00010000"))
  memory_SetValue(19,Val("%11110000"))
  ;4
  memory_SetValue(20,Val("%10010000"))
  memory_SetValue(21,Val("%10010000"))
  memory_SetValue(22,Val("%11110000"))
  memory_SetValue(23,Val("%00010000"))
  memory_SetValue(24,Val("%00010000"))
  ;5
  memory_SetValue(25,Val("%11110000"))
  memory_SetValue(26,Val("%10000000"))
  memory_SetValue(27,Val("%11110000"))
  memory_SetValue(28,Val("%00010000"))
  memory_SetValue(29,Val("%11110000"))
  ;6
  memory_SetValue(30,Val("%11110000"))
  memory_SetValue(31,Val("%10000000"))
  memory_SetValue(32,Val("%11110000"))
  memory_SetValue(33,Val("%10010000"))
  memory_SetValue(34,Val("%11110000"))
  ;7
  memory_SetValue(35,Val("%11110000"))
  memory_SetValue(36,Val("%00010000"))
  memory_SetValue(37,Val("%00100000"))
  memory_SetValue(38,Val("%01000000"))
  memory_SetValue(39,Val("%01000000"))
  ;8
  memory_SetValue(40,Val("%11110000"))
  memory_SetValue(41,Val("%10010000"))
  memory_SetValue(42,Val("%11110000"))
  memory_SetValue(43,Val("%10010000"))
  memory_SetValue(44,Val("%11110000"))
  ;9
  memory_SetValue(45,Val("%11110000"))
  memory_SetValue(46,Val("%10010000"))
  memory_SetValue(47,Val("%11110000"))
  memory_SetValue(48,Val("%00010000"))
  memory_SetValue(49,Val("%11110000"))
  ;A
  memory_SetValue(50,Val("%11110000"))
  memory_SetValue(51,Val("%10010000"))
  memory_SetValue(52,Val("%11110000"))
  memory_SetValue(53,Val("%10010000"))
  memory_SetValue(54,Val("%10010000"))
  ;B
  memory_SetValue(55,Val("%11100000"))
  memory_SetValue(56,Val("%10010000"))
  memory_SetValue(57,Val("%11100000"))
  memory_SetValue(58,Val("%10010000"))
  memory_SetValue(59,Val("%11100000"))
  ;C
  memory_SetValue(60,Val("%11110000"))
  memory_SetValue(61,Val("%10000000"))
  memory_SetValue(62,Val("%10000000"))
  memory_SetValue(63,Val("%10000000"))
  memory_SetValue(64,Val("%11110000"))
  ;D
  memory_SetValue(65,Val("%11100000"))
  memory_SetValue(66,Val("%10010000"))
  memory_SetValue(67,Val("%10010000"))
  memory_SetValue(68,Val("%10010000"))
  memory_SetValue(69,Val("%11100000"))
  ;E
  memory_SetValue(70,Val("%11110000"))
  memory_SetValue(71,Val("%10000000"))
  memory_SetValue(72,Val("%11110000"))
  memory_SetValue(73,Val("%10000000"))
  memory_SetValue(74,Val("%11110000"))
  ;F
  memory_SetValue(75,Val("%11110000"))
  memory_SetValue(76,Val("%10000000"))
  memory_SetValue(77,Val("%11110000"))
  memory_SetValue(78,Val("%10000000"))
  memory_SetValue(79,Val("%10000000"))
  
  ; -- SUPERCHIP IMPLENMENTATION --
  
  ;Store the enlarged default digits in memory, used by superchip games for ingame representation
  ;0
  memory_SetValue(80,Val("%01111110"))
  memory_SetValue(81,Val("%11111111"))
  memory_SetValue(82,Val("%11100011"))
  memory_SetValue(83,Val("%11010011"))
  memory_SetValue(84,Val("%11010011"))
  memory_SetValue(85,Val("%11010011"))
  memory_SetValue(86,Val("%11001011"))
  memory_SetValue(87,Val("%11000111"))
  memory_SetValue(88,Val("%11111111"))
  memory_SetValue(89,Val("%01111110"))
  ;1
  memory_SetValue(90,Val("%00001000"))
  memory_SetValue(91,Val("%00011000"))
  memory_SetValue(92,Val("%00111000"))
  memory_SetValue(93,Val("%01111000"))
  memory_SetValue(94,Val("%00011000"))
  memory_SetValue(95,Val("%00011000"))
  memory_SetValue(96,Val("%00011000"))
  memory_SetValue(97,Val("%00011000"))
  memory_SetValue(98,Val("%00111100"))
  memory_SetValue(99,Val("%01111110"))
  ;2
  memory_SetValue(100,Val("%01111110"))
  memory_SetValue(101,Val("%11111111"))
  memory_SetValue(102,Val("%11000011"))
  memory_SetValue(103,Val("%00000110"))
  memory_SetValue(104,Val("%00001100"))
  memory_SetValue(105,Val("%00011000"))
  memory_SetValue(106,Val("%00110000"))
  memory_SetValue(107,Val("%01100000"))
  memory_SetValue(108,Val("%11111111"))
  memory_SetValue(109,Val("%11111111"))
  ;3
  memory_SetValue(110,Val("%11111110"))
  memory_SetValue(111,Val("%01111111"))
  memory_SetValue(112,Val("%00000011"))
  memory_SetValue(113,Val("%00000011"))
  memory_SetValue(114,Val("%11111111"))
  memory_SetValue(115,Val("%11111111"))
  memory_SetValue(116,Val("%00000011"))
  memory_SetValue(117,Val("%00000011"))
  memory_SetValue(118,Val("%01111111"))
  memory_SetValue(119,Val("%11111110"))
  ;4
  memory_SetValue(120,Val("%00000111"))
  memory_SetValue(121,Val("%00001111"))
  memory_SetValue(122,Val("%00011011"))
  memory_SetValue(123,Val("%00110011"))
  memory_SetValue(124,Val("%01100011"))
  memory_SetValue(125,Val("%11111111"))
  memory_SetValue(126,Val("%11111111"))
  memory_SetValue(127,Val("%00000011"))
  memory_SetValue(128,Val("%00000011"))
  memory_SetValue(129,Val("%00000011"))
  ;5
  memory_SetValue(130,Val("%11111111"))
  memory_SetValue(131,Val("%11111111"))
  memory_SetValue(132,Val("%11000000"))
  memory_SetValue(133,Val("%11111110"))
  memory_SetValue(134,Val("%11111111"))
  memory_SetValue(135,Val("%10000011"))
  memory_SetValue(136,Val("%00000011"))
  memory_SetValue(137,Val("%11000011"))
  memory_SetValue(138,Val("%11111111"))
  memory_SetValue(139,Val("%00111110"))
  ;6
  memory_SetValue(140,Val("%01111100"))
  memory_SetValue(141,Val("%11111111"))
  memory_SetValue(142,Val("%11000011"))
  memory_SetValue(143,Val("%11000000"))
  memory_SetValue(144,Val("%11111110"))
  memory_SetValue(145,Val("%11111111"))
  memory_SetValue(146,Val("%11000011"))
  memory_SetValue(147,Val("%11000011"))
  memory_SetValue(148,Val("%11111111"))
  memory_SetValue(149,Val("%00111100"))
  ;7
  memory_SetValue(150,Val("%11111111"))
  memory_SetValue(151,Val("%01111111"))
  memory_SetValue(152,Val("%00000011"))
  memory_SetValue(153,Val("%00000110"))
  memory_SetValue(154,Val("%00001100"))
  memory_SetValue(155,Val("%00011000"))
  memory_SetValue(156,Val("%00110000"))
  memory_SetValue(157,Val("%01100000"))
  memory_SetValue(158,Val("%11000000"))
  memory_SetValue(159,Val("%11000000"))
  ;8
  memory_SetValue(160,Val("%01111110"))
  memory_SetValue(161,Val("%11111111"))
  memory_SetValue(162,Val("%11000011"))
  memory_SetValue(163,Val("%11000011"))
  memory_SetValue(164,Val("%01111110"))
  memory_SetValue(165,Val("%01111110"))
  memory_SetValue(166,Val("%11000011"))
  memory_SetValue(167,Val("%11000011"))
  memory_SetValue(168,Val("%11111111"))
  memory_SetValue(169,Val("%01111110"))
  ;9
  memory_SetValue(170,Val("%00111100"))
  memory_SetValue(171,Val("%11111111"))
  memory_SetValue(172,Val("%11000011"))
  memory_SetValue(173,Val("%11000011"))
  memory_SetValue(174,Val("%11111111"))
  memory_SetValue(175,Val("%01111111"))
  memory_SetValue(176,Val("%00000011"))
  memory_SetValue(177,Val("%11000011"))
  memory_SetValue(178,Val("%11111111"))
  memory_SetValue(179,Val("%00111110"))
  ;A
  memory_SetValue(180,Val("%01111110"))
  memory_SetValue(181,Val("%11111111"))
  memory_SetValue(182,Val("%11000011"))
  memory_SetValue(183,Val("%11000011"))
  memory_SetValue(184,Val("%11111111"))
  memory_SetValue(185,Val("%11111111"))
  memory_SetValue(186,Val("%11000011"))
  memory_SetValue(187,Val("%11000011"))
  memory_SetValue(188,Val("%11000011"))
  memory_SetValue(189,Val("%11000011"))
  ;B
  memory_SetValue(190,Val("%11111110"))
  memory_SetValue(191,Val("%11111111"))
  memory_SetValue(192,Val("%11000011"))
  memory_SetValue(193,Val("%11000011"))
  memory_SetValue(194,Val("%11111110"))
  memory_SetValue(195,Val("%11111110"))
  memory_SetValue(196,Val("%11000011"))
  memory_SetValue(197,Val("%11000011"))
  memory_SetValue(198,Val("%11111111"))
  memory_SetValue(199,Val("%11111110"))
  ;C
  memory_SetValue(200,Val("%00111110"))
  memory_SetValue(201,Val("%01111111"))
  memory_SetValue(202,Val("%11100000"))
  memory_SetValue(203,Val("%11000000"))
  memory_SetValue(204,Val("%11000000"))
  memory_SetValue(205,Val("%11000000"))
  memory_SetValue(206,Val("%11000000"))
  memory_SetValue(207,Val("%11100000"))
  memory_SetValue(208,Val("%01111111"))
  memory_SetValue(209,Val("%00111110"))
  ;D
  memory_SetValue(210,Val("%11111100"))
  memory_SetValue(211,Val("%11111110"))
  memory_SetValue(212,Val("%11000011"))
  memory_SetValue(213,Val("%11000011"))
  memory_SetValue(214,Val("%11000011"))
  memory_SetValue(215,Val("%11000011"))
  memory_SetValue(216,Val("%11000011"))
  memory_SetValue(217,Val("%11000011"))
  memory_SetValue(218,Val("%11111110"))
  memory_SetValue(219,Val("%11111100"))
  ;E
  memory_SetValue(220,Val("%01111110"))
  memory_SetValue(221,Val("%11111111"))
  memory_SetValue(222,Val("%11000000"))
  memory_SetValue(223,Val("%11000000"))
  memory_SetValue(224,Val("%11111111"))
  memory_SetValue(225,Val("%11111110"))
  memory_SetValue(226,Val("%11000000"))
  memory_SetValue(227,Val("%11000000"))
  memory_SetValue(228,Val("%11111111"))
  memory_SetValue(229,Val("%01111110"))
  ;F
  memory_SetValue(230,Val("%01111111"))
  memory_SetValue(231,Val("%11111110"))
  memory_SetValue(232,Val("%11000000"))
  memory_SetValue(233,Val("%11000000"))
  memory_SetValue(234,Val("%11111110"))
  memory_SetValue(235,Val("%11111100"))
  memory_SetValue(236,Val("%11000000"))
  memory_SetValue(237,Val("%11000000"))
  memory_SetValue(238,Val("%11000000"))
  memory_SetValue(239,Val("%11000000"))
  
  
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 41
; FirstLine = 13
; Folding = -
; EnableXP