# A demonstration of some simple MIPS instructions
# used to test QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
    	lw $t0, a		# loads in a value into temp reg $t0
    	lw $t1, b 		# loads in b value into temp reg $t1
    	lw $t3, i		# loads in i value into temp reg $t3
    	
	li $v0, 4 		# code for syscall: print_string
	la $a0, msg		# pointer to string of msg to $a0
	syscall
	li $v0, 8 		# code for syscall: read_string
	la $a0, string 		# loading address of user string into $a0
	li $a1, 256 		# reads in 256 character string
	syscall 
	la $t0, string 		# loads address of user string array into $t0
	la $t1, end		# address of end(NULL pointer) into $t1
while: 
	lb $t2, 0($t0) 		# byte of first element into $t2
	beqz $t2, NULL 		# if array is NULL, goes to NULL 
	beq $t2,'e', find_e 	# byte at $t2 equal to e, branch to find_e 
	addi $t3, $t3, 1 	# increments i++ 
	add $t0, $t0, 1		# increments array++ 
	j while 		# jumps back into while loop

f_loop:
	
	addi $t3, $t3, 1 	# increments i++ 
	
find_e: 
	sw $t2, end 		# storing resulting character 
	j if 			# jumps to if 
if: 
	lw $t4, end 		# load result to $t4
	beq $t4, $0, NULL 	# if pointer is NULL, then branch to NULL
	li $v0, 4 		# message is printed 
	la $a0, msg1 		# load msg1 into $a0 
	syscall 
	move $a0, $t0 		# load address of array into $a0 
	li $v0, 1 		# prints integer 
	syscall
	li $v0, 4 		# message printed 
	la $a0, msg2 		# load address of msg2 to $a0 
	syscall 
	la $a0, 0($t4) 		# load address $a0 
	li $v0, 11 		# prints character 'e'
	syscall
	j done			# jumps to end of program
NULL: 
	li $v0, 4 		# allows a message to be printed 
	la $a0, msg3 		# loading address of msg3 into $a0 
	syscall 
	j done			# jumps to end of program
	
gcd:				# GCD of two numbers (a($t0), b($t1)) using recursive Euclid method
	divu $t0, $t3		# i($t0) mod 2($t3)
	mfhi $t6      	  	# temp for the mod stored in ($t6)
	beq $t6, 0, Lmod   	# if mod == 0, jump over to L1
	add $t2, $t2, $t0  	# k = k + i
	
GCD:			# get random function returns random number
	addi $sp, $sp, -4	#
	sw $s0, 0($sp)		#
	addi $sp, $sp, -4	#
	sw $s1, 0($sp)		#
	addi $sp, $sp, -4	#
	sw $ra, 0($sp)		#
	

	lw $s0, a		#
	lw $s1, b		#
	
	and $t3, $s0, $t2	#
	mul $t3, $t0, $t3	#
	srl $t4, $s0, 16	#
	addu $s0, $t3, $t4	#
	sw$s0, z		#
	
	sll $t3, $s0, 16	# z<<16
	addu $t3, $t3, $s1	#
	
	move $v0, $t3		#
	
	lw $ra, 0($sp)		#
	addi $sp, $sp, 4	#
	lw $s1, 0($sp)		#
	addi $sp, $sp, 4	#
	lw $s0, 0($sp)		#
	addi $sp, $sp, 4	#
	
	jr $ra	
	
	 			
get_random:			# get random function returns random number

	addi $sp, $sp, -4	#
	sw $s0, 0($sp)		#
	addi $sp, $sp, -4	#
	sw $s1, 0($sp)		#
	addi $sp, $sp, -4	#
	sw $ra, 0($sp)		#
	
	li $t0, 36969		# load integer 36969 into temp reg $t0
	li $t1, 18000		# load integer 18000 into temp reg $t1
	li $t2, 65535		# load integer 65535 into temp reg $t2
	
	lw $s0, z		# load word z into reg $s0
	lw $s1, w		# load word w into reg $s1
	
	and $t3, $s0, $t2	# m_z & 65535
	mul $t3, $t0, $t3	# 36969 * (m_z & 65535)
	srl $t4, $s0, 16	# m_z >> 16
	addu $s0, $t3, $t4	# add unsigned (36969 * (m_z & 65535))   +   (m_z >> 16);
	sw $s0, z		#
	
	and $t3, $s1, $t2	# m_w & 65535
	mul $t3, $t1, $t3	# 18000 * (m_w & 65535)
	srl $t4, $s1, 16	# m_w >> 16
	addu $s1, $t3, $t4	# add unsigned (18000 * (m_w & 65535))   +   (m_w >> 16);
	sw $s1, w		#
	
	sll $t3, $s0, 16	# m_z << 16 
	addu $t3, $t3, $s1	# m_z << 16 + m_w
	
	move $v0, $t3		# moves ( m_z << 16 + m_w ) into return register
	
	lw $ra, 0($sp)		#
	addi $sp, $sp, 4	#
	lw $s1, 0($sp)		#
	addi $sp, $sp, 4	#
	lw $s0, 0($sp)		#
	addi $sp, $sp, 4	#
	
	jr $ra			#
	
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
a:	.word 0			# initializing 4 btye variable a to binary NULL
b:	.word 0			# initializing 4 byte variable b to binary NULL
i:	.word 0			# initializing 4 byte variable b to binary NULL
msg: 	.asciiz "GCD(" 		#tells user to enter string

