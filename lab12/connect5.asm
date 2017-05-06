	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		


main:
 	lw $s1, m_w
 	lw $s2, m_z
 	la $s4, bord
 	lw $s6, i
 	
	li $v0, 4 		#function call to print
	la $a0, msg 		#actually prints msg "Welcome to Connect Four, Five-in-a-Row variant! \nVersion 1.0\nImplemented by Steve
	syscall
	
	li $v0, 4		#message is printed
	la $a0, msg1		#actually prints msg "Enter two positive numbers to initialize the random number generator.\nNumber 1
	syscall

	li $v0, 5		# reading in user imp
	syscall
	
	move $s1, $v0		#loading address of num chosen
	sw $s1, m_w
	
	li $v0, 4		#message is printed
	la $a0, msg2 		#actually prints msg "\nNumber 2: "
	syscall

	li $v0, 5		# reading in user imp
	syscall
	
	move $s2, $v0		#loading address of num chosen
	sw $s2, m_z
	
	li $v0, 4 		#message is printed
	la $a0, msg3 		#actually prints msg "\nHuman player (H)\nComputer player (C)\n"
	syscall
	
	li $a0, 1		# 1 as first argument
	li $a1, 10		# 10 as 2nd argument
	
	jal random_in_range	# function call random_in_range for B
	move $s5, $v0		# move return value into $s1 = flip
	
	li $v0, 4		#message is printed
	la $a0, msg4 		#actually prints msg "Coin flip... "
	syscall
	
	ble $s5, 5, hum
	
	li $v0, 4		#message is printed
	la $a0, msg6		#actually prints msg "COMPUTER goes first.\n\n"
	syscall
	
create:	
	jal createBoard 	#makes board
	jal printBoard 		#jumps and links board
	j floop
	
hum:
	li $v0, 4		#message is printed
	la $a0, msg5 		#actually prints msg "HUMAN goes first.\n\n"
	syscall
	j create

floop:
	bge $s6, 21, gameover # if i >= 5 break out of for loop
	jal EndGame
	ble $s5, 5, human_first
	j comp_first
	
loop:	
	addi $s6, $s6, 1 	# implements i++
	j floop

human_first:
	jal human
	jal printBoard
	jal EndGame
	jal computer
	jal printBoard
	jal EndGame
	j loop
	
comp_first:
	jal computer
	jal printBoard
	jal EndGame
	jal human
	jal printBoard
	jal EndGame
	j loop
	
human:
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s0, 0($sp)		# Save $s0 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s1, 0($sp)		# Save $s1 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s2, 0($sp)		# Save $s2 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s3, 0($sp)		# Save $s3 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s5, 0($sp)		# Save $s5 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $ra, 0($sp)		# Save $ra to stack
	
	li $s5, 2		# 2 = human
inv:
	li $v0, 4		#message is printed
	la $a0, msg13 	#actually prints msg "What column would you like to drop token into? Enter 1-7: "
	syscall
	
	
	la $s4, bord		# set base address of bord
	lw $s0, offset
	li $v0, 5		# reading in user imp
	syscall

	move $s0, $v0		#move input to offset

	
	blt, $s0, 1, invalid	#checks if input<1 or input>7 goes to invalid
	bgt, $s0, 7, invalid
	
	
	mul $s0, $s0, 4	# multiplys offset by 4
	add $s4, $s4, $s0	# shifts base address of bord[offset]
	lw $s1, 0($s4)	# loads in value from bord[offset]
	
	bne $s1, 0, col_full	# if value = 0 columns full
	
	la $s4, bord
	
		
	li $s1, 5		# row = 5
	
for_human:
	la $s4, bord
	
	mul $s2, $s1, 36	# mult (9*4)*row
	
	add $s2, $s0, $s2	# $s2 + offset
	
	add $s4, $s4, $s2	# $ shift base address by (9*row + offset)*4bytes
	
	lw $s3, 0($s4)	# load value at bord[$s2 + offset]
	
	beq $s3, 0, insert	# if $s3 = 0 row + offset empty insert 2
	beq $s1, 0, human_return	# when i = 0 return
	sub $s1, $s1, 1	# move up 1 row
	
	j for_human
	
human_return:	
	lw $ra, 0($sp)		# Restore $ra to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s5, 0($sp)		# Restore $s5 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s3, 0($sp)		# Restore $s3 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s2, 0($sp)		# Restore $s2 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s1, 0($sp)		# Restore $s1 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s0, 0($sp)		# Restore $s0 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	
	jr $ra
	
