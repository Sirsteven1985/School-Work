# A demonstration of some simple MIPS instructions
# used to test QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:

	lw $t1, A		# Load the word stored at label 'A'
	lw $t2, B		# Load the word stored at label 'B'
	add $t7, $t1, $t2	# Add (A+B) store in $t7
	lw $t3, C		# Load the word stored at label 'C'
	lw $t4, D		# Load the word stored at label 'D'
	sub $s2, $t3, $t4	# Subtract (C-D) store in $s2
	lw $t5, E		# Load the word stored at label 'E'
	lw $t6, F		# Load the word stored at label 'F'
	lw $s1, Z		# Load the word stored at label 'Z'
	add $s3, $t5, $t6	# Add (E+F) store in $s3
	sub $s4, $t1, $t3	# Subtract (A-C) stored in $s4
	add $s5, $t7, $s2	# Add (A+B)+(C-D) store in $s5
	add $s6, $s5, $s3	# Add (A+B)+(C-D)+(E+F) store in $s6
	sub $s1, $s6, $s4	# Subtract ((A+B)+(C-D)+(E+F))-(A-C) store in $s1
	sw $s1 Z		# Storing final value in $s1 for 'Z'


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
A:	.word 15
B:	.word 10
C:	.word 7
D:	.word 2
E:	.word 18
F:	.word -3
Z:	.word 0
