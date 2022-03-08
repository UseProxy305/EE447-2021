
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		CONVRT
			EXTERN		InChar
			EXTERN		UPBND
			EXPORT  	__main



__main		PROC;TAKING DATA AS WITH TWO DIGITS
			LDR			R8,=0xA
			BL    		InChar	
			PUSH		{R5}
			BL			InChar
			POP			{R7}
			SUB			R7,#0x30
			SUB			R5,#0x30
			MUL			R7,R8
			ADD			R5,R7
			MOV			R2,R5; R2=n
;Prepreation for the alghoritm
			MOV			R0,#0;This will be held for minimum limit
			MOV			R11,#1; R11=1
			LSL			R11,R11,R2;This will be the maximum == 2^n
calcu		ADD			R1,R11,R0 ; R1=R11+R0 (MIN+MAX)
			LSR			R1,R1,#1 ; 	R1=R1/2		(MIN+MAX)/2
			MOV			R4,R1
			BL			CONVRT
			BL			UPBND
			B			calcu
loop		B			loop
			ALIGN
			ENDP