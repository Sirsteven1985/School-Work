# A demonstration of some simple MIPS instructions
# used to test QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
	#load in values for i & Z
	lw $t1, i		# Load the word stored at label 'i'
	lw $t2, Z		# Load the word stored at label 'Z'

	
	#begin while loop
loop: 
   	add $t1, $t1, 2  	#add 2 to i each iteration i+=2;
   	addi $t2, $t2, 1 	#same as Z++ 
   	bgt $t1, 20, do   	#while loop ending condition i>20
   	j loop	 		#define loop
	
do: 
   	addi $t2, $t2, 1   	#+ to Z so Z++
   	blt $t2, 100, do   	#define do
   	
	#starting while loop
while: 
   	sub $t2, $t2, 1   	#subtracts Z so --Z
   	sub $t1, $t1, 1   	#subtracts i so --i
   	bgt $t1, 0, while 	#end whileloop
   	
   	
	sw $t2, Z
	sw $t1, i

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
	

i:	.word 0
Z:	.word 2




#int main()
#{
#   int Z=2;
#   int i;
#
#  i=0;
#   while(1){
#     if(i>20)
#       break;
#    Z++;
#    i+=2;
#   }
# 
#   do {
#      Z++;
#   } while (Z<100);
#  
#   while(i > 0) {
#      Z--;
#      i--;
#}
