SYSPRI3				EQU		0xE000ED20
SYSCTRL				EQU	0xE000E010
;------------------ADC-------------------------------------------;
RCGCADC EQU 0x400FE638 ; ADC clock register
; ADC0 base address EQU 0x40038000
ADC0_ACTSS EQU 0x40038000 ; Sample sequencer (ADC0 base address)
ADC0_RIS EQU 0x40038004 ; Interrupt status
ADC0_IM EQU 0x40038008 ; Interrupt select
ADC0_EMUX EQU 0x40038014 ; Trigger select
ADC0_PSSI EQU 0x40038028 ; Initiate sample
ADC0_SSMUX3 EQU 0x400380A0 ; Input channel select
ADC0_SSCTL3 EQU 0x400380A4 ; Sample sequence control
ADC0_SSFIFO3 EQU 0x400380A8 ; Channel 3 results
ADC0_PC EQU 0x40038FC4 ; Sample rate 

;-------------------PORT-------------------------------------------;
RCGCGPIO EQU 0x400FE608 ; GPIO clock register
;PORT E base address EQU 0x40024000
PORTE_DEN EQU 0x4002451C ; Digital Enable
PORTE_PCTL EQU 0x4002452C ; Alternate function select
PORTE_AFSEL EQU 0x40024420 ; Enable Alt functions
PORTE_AMSEL EQU 0x40024528 ; Enable analog


GPIO_PORTB_DIR 		EQU 0x40005400
GPIO_PORTB_AFSEL 	EQU 0x40005420
GPIO_PORTB_DEN 		EQU 0x4000551C
GPIO_PORTF_LOCK		EQU	0x40025520
GPIO_PORTF_OCR		EQU	0x40025524
GPIO_PORTF_DIR 		EQU 0x40025400
GPIO_PORTF_AFSEL 	EQU 0x40025420
GPIO_PORTF_DEN 		EQU 0x4002551C
GPIO_PORTF_PDR		EQU	0x40025514
GPIO_PORTF_PUL		EQU	0x40025510
SYSCTL_RCGCGPIO 	EQU 0x400FE608
PB_OUT				EQU	0x4000503C
;PORTS ARE CONNECTED AS 
;PE<=Middle port of POT
;Vbus <= Top port of POT
;GND <=	Bottom port of POT
					AREA    	INIT, READONLY, CODE
					THUMB
					EXPORT  	Init

