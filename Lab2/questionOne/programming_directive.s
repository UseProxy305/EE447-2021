
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		OutChar
			EXPORT		DELAY100  	
				
DELAY100	PROC;			
			PUSH		{R8}			;To keep data in register8 same	
;Since its clock is 16MHz. Each cycle will take 0.06us (1/16M sec) to operate
;To take 100ms (0.1 sec = 10^5 us),
;It should take (0.1sec)/((1/16M)sec) =1.6M cycle 
			MOV32		R8,#400000		;Since each loop takes 4 cycles. # of iteration should be 1.600.000/4 = 400000.

delaying	NOP							;Taking 1 cycle
			SUBS		R8,#1 			;Taking 1 cycle
			BNE			delaying		;Taking 2 cycle
			POP			{R8}
			BX			LR
			ALIGN
			ENDP