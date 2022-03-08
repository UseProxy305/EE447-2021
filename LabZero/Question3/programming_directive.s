
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		InChar	;Externing necessary subroutine
			EXTERN		OutChar	;Externing necessary subroutine
			EXPORT  	__main
__main		PROC
geta		BL    		InChar	;Taken From Manual
			CMP			R5,#0x20
			BEQ    		done
			BL			OutChar
			B 			geta
done		B			done

			ENDP
			ALIGN
			END