invalid:			#Checks for invalid input

	li $v0, 4		#message is printed
	la $a0, msg14		# msg "\nInvalid input! \n"
	syscall
	
	j inv		# jump back to human for next input
			
col_full:
	li $v0, 4 		#function call to print
	la $a0, msg15 		#actually prints msg
	syscall
	j inv
insert:
	sw $s5, 0($s4)
	j human_return
	
computer:
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s0, 0($sp)		# Save $s0 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s1, 0($sp)		# Save $s1 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s2, 0($sp)		# Save $s2 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s3, 0($sp)		# Save $s3 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s5, 0($sp)		# Save $s3 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $ra, 0($sp)		# Save $ra to stack

	li $s5, 1		# 1 = computer
			
com_ret:	la $s4, bord        # base address of game
    
    	# Setting num = random_in_range(1,7)    
    	li $a0, 1        # argument: 1
    	li $a1, 7        # argument: 7
    	jal random_in_range    # function call
    	move $s0, $v0        # $s0 = num
	
	li $v0, 4		#message is printed
	la $a0, msg16 	#actually prints msg "Computer player selected column "
	syscall
	
	li $v0, 1		# print int
	move $a0, $s0
	syscall
	
	li $v0, 4		#message is printed
	la $a0, msg12 	#actually prints msg "\n"
	syscall
	
	mul $s0, $s0, 4	# multiplys offset by 4
	add $s4, $s4, $s0
	lw $s1, 0($s4)	# loads in value from bord[offset]
	
	bne $s1, 0, col_full_c	# if value = 0 columns full
	
	la $s4, bord

		
	li $s1, 5		# row = 5
	
for_comp:
	la $s4, bord
	
	mul $s2, $s1, 36	# mult (9*4)*row
	
	add $s2, $s0, $s2	# $s2 + offset
	
	add $s4, $s4, $s2
	
	lw $s3, 0($s4)	# load value at bord[$s2 + offset]
	
	beq $s3, 0, insert_c
	beq $s1, 0, comp_return
	sub $s1, $s1, 1	# move up 1 row
	
	j for_comp
	
comp_return:	
	lw $ra, 0($sp)		# Restore $ra to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s5, 0($sp)		# Restore $s5 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s3, 0($sp)		# Restore $s3 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s2, 0($sp)		# Restore $s2 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s1, 0($sp)		# Restore $s1 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s0, 0($sp)		# Restore $s0 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	
	jr $ra
	
			
col_full_c:
	li $v0, 4 		#function call to print
	la $a0, msg15 		#actually prints msg
	syscall
	j com_ret
	
insert_c:
	sw $s5, 0($s4)
	j comp_return

	
createBoard:
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s0, 0($sp)		# Save $s0 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s1, 0($sp)		# Save $s1 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s2, 0($sp)		# Save $s2 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $ra, 0($sp)

	lw $s0, k       	# k=0 into $s0
    
    	la $s4, bord		# base address
	li $s1, 1		# input element 1
	sw $s1, 0($s4)	# storing 1 in base address

	
 for_i: 
	addi $s4, $s4, 32    # i*9*4 for element
	sw $s1, 0($s4)
	
	bge $s0, 2, reset_i    # i >= ROWS(6), jump to j
	
	# Multiply k by 4
	addi $s4, $s4, 40    # i*9*4 for element
	sw $s1, 0($s4)

	addi $s0, $s0, 1    	# i++
	j for_i
	
 reset_i:
	li $s0, 0		# sets i to j = 0 for next loop
	la $s4, bord		#starts a base address
	addi $s4, $s4, 36	# shift 9 elements
	li $s1, 2
	sw $s1, 0($s4)	#load 2 into element 9
 for_j:
 	addi $s4, $s4, 32    # i*9*4 for element
	sw $s1, 0($s4)
	
	bge $s0, 2, stak    # i >= ROWS(6), jump to stak
	
	# Multiply k by 4
	addi $s4, $s4, 40    # i*9*4 for element
	sw $s1, 0($s4)

	addi $s0, $s0, 1    	# i++
	j for_j
	
 stak:
	lw $ra, 0($sp)		# Restore $ra to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s2, 0($sp)		# Restore $s2 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s1, 0($sp)		# Restore $s1 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s0, 0($sp)		# Restore $s0 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	
	jr $ra

printBoard: 
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s0, 0($sp)		# Save $s0 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s1, 0($sp)		# Save $s1 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s2, 0($sp)		# Save $s2 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s3, 0($sp)		# Save $s3 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $ra, 0($sp)		# Save $ra to stack
	
	la $s4, bord		#starts a base address
	li $s0, 0
	li $s3, 9
	j print_4
	
