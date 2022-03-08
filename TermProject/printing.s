

				AREA   main, CODE, READONLY
				THUMB
				EXTERN  PrintR5
				EXTERN  CursorSettings					

				EXTERN  DELAY100

NUMBERS			DCB		0x3C, 0x42, 0x81, 0x42, 0x3C ;0
				DCB		0x00, 0x00, 0xFF, 0x00, 0x00 ;1
				DCB		0xE1, 0x91, 0x89, 0x85, 0x83 ;2
				DCB		0x91, 0x91, 0x91, 0x91, 0xFF ;3
				DCB		0x0F, 0x08, 0x08, 0x08, 0xFF ;4
				DCB		0x9F, 0x91, 0x91, 0x91, 0xF1 ;5
				DCB		0xFF, 0x91, 0x91, 0x91, 0xF1 ;6
				DCB		0x01, 0x01, 0x01, 0x01, 0xFF ;7
				DCB		0xFF, 0x91, 0x91, 0x91, 0xFF ;8
				DCB		0x9F, 0x91, 0x91, 0x91, 0xFF ;9
				
				EXPORT	printR2Hex

printR2Hex		PROC
				PUSH	{LR}
				MOV		R3,#100
				UDIV	R1,R2,R3
				MUL		R3,R1
				SUB		R2,R2,R3
				
				MOV		R3,#5
				MUL		R1,R3
				PUSH	{R1-R3}
	
				MOV		R10, #5
				BL		CursorSettings
				LDR		R9,=NUMBERS
				ADD		R9,R1
				MOV		R0,#0
				BL		loop

				
				POP		{R1-R3}
				MOV		R3,#10
				UDIV	R1,R2,R3
				MUL		R3,R1
				SUB		R2,R2,R3
				MOV		R3,#5
				MUL		R1,R3

				BL		DELAY100
				MOV		R10, #15
				BL		CursorSettings
				LDR		R9,=NUMBERS
				ADD		R9,R1
				MOV		R0,#0
				BL		loop

				MOV		R3,#5
				MUL		R2,R3

				BL		DELAY100
				MOV		R10, #25
				BL		CursorSettings
				LDR		R9,=NUMBERS
				ADD		R9,R2
				MOV		R0,#0
				BL		loop
				POP		{LR}
				BX		LR	

loop			LDRB	R5,[R9,R0]
				PUSH	{R0,LR}
				BL		PrintR5
				POP		{R0,LR}
				ADD		R0,#1
				CMP		R0,#5
				BNE		loop
				BX		LR
				