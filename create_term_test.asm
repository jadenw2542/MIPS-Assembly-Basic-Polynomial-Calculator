############################ CHANGE THIS FILE AS YOU DEEM FIT ############################
.data
badcoeff: .word 0
exp0: .word 0
coeff1: .word 1
exp1: .word 1
coeff2: .word 2
exp2: .word 2
coeff3: .word 3
exp7: .word 7
coeff256839: .word 256839
badexp1: .word -1
coeffneg1: .word -1
badexp2: .word -92034
coeffneg2: .word -2
exp87: .word 87
coeffneg3: .word -3
exp4: .word 4


TestCase: .asciiz"Running case #"
TestCaseFail: .asciiz "Did not expect the following output: "
Bullet: .asciiz " - "

.macro ss (%reg)
# Stores the given register to the stack.
addi $sp, $sp, -4
sw %reg, 0($sp)
.end_macro

.macro rs (%reg)
# Pops from the stack and restores to the given register.
lw %reg, 0($sp)
addi $sp, $sp, 4
.end_macro

.macro syscalli (%v0i)
# Performs syscall with a one-line macro and a provided immediate for $v0.
li $v0, %v0i
syscall
.end_macro

.macro print_int (%int)
# Prints int from the given register.
move $a0, %int
syscalli 1
.end_macro

.macro print_char (%char)
# Prints char from the least significant byte of the given register.
move $a0, %char
syscalli 11
.end_macro

.macro print_ln ()
li $a0, 0xA
print_char $a0
.end_macro

.macro print_str_label (%str_label)
la $a0, %str_label
syscalli 4
.end_macro

.macro print_str_len (%str_addr, %len)
# Prints the string from the given str_addr with a specified length.
ss $t0
ss $t1
ss $t2
ss $t3

move $t2, %str_addr
move $t3, %len

# for ($t0=0; $t0<%len; $t0++)
move $t0, $0
print_str_for1:
# Branch if $t0>=%len
bge $t0, $t3, print_str_for1_done
	add $t1, $t2, $t0
	lbu $t1, 0($t1)
	move $a0, $t1
	syscalli 11
addi $t0, $t0, 1
j print_str_for1
print_str_for1_done:
rs $t3
rs $t2
rs $t1
rs $t0
.end_macro

.macro print_bullet ()
print_str_label Bullet
.end_macro

.macro print_case (%im)
# Prints the test case being run.
print_str_label TestCase
li $a0, %im
print_int $a0
print_ln
.end_macro

.macro print_case_fail (%output)
# Prints that a case failed, printing the unexpected int output.
print_str_label TestCaseFail
print_int %output
print_ln
.end_macro

.macro assert_eq (%reg, %im)
# Asserts that register matches the given immediate.
li $t0, %im
beq %reg, $t0, success
print_case_fail %reg
success:
.end_macro

.text


main:

 print_case 1
 lw $a0, badcoeff
 lw $a1, exp4
 jal create_term #coeff is 0 should return -1
 assert_eq $v0, -1
 
 print_case 2
 lw $a0, coeff1
 lw $a1, badexp1
 jal create_term #exp is <0 should return -1
 assert_eq $v0, -1
 
 print_case 3
 lw $a0, coeff256839
 lw $a1, badexp2
 jal create_term #exp is <0 should return -1
 assert_eq $v0, -1
 
 print_case 4
 lw $a0, coeff2
 lw $a1, exp4
 jal create_term #term created successfully should return 0x10040000
 assert_eq $v0, 0x10040000
 
 print_case 5
 lw $a0, coeffneg1
 lw $a1, exp4
 jal create_term #term created successfully should return 0x1004000c
 assert_eq $v0, 0x1004000c
 
 print_case 6
 lw $a0, coeffneg3
 lw $a1, exp7
 jal create_term #term created successfully should return 0x10040018
 assert_eq $v0, 0x10040018
 
 print_case 7
 lw $a0, coeff256839
 lw $a1, exp1
 jal create_term #term created successfully should return 0x10040024
 assert_eq $v0, 0x10040024
 
 print_case 8
 lw $a0, coeffneg3
 lw $a1, exp7
 jal create_term #term created successfully should return 0x10040030
 assert_eq $v0, 0x10040030

#This prints the terms
        li $t0, 0x10040000
        li $t1, 0x10040070
        li $v0, 1
        loop:
        beq $t0, $t1, exit
        lw $a0 0($t0)
        syscall
        addi $t0, $t0, 4
        j loop

#should print 220-1-10-3-302568392568390-3-300000000000000

exit:
 li $v0, 10
 syscall
.include "hw5.asm"
