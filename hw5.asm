############## Jaden Wong ##############
############## 113469617 #################
############## JADWONG ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_term
create_term:
addi $sp, $sp, -60
 sw $t0, 56($sp)
 sw $t1, 52($sp)
 sw $t2, 48($sp)
 sw $t3, 44($sp)
 sw $t4, 40($sp)
 sw $t5, 36($sp)
 sw $s0, 32($sp)
 sw $s1, 28($sp)
 sw $s2, 24($sp)
 sw $s3, 20($sp)
 sw $s4, 16($sp)
 sw $s5, 12($sp)
 sw $s6, 8($sp)
 sw $s7, 4($sp)
 sw $ra, 0($sp)
 
 move $s0, $a0 # $s0 = coef
 move $s1, $a1 # $s1 = exponenet
 
 #If the coefficient is 0 or the exponent is negative, then return -1 in $v0.
 beqz $s0, create_term_fail #coefficient is 0
 bltz $s1, create_term_fail#exponent is negative
 
 
 # store data in system heap
 li $a0, 12
 li $v0, 9
 syscall
 
 #The first 4 bytes holds the coefficient, The next 4 bytes holds the exponent, 
 #and The final 4 bytes holds the address of another term. Set this to 0 at this point.
 move $s3, $v0
 move $t0, $s3
 sw $s0, 0($t0)
 addi $t0, $t0, 4
 sw $s1, 0($t0)
 addi $t0, $t0, 4
 sw $0, 0($t0)
 
 move $v0, $s3
 j create_term_terminate
 
 create_term_fail:
 li $v0, -1

 create_term_terminate:
 lw $t0, 56($sp)
 lw $t1, 52($sp)
 lw $t2, 48($sp)
 lw $t3, 44($sp)
 lw $t4, 40($sp)
 lw $t5, 36($sp)
 lw $s0, 32($sp)
 lw $s1, 28($sp)
 lw $s2, 24($sp)
 lw $s3, 20($sp)
 lw $s4, 16($sp)
 lw $s5, 12($sp)
 lw $s6, 8($sp)
 lw $s7, 4($sp)
 lw $ra, 0($sp)
 addi $sp, $sp, 60
 jr $ra


