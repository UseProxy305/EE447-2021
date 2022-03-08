PB_INP				EQU	0x400050C0	
PB_OUT				EQU	0x4000503C	
					AREA    	main, READONLY, CODE
					THUMB
					EXTERN		DELAY100		;Delay Subroutine from previous experiment (For debouncing)
					EXTERN		portb_init		;PortB Initialize
					EXPORT  	__main

__main				PROC;
					MOV			R9,#0x01			;Data that will be written
					BL			portb_init			;init port B
					LDR			R5,=PB_OUT
					STR			R9,[R5]
store				LDR			R0,=PB_INP
					LDR			R1,[R0]
					CMP			R1,#0x30
					BEQ			store
					BL			DELAY100		; To put a barrier for debouncing 
					LDR			R2,[R0]
					CMP			R1,R2
					BNE			store
					CMP			R2,#0x20
					BEQ			ccw
					CMP			R2,#0x10
					BEQ			cw
					B			store

					
cw					LDR			R0,=PB_INP
					LDR			R1,[R0]
					CMP			R1,#0x10
					BEQ			cw
					LSR			R9,#1
					CMP			R9,#0x00
					MOVEQ		R9,#0x08
					LDR			R5,=PB_OUT
					STR			R9,[R5]
					BL			DELAY100
					B			store

ccw					LDR			R0,=PB_INP
					LDR			R1,[R0]
					CMP			R1,#0x20
					BEQ			ccw
					LSL			R9,#1
					CMP			R9,#0x10
					MOVEQ		R9,#0x01
					LDR			R5,=PB_OUT
					STR			R9,[R5]					
					BL			DELAY100
					B			store
					



					ALIGN
					ENDP
					END
