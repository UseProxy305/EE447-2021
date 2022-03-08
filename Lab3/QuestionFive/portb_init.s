GPIO_PORTB_DIR 		EQU 0x40005400
GPIO_PORTB_AFSEL 	EQU 0x40005420
GPIO_PORTB_DEN 		EQU 0x4000551C
SYSCTL_RCGCGPIO 	EQU 0x400FE608

;PORTS ARE CONNECTED AS 
;IN1 =>pb0 , IN2=>pb1 , IN3=>pb2 , IN4=>pb3
;SW1 =>pb4 , SW2=>pb5 , SW3=>pb6 , SW4=>pb7
					AREA    	main, READONLY, CODE
					THUMB
					EXPORT  	portb_init

portb_init			PROC;
					PUSH		{R0,R1}
Start				LDR 		R1,=SYSCTL_RCGCGPIO
					LDR 		R0,[R1]
					ORR 		R0,R0,#0x2F
					STR 		R0,[R1]
					NOP
					NOP
					NOP 
					LDR 		R1,=GPIO_PORTB_DIR 
					LDR 		R0,[R1]
					MOV			R0,#0x0F
					STR 		R0,[R1]
					LDR 		R1,=GPIO_PORTB_AFSEL
					LDR 		R0,[R1]
					BIC 		R0,#0xFF
					STR 		R0,[R1]
					LDR 		R1,=GPIO_PORTB_DEN
					LDR 		R0,[R1]
					ORR 		R0,#0xFF
					STR			R0,[R1]
					POP			{R0,R1}
					BX			LR