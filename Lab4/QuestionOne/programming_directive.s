PB_INP				EQU	0x400053C0			;To take input
	
					AREA    	main, READONLY, CODE
					THUMB
					IMPORT		PULSE_INIT
					EXPORT 		__main
					
__main				PROC
					mov			r5,#0x32
					ldr			R5,0x1B58
					BL			PULSE_INIT
					B			.
					ALIGN
					ENDP
					END