.globl create_polynomial
create_polynomial:
addi $sp, $sp, -60
 sw $t0, 56($sp)
 sw $t1, 52($sp)
 sw $t2, 48($sp)
 sw $t3, 44($sp)
 sw $t4, 40($sp)
 sw $t5, 36($sp)
 sw $s0, 32($sp)
 sw $s1, 28($sp)
 sw $s2, 24($sp)
 sw $s3, 20($sp)
 sw $s4, 16($sp)
 sw $s5, 12($sp)
 sw $s6, 8($sp)
 sw $s7, 4($sp)
 sw $ra, 0($sp)
 
 move $s0, $a0 # [] of terms
 #If the terms array is empty then return NULL in $v0. (starts with 0, -1
 move $t0, $s0 # $t0 = current address of [] of terms
 lw $t1, 0($s0)
 lw $t2, 4($s0)
 bnez $t1, create_polynomial_start

 li $t3, -1
 beq $t2, $t3, create_polynomial_error
 
 create_polynomial_start:
 
 move $a0, $t1
 move $a1, $t2
 jal create_term
 li $t3, -1
 beq $v0, $t3, create_polynomial_error
 move $s1, $v0 # $s1 = head of linked list
 li $s2, 1 # $s2 = current nodes in linked list

 addi $s3, $s0, 8 # $s3 = paris[] address + 8 (already have 1st index)
 move $s4, $s1 # $s4 = linked list head address
 
 create_polynomial_loop_pairs:
 	
 	lw $t2, 0($s3) # $t2 = coefficient of pairs
 	lw $t3, 4($s3) # #t3 = exponenet of pairs
 	bnez $t2, create_polynomial_loop_checkIfExistInLinkedList
 	li $t4, -1

 	beq $t3, $t4, create_polynomial_end_of_pairs#if exponent = -1, end of list
 
 	create_polynomial_loop_checkIfExistInLinkedList:
 	move $t4, $s1 # $t4 = linked list head address
 	li $t9, 0 #flag for if exists , if = 1 ,then there was a pari with the same exponenet
 		create_polynomial_loop_check_if_same_exponent:
 		
 			lw $t5, 0($t4) #coefficient of current linked list node
  			lw $t6, 4($t4) #exponenet of current linked list node
  			lw $t7, 8($t4) #address of next node 
  	
 			bne $t3, $t6,  create_polynomial_loop_check_if_same_exponent_nextLink# if exponmenets not equal, check next link
			add $t5, $t5, $t2 #add coeficients
			sw $t5, 0($t4)
			j create_polynomial_loop_coefficient_added
 			
 			create_polynomial_loop_check_if_same_exponent_nextLink:
 			beqz $t7 create_polynomial_loop_check_if_same_exponent_end #end of linked list
 			move $t4, $t7 #move cursor to next address
 			
 			j create_polynomial_loop_check_if_same_exponent
 			
 		create_polynomial_loop_check_if_same_exponent_end: # no term with same exponent found, add a node to linked list
 		move $a0, $t2
 		move $a1, $t3
 		jal create_term # $v0 = address of new term
 		li $t4, -1
		beq $v0, $t4, create_polynomial_error
 		sw $v0, 8($s4) # store address in 3rd arg
 		lw $s4, 8($s4) # move cursor of linked list to next node
 		addi $s2, $s2, 1 # coutner of nodes in linked list + 1
 		
 		create_polynomial_loop_coefficient_added: # term with same exponenet found, so it's coefficient has been added
 		
 		addi $s3, $s3, 8 # go to next pair
 		
 j create_polynomial_loop_pairs
 create_polynomial_end_of_pairs:
 
 #rid of nodes in linked lists that have coefficient of zero
 move $s4, $s1 # $s4 = linked list head address
 move $t0, $s4 # prev node (starts as first head address) $s2 = current nodes in linked list
 lw $t1, 8($t0) # curr node address
 
 create_polynomial_look_for_zeros:
 
 	beqz $t1, create_polynomial_zeros_end
 	lw $t2, 0($t1) # $t2 = current node coefiiciient
 	bnez $t2, create_polynomial_zeros_goNextLink	
 	lw $t3, 8($t1) # $t3 = next link
 	sw $t3, 8($t0) # set link of prev node to next link
 	addi $s2, $s2, -1 # decremnt counter of # of nodes
 	
 	
 	beqz $t3, create_polynomial_zeros_end
 	lw $t1, 8($t0) # curr node = prev node link
 	j create_polynomial_look_for_zeros
 	create_polynomial_zeros_goNextLink:

	lw $t0, 8($t0) #prev node = next node
	beqz $t0, create_polynomial_zeros_end
	lw $t1, 8($t0) # curr node = prev node link
	beqz $t1, create_polynomial_zeros_end
 	
 j create_polynomial_look_for_zeros
 create_polynomial_zeros_end:
 
 #check if head coefficient is 0, if it else, move the head pointer
 move $s4, $s1 # $s4 = linked list head address
 lw $t0, 0($s4)
 bnez  $t0, create_polynomial_succuess
 lw $s4, 8($s4)
 move $s1, $s4
 addi $s2, $s2, -1 # decremnt counter of # of nodes
 beqz $s2, create_polynomial_return_emptyPoly # linked list is empty
 lw $t0, 0($s1)
 beqz $t0, create_polynomial_return_emptyPoly
 create_polynomial_succuess:		
 #create Polynomial structure
 li $a0, 8
 li $v0, 9
 syscall	
 sw $s1, 0($v0)#return head of linked list
 sw $s2, 4($v0) 
 j create_polynomial_terminate
 
 create_polynomial_error:
 li $v0, 0
 j create_polynomial_terminate
 
 create_polynomial_return_emptyPoly:
 li $a0, 8
 li $v0, 9
 syscall	
 sw $0, 0($v0)
 sw $0, 4($v0)
 j create_polynomial_terminate
 
 
 create_polynomial_terminate:
 
 lw $t0, 56($sp)
 lw $t1, 52($sp)
 lw $t2, 48($sp)
 lw $t3, 44($sp)
 lw $t4, 40($sp)
 lw $t5, 36($sp)
 lw $s0, 32($sp)
 lw $s1, 28($sp)
 lw $s2, 24($sp)
 lw $s3, 20($sp)
 lw $s4, 16($sp)
 lw $s5, 12($sp)
 lw $s6, 8($sp)
 lw $s7, 4($sp)
 lw $ra, 0($sp)
 addi $sp, $sp, 60
 jr $ra

