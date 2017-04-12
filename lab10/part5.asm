# A demonstration of some simple MIPS instructions
# used to test QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
    	lw $t3, i 		# loads in i value into temp reg $t3
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
	j done 			# jumps to end of program
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

string: .byte 0:255 		#char string[256]
i:	.word 0 		#setting i=0
end: 	.word 0 		#char *result = NULL // NULL pointer is binary 0
msg: 	.asciiz "Enter a string up to 256 characters: " #tells user to enter string
msg1: 	.asciiz "First match at address: " #tells user address of first match 
msg2: 	.asciiz "\nThe matching character is: " #tells what matching character
msg3: 	.asciiz "\nNo match found " #no match

