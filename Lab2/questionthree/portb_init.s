GPIO_PORTB_DIR 		EQU 0x40005400		;Data address to direction register
GPIO_PORTB_AFSEL 	EQU 0x40005420
GPIO_PORTB_DEN 		EQU 0x4000551C
GPIO_PORTB_PUR		EQU	0x40005510
GPIO_PORTB_PDR		EQU	0x40005514
SYSCTL_RCGCGPIO 	EQU 0x400FE608
					AREA    	main, READONLY, CODE
					THUMB
					EXTERN		DELAY100
					EXPORT  	PORTB_INIT

PORTB_INIT			PROC;
Start				PUSH		{R0,R1}
					LDR 		R1,=SYSCTL_RCGCGPIO
					LDR 		R0,[R1]
					ORR 		R0,R0,#0x02			;Clock initializer for PORT B
					STR 		R0,[R1]
					NOP
					NOP
					NOP	 							;let GPIO clock stabilize
					LDR 		R1,=GPIO_PORTB_DIR 	;config	for direction register 1 means output 0 means input
					LDR 		R0,[R1]
					MOV			R0,#0x0F			;For pb0-3 = Output(L1,L2,L3,L4), pb4-7=Input(R1,R2,R3,R4)
					STR 		R0,[R1]
					LDR 		R1,=GPIO_PORTB_AFSEL
					LDR 		R0,[R1]
					BIC 		R0,#0xFF			;No AFSEL for all pins
					STR 		R0,[R1]
					LDR 		R1,=GPIO_PORTB_DEN
					LDR 		R0,[R1]
					ORR 		R0,#0xFF			;Digital enables for all pins
					STR			R0,[R1]
					LDR			R1,=GPIO_PORTB_PDR
					LDR			R0,[R1]
					ORR			R0,#0xF0			;Pull down registers for Output pins
					STR 		R0,[R1]
					POP			{R0,R1}
					BX			LR
					ENDP