.globl sort_polynomial #buble sort
sort_polynomial:
addi $sp, $sp, -60
 sw $t0, 56($sp)
 sw $t1, 52($sp)
 sw $t2, 48($sp)
 sw $t3, 44($sp)
 sw $t4, 40($sp)
 sw $t5, 36($sp)
 sw $s0, 32($sp)
 sw $s1, 28($sp)
 sw $s2, 24($sp)
 sw $s3, 20($sp)
 sw $s4, 16($sp)
 sw $s5, 12($sp)
 sw $s6, 8($sp)
 sw $s7, 4($sp)
 sw $ra, 0($sp)
 
 lw $s0, 0($a0) # $s0 = head of linked list address
 lw $t0, 4($a0) #$t0 = num of links
 beqz $t0, sort_polynomial_terminate
 
 li $s1, 0 # times swapped
 li $s2, 0 #position in list
 sort_polynomial_loop:
 move $t0, $s0
 li $s2, 0 #position in list
 sort_polynomial_start_swap:
 	lw $t1, 8($t0) # address of next node
 	beqz $t1, sort_polynomial_finish_swap
 	lw $t2, 4($t0) # curr exponenet 
 	lw $t3, 4($t1) # next exponenet
 	bgt $t2, $t3, sort_polynomial_next_nodes # if curr exponenet > next exponent, go to next node
 	
 	#swapping
 	#if head
 	bnez $s2, sort_polynomial_not_head
 	lw $t3, 8($t1)
 	sw $t3, 8($t0)
 	sw $t0, 8($t1)
 	move $t4, $t1 #prev node
 	move $s0, $t1 #new head
 	addi $s1, $s1, 1 #increment # of times swapped
 	addi $s2, $s2, 1 #increment position in list
 	j sort_polynomial_start_swap
 	
 	sort_polynomial_not_head:
 	lw $t3, 8($t1)
 	sw $t3, 8($t0)
 	sw $t0, 8($t1)
 	
 	sw $t1, 8($t4) # changes address of prev link
 	move $t4, $t1
 	
 	#move $t0, $t1 #go to next link
 	
 	addi $s1, $s1, 1 #increment # of times swapped
 	addi $s2, $s2, 1 #increment position in list
 	j sort_polynomial_start_swap
 	
 	sort_polynomial_next_nodes:
 	move $t4, $t0
 	lw $t0, 8($t0)
 	
 	addi $s2, $s2, 1
 	j sort_polynomial_start_swap
 	sort_polynomial_finish_swap:
 	
 beqz $s1, sort_polynomial_loop_stop
 li $s1, 0 # times swapped
 j sort_polynomial_loop	
 
 sort_polynomial_loop_stop:
 sw $s0, 0($a0)
 sort_polynomial_terminate:
 lw $t0, 56($sp)
 lw $t1, 52($sp)
 lw $t2, 48($sp)
 lw $t3, 44($sp)
 lw $t4, 40($sp)
 lw $t5, 36($sp)
 lw $s0, 32($sp)
 lw $s1, 28($sp)
 lw $s2, 24($sp)
 lw $s3, 20($sp)
 lw $s4, 16($sp)
 lw $s5, 12($sp)
 lw $s6, 8($sp)
 lw $s7, 4($sp)
 lw $ra, 0($sp)
 addi $sp, $sp, 60
 jr $ra

