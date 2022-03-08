SYSCTL_RCGCGPIO  		EQU 0x400FE608	
GPIO_PORTA_DATA			EQU	0x400043FC	
GPIO_PORTA_DIR   		EQU 0x40004400	
GPIO_PORTA_AFSEL 		EQU 0x40004420	
GPIO_PORTA_DEN   		EQU 0x4000451C	
GPIO_PORTA_PCTL  		EQU 0x4000452C	
GPIO_PORTA_AMSEL 		EQU 0x40004528	

SYSCTL_RCGCSSI			EQU	0x400FE61C
SSI0_CR1				EQU	0x40008004
SSI0_CC					EQU	0x40008FC8	
SSI0_CR0				EQU	0x40008000
SSI0_CPSR				EQU	0x40008010
SSI0_SR					EQU	0x4000800C	
SSI0_DR					EQU	0x40008008


				AREA   main, CODE, READONLY
				THUMB
						
				EXPORT	init_porta
				
init_porta			PUSH	{LR}
					LDR 	R1,=SYSCTL_RCGCSSI
					LDR 	R0,[R1]                   
					ORR		R0,#0x01
					STR 	R0,[R1]                
					NOP
					NOP
					NOP
					LDR 	R1, =SYSCTL_RCGCGPIO
					LDR 	R0, [R1]                   
					ORR		R0, #0x01					
					STR 	R0, [R1]                   
					NOP								
					NOP
					NOP		
;---------------------------PORTS					
					LDR		R1,=GPIO_PORTA_DIR		
					LDR 	R0, [R1]
					ORR		R0, #0xEC				
					STR		R0,[R1]
					LDR		R1,=GPIO_PORTA_DEN		
					LDR 	R0, [R1]
					ORR		R0, #0xFC
					STR		R0,[R1]						
					LDR		R1,=GPIO_PORTA_AFSEL	
					LDR 	R0, [R1]
					ORR		R0, #0x3C				
					STR		R0,[R1]
					LDR		R1,=GPIO_PORTA_PCTL 	
					MOV32	R0, #0x00222200						
					STR		R0,[R1]
					LDR		R1,=GPIO_PORTA_AMSEL	
					LDR 	R0, [R1]
					BIC		R0, #0xFC				
					STR		R0,[R1]

;-----------------------------SSI
					LDR		R1,=SSI0_CR1	;lock SSI	
					MOV		R0,#0x00					 
					STR		R0,[R1]

					LDR		R1,=SSI0_CPSR	
					MOV		R0,#0x04		;prescale value			
					STR		R0,[R1]	
					LDR		R1,=SSI0_CC			
					MOV		R0,#0x05  		;To use PIOSC
					STR		R0,[R1]
					LDR		R1,=SSI0_CR0	
					LDR		R0,[R1]
					ORR		R0,#0x0100		;To be able to get baud rate of 2MHz SCR = 0x01
					STR		R0,[R1]
					LDR		R1,=SSI0_CR0			
					LDR		R0,[R1]					
					BIC		R0, #0x30		;clearing SPH-SPO
					ORR		R0, #0x07		;8-bit data is sending
					STR		R0,[R1]
					
					LDR		R1,=SSI0_CR1	
					LDR		R0,[R1]
					ORR		R0,#0x02		;unlock SSI			
					STR		R0,[R1]
					BL		wait
					POP		{LR}
					BX		LR
	
				
wait				LDR		R1,=SSI0_SR
					LDR		R0,[R1]
					ANDS	R0,#0x10
					BNE		wait
					BX		LR
					ENDP
	