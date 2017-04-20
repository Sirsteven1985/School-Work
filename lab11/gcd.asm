# A demonstration of some simple MIPS instructions
# used to test QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
    	lw $s0, A		# loads in a value into temp reg $s0
    	lw $s1, B 		# loads in b value into temp reg $s1
    	lw $s3, i		# loads in i value into temp reg $s3
 	lw $s2, z		# loads in z value into temp reg $s2
 	lw $s4, w		# loads in w value into temp reg $s4

f_loop:

	bge $s3, 10, done 	# if i >=10 break out of for loop
	li $a0, 1		# 1 as first argument
	li $a1, 100000		# 100000 as 2nd argument
	
	jal random_in_range	# function call random_in_range for A
	move $s0, $v0		# move return value into $s0 = A
	
	li $a0, 1		# 1 as first argument
	li $a1, 100000		# 100000 as 2nd argument
	
	jal random_in_range	# function call random_in_range for B
	move $s1, $v0		# move return value into $s1 = B
		
	li $v0, 4 		# message is printed
	la $a0, msg 		# load msg into $a0
	syscall			# prints "GCD ("
	
	move $a0, $s0		# load address of a into $a0
	li $v0, 1 		# prints "A" Value
	syscall			 
	
	li $v0, 4 		# message is printed 
	la $a0, msg1 		# load msg1 into $a0
	syscall			# prints ","
	
	move $a0, $s1		# load address of b into $a0 
	li $v0, 1 		# prints "B" Value 
	syscall			
	
	li $v0, 4 		# message is printed 
	la $a0, msg2 		# load msg1 into $a0
	syscall			# prints ") = "
	
	move $a0, $s0		# A is first argument
	move $a1, $s1		# B is first argument
	jal GCD			# function call for gcd
	move $s5, $v0		# move return value into $s5
	
	move $a0, $s5		# load address of gcd(a,b) into $a0 
	li $v0, 1 		# prints "gcd(a,b)" value 
	syscall
	
	li $v0, 4 		# message is printed 
	la $a0, msg3 		# load msg1 into $a0
	syscall			# prints ") = "
	
	addi $s3, $s3, 1 	# increments i++ 
	
	j f_loop		# Jumps back into for loop
	
random_in_range:

	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s0, 0($sp)		# Save $s0 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s1, 0($sp)		# Save $s1 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s2, 0($sp)		# Save $s2 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $ra, 0($sp)		# Save $ra to stack
	

	move $s0, $a0		# low value 1
	move $s1, $a1		# high value 100000
	
	subu $t2, $s1, $s0	# high - low
	addiu $t2, $t2, 1	# high - low + 1 to $t2 = range
	
	jal get_random		# get_random call
	move $s2, $v0		# return value in $s2 rand_num

	divu $s2, $t2		# Mod rand_num % range
	mfhi $t4		# Mod value saved to $t4
	addu $t4, $t4, $s0	# (rand_num % range) + low
	
	move $v0, $t4		# return $t4
	
	lw $ra, 0($sp)		# Restore $ra to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s2, 0($sp)		# Restore $s2 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s1, 0($sp)		# Restore $s1 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s0, 0($sp)		# Restore $s0 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	
	jr $ra			# return value
		
GCD:				# get random function returns random number
	

	addi $sp, $sp, -4	# Adjust stack pointer
	sw $ra, 0($sp)		# Save $ra
	

	move $t0, $a0		# $t0 holds A
	move $t1, $a1		# $t1 holds B
	
	divu $t0, $t1		# Mod A % B
	mfhi $t5   		# store modulus in temp

	beq $t5, 0, Help 	# if mod == 0, jump over to not sure if right?
	move $a0, $t1		# New A = B
	move $a1, $t5		# New B = (A % B)
	
	j GCD
			
Help:	
	move $v0, $t1		# return b
	
	
	lw $ra, 0($sp)		# Restore $ra
	addi $sp, $sp, 4	# Adjust stack pointer

	
	
	jr $ra			#return value
	 			
get_random:			# get random function returns random number

	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s0, 0($sp)		# Save $s0 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s1, 0($sp)		# Save $s1 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $ra, 0($sp)		# Save $ra to stack
	
	li $t5, 36969		# load integer 36969 into temp reg $t0
	li $t6, 18000		# load integer 18000 into temp reg $t1
	li $t7, 65535		# load integer 65535 into temp reg $t2
	
	lw $s0, z		# load word z into reg $s0
	lw $s1, w		# load word w into reg $s1
	
	and $t3, $s0, $t7	# m_z & 65535
	mul $t3, $t5, $t3	# 36969 * (m_z & 65535)
	srl $t4, $s0, 16	# m_z >> 16
	addu $s0, $t3, $t4	# add unsigned (36969 * (m_z & 65535))   +   (m_z >> 16);
	sw $s0, z		#
	
	and $t3, $s1, $t7	# m_w & 65535
	mul $t3, $t6, $t3	# 18000 * (m_w & 65535)
	srl $t4, $s1, 16	# m_w >> 16
	addu $s1, $t3, $t4	# add unsigned (18000 * (m_w & 65535))   +   (m_w >> 16);
	sw $s1, w		#
	
	sll $t3, $s0, 16	# m_z << 16 
	addu $t3, $t3, $s1	# m_z << 16 + m_w
	
	move $v0, $t3		# moves ( m_z << 16 + m_w ) into return register
	
	lw $ra, 0($sp)		# Restore $ra to stack
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

w:	.word 50000		# initializing 4 byte global variable int to 50000
z:	.word 60000		# initializing 4 byte global variable int to 60000
A:	.word 0			# initializing 4 btye variable a to binary NULL
B:	.word 0			# initializing 4 byte variable b to binary NULL
i:	.word 0			# initializing 4 byte variable b to binary NULL
msg: 	.asciiz "GCD(" 		# contains message to print
msg1: 	.asciiz "," 		# contains message to print
msg2: 	.asciiz ") = " 		# contains message to print
msg3:	.asciiz "\n" 		# contains message to print