print_4return:
	
	li $v0, 4		#message is printed
	la $a0, msg12		# f
	syscall
		
	li $v0, 4		#message is printed
	la $a0, msg8		# f
	syscall
	
	li $v0, 4		#message is printed
	la $a0, msg12		# f
	syscall
	
	lw $ra, 0($sp)		# Restore $ra to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s3, 0($sp)		# Restore $s3 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s2, 0($sp)		# Restore $s2 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s1, 0($sp)		# Restore $s1 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s0, 0($sp)		# Restore $s0 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	
	jr $ra
	
print_4:
	
	li $v0, 4		#message is printed
	la $a0, msg7		# f
	syscall
	
	li $v0, 4		#message is printed
	la $a0, msg8		# f
	syscall
 mid_sec:	
 	bge $s0, 54, print_4return
	lw $s1 , 0($s4)
	addi $s4, $s4, 4
	move $s2, $s0		# duplicate i
	#addi $s2, $s2, 1
	div $s2, $s3
	mfhi $s2
	beq $s2, 0, print_line
here:
	beq $s1, 0, print_dot
	beq $s1, 1, print_c
	beq $s1, 2, print_h
	j mid_sec
	
print_dot:
	li $v0, 4		#message is printed
	la $a0, msg9		# f
	syscall
	addi $s0, $s0, 1    	# i++
	j mid_sec
print_c:
	li $v0, 4		#message is printed
	la $a0, msg10		# f
	syscall
	addi $s0, $s0, 1    	# i++
	j mid_sec
	
print_h:
	li $v0, 4		#message is printed
	la $a0, msg11		# f
	syscall
	addi $s0, $s0, 1    	# i++
	j mid_sec
	
print_line:
	li $v0, 4		#message is printed
	la $a0, msg12		# f
	syscall
	j here

	
EndGame:
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s0, 0($sp)		# Save $s0 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s1, 0($sp)		# Save $s1 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s2, 0($sp)		# Save $s2 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s3, 0($sp)		# Save $s3 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s5, 0($sp)		# Save $s5 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s6, 0($sp)		# Save $s6 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $s7, 0($sp)		# Save $s7 to stack
	addi $sp, $sp, -4	# Adjust stack pointer
	sw $ra, 0($sp)		# Save $ra to stack
	
	la $s4, bord
	lw $s0, z		# z = 1
	lw $s1, x		# x = 0
		
z_loop:bge $s0, 3, pop
x_loop:bgt $s1, 53, add_z		
	
	blt $s1, 4, n_dia
	beq $s1, 9, n_dia
	beq $s1, 10, n_dia
	beq $s1, 11, n_dia
	beq $s1, 12, n_dia
	bgt $s1, 17, n_dia
	
	mul $s2, $s1, 4
	add $s4, $s4, $s2
	lw $s3, 0($s4)		# $s3 = bord[x]
	bne $s3, $s0, n_dia
	
	
	addi $s4, $s4, 32
	lw $s3, 0($s4)		# $s3 = bord[x+8]
	bne $s3, $s0, n_dia
	
	addi $s4, $s4, 32
	lw $s3, 0($s4)		# $s3 = bord[x+16]
	bne $s3, $s0, n_dia
	
	addi $s4, $s4, 32
	lw $s3, 0($s4)		# $s3 = bord[x+24]
	bne $s3, $s0, n_dia
	
	addi $s4, $s4, 32
	lw $s3, 0($s4)		# $s3 = bord[x+32]
	bne $s3, $s0, n_dia
	
	beq $s0, 1, cdia
	beq $s0, 2, hdia
	
n_dia:	
	la $s4, bord
	li $s2, 0
	
	bgt $s1, 13, vert
	beq $s1, 5, vert
	beq $s1, 6, vert
	beq $s1, 7, vert
	beq $s1, 8, vert
	
	mul $s2, $s1, 4
	add $s4, $s4, $s2
	lw $s3, 0($s4)		# $s3 = bord[x]
	bne $s3, $s0, vert
	
	addi $s4, $s4, 40
	lw $s3, 0($s4)		# $s3 = bord[x+10]
	bne $s3, $s0, vert
	
	addi $s4, $s4, 40
	lw $s3, 0($s4)		# $s3 = bord[x+20]
	bne $s3, $s0, vert
	
	addi $s4, $s4, 40
	lw $s3, 0($s4)		# $s3 = bord[x+30]
	bne $s3, $s0, vert
	
	addi $s4, $s4, 40
	lw $s3, 0($s4)		# $s3 = bord[x+40]
	bne $s3, $s0, vert
	
	beq $s0, 1, cdia
	beq $s0, 2, hdia

