# A demonstration of some simple MIPS instructions
# used to test QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
	lw $t0, i 		# loads in i value into temp reg
	la $s0, A 		# loads address to create array A
	la $s1, B 		# loads address to create array B
	lw $t3, C 		# loads in C value into temp reg
	###bge $t0, 0, f_loop #starts for loop when i >= 0

#creating for-loop
f_loop:
	bge $t0, 5, breakout 	# if i >= 5 break out of for loop
	lw $t2, 0($s1) 		# storing address of B array in temp reg
	add $t2, $t2, $t3 	# adding C to B[i]
	sw $t2, 0($s0) 		# storing B[i] + C to array A[i]
	addi $s0, $s0, 4 	# adds to array A by 4 bytes to shift to next array address
	addi $s1, $s1, 4 	# adds to array B by 4 bytes to shift to next array address
	addi $t0, $t0, 1 	# implements i++
	j f_loop
breakout: 
	sub $t0, $t0, 1 	# implement i-- before entering while loop
	sub $s0, $s0, 4 	# subtracts from array A by 4 bytes
	sub $s1, $s1, 4 	# subtracts from array B by 4 bytes
	bge $t0, 0, w_loop 	# enter whileloop when i is greater than or equal to 0
	j done			# if i is not greater than 0; end program
w_loop: 
	lw $t4, 0($s0) 		# storing array A in temp reg $t4
	mul $t4, $t4, 2 	# multiplys A[i] by 2 stores back in temp reg $t4
	sw $t4, 0($s0) 		# stores $t4 value into A[i]
	sub $t0, $t0, 1 	# i--
	sub $s0, $s0, 4 	# subtracts from array A by 4 bytes; shifts to prev address
	sub $s1, $s1, 4 	# subtracts from array B by 4 bytes; shifts to prev address
	blt $t0, 0, done 	# breakout when i is greater than or equal to 0 fails
	j w_loop		# jumps back fo next iteration if not done
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
	

A: .word 0:5
B: .word 1, 2, 3, 4, 5
C: .word 12
i: .word 0

