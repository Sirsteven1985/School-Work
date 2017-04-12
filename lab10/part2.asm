# A demonstration of some simple MIPS instructions
# used to test QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
	#load in values for A,B,C
	lw $t1, A		# Load the word stored at label 'A'
	lw $t2, B		# Load the word stored at label 'B'
	lw $t3, C		# Load the word stored at label 'C'
	
	#statement if A>B or C<5
	bgt $t1, $t2, done1	# branch if A>B
	blt $t3, 5, done1 	# if C is less than 5 go to done1
	
	#statement else if( !((A > B) && ((C+1) == 7)))
	add $t5, $t3, 1		# add 1 to C first then compare
	bne $t5, 7, done2 	# branch off to done2 to check next part of stmnt
	ble $t1, $t2, done3
	
	#statement else Z = 3
	li $t4, 3 		#z=3

done1: 	li $t4, 1; j switch	# z=1 jump to switch statements
done2: 	bgt $t1, $t2, done3 	# if t2 is less than 5 jump to done3
done3: 	li $t4, 2 		# z=2

   	#switch statement cases
switch:	beq $t4, 1, case1 	# when Z(t4) is equal to 1 first case 
	beq $t4, 2, case2 	# when Z(t4) is equal to 2 second case
	beq $t4, 3, case3 	# when Z(t4) is equal to 3 third case
	li $t4, 0 		# default Z(t4) = 0

case1: 	li $t4, -1; j end 	# jumps to end and gives value -1
case2: 	li $t4, -2; j end 	# jumps to end and gives value -2
case3: 	li $t4, -3; j end 	# jumps to end and gives value -3

end: 	sw $t4, Z

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
	
A:	.word 10
B:	.word 15
C:	.word 4
Z:	.word 0