vert:	
	la $s4, bord
	li $s2, 0
	
	bgt $s1, 17, hori
	
	mul $s2, $s1, 4
	add $s4, $s4, $s2
	lw $s3, 0($s4)		# $s3 = bord[x]
	bne $s3, $s0, hori
	
	addi $s4, $s4, 36
	lw $s3, 0($s4)		# $s3 = bord[x+9]
	bne $s3, $s0, hori
	
	addi $s4, $s4, 36
	lw $s3, 0($s4)		# $s3 = bord[x+18]
	bne $s3, $s0, hori
	
	addi $s4, $s4, 36
	lw $s3, 0($s4)		# $s3 = bord[x+27]
	bne $s3, $s0, hori
	
	addi $s4, $s4, 36
	lw $s3, 0($s4)		# $s3 = bord[x+36]
	bne $s3, $s0, hori
	
	beq $s0, 1, cvert
	beq $s0, 2, hvert
	
hori:	
	la $s4, bord
	li $s2, 0
	
	bgt $s1, 49, end_x
	
	mul $s2, $s1, 4
	add $s4, $s4, $s2
	lw $s3, 0($s4)		# $s3 = bord[x]
	bne $s3, $s0, end_x
	
	
	addi $s4, $s4, 4
	lw $s3, 0($s4)		# $s3 = bord[x+1]
	bne $s3, $s0, end_x
	
	addi $s4, $s4, 4
	lw $s3, 0($s4)		# $s3 = bord[x+2]
	bne $s3, $s0, end_x
	
	addi $s4, $s4, 4
	lw $s3, 0($s4)		# $s3 = bord[x+3]
	bne $s3, $s0, end_x
	
	addi $s4, $s4, 4
	lw $s3, 0($s4)		# $s3 = bord[x+4]
	bne $s3, $s0, end_x
	
	beq $s0, 1, chori
	beq $s0, 2, hhori
	
end_x:	
	addi $s1, $s1, 1		# x++
	j x_loop
	
add_z:	
	addi $s0, $s0, 1		# z++
	li $s1, 0			#TEST----------------------------------------------------
	j z_loop	
	
cdia:	
	li $v0, 4		#message is printed
	la $a0, msg17		# You lose, Computer won diagonally
	syscall
	j gameover
	
hdia:	
	li $v0, 4		#message is printed
	la $a0, msg18		# congrats, human won diagonally
	syscall
	j gameover
	
cvert:	
	li $v0, 4		#message is printed
	la $a0, msg19		# You lose, Computer won vertically
	syscall
	j gameover
	
hvert:	
	li $v0, 4		#message is printed
	la $a0, msg20		# congrats, human won vertically
	syscall
	j gameover
	
chori:	
	li $v0, 4		#message is printed
	la $a0, msg21		# You lose, Computer won horizontally
	syscall
	j gameover
	
hhori:	
	li $v0, 4		#message is printed
	la $a0, msg22		# congrats, human won horizontally
	syscall
	j gameover
	
	
pop:	lw $ra, 0($sp)		# Restore $ra to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s7, 0($sp)		# Restore $s7 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s6, 0($sp)		# Restore $s6 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s5, 0($sp)		# Restore $s5 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s3, 0($sp)		# Restore $s3 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s2, 0($sp)		# Restore $s2 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s1, 0($sp)		# Restore $s1 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	lw $s0, 0($sp)		# Restore $s0 to stack
	addi $sp, $sp, 4	# Adjust stack pointer
	
	jr $ra			# return value

# Generate random number in range [low, high] (i.e. including low and high)
random_in_range:
    addi $sp, $sp, -4    # push on to stack
    sw $s0, 0($sp)
    addi $sp, $sp, -4    
    sw $s1, 0($sp)
    addi $sp, $sp, -4    
    sw $ra, 0($sp)

    move $s0, $a0        # move low = $s0
    move $s1, $a1        # move high = $s1
    
    subu $t7, $s1, $s0    # range ($t7) = high - low
    addiu $t7, $t7, 1    # range ($t7) = high - low + 1
    
    jal get_random        # function call to get_random
    move $t0, $v0        # return value to rand_num ($t0)
    
    divu $t0, $t7        # rand_num ($t0) / range ($t7)
    mfhi $t2        # rand_num % range = $t2
    addu $t2, $t2, $s0    # $t2 = (rand_num % range) + low

    move $v0, $t2        # return value
    
    lw $ra, 0($sp)        # pop from stack
    addi $sp, $sp, 4    
    lw $s1, 0($sp)        
    addi $sp, $sp, 4
    lw $s0, 0($sp)        
    addi $sp, $sp, 4
    
    jr $ra            # return from function
