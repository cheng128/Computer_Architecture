.data
Pnewline: .asciiz "\n"
PA:	.asciiz "input a:"
PB:	.asciiz "input b:"
PAns:	.asciiz "ans:"

.text
move $s0,$zero    # a = 0
move $s1,$zero    # b = 0 
move $s2,$zero    # c = 0
move $s3,$zero    # d = 0

la $a0, PA
jal PrintString	   # print "input a:"
li $v0,5           # ready to read integer(scanf)
syscall            # read value
move $s0,$v0       # move the input number to $s0 register

la $a0, PB
jal PrintString    # print "input b:"
li $v0,5           # ready to read integer(scanf)
syscall            # read value
move $s1,$v0       # move the input number to $s1 register

move $a0,$s0	# move the value of 'a' to $a0
jal _RecBody	# jump to caculate recursive(a)
move $s2,$v0	# move the result to $s2('c')

la $a0, PAns	
jal PrintString	   # print "ans:"
la $a0,($s2)       # load the value of "c" to print
li $v0, 1	   # ready to print integer
syscall	           # print
jal PrintNewline   # print new line

move $a1,$s1	   # move the value of "b" to $a1
move $a2,$s2       # move the value of "c" to $a2
jal _FuncBody      # jump to cacluate function(b,c)
move $s3,$v1       # move the result to $s3('d')

la $a0, PAns
jal PrintString	   # print "ans:"
la $a0,($s3)       # load the value of $s3('d') to print
li $v0, 1	   # ready to print integer
syscall	           # print
j _Exit


_RecBody:
	addi $t0,$zero,255   
	slt $t1,$a0,$t0      	  # test if (x<255) 
	beq $t1,$zero,_RecElse1   # if x>=255($t1=0) go to _RecElse1 to caculate 
	addi $t0,$zero,15    
	slt $t1,$a0,$t0           # test if (x<15)
	beq $t1,$zero,_RecElse2   # if x>=15($t1=0) go to _RecElse2 to caculate
	addi $v0,$zero,1          # x<15 return 1
	jr $ra			  # jump back
	
_RecElse1:
	addi $sp,$sp,-12	  # need to store 3 registers to stack 
	sw $ra,0($sp)		  # store $ra
	sw $a0,4($sp)		  # store the value of x
	
	addi $a0,$a0,-3		  # x-3
	jal _RecBody		  # jump to _RecBody to caculate recursive(x-3)
	sw $v0,8($sp)		  # store the result so it won't be overwritten
	
	lw $a0,4($sp)    	# retrieve the original value of x
	addi $a0,$a0,-2  	# x-2
	jal _RecBody   		# jump to _RecBody to caculate recursive(x-2)  
	
	lw $t0,8($sp)		# retrieve first result ( recursive(x-3) )
	add $v0,$v0,$t0		# recursive(x-3)+recursive(x-2)
	lw $ra,0($sp)		# retrieve return address
	addi $sp,$sp,12         # recover the $sp
	jr $ra
	
_RecElse2:
	addi $sp,$sp,-8	  	# need to store 2 registers to stack
	sw $ra,0($sp)		# store $ra 
	sw $a0,4($sp)		# store $a0
	
	addi $a0,$a0,-1         # x-1
	jal _RecBody   		# jump to _RecBody to caculate recursive(x-1) 
	
	addi $v0,$v0,1          # recursive(x-1)+1
	lw $ra,0($sp)           # retrieve return address 
	addi $sp,$sp,8          # recover the $sp
	jr $ra

_FuncBody:
	
	slt $t0,$zero,$a1 	# test if x > 0
	slt $t1,$zero,$a2 	# test if y > 0
	and $t2,$t0,$t1 	# if x and y both >0 then $t2 = 1
	bne $t2,$zero,_FuncRec  # if $t2 = 1 then jump to else statement
	addi $v1,$zero,1	# return 1 (if $t2=0, means x<=0 or y<=0)
	jr $ra
	
_FuncRec:
	addi $sp,$sp,-16        # need to store 4 registers to stack
	sw $ra,0($sp)		# store $ra
	sw $a1,4($sp)		# store the value of x
	sw $a2,8($sp)		# store the value of y
	
	addi $a1,$a1,-1		# x-1
	jal _FuncBody		# jump to _RecBody to caculate function(x-1,y)
	sw $v1,12($sp)		# store the result so it won't be overwritten
	
	lw $a1,4($sp)           # retrieve the original value of x
	lw $a2,8($sp)           # retrieve the original value of y
	addi $a2,$a2,-1         # y-1
	jal _FuncBody		# jump to _RecBody to caculate function(x,y-1)
	
	lw $t0,12($sp)		# retrieve first result: function(x-1,y)
	add $v1,$v1,$t0		# function(x-1,y)+function(x,y-1)
	lw $ra,0($sp)           # retrieve return address
	addi $sp,$sp,16         # recover the stack
	jr $ra
	
_Exit:
	li   $v0, 10       # ready to exit this program
  	syscall            # exit   



PrintString:
li $v0, 4	 # ready to print string
syscall	         # print
jr $ra           # return 

PrintNewline:
la $a0, Pnewline  # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
jr $ra           # return