.globl add_polynomial # Polynomial* add_polynomial(Polynomial* p, Polynomial* q)
add_polynomial:

 addi $sp, $sp, -60
 sw $t0, 56($sp)
 sw $t1, 52($sp)
 sw $t2, 48($sp)
 sw $t3, 44($sp)
 sw $t4, 40($sp)
 sw $t5, 36($sp)
 sw $s0, 32($sp)
 sw $s1, 28($sp)
 sw $s2, 24($sp)
 sw $s3, 20($sp)
 sw $s4, 16($sp)
 sw $s5, 12($sp)
 sw $s6, 8($sp)
 sw $s7, 4($sp)
 sw $ra, 0($sp)
 
 #check if both are null
 bnez $a0, add_polynomial_both_not_null
 bnez $a1, add_polynomial_both_not_null
 #create Polynomial structure
 li $a0, 8
 li $v0, 9
 syscall
 lw $0, 0($v0)
 lw $0, 4($v0)
 j add_polynomial_terminate2
 
 #both are null
 add_polynomial_both_not_null:
 
 beqz $a0, add_polynomial_return_q
 beqz $a1, add_polynomial_return_p
 lw $t0, 4($a0)
 lw $t1, 4($a1)
 beqz $t0, add_polynomial_return_q
 beqz $t1, add_polynomial_return_p
 j add_polynomial_both_are_valid
 
 add_polynomial_return_q:
 move $a0, $a1
 jal sort_polynomial 
 j add_polynomial_terminate2
 
 add_polynomial_return_p:
 jal sort_polynomial 
 j add_polynomial_terminate2
 
 
 add_polynomial_both_are_valid:
 # If both arguments are NULL, the function returns a pointer to an empty polynomial. 
 #An empty polynomial has it's head term set to NULL and the no. of terms set to 0.
 lw $s0, 0($a0) # $s0 = p head terms
 lw $s1, 4($a0) # $s1 = p term count
 lw $s2, 0($a1) # $s2 = q head term
 lw $s3, 4($a1)# $s3 = q term count


 move $s7, $sp #save orgiinal stack position
 # sto re 0, -1 in stack
 addi $sp, $sp, -12
 li $t0, 0
 li $t1, -1
 sw $t0, 0($sp)
 sw $t1, 4($sp)
 
 #adjust sp 
 add $t0, $s1, $s3  #add number of terms together
 li $t1, -8
 mult $t0, $t1
 mflo $t0
 add $sp, $sp, $t0
 move $s4, $sp # $s4 = beginning of stack
 
 #add p terms to stack
 move $t0, $s0 # $t0 = p head term address
 lw $t1, 0($t0) #$t1 = coefficient
 lw $t2, 4($t0) #$t2 = exponent
 lw $t3, 8($t0) #t3 = next link
 add_polynomial_add_p:
 	
 	sw $t1, 0($sp)
 	sw $t2, 4($sp)	
 	addi $sp, $sp, 8
 	beqz $t3, add_polynomial_add_p_done

	move $t0, $t3 # go to next link
 	lw $t1, 0($t0) #$t1 = coefficient
 	lw $t2, 4($t0) #$t2 = exponent
 	lw $t3, 8($t0) #t3 = next link

	j add_polynomial_add_p
 add_polynomial_add_p_done:


#add q terms to stack
 move $t0, $s2 # $t0 = p head term address
 lw $t1, 0($t0) #$t1 = coefficient
 lw $t2, 4($t0) #$t2 = exponent
 lw $t3, 8($t0) #t3 = next link
 add_polynomial_add_q:
 	
 	sw $t1, 0($sp)
 	sw $t2, 4($sp)	
 	addi $sp, $sp, 8
 	beqz $t3, add_polynomial_add_q_done

	move $t0, $t3 # go to next link
 	lw $t1, 0($t0) #$t1 = coefficient
 	lw $t2, 4($t0) #$t2 = exponent
 	lw $t3, 8($t0) #t3 = next link

	j add_polynomial_add_q
 add_polynomial_add_q_done:

 move $sp, $s4
 move $a0, $s4
 jal create_polynomial
 
 lw $t0, 4($v0) #check if is empty polynomial
 bnez $t0, add_polynomial_sort
 j add_polynomial_terminate
 
 
 add_polynomial_sort:
 move $a0, $v0
 jal sort_polynomial


 add_polynomial_terminate:
 move $sp, $s7 #save orgiinal stack position
 add_polynomial_terminate2:
 lw $t0, 56($sp)
 lw $t1, 52($sp)
 lw $t2, 48($sp)
 lw $t3, 44($sp)
 lw $t4, 40($sp)
 lw $t5, 36($sp)
 lw $s0, 32($sp)
 lw $s1, 28($sp)
 lw $s2, 24($sp)
 lw $s3, 20($sp)
 lw $s4, 16($sp)
 lw $s5, 12($sp)
 lw $s6, 8($sp)
 lw $s7, 4($sp)
 lw $ra, 0($sp)
 addi $sp, $sp, 60
 jr $ra

