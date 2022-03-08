; 16/32 Timer Registers
TIMER0_CFG			EQU 0x40030000
TIMER0_TAMR			EQU 0x40030004
TIMER0_CTL			EQU 0x4003000C
TIMER0_IMR			EQU 0x40030018
TIMER0_RIS			EQU 0x4003001C ; Timer Interrupt Status
TIMER0_ICR			EQU 0x40030024 ; Timer Interrupt Clear
TIMER0_TAILR		EQU 0x40030028 ; Timer interval
TIMER0_TAPR			EQU 0x40030038
TIMER0_TAR			EQU	0x40030048 ; Timer register

;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
PB_OUT				EQU	0x4000503C
SPEED				EQU	0x2000078C
DIRECTION			EQU	0x20000790
;---------------------------------------------------
LOW					EQU	0x00000010 ;4x (40us=1us * (0x28))
HIGH				EQU	0x00000070 ;1x (10us=1us * (0x0A))
;---------------------------------------------------
					
			AREA 	routines, CODE, READONLY
			THUMB
			EXPORT 	My_Timer0A_Handler
					
;---------------------------------------------------					
My_Timer0A_Handler	PROC

					LDR			R1,=DIRECTION
					LDR			R0,[R1]
					CMP			R0,#0x00
					BEQ			turn1
					CMP			R0,#0x01
					BEQ			turn2
					
turn1				LDR			R1,=PB_OUT
					LDR			R0,[R1]
					LSL			R0,#1
					CMP			R0,#0x10
					MOVEQ		R0,#0x01
					LDR			R1,=PB_OUT
					STR			R0,[R1]
					B			exit

turn2				LDR			R1,=PB_OUT
					LDR			R0,[R1]
					LSR			R0,#1
					CMP			R0,#0x00
					MOVEQ		R0,#0x08
					LDR			R1,=PB_OUT
					STR			R0,[R1]
					B			exit

exit				LDR			R1,=SPEED
					LDR			R0,[R1]
					LDR			R1, =TIMER0_TAILR
					STR			R0,[R1]
					LDR 		R1, =TIMER0_ICR ; interrupt clear
					MOV 		R0, #0x01		;
					STR 		R0, [R1]
					BX			LR
;FULL CYCLE SHOULD BE 50.000 NANO SECOND
;WILL BE TURNED ON EVERY 10us = 10.000 NANO SECOND
;WILL BE TURNED OFF EVERY 40us = 40.000 NANO SECOND
;THIS INTERRPUT WILL BE CALLED EACH 1US=1.000 nanosecond
					ENDP
					END