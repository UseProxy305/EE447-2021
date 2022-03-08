
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		OutChar	; Reference external subroutine	
			EXTERN		OutStr
			EXPORT  	CONVRT	; Make available

CONVRT		PROC
start		PUSH		{R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,LR}			
			LDR    		R0,=0x0	;Temp value 1
			LDR			R1,=0x0 ;Temp value 2
			LDR			R2,=0x0 ;Temp value 3
			LDR			R3,=0xA	;Since we are converting hex to decimal. It's based is 10 ( Hexa [A]= Deci [10])
			LDR			R5,=0x20000480	;Address value that will be written ASCII Value
			PUSH		{R5} ; Pushing adress value
			MOV			R6,R5
			BL			CONVeRT ;Starter for subroutine
			LDR			R1,=0x04	;null char for outstr subroutine
			STRB		R1,[R6]
			POP			{R5} ; Popping adress value
			BL			checker
ret			BL			OutStr
			POP			{R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,LR}
			BX			LR
			ENDP	

checker		PROC
			LDRB		R0,[R5]
			CMP			R0,#0x30
			BEQ			checker2
			BX			LR

checker2	LDRB		R0,[R5,#1]
			CMP			R0,#0x04
			ADDNE		R5,#1
			BX			LR

CONVeRT		PROC
loop		CMP			R4,#0
			BEQ			finish
			UDIV		R0,R4,R3 ; R0=(R4//0xA)
			MUL			R1,R0,R3 ; R1=(R0*10) That will be our current digit, starting from unit digit
			SUB			R2,R4,R1 ; R2= R4-R1 (that will be data for the current digit,starting from unit digit)
			STRB		R2,[R5] ; Writing Data
			ADD			R5,R5,#1 ; Increasing Data Adress
			MOV			R4,R0 ; Updating number so that we can go to next digit
			CMP			R4,#10 ; If it finishes, the number will be less than 10 otherwise it should go to label "loop"
			BMI			finish
			B			loop
finish		STRB		R4,[R5];	Writing converted data is finished here. It is time to rearrange numbers and converting ASCII values
			MOV 		R7,R5
			ADD			R5,R5,#1
			MOV			R8,R5
loop1		LDRB		R1,[R7] ; This loop is writing the same table at the end of it. However, it is in reversed order
			STRB		R1,[R5]
			ADD			R5,R5,#1
			SUB			R7,R7,#1
			CMP			R7,R6
			BPL			loop1
loop2		LDRB		R1,[R8] ; This loop is writing ASCII values in the reversed table at the desired location
			ADD			R1,R1,#48
			STRB		R1,[R6]
			ADD			R6,R6,#1
			ADD			R8,R8,#1
			CMP			R8,R5
			BMI			loop2
			MOV			R5,R6
			BX 			LR
			ENDP
			END
		


