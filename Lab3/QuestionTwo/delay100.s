
			AREA    	main, READONLY, CODE
			THUMB
			EXPORT  	DELAY100



DELAY100	PROC;
			PUSH		{R0}
			MOV32		R0,#100000
berkay		SUBS		R0,#1
			NOP
			BNE			berkay
			POP			{R0}
			BX			LR
			ENDP
			END