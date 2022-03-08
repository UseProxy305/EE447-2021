PB_OUT				EQU	0x4000503C			;Address to output data
PB_INP				EQU	0x400053C0			;Address to output data
					AREA    	main, READONLY, CODE
					THUMB
					EXTERN		PORTB_INIT	;To initialize port B
					EXTERN		OutChar		;To print spesific Characters
					EXTERN		DELAY100	;To create delay 100 msec
					EXPORT  	__main		;To make this script available

__main				PROC
					BL			PORTB_INIT
					MOV			R1,#0x01	;R1 register determines which pin will be given high voltage
TRY					LDR			R0,=PB_OUT
					CMP			R1,#0x10	;When all 4 pins are given high voltages, it should return back into the original
					LSLNE		R1,#1		;If it is not finished (NE), then it will go into next pin
					MOVEQ		R1,#0x1		;If it is finished (EQ), then it will go into the starter pin
waitInp				STR			R1,[R0]		;Give necessary voltage settings
					LDR			R0,=PB_INP	
					LDR			R2,[R0]		;Taking data from keys
					BL			DELAY100	;Wait about 100 msec
					LDR			R3,[R0]		;Taking another data from keys
					CMP			R3,R2		;Then compare
					BNE			waitInp		;If they are not equal, then go into waiting input stage
					
					;If a key is preseed, R2 will be 0x10,0x20,0x40, or 0x80.
					CMP			R2,#0x10
					BEQ			COL1
					CMP			R2,#0x20
					BEQ			COL2
					CMP			R2,#0x40
					BEQ			COL3
					CMP			R2,#0x80
					BEQ			COL4
					;If a key is not preseed in that corresponding rows, it will go into the next rows (SEE LINE 14) 
					B			TRY
					
;A KEY IN COLUMN1 HAS BEEN PRESSED
COL1				LDR			R4,[R0]		;Take input data
					CMP			R2,R4		;Compare with previous one
					BEQ			COL1		;If it is still same, it means it is not released yet
					;This part will determine which key is pressed by checking which pin is high voltage
					CMP			R1,#0x01	;That means the first row (column 1)
					MOVEQ		R5,#0x30
					CMP			R1,#0x02	;That means the second row (column 1)
					MOVEQ		R5,#0x34
					CMP			R1,#0x04	;That means the third row (column 1)
					MOVEQ		R5,#0x38
					CMP			R1,#0x08	;That means the forth row (column 1)
					MOVEQ		R5,#0x43
					BL			OutChar		;Print the assigned value
					B			TRY			;Go into the next iteration
					
;A KEY IN COLUMN2 HAS BEEN PRESSED
COL2				LDR			R4,[R0]		;Take input data
					CMP			R2,R4		;Compare with previous one
					BEQ			COL2		;If it is still same, it means it is not released yet
					;This part will determine which key is pressed by checking which pin is high voltage
					CMP			R1,#0x01	;That means the first row (column 2)
					MOVEQ		R5,#0x31
					CMP			R1,#0x02	;That means the second row (column 2)
					MOVEQ		R5,#0x35
					CMP			R1,#0x04	;That means the third row (column 2)
					MOVEQ		R5,#0x39
					CMP			R1,#0x08	;That means the forth row (column 2)
					MOVEQ		R5,#0x44
					BL			OutChar		;Print the assigned value
					B			TRY			;Go to next iteration

;A KEY IN COLUMN3 HAS BEEN PRESSED
COL3				LDR			R4,[R0]		;Take input data
					CMP			R2,R4		;Compare with previous one
					BEQ			COL3		;If it is still same, it means it is not released yet
					;This part will determine which key is pressed by checking which pin is high voltage
					CMP			R1,#0x01	;That means the first row (column 3)
					MOVEQ		R5,#0x32
					CMP			R1,#0x02	;That means the second row (column 3)
					MOVEQ		R5,#0x36
					CMP			R1,#0x04	;That means the third row (column 3)
					MOVEQ		R5,#0x41
					CMP			R1,#0x08	;That means the forth row (column 3)
					MOVEQ		R5,#0x45
					BL			OutChar		;Print the assigned value
					B			TRY			;Go to next iteration

;A KEY IN COLUMN4 HAS BEEN PRESSED
COL4				LDR			R4,[R0]		;Take input data
					CMP			R2,R4		;Compare with previous one
					BEQ			COL4		;If it is still same, it means it is not released yet
					;This part will determine which key is pressed by checking which pin is high voltage
					CMP			R1,#0x01	;That means the first row (column 4)
					MOVEQ		R5,#0x33
					CMP			R1,#0x02	;That means the second row (column 4)
					MOVEQ		R5,#0x37
					CMP			R1,#0x04	;That means the third row (column 4)
					MOVEQ		R5,#0x42
					CMP			R1,#0x08	;That means the forth row (column 4)
					MOVEQ		R5,#0x46
					BL			OutChar		;Print the assigned value
					B			TRY			;Go to next iteration

					ALIGN
					ENDP