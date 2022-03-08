SYSCTRL				EQU			0xE000E010
					AREA    	main, READONLY, CODE
					THUMB
					EXPORT  	IntStart
;This script is to create system timer with given R8 Value
IntStart			PROC
					LDR			R0,=SYSCTRL		;set the address of systemctrl
					MOV			R1,#0			
					STR			R1,[R0]			;Reseting
					MOV			R1,R8			;GIVEN R8 VALUE, ROTATION(Number of Cycle) SPEED CAN BE ADJUSTED
					STR			R1,[R0,#4]		;Reload value
					STR			R1,[R0,#8]		;Current value
					MOV			R1,#0x03		;(enable, interrupt, use PIOSC as clock)
					STR			R1,[R0]			;Start timer
					BX			LR