############################ CHANGE THIS FILE AS YOU DEEM FIT ############################
.data
pairs: .word 8 9 4 5 3 10 -2 9 -5 5 1 5 -7 10 2 10 8 1 2 10 0 -1 89

.text
main:
 la $a0, pairs
 jal create_polynomial
 #write test code


exit:
 li $v0, 10
 syscall
.include "hw5.asm"
