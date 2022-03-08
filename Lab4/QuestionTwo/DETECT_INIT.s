; Timer channel registers for TIMER1:
TIMER1_CFG 				EQU 0x40031000 ; Configuration Register
TIMER1_TAMR 			EQU 0x40031004 ; Mode Register 
TIMER1_CTL			 	EQU 0x4003100C ; Control Register
TIMER1_ICR 				EQU 0x40031024 ; Interrupt Clear Register
TIMER1_TAILR 			EQU 0x40031028 ; Interval Load Register
TIMER1_TAPR 			EQU 0x40031038 ; Prescaling Divider
; Timer Gate Control
SYSCTL_RCGCTIMER 		EQU 0x400FE604 ; Timer Clock Gating
;GPIO Registers for Port B
;Port B base 0x40005000
GPIO_PORTB_DIR 			EQU 0x40005400 ; Port Direction
GPIO_PORTB_AFSEL 		EQU 0x40005420 ; Alt Function enable
GPIO_PORTB_DEN 			EQU 0x4000551C ; Digital Enable
GPIO_PORTB_AMSEL 		EQU 0x40005528 ; Analog enable
GPIO_PORTB_PCTL 		EQU 0x4000552C ; Alternate Functions
;GPIO Gate Control Register
SYSCTL_RCGCGPIO 		EQU 0x400FE608
; Setup Port B for signal input
; set direction of PB4


						AREA 	routinea, CODE, READONLY
						THUMB

						EXPORT	DETECT_INIT
							
DETECT_INIT				PROC
						LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
						LDR R0, [R1]
						ORR R0, R0, #0x02 ; set Port B
						STR R0, [R1]
						NOP ; allow clock to settle
						NOP
						NOP
						LDR R1, =GPIO_PORTB_DIR
						LDR R0, [R1]
						BIC R0, R0, #0x10 ; clear bit 4 for input
						STR R0, [R1]

; enable alternate function
						LDR R1, =GPIO_PORTB_AFSEL
						LDR R0, [R1]
						ORR R0, R0, #0x10 ; set bit4 for alternate fuction on PB4
						STR R0, [R1]
; set alternate function to T1CCP0 (7)

						LDR R1, =GPIO_PORTB_PCTL
						LDR R0, [R1]
						ORR R0, R0, #0x00070000 ; set bits of PCTL to 7
						STR R0, [R1] ; to enable T1CCP0 on PB4
; disable analog
						LDR R1, =GPIO_PORTB_AMSEL
						MOV R0, #0 ; clear AMSEL to diable analog
						STR R0, [R1]
; enable analog
						LDR R1, =GPIO_PORTB_DEN
						MOV R0, #0x10 ; set AFSEL to enable analog
						STR R0, [R1]						

; Start Timer 0 clock
						LDR R1, =SYSCTL_RCGCTIMER
						LDR R2, [R1] ; Start timer 0
						ORR R2, R2, #0x02 ; Timer module = bit position (0)
						STR R2, [R1] 
						NOP
						NOP
						NOP ; allow clock to settle

; disable timer during setup
						LDR R1, =TIMER1_CTL
						LDR R2, [R1]
						BIC R2, R2, #0x01 ; clear bit 0 to disable Timer 0
						STR R2, [R1]

; set to 16bit Timer Mode
						LDR R1, =TIMER1_CFG
						MOV R2, #0x04 ; set bits 2:0 to 0x04 for 16bit timer
						STR R2, [R1]
; set for edge time and capture mode
						LDR R1, =TIMER1_TAMR
						MOV R2, #0x07 ; set bit2 to 0x01 for Edge Time Mode,
						STR R2, [R1] ; set bits 1:0 to 0x03 for Capture Mode

; set edge detection to both
						LDR R1, =TIMER1_CTL
						LDR R2, [R1]
						ORR R2, R2, #0x0C ; set bits 3:2 to 0x03
						STR R2, [R1]
; set start value
						LDR 	R1, =TIMER1_TAILR ; counter counts down,
						MOV 	R0, #0xFFFF ; MAX value
						STR 	R0, [R1]

						LDR		R1,=TIMER1_TAPR
						MOV		R0,#0xFF	;PreScaling
						STR		R0,[R1]
							
; Enable timer
						LDR 	R1, =TIMER1_CTL 
						LDR 	R2, [R1] ;
						ORR 	R2, R2, #0x03 ; set bit 0 to enable
						STR 	R2, [R1]
						BX		LR				;returning
; Now use this data, with other measured data to compute
; period, pulse width, duty cycle, frequency,...
