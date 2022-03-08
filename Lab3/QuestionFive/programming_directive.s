PB_INP				EQU	0x400053C0			;To take input
	
					AREA    	main, READONLY, CODE
					THUMB
					EXTERN		DELAY100		;Delay for Buttons
					EXTERN		portb_init		;PortB Initialize 
					EXTERN		IntStart		;Interrupt settings (Given value in the R8)
					EXPORT  	__main

__main				PROC
	
	;Rotation Type will be determined by R10 (1: Clockwise Rotation(Default), 2: Counter Clockwise Rotation)
					MOV			R10,#0x01		
	;R9 begins with 1. Look in my_ST_ISR.file
					MOV			R9,#0x01
					BL			portb_init    ;PORT_B initializer 
					MOV			R8,#10000      ;Default Rotation Speed Value
					BL			IntStart	;Create SysTime
re					LDR			R0,=PB_INP	;Taking input 
					LDR			R1,[R0]
					CMP			R1,#0xF0
					BEQ			re
					BL			DELAY100    ; To put a barrier for debouncing 
					LDR			R2,[R0]
					CMP			R1,R2
					BNE			re			; To put a barrier for debouncing
					
					CMP			R1,#0xF0	; F0 == No button is pressed. Keep going
					BEQ			re
					
					CMP			R1,#0xE0	; E0 == SW1 is pressed => Rotate Counter Clockwise
					BEQ			ccw
					
					CMP			R1,#0xD0    ; D0 == SW2 is pressed => Rotate Clockwise
					BEQ			cw
					
					CMP			R1,#0xB0	; B0 == SW3 is pressed => Rotation Speed is changed to fast
					BEQ			speedup
					
					CMP			R1,#0x70	; 70 == SW4 is pressed => Rotation Speed is changed to slow
					BEQ			speeddown
					
					B			re			; Other cases => dont do anything

ccw					LDR			R2,[R0]
					CMP			R2,R1
					BEQ			ccw			;Wait until key is released
					MOV			R10,#0x02	;Change R10 to 0x02 so that rotation can be in ccw (See my_STR_ISR.s)
					B			re

cw					LDR			R2,[R0]
					CMP			R2,R1
					BEQ			cw			;Wait until key is released
					MOV			R10,#0x01	;Change R10 to 0x01 so that rotation can be in cw (See my_STR_ISR.s)
					B			re
					
speedup				LDR			R2,[R0]
					CMP			R2,R1
					BEQ			speedup		;Wait until key is released
					MOV			R8,#9000	; Set R8 to fast speed value. See InterruptStarter.s
					BL			IntStart
					B			re

speeddown			LDR			R2,[R0]
					CMP			R2,R1
					BEQ			speeddown	;Wait until key is released
					MOV			R8,#30000	; Set R8 to slow speed value. See InterruptStarter.s
					BL			IntStart
					B			re

					ALIGN
					ENDP
					END
