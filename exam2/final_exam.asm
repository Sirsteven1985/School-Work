# ECPE 170 Exam Problem
# REcursive function to search array for matching element
# e.g. Searching array [2,3,5,7,11] for element 7
# has result position 3

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
    	la $s5, array		# loads in a value into temp reg $s0
    	lw $s4, asize 		# loads in b value into temp reg $s1
    	lw $s3, srch		# loads in i value into temp reg $s3
 	lw $s2, res		# loads in z value into temp reg $s2
 	
 	
 	la $a0, array			# array as first argument
 	lw $a1, asize			# arraysize as 2nd argument
 	
	jal arraySearch		# function call array search for B
	move $s2, $v0
	
	bge $s2, 0, else
	
iffy:
	li $v0, 4 		# message is printed 
	la $a0, msg0 		# "Search key not found\n"
	syscall
	
	j done			# exits program
	
	
else:

	li $v0, 4 		# message is printed 
	la $a0, msg 		# "Element "
	syscall
	
	li $v0, 1		# print search value
	move $a0, $s3			
	syscall
	
	li $v0, 4 		# message is printed 
	la $a0, msg1 		# " found at array index "
	syscall
	
	li $v0, 1		# print result value
	move $a0, $s2			
	syscall
	
	li $v0, 4 		# message is printed 
	la $a0, msg2 		# " \n"
	syscall
	
	j done			# exits program
	
arraySearch:
	
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s0, 0($sp)		# Save $s0 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s1, 0($sp)		# Save $s1 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s2, 0($sp)		# Save $s2 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $ra, 0($sp)		# Save $ra to stack
	
	move $t0, $a0        	# move array = $t0
	move $t1, $a1        	# move array size = $t1
	lw $s3, srch			# loads in i value into reg $s3
	
a_search:
	la $t0, array

	beq $t1, -1, a_srch_pop
	
	move $s0, $t1
	mul $s0, $s0, 4
	add $t0, $t0, $s0
	lw $t3, 0($t0)
	
	beq $t3, $s3, a_srch_pop_2
	
	sub $t1, $t1, 1

	
	j a_search
	
a_srch_pop:

	move $v0, $t1		# return $t4

	lw $ra, 0($sp)		# Restore $ra to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s2, 0($sp)		# Restore $s2 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s1, 0($sp)		# Restore $s1 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s0, 0($sp)		# Restore $s0 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	
	jr $ra			# return value
	

			
a_srch_pop_2:

	move $v0, $t1		# return $t4

	lw $ra, 0($sp)		# Restore $ra to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s2, 0($sp)		# Restore $s2 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s1, 0($sp)		# Restore $s1 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s0, 0($sp)		# Restore $s0 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	
	jr $ra			# return value
	 			
	
done: 

	# Exit the program by means of a syscall.
	# There are many syscalls - pick the desired one
	# by placing its code in $v0. The code for exit is "10"
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit

	# All memory structures are placed after the
	# .data assembler directive
	.data

	# The .word assembler directive reserves space
	# in memory for a single 4-byte word (or multiple 4-byte words)
	# and assigns that memory location an initial value
	# (or a comma separated list of initial values)

array:	.word 2, 3, 5, 7, 11		# initializing 4 byte global variable int to 50000

asize:	.word 5		# initializing 4 byte global variable int to 60000
srch:	.word 7			# initializing 4 btye variable a to binary NULL
res:	.word 0			# initializing 4 byte variable b to binary NULL
msg0:  .asciiz "Search key not found\n"
msg: 	.asciiz "Element " 		# contains message to print
msg1: 	.asciiz " found at array index " 		# contains message to print
msg2:	.asciiz " \n" 		# contains message to print
