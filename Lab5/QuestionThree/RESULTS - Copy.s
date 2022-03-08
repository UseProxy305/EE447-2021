ADC0_RIS 			EQU 		0x40038004 			; Interrupt status
ADC0_PSSI 			EQU 		0x40038028 			; Initiate sample
ADC0_ISC			EQU			0x4003800C 			;Interrupt Status and Clear Register	
ADC0_SSFIFO3 		EQU 		0x400380A8 			; Channel 3 results 	

					AREA    	calculate, READONLY, CODE
					THUMB
					IMPORT		CONVRT
					IMPORT		OutChar
					IMPORT		DELAY100
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
					CMP			R5,#0x01
					BMI			negativ
					B			decimals


;Clear interrput register
exit				LDR			R4,[R2] 
					MOV			R4,#8
					STR			R4,[R2]
;Return the cycle
					B			takeSample

negativ				MOV			R6,R5
					BL			minus
					MOV			R4,#0xFFFFFFFF
					SUB			R6,R4,R6
					MOV			R5,R6
					B			decimals
					B			exit

dot					PUSH		{R5,LR}
					MOV			R5,0x2E
					BL			OutChar
					POP			{R5,LR}
					BX			LR

minus				PUSH		{R5,LR}
					MOV			R5,0x2E
					BL			OutChar
					POP			{R5,LR}
					BX			LR

decimals			MOV			R11,#1242
					SDIV		R6,R5,R11
					MOV			R4,R6
					BL			CONVRT
					MUL			R9,R6,R11
					SUB			R5,R5,R9
					BL			dot
					MOV			R11,#124
					SDIV		R7,R5,R11
					MOV			R4,R7
					BL			CONVRT
					MUL			R9,R7,R11
					SUB			R5,R5,R9

					MOV			R11,#12
					SDIV		R8,R5,R11
					MOV			R4,R8
					BL			CONVRT
					BL			DELAY100
					B			exit
					ENDP