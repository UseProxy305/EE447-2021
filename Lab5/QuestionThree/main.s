;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		Init
			EXTERN		calc
			EXPORT  	__main		; Make available

__main		PROC
			BL			Init		; Init gpio and adc0
			BL			calc		; Calculate and store
			B			.			; Dummy code since program can not exit calc
			
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
