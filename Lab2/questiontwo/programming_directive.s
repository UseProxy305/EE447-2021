PB_INP				EQU	0x4000503C
PB_OUT				EQU	0x400053C0
GPIO_PORTB_DATA 	EQU 0x400053FC ; data a d d r e s s t o a l l pi n s
GPIO_PORTB_DIR 		EQU 0x40005400
GPIO_PORTB_AFSEL 	EQU 0x40005420
GPIO_PORTB_DEN 		EQU 0x4000551C
GPIO_PORTB_PDR		EQU	0x40005514
IOB 				EQU 0xF0
SYSCTL_RCGCGPIO 	EQU 0x400FE608
	

					AREA    	main, READONLY, CODE
					THUMB
					EXTERN		DELAY100
					EXPORT  	__main

__main				PROC;
Start				LDR 		R1,=SYSCTL_RCGCGPIO
					LDR 		R0,[R1]
					ORR 		R0,R0,#0x12
					STR 		R0,[R1]
					NOP
					NOP
					NOP 
					LDR 		R1,=GPIO_PORTB_DIR 
					LDR 		R0,[R1]
					MOV			R0,#0xF0
					STR 		R0,[R1]
					LDR 		R1,=GPIO_PORTB_AFSEL
					LDR 		R0,[R1]
					BIC 		R0,#0xFF
					STR 		R0,[R1]
					LDR 		R1,=GPIO_PORTB_DEN
					LDR 		R0,[R1]
					ORR 		R0,#0xFF
					STR			R0,[R1]
					LDR			R1,=GPIO_PORTB_PDR
					LDR			R0,[R1]
					ORR			R0,#0xF0
					STR 		R0,[R1] 

					MOV			R2,#0
nanInp				LDR			R1,=PB_INP
					LDR			R0,[R1]
					CMP			R0,#0xF
					BEQ			nanInp
					BL			DELAY100
					LDR			R3,[R1]
					CMP			R3,R0
					BNE			nanInp

					CMP			R0,#0x0E
					BEQ			LED1
					CMP			R0,#0x0D
					BEQ			LED2
					CMP			R0,#0x0B
					BEQ			LED3
					CMP			R0,#0x07
					BEQ			LED4
					B			nanInp

LED1				LDR			R4,[R1]
					CMP			R4,R0
					BEQ			LED1
					EOR			R2,R2,#0x10
					LDR			R1,=PB_OUT
					STR			R2,[R1]
					B			nanInp

LED2				LDR			R4,[R1]
					CMP			R4,R0
					BEQ			LED2
					EOR			R2,R2,#0x20
					LDR			R1,=PB_OUT
					STR			R2,[R1]
					B			nanInp
					
LED3				LDR			R4,[R1]
					CMP			R4,R0
					BEQ			LED3				
					EOR			R2,R2,#0x40
					LDR			R1,=PB_OUT
					STR			R2,[R1]
					B			nanInp

LED4				LDR			R4,[R1]
					CMP			R4,R0
					BEQ			LED4
					EOR			R2,R2,#0x80
					LDR			R1,=PB_OUT
					STR			R2,[R1]
					B			nanInp
					
					ALIGN
					ENDP
					END