.globl mult_polynomial
mult_polynomial:
 addi $sp, $sp, -60
 sw $t0, 56($sp)
 sw $t1, 52($sp)
 sw $t2, 48($sp)
 sw $t3, 44($sp)
 sw $t4, 40($sp)
 sw $t5, 36($sp)
 sw $s0, 32($sp)
 sw $s1, 28($sp)
 sw $s2, 24($sp)
 sw $s3, 20($sp)
 sw $s4, 16($sp)
 sw $s5, 12($sp)
 sw $s6, 8($sp)
 sw $s7, 4($sp)
 sw $ra, 0($sp)
 
 
 move $s7, $sp #save orgiinal stack position
 
 beqz $a0, mult_polynomial_return_empty_poly
 beqz $a1, mult_polynomial_return_empty_poly

 lw $t0, 4($a0)
 lw $t1, 4($a1)
 beqz $t0, mult_polynomial_return_empty_poly
 beqz $t1, mult_polynomial_return_empty_poly
 

 lw $s0, 0($a0) # $s0 = p head terms
 lw $s1, 4($a0) # $s1 = p term count
 lw $s2, 0($a1) # $s2 = q head term
 lw $s3, 4($a1)# $s3 = q term count

 # sto re 0, -1 in stack
 addi $sp, $sp, -12
 li $t0, 0
 li $t1, -1
 sw $t0, 0($sp)
 sw $t1, 4($sp)
 
 #adjust sp 
 mult $s1, $s3  # multiply number of terms together
 mflo $t0
 li $t1, -8
 mult $t0, $t1
 mflo $t0
 add $sp, $sp, $t0
 move $s4, $sp # $s4 = beginning of array of terms(to be jal)
 
 
 move $t0, $s0 # $t0 = p head term address
 lw $t1, 0($t0) #$t1 = coefficient
 lw $t2, 4($t0) #$t2 = exponent
 lw $t3, 8($t0) #t3 = next link
 
 
 mult_polynomial_loop_p:
 	
 	move $t4, $s2 # $t4 = q head term address
 	lw $t5, 0($t4) #$t5 = coefficient
 	lw $t6, 4($t4) #$t6 = exponent
 	lw $t7, 8($t4) #t7 = next link
	mult_polynomial_loop_q:
 		
 		
 		mult $t1, $t5
 		mflo $t8
 		add $t9, $t2, $t6
 		sw $t8, 0($sp)
 		sw $t9, 4($sp)	
 		addi $sp, $sp, 8
 		
 		beqz $t7, mult_polynomial_loop_q_done

		move $t4, $t7 # go to next link
 		lw $t5, 0($t4) #$t1 = coefficient
 		lw $t6, 4($t4) #$t2 = exponent
 		lw $t7, 8($t4) #t3 = next link

		j mult_polynomial_loop_q
		
	mult_polynomial_loop_q_done:	
	beqz $t3, mult_polynomial_added_to_stack
	move $t0, $t3 # go to next link of p
	lw $t1, 0($t0) #$t1 = coefficient
 	lw $t2, 4($t0) #$t2 = exponent
 	lw $t3, 8($t0) #t3 = next link
 j mult_polynomial_loop_p
 
 mult_polynomial_added_to_stack:
 move $sp, $s4
 move $a0, $s4
 jal create_polynomial
 lw $t0, 4($v0)
 beqz $t0, mult_polynomial_return_empty_poly
 move $a0, $v0
 jal sort_polynomial
 j mult_polynomial_terminate
 
 mult_polynomial_return_empty_poly:
 li $a0, 8
 li $v0, 9
 syscall	
 sw $0, 0($v0)
 sw $0, 4($v0)
 j mult_polynomial_terminate
 
 mult_polynomial_terminate:
 move $sp, $s7 #save orgiinal stack position
 lw $t0, 56($sp)
 lw $t1, 52($sp)
 lw $t2, 48($sp)
 lw $t3, 44($sp)
 lw $t4, 40($sp)
 lw $t5, 36($sp)
 lw $s0, 32($sp)
 lw $s1, 28($sp)
 lw $s2, 24($sp)
 lw $s3, 20($sp)
 lw $s4, 16($sp)
 lw $s5, 12($sp)
 lw $s6, 8($sp)
 lw $s7, 4($sp)
 lw $ra, 0($sp)
 addi $sp, $sp, 60
  jr $ra
