PB_OUT				EQU	0x4000503C	
					AREA    	main, READONLY, CODE
					THUMB
					EXPORT  	my_ST_ISR
;This script is called when sysTimer is triggered
;According to value in R10, it will be determined which rotation will be occured,
;CounterClockWise(cCW)		ClockWise(cW)
;R10 value is changing in main function
my_ST_ISR			PROC
					LDR			R5,=PB_OUT
					STR			R9,[R5]		;Write values in IN1-4
					CMP			R10,#0x02	;Deciding which rotation
					BEQ			cCW
					CMP			R10,#0x01
					BEQ			cW
					BX			LR

cW					LSR			R9,#1		;Out1-4 changing as desired in manual
					CMP			R9,#0x00	;Checking boundaries
					MOVEQ		R9,#0x08
					BX			LR		

cCW					LSL			R9,#1		;Out1-4 changing as desired in manual
					CMP			R9,#0x10	;Checking boundaries
					MOVEQ		R9,#0x01
					BX			LR

					ALIGN
					ENDP
					END