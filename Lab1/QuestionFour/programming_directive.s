
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		CONVRT
			EXTERN		InChar
			EXPORT  	__main


MULT		EQU			0x00000002

__main		PROC
			LDR			R8,=0xA
			MOV			R12,#100
			BL    		InChar	;Taken From Manual
			PUSH		{R5}
			BL			InChar
			PUSH		{R5}
			BL			InChar
			POP			{R7}
			POP			{R6}
			SUB			R7,#0x30
			SUB			R6,#0x30
			SUB			R5,#0x30
			MUL			R7,R8
			ADD			R5,R7
			MUL			R6,R12
			ADD			R5,R6
			MOV			R1,R5
			LDR			R0,=0x20000800
			LDR			R10,=MULT ;
			LDR			R5,=0x20000200
			CMP			R1,#0x02
			MOV			R12,#0x0
			BMI			special
			PUSH		{R5}
			BL			fibo
			POP			{R1}
			SUB			R12,#1
loop		LDR			R0,[R1]
			MOV			R4,R0
			ADD			R1,#0x04
			BL			CONVRT
			SUBS		R12,#1
			BNE			loop			
forever		B			forever
			ENDP

special		PROC
			MOV			R4,#0x0
;			BL			CONVRT
			SUBS		R1,#0x1
			BMI			forever
			MOV			R4,#0x1
;			BL			CONVRT
			B			forever

wrt			STR			R1,[R5]
			ADD			R5,#4
			STR			R2,[R5]
			ADD			R5,#4
			B			exit




			
fibo		MOV			R0,#0
			MOV			R2,#1
			STR			R0,[R5]
			ADD			R5,#4
			STR			R2,[R5]
			ADD			R5,#4
			ADD			R12,#2
fibo2		MOV			R11,R2
			MUL			R2,R10
			ADD			R2,R0
			CMP			R2,R1
			BPL			exit
			ADD			R5,#4
			MOV			R0,R11
			STMDB		SP!,{R2,LR}
			BL			fibo2
			LDMIA		SP!,{R2,LR}
exit		ADD			R12,#1
			STR			R2,[R5]
			SUB			R5,#4
			MOV			PC,LR
			ALIGN
			ENDP