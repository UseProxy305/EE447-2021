TIMER1_RIS 			EQU 0x4003101C ; Raw interrupt Status
GPIO_PORTB_DATA 	EQU 0x40005040	
TIMER1_TAR 			EQU	0x40031048 ; Counter Register
TIMER1_ICR 			EQU 0x40031024 ; Interrupt Clear Register					
								
								
					AREA    	writing, DATA, READONLY
					THUMB
DutyCycle			DCB			"	Duty Cycle(%):"
					DCB		0x04
Pulse				DCB			"	Pulse Width(in ns):"
					DCB		0x04
Period				DCB			"	Period(in ns):"
					DCB		0x04
					
					
					AREA    	main, READONLY, CODE
					THUMB
					IMPORT		CONVRT
					IMPORT 		OutStr
					EXPORT 		RESULT

RESULT				PROC
					MOV		R2,#0	;This register will be the flag which decides # of edge that captured 
					LDR		R7,=TIMER1_TAR
					LDR		R8,=TIMER1_ICR
					LDR		R9,=GPIO_PORTB_DATA
					LDR		R10,=TIMER1_RIS
loop				LDR		R0,[R10]
					ANDS	R0,#0x4	;Seperating CAERIS bit,
					BEQ 	loop ; if there is no captured time, then iterate
					LDRH 	R3, [R7] ; Get timer register value
					MOV		R0,#0x04
					STR		R0,[R8]	;Clear ICR
					CMP		R2,#0	
					BEQ		first	;That means it can be first edge (First edge is in R4)
					CMP		R2,#1
					BEQ		second	;That means it is the second edge (Second edge is in R5)
					CMP		R2,#2
					BEQ		third	;That means it is the third edge (Third edge is in R6)
	
;That means taking necessary part is finished. Move to calculation part
;WHEN R2=3, IT WILL GO INTO CALCULATION PART

;-----------------------------------------------------------------------------------------;
;-------------------CALCULATION---------------------------PART---------------------------;
;-----------------------------------------------------------------------------------------;

;-----------------CONSTANTS (TO BE ABLE TO MULT BY 62.5--------------------------;
					MOV		R0,#10
					MOV		R1,#625


;-----------------CALCULATING INTERVALS--------------------------|
					SUB		R7,R4,R6 ;PERIOD (FIRST EDGE - THIRD EDGE) [IN CYCLE UNIT, NOT IN ns]
					SUB		R8,R4,R5 ;PULSE WIDTH (FIRST EDGE- SECOND EDGE) [IN CYCLE UNIT, NOT IN ns]

;-----------------DUTY-CYCLE--------------------------|
					MUL		R9,R8,R0 ; Pulse Width *=10
					MUL		R9,R0	;Pulse Width *=10 ( At the end Pulse Width *=100)	
					UDIV	R9,R7	; Pulse Width*100 / PERIOD = DUTY CYCLE
					LDR		R5,=DutyCycle
					BL		OutStr
					MOV		R4,R9
					BL		CONVRT
					
;-----------------PERIOD--------------------------|

					MUL		R7,R1	;PERIOD *= 625
					UDIV	R7,R0	;PERIOD /= 10 (NOW WE GOT PERIOD IN UNITS OF NANOSECOND)
					LDR		R5,=Period
					BL		OutStr
					MOV		R4,R7
					BL		CONVRT				
;-----------------PULSE-WIDTH--------------------------|
					MUL		R8,R1 	;PULSE_WIDTH *= 625
					UDIV	R8,R0	;PULSE_WIDTH /= 10 (NOW WE GOT PERIOD IN UNITS OF NANOSECOND)
					LDR		R5,=Pulse
					BL		OutStr
					MOV		R4,R8
					BL		CONVRT

;-----------------FINISHING-SUBROUTINE--------------------------|
					BX		LR

;-----------------CATCHING FIRST POS EDGE--------------------------|
first				LDR		R0,[R9]
					CMP		R0,#0x10
					BNE		loop	;CHECKING WHETHER IT IS POS EDGE OR NOT
					MOV		R4,R3	;LOAD THE CAPTURED TIME TO R4
					ADD		R2,#1	;CHANGE FLAG SO THAT IT CAN GO INTO THE SECOND LOOP WHEN THERE IS AN EDGE
					B		loop

second				MOV		R5,R3	;LOAD THE CAPTURED TIME TO R5
					ADD		R2,#1	;CHANGE FLAG SO THAT IT CAN GO INTO THE THIRD LOOP WHEN THERE IS AN EDGE
					B		loop

third				MOV		R6,R3		;LOAD THE CAPTURED TIME TO R6
					ADD		R2,#1 	;CHANGE FLAG SO THAT IT CAN GO INTO THE CALCULATION LOOP WHEN THERE IS AN EDGE
					B		loop
					ENDP