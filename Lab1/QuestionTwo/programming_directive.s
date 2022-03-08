
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		CONVRT
			EXTERN		InChar
			EXPORT  	__main


NUM			EQU			0x20000480

__main		PROC
geta		BL    		InChar	;Getting Character
			CMP			R5,#0x00	; Checking if its ASCII value is zero or nor
			BEQ			geta		; if it is zero then wait for another input
			LDR			R0,=NUM		; Stote the adress, NUM, in the register R0
			LDR			R4,[R0]		; Load R4 by the value pointed by NUM so that it can pass it to subroutine CONVRT
			BL			CONVRT		;	Go to CONVRT subroutine
done		B			done		; Infinitive loop
			ALIGN
			ENDP