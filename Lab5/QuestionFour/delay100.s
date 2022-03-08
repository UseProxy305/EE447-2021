
			AREA    	main, READONLY, CODE
			THUMB
			EXPORT  	DELAY100



DELAY100	PROC;
			PUSH		{R8}
			MOV32		R8,#8000000
delaying	NOP
			SUBS		R8,#1
			BNE			delaying
			POP			{R8}
			BX			LR
			ENDP
			END