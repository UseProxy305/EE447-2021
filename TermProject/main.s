SYSCTRL				EQU			0xE000E010
ARRAY_LENGTH		EQU			0x20000780
DIRECTION			EQU			0x20000790
GPIO_PORTF_DATA 	EQU 		0x40025044 ; data a d d r e s s t o a l l pi n s

;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		Init
			EXTERN		calc
			EXTERN		Init_timer
			EXTERN		DELAY100
			EXTERN		init_screen
			EXPORT  	__main		; Make available

__main		PROC
			LDR			R1,=ARRAY_LENGTH
			MOV			R0,#0
			STR			R0,[R1]
			LDR			R1,=DIRECTION
			MOV			R0,#0x01
			STR			R0,[R1]	
			BL			Init		; Init gpio and adc0
			BL			Init_timer
			BL			init_screen
loop		LDR			R1,=GPIO_PORTF_DATA
			LDR			R0,[R1]
			BL			DELAY100
			LDR			R2,[R1]
			CMP			R0,R2
			BNE			loop		;debounce
			CMP			R0,#0x01
			BEQ			CW
			CMP			R0,#0x10
			BEQ			CCW
			B			loop
			
CW			BL			DELAY100
			LDR			R0,[R1]
			CMP			R0,R2
			BEQ			CW
			LDR			R1,=DIRECTION
			MOV			R0,#0x00
			STR			R0,[R1]
			B			loop
			
CCW			BL			DELAY100
			LDR			R0,[R1]
			CMP			R0,R2
			BEQ			CCW
			LDR			R1,=DIRECTION
			MOV			R0,#0x01
			STR			R0,[R1]
			B			loop
			
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
