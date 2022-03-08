					AREA    	main, READONLY, CODE
					THUMB
					IMPORT		PULSE_INIT
					IMPORT		DETECT_INIT
					IMPORT 		RESULT
					EXPORT 		__main
					
__main				PROC
					BL			PULSE_INIT
					BL			DETECT_INIT
					BL			RESULT
					B			.
					

					ALIGN
					ENDP
					END
