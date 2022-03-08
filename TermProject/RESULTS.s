ADC0_RIS 			EQU 		0x40038004 			; Interrupt status
ADC0_PSSI 			EQU 		0x40038028 			; Initiate sample
ADC0_ISC			EQU			0x4003800C 			;Interrupt Status and Clear Register	
ADC0_SSFIFO3 		EQU 		0x400380A8 			; Channel 3 results 	
ADDRESSES			EQU			0x20000800
					AREA    	calculate, READONLY, CODE
					THUMB
					;IMPORT		OutChar
					EXTERN		arm_cfft_q15
					EXTERN		arm_cfft_sR_q15_len256
					IMPORT		DELAY100
					;IMPORT 		CONVRT
					EXPORT  	calc


calc				PROC

;----------------------------CONSTANT REGISTERS FOR ALL PROGRAMS---------------------------;
					LDR			R2,=ADDRESSES		;This is the location of data
;1.65/3.3 = 0.5
;0xFFF * 0.5 ~= 0x800

;-------------------------------MAIN LOOP------------------------------------------------;

;----------------------READ AND STORE SAMPLES----------------------;
;initiate sampling by enabling sequencer 3 in ADC0_PSSI 

takeSample			LDR			R1,=ADC0_PSSI
					LDR			R0,[R1]
					MOV			R0,#0x08 			; which will enable sequencer3
					STR			R0,[R1]
;check for sample complete, wait otherwise
wait				LDR			R1,=ADC0_RIS		;R0 will be same for this script. It will hold RIS value				
					LDR			R0,[R1]
					ANDS		R0,#0x08
					BEQ			wait
					LDR			R1,=ADC0_SSFIFO3
					LDR			R0,[R1];Taking data and store it in R5
					
					MOV			R1,#1552
					SUB			R0,R1
					LDR			R1,=ARRAY_LENGTH
					LDR			R3,[R1]
					CMP			R3,#0x100
					BEQ			ARMING
					STR			R0,[R2,R3,LSL #2]
					ADD			R3,#0x01
					STR			R3,[R1]
					
					BL			clear
					B			takeSample



;--------------------ARMING-----IS------------STARTED;
ARMING				LDR			R0,=arm_cfft_sR_q15_len256
					LDR			R1,=ADDRESSES
					MOV			R2,#0
					MOV			R3,#1
					BL			arm_cfft_q15
;-------------------ARMING-----IS-----------FINISHED;

;----------SET--UP--TO--TAKE--MAG-------------STARTED;
					LDR			R2,=ADDRESSES
					MOV			R3,#0x100
takeanothermag		LDR			R1,[R2]
					BL			takeMag
					ADD			R2,#4
					SUBS		R3,#0x01
					BNE			takeanothermag
					BX			LR

takeMag				PUSH		{LR}
					MOV			R0,R1
					LSR			R0,#16
					PUSH		{R0}
					ANDS		R0,#0x00008000
					POP			{R0}
					BLNE		negative
					
					PUSH		{R0}
					NOP
					NOP
					NOP
					LSL			R1,#16
					LSR			R1,#16
					MOV			R0,R1
					PUSH		{R0}
					ANDS		R0,#0x00008000
					POP			{R0}
					BLNE		negative
					POP			{R1}
					BL			magn
					POP			{LR}
					BX			LR

magn				MUL			R1,R1
					MUL			R0,R0
					ADD			R0,R1
					STR			R0,[R2]
					BX			LR

negative			PUSH		{R1}
					MOV			R1,#0xFFFF
					SUBS		R0,R1,R0
					POP			{R1}
					BX			LR





;-------------CLEAR ISC------------------;			
clear				LDR			R1,=ADC0_ISC
					LDR			R4,[R1] 
					MOV			R4,#8
					STR			R4,[R1]
					BX			LR




					ENDP