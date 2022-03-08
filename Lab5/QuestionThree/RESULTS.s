ADC0_RIS 			EQU 		0x40038004 			; Interrupt status
ADC0_PSSI 			EQU 		0x40038028 			; Initiate sample
ADC0_ISC			EQU			0x4003800C 			;Interrupt Status and Clear Register	
ADC0_SSFIFO3 		EQU 		0x400380A8 			; Channel 3 results 	

					AREA    	calculate, READONLY, CODE
					THUMB
					EXPORT  	calc


calc				PROC
					LDR			R0,=ADC0_PSSI
					LDR			R1,=ADC0_RIS
					LDR			R2,=ADC0_ISC
					LDR			R3,=ADC0_SSFIFO3	
;1.65/3.3 = 0.5
;0xFFF * 0.5 ~= 0x800
					MOV			R10,#0x800
;initiate sampling by enabling sequencer 3 in ADC0_PSSI 
takeSample			LDR			R4,[R0]
					MOV			R4,#0x08 			; which will enable sequencer3
					STR			R4,[R0]
;check for sample complete, wait otherwise
wait				LDR			R4,[R1]
					ANDS		R4,#0x08
					BEQ			wait
;Sample is finished
					LDR			R5,[R3]				;Taking data and store it in R5
					SUB			R5,R10				;Offset is taken account.
					CMP			R5,#0x01			;Is it negative ?
					BMI			negativ				;yes go to negativ subroutine
					B			decimals			;no go to deicmals subroutine




negativ				MOV			R4,#0xFFFFFFFF		;Since result is negative,
					SUB			R5,R4,R5			;Take absoulte value of it

;Result is in form of X.YZ
;#2048 ~= #0x800
decimals			MOV			R11,#1241			;2048 ~ 1.65 ; 1241 ~1.00			
					SDIV		R6,R5,R11			; R6 is holding X digit R6=X 
					MUL			R9,R6,R11			; Update the reminder
					SUB			R5,R5,R9			; Update the reminder; R5= 0.YZ
					LSL			R6,#8				; R6 = 0xX00

					MOV			R11,#124			;2048 ~ 1.65 ; 124 ~0.10	
					SDIV		R7,R5,R11			;R7 is holding Y digit R7=Y
					MUL			R9,R7,R11			;Update the reminder
					SUB			R5,R5,R9			;Update the reminder ; R5= 0.0Z
					LSL			R7,#4				;R7=0x0Y0
					ADD			R6,R7				;R6=0xXY0
					
					MOV			R11,#12				;2048 ~ 1.65 ; 12 ~0.01
					SDIV		R8,R5,R11			;R8 is holding Z digit R8=Z 
					ADD			R5,R6,R8			;R5=0xXYZ
					B			exit

;Clear interrput register
exit				LDR			R4,[R2] 
					MOV			R4,#8
					STR			R4,[R2]
;Return the cycle
					B			takeSample
					ENDP