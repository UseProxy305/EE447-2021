ADC0_RIS 			EQU 		0x40038004 			; Interrupt status
ADC0_PSSI 			EQU 		0x40038028 			; Initiate sample
ADC0_ISC			EQU			0x4003800C 			;Interrupt Status and Clear Register
ADC0_SSFIFO3 		EQU 		0x400380A8 			; Channel 3 results
ADDRESSES			EQU			0x20000800
ARRAY_LENGTH		EQU			0x20000780
MAGNITUDE			EQU			0x20000784 ; INPUT MAG
FREQUENCY			EQU			0x20000788 ; INPUT FREQUENCY
MAGTH				EQU			0x50000		;Magnitude Threshold
FREQLWTH			EQU			0x1F4		;LOWER THRESHOLD FOR FREQUENCY (500 Hz)
FREQUPTH			EQU			0x2E0		;UPPER THRESHOLD FOR FREQUENCY	(736 Hz)
GPIO_PORTF_DATA 	EQU 		0x400253FC ; data a d d r e s s t o a l l pi n s
SPEED				EQU			0x2000078C

					AREA    	main, READONLY, CODE
					THUMB
					EXTERN		arm_cfft_q15
					EXTERN		arm_cfft_sR_q15_len256
					EXTERN		printR2Hex
					EXTERN		DELAY100
				
					EXPORT  	my_ST_ISR
;This script is called when sysTimer is triggered

my_ST_ISR			PROC
					PUSH		{R0-R10,LR}
;----------------------------CONSTANT REGISTERS FOR ALL PROGRAMS---------------------------;
					LDR			R2,=ADDRESSES		;This is the location of data
;-------------------------------MAIN LOOP------------------------------------------------;

;----------------------READ AND STORE SAMPLES----------------------;
;initiate sampling by enabling sequencer 3 in ADC0_PSSI

takeSample			LDR			R1,=ADC0_PSSI
					LDR			R0,[R1]
					MOV			R0,#0x08 			; which will enable sequencer3
					STR			R0,[R1]
					NOP
					NOP
					NOP
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
					CMP			R3,#256
					BEQ			ARMING
					LSL			R0, #4
					MOV			R4,#0xFFFF
					AND			R0,R4
					STR			R0,[R2,R3,LSL #2]
					ADD			R3,#1
					STR			R3,[R1]
					B			clear




;--------------------ARMING-----IS------------STARTED;
ARMING				LDR			R0,=arm_cfft_sR_q15_len256
					LDR			R1,=ADDRESSES
					MOV			R2,#0
					MOV			R3,#1
					BL			arm_cfft_q15
;-------------------ARMING-----IS-----------FINISHED;

;----------SET--UP--TO--TAKE--MAG-------------STARTED;
					LDR			R2,=ADDRESSES
					MOV			R3,#0
					MOV			R5,#0 ;MAX FREQUENCY ADDRRESS
					MOV			R6,#0
takeanothermag		LDR			R1,[R2,R3]
					BL			takeMag
					BL			maxFinder
					ADD			R3,#4
					CMP			R3,#512
					BNE			takeanothermag
					LDR			R1,=ARRAY_LENGTH
					MOV			R0,#0x00
					STR			R0,[R1]
					B			berkay

maxFinder			CMP			R3,#0
					BXEQ		LR
					CMP			R0,R5
					MOVHI		R5,R0
					MOVHI		R6,R3,lsl#1
					BX			LR

berkay				BL			printing
					LDR			R1,=MAGNITUDE
					STR			R5,[R1]
					LDR			R1,=FREQUENCY
					STR			R6,[R1]
					MOV			R2,R6
					PUSH		{R5,R6,LR}
					MOV			R11,#4
					BL			printR2Hex
					BL			DELAY100
					POP			{R5,R6,LR}
					CMP			R5,#MAGTH
					BLT			exitoff

		;CALCULATION FOR SPEED
					LDR			R1,=FREQUENCY
					LDR			R0,[R1]
					MOV			R2,#12
					MUL			R0,R2
					MOV			R2,#14064
					SUB			R0,R2,R0
					LDR			R1,=SPEED
					STR			R0,[R1]
		;CALCULATION FOR SPEED ENDED

					LDR			R1,=FREQUENCY
					LDR			R0,[R1]
					CMP			R0,#FREQLWTH
					BLT			red
					CMP			R0,#FREQUPTH
					BLT			green
					B			blue

green				LDR			R1,=GPIO_PORTF_DATA
					LDR			R0,[R1]
					MOV			R0,#0x08 ;GREEN 0x04 BLUE 0x02 RED
					STR			R0,[R1]
					B			clear

red					LDR			R1,=GPIO_PORTF_DATA
					LDR			R0,[R1]
					MOV			R0,#0x02 ;GREEN 0x04 BLUE 0x02 RED
					STR			R0,[R1]
					B			clear

blue				LDR			R1,=GPIO_PORTF_DATA
					LDR			R0,[R1]
					MOV			R0,#0x04 ;GREEN 0x04 BLUE 0x02 RED
					STR			R0,[R1]
					B			clear



exitoff				LDR			R1,=GPIO_PORTF_DATA
					MOV			R0,#0x00
					STR			R0,[R1]
					B			clear

takeMag				PUSH		{LR}
					MOV			R0,R1
					LSR			R0,#16
					PUSH		{R0}
					ANDS		R0,#0x00008000
					POP			{R0}
					BLNE		negative

					PUSH		{R0}
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
					STR			R0,[R2,R3]
					BX			LR

negative			PUSH		{R1}
					MOV			R1,#0xFFFF
					SUBS		R0,R1,R0
					POP			{R1}
					BX			LR





;-------------CLEAR ISC------------------;
clear				LDR			R1,=ADC0_ISC
					LDR			R4,[R1]
					ORR			R4,#0x08
					STR			R4,[R1]
					POP			{R0-R10,LR}
					BX			LR

printing			PUSH	{R5,R6,LR}
					MOV		R11,#0
					MOV		R2,#FREQLWTH
					BL		printR2Hex
					BL		DELAY100
					MOV		R11,#2
					MOV		R2,#FREQUPTH
					BL		printR2Hex
					BL		DELAY100
					
					POP		{R5,R6,LR}
					BX		LR
					ALIGN
					ENDP
					END
