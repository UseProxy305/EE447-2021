
					AREA    	main, READONLY, CODE
					THUMB
					EXPORT  	my_ST_ISR
;This script is called when sysTimer is triggered
;According to value in R10, it will be determined which rotation will be occured,
;CounterClockWise(cCW)		ClockWise(cW)
;R10 value is changing in main function

					ALIGN
					ENDP
					END