Init				PROC
					;PUSH		{R0,R1}
					LDR 		R1,=RCGCADC ; Turn on ADC clock
					LDR 		R0,[R1]
					ORR 		R0,R0,#0x01 ; set bit 0 to enable ADC0 clock
					STR 		R0,[R1]
			
					NOP
					NOP
					NOP ; Let clock stabilize 
			
					LDR 		R1,=RCGCGPIO
					LDR			R0,[R1]
					ORR 		R0,R0,#0x10		;To init port E
					STR			R0,[R1]		
			
					NOP
					NOP
					NOP					; to stabilize clocks
					

					;These part is taken from lecture notes
					LDR R1, =PORTE_AFSEL
					LDR R0, [R1]
					ORR R0, R0, #0x08 ; set bit 3 to enable alt functions on PE3 
					STR R0, [R1]
					
					; PCTL does not have to be configured
					; since ADC0 is automatically selected when
					; port pin is set to analog.
					
					; Disable digital on PE3
					LDR R1, =PORTE_DEN
					LDR R0, [R1]
					BIC R0, R0, #0x08 ; clear bit 3 to disable digital on PE3
					STR R0, [R1]
					
					; Enable analog on PE3
					LDR R1, =PORTE_AMSEL
					LDR R0, [R1]
					ORR R0, R0, #0x08 ; set bit 3 to enable analog on PE3
					STR R0, [R1]
	
					; Disable sequencer while ADC setup
					LDR 		R1,=ADC0_ACTSS
					LDR 		R0,[R1]
					BIC 		R0,R0,#0x08 ; clear bit 3 to disable seq 3
					STR 		R0,[R1]
					
					; Select trigger source
					LDR 		R1,=ADC0_EMUX
					LDR 		R0,[R1]
					BIC 		R0,R0,#0xF000 ; clear bits 15:12 to select SOFTWARE
					STR 		R0,[R1] ; trigger
					
					; Select input channel
					LDR 		R1,=ADC0_SSMUX3
					LDR 		R0,[R1]
					BIC 		R0,R0,#0x000F ; clear bits 3:0 to select AIN0
					STR 		R0,[R1]
					
					; Config sample sequence
					LDR 		R1, =ADC0_SSCTL3
					LDR 		R0, [R1]
					ORR 		R0, R0, #0x06 ; set bits 2:1 (IE0, END0) IE0 is set since we want RIS to be set
					STR 		R0, [R1]
					
					; Set sample rate
					LDR 		R1, =ADC0_PC
					LDR 		R0, [R1]
					ORR 		R0, R0, #0x01 ; set bits 3:0 to 1 for 125k sps
					STR 		R0, [R1]
					
					; Done with setup, enable sequencer
					LDR 		R1, =ADC0_ACTSS
					LDR 		R0, [R1]
					ORR 		R0, R0, #0x08 ; set bit 3 to enable seq 3
					STR 		R0, [R1] ; sampling enabled but not initiated yet;Disable 
					;BX			LR
					LDR			R0,=SYSCTRL		;set the address of systemctrl
					MOV			R1,#0			
					STR			R1,[R0]			;Reseting
					MOV			R1,#2000		;GIVEN R8 VALUE, ROTATION(Number of Cycle) SPEED CAN BE ADJUSTED
					STR			R1,[R0,#4]		;Reload value
					STR			R1,[R0,#8]		;Current value
					LDR 		R1, =SYSPRI3
					LDR 		R0, [R1]
					MOV 		R0, #0x40000000
					STR 		R0, [R1]	
					LDR			R0,=SYSCTRL
					MOV			R1,#0x03		;(enable, interrupt, use PIOSC as clock)
					STR			R1,[R0]			;Start timer	

Start				LDR 		R1,=SYSCTL_RCGCGPIO
					LDR 		R0,[R1]
					ORR 		R0,R0,#0x22
					STR 		R0,[R1]
					NOP
					NOP
					NOP
					LDR			R1, =GPIO_PORTF_LOCK  ;UNLOCKING
					LDR			R0, =0x4C4F434B
					STR			R0, [R1]
					LDR			R1, =GPIO_PORTF_OCR
					LDR			R0, =0x3F
					STR			R0, [R1]
					LDR			R1, =GPIO_PORTF_LOCK  ;to unclock PF0
					LDR			R0, =0x4C4F434B
					STR			R0, [R1]					
					LDR 		R1,=GPIO_PORTF_DIR 
					LDR 		R0,[R1]
					MOV			R0,#0x0E
					STR 		R0,[R1]
					LDR 		R1,=GPIO_PORTF_AFSEL
					LDR 		R0,[R1]
					BIC 		R0,#0x1F
					STR 		R0,[R1]
					LDR 		R1,=GPIO_PORTF_DEN
					LDR 		R0,[R1]
					ORR 		R0,#0x1F		;ENABLE
					STR			R0,[R1]
					LDR			R1, =GPIO_PORTF_PUL
					LDR			R0,[R1]
					ORR			R0,#0x11
					STR			R0, [R1]
					LDR 		R1,=GPIO_PORTB_DIR 
					LDR 		R0,[R1]
					MOV			R0,#0x0F
					STR 		R0,[R1]
					LDR 		R1,=GPIO_PORTB_AFSEL
					LDR 		R0,[R1]
					BIC 		R0,#0x0F
					STR 		R0,[R1]
					LDR 		R1,=GPIO_PORTB_DEN
					LDR 		R0,[R1]
					ORR 		R0,#0x0F
					STR			R0,[R1]
					LDR			R1,=PB_OUT
					LDR			R0,[R1]
					ORR			R0,#0x01
					STR			R0,[R1]
					;POP			{R0,R1}
					BX			LR