#-------------------------------------------------------------------------------------------------------------------------------------------
# Get Random Function
get_random:
    addi $sp, $sp, -4    # push on to stack
    sw $s0, 0($sp)
    addi $sp, $sp, -4
    sw $s1, 0($sp)
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $t0, 36969
    li $t1, 18000
    li $t2, 65535
    lw $s0, m_z        # load global z from memory
    lw $s1, m_w        # load global w from memory
    
    and $t3, $s0, $t2    # $t3 = z & 65535
    mul $t3, $t0, $t3    # $t3 = 36969 * (z & 65535)
    srl $t4, $s0, 16    # $t4 = z >> 16
    addu $s0, $t3, $t4    # z = 36969 * (z & 65535) + (z >> 16)
    sw $s0, m_z        # store $s0 into z
    
    and $t3, $s1, $t2    # $t3 = w & 65535
    mul $t3, $t1, $t3    # $t3 = 18000 * (w & 65535)
    srl $t4, $s1, 16    # $t4 = w >> 16
    addu $s1, $t3, $t4    # w = 18000 * (w & 65535) + (w >> 16)
    sw $s1, m_w        # store $s0 into w
    
    sll $t3, $s0, 16    # z  << 16
    addu $t3, $t3, $s1    # result = (z << 16) + w
    move $v0, $t3        # return location
    
    lw $ra, 0($sp)        # pop the stack
    addi $sp, $sp, 4
    lw $s1, 0($sp)
    addi $sp, $sp, 4
    lw $s0, 0($sp)
    addi $sp, $sp, 4
    
    jr $ra            # return from function


gameover: #in this chunk of code the code will decide if the computer won or if the player won 
	
	li $v0, 4 		#function call to print
	la $a0, msg25 		#actually prints msg
	syscall

	# Exit the program by means of a syscall.
	# There are many syscalls - pick the desired one
	# by placing its code in $v0. The code for exit is "10"
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit

	# .data assembler directive
	.data

# global values and array
m_w:		.word 0			# initializing 4 byte global variable int to 0
m_z:		.word 0			# initializing 4 byte global variable int to 0
i:		.word 0
bord: 		.word 0:54			# initializing aray size 54 with 4 bytes each containing 0
x:		.word 0			# initializing 4 byte global variable int to 0
z:		.word 1			# initializing 4 byte global variable int to 0
offset: 	.word 0
k:		.word 0

# main beginning messages
msg: 		.asciiz "Welcome to Connect Four, Five-in-a-Row variant! \nVersion 1.0\nImplemented by Steve Guerrero \n\n" #text that is displayed 
msg1: 		.asciiz "Enter two positive numbers to initialize the random number generator.\nNumber 1: " #text that is displayed
msg2: 		.asciiz "\nNumber 2: " 	#text that is displayed
msg3: 		.asciiz "\nHuman player (H)\nComputer player (C)\n" #text that is displayed
msg4: 		.asciiz "Coin flip... "
msg5: 		.asciiz "HUMAN goes first.\n\n"
msg6: 		.asciiz "COMPUTER goes first.\n\n"

# printBoard messages
msg7: 		.asciiz "    1  2  3  4  5  6  7   \n"
msg8: 		.asciiz "   --------------------- "
msg9: 		.asciiz " . "
msg10: 	.asciiz " C "
msg11: 	.asciiz " H "
msg12: 	.asciiz "\n"

# human and computer function messages
msg13: 	.asciiz "What column would you like to drop token into? Enter 1-7: "
msg14: 	.asciiz "\nInvalid input! \n"
msg15: 	.asciiz "Column is full! \n"
msg16: 	.asciiz "Computer player selected column "

# EndGame function messages
msg17: 	.asciiz "You Lose, Computer Won Diagonally!\n"
msg18: 	.asciiz "Congratulations, Human Won Diagonally!\n"
msg19: 	.asciiz "You Lose, Computer Won Vertically!\n"
msg20: 	.asciiz "Congratulations, Human Won Vertically!\n"
msg21: 	.asciiz "You Lose, Computer Won Horizontally!\n"
msg22: 	.asciiz "Congratulations, Human Won Horizontally!\n"

# Gameover message
msg25: 	.asciiz "\nGAME OVER\n"
