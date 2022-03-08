DATA_PORTA			EQU	0x400043FC	

SSI0SR					EQU	0x4000800C	
SSI0DR					EQU	0x40008008


					AREA   main, CODE, READONLY
					THUMB
					
					EXTERN	init_porta
					EXPORT	init_screen
					EXPORT	PrintR5
					EXPORT	CursorSettings
	
init_screen			PUSH	{LR}
					BL		init_porta
					LDR		R1,=DATA_PORTA	
					MOV		R0,#0x00 	
					STR		R0,[R1]
					NOP
					NOP
					NOP
					LDR		R1,=DATA_PORTA		 
					MOV		R0,#0x80			;Reseting	
					STR		R0,[R1]					
					LDR		R1,=DATA_PORTA		;Command Mode
					LDR		R0,[R1]
					BIC		R0,#0x40
					STR		R0,[R1]

					MOV		R5,#0x04			;temporart coefficient
					BL		PrintR5
					MOV		R5,#0x14			;Bias adjustment
					BL		PrintR5					
					MOV		R5,#0x21			;H=1, V=0
					BL		PrintR5	
					MOV		R5,#0xB8			;contrast setting
					BL		PrintR5


					MOV		R5,#0x20			;H=0
					BL		PrintR5
					MOV		R5,#0x0C			;Control Mode
					BL		PrintR5
					BL		wait
					POP		{LR}
					BX		LR

PrintR5				PUSH	{LR}
					BL		wait
					LDR		R1,=SSI0DR
					STRB	R5,[R1]
					POP		{LR}
					BX		LR

;This subroutine is helping to adjusting printing area
CursorSettings		PROC
					PUSH	{R0-R9,LR}
					LDR		R1,=DATA_PORTA		
					LDR		R0,[R1]
					BIC		R0,#0x40				;Command
					STR		R0,[R1]
					MOV		R5,#0x20				
					BL		PrintR5					;H=0		
					MOV		R5,R10					
					ORR		R5,#0x80
					BL		PrintR5					;X address
					MOV		R5,R11					
					ORR		R5,#0x40
					BL		PrintR5					;Y address

					BL		wait

					LDR		R1,=DATA_PORTA		;Data
					LDR		R0,[R1]
					ORR		R0,#0x40
					STR		R0,[R1]
					POP		{R0-R9,LR}
					BX		LR

wait				LDR		R1,=SSI0SR
					LDR		R0,[R1]
					ANDS	R0,#0x10
					BNE		wait
					BX		LR
					ENDP
	