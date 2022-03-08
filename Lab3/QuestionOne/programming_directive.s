PB_OUT				EQU	0x4000503C
PB_INP				EQU	0x400053C0	

					AREA    	main, READONLY, CODE
					THUMB
					EXTERN		DELAY100
					EXTERN		portb_init
					EXPORT  	__main

__main				PROC;
Start				BL			portb_init

;					MOV			R2,#0x08
					MOV			R2,#0x01
nanInp				LDR			R1,=PB_OUT
					LDR			R0,[R1]
					BL			DELAY100
;					LSR			R2,#1
;					CMP			R2,#0x00
;					MOVEQ		R2,#0x08
					LSL			R2,#1
					CMP			R2,#0x10
					MOVEQ		R2,#0x01
					STR			R2,[R1]
					B			nanInp
					
					ALIGN
					ENDP
					END
