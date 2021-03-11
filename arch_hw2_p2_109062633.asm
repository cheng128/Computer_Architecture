.data
str1:		.asciiz "The Bomb has been activated!!!"
str2:		.asciiz "Please enter your lucky number[0-9]: "
str3:		.asciiz "You have only "
str4:		.asciiz " times to inactivate it!!!"
str5:		.asciiz "HA!HA!HA! Wrong Guess!"
str6:		.asciiz "You should choose a bigger number!"
str7:		.asciiz "You should choose a smaller number!"
str8:		.asciiz "Bye Bye!!!Boom!!!"
str9:		.asciiz "Wow! You are very lucky! The boom has been inactive!"
newline: 	.asciiz "\n"
.text


#########DONOT MODIFY HERE###########
#Setup random
addi $a1, $zero, 10
addi $v0, $zero, 42  
syscall
# li   $v0, 1           	
# syscall
move $t0, $a0 # Hint: Donot overwrite $t0, it stores the random number
##########################################   
		
#Setup counter
addi $t1,$zero,3  # set the counter to 3 and place it in the register $t1
la $a0, str1      # load address of string to print
jal PrintString   # jump and link to PrintString 
jal PrintNewline  # jump and link to PrintNewline

#Game loop start!      	
_Start:
	#printf something
	la $a0, str3	   # load address of string to print
	jal PrintString    # jump and link to PrintString 
	la $a0,($t1)       # load the value of counter to print
	li $v0, 1	   # ready to print integer
	syscall	           # print
	la $a0, str4	   # load address of string to print
	jal PrintString    # jump and link to PrintString 
	jal PrintNewline   # jump and link to PrintNewline
	#scanf
	la $a0, str2	   # load address of string to print
	jal PrintString    # jump and link to PrintString 
	jal PrintNewline   # jump and link to PrintNewline
	li $v0,5           # ready to read integer(scanf)
	syscall            # read value
	move $t2,$v0       # move the input number to $t2 register

  	
  	beq $t0,$t2,_Win      # compare the the input value($t2) and the random number($t0), if equals, go to _Win 
  	
  	#if not, continute from here
  	addi $t3,$zero,1      # put the value 1 into the $t3
  	beq $t3,$t1,_Lose     # check the counter(compares counter with $t3(1)) if equals, go to _Lose
  	
  	#if counter is not equal to 1, check who is bigger(jump to _Bigger)
  	slt $t4,$t2,$t0       # compares random number($t0) with the input number($t2), if the input is smaller, set $t4 to 1
  	bne $zero,$t4,_Bigger # if the input is smaller, the value of $t4 will be 1 then not equals to zero, go to _Bigger
  	
  	j _Smaller           # otherwise means input number is bigger, go to _Smaller
  	 	
  	 	 	 	
#win event 	
_Win:
	la $a0, str9	   # load address of string to print 
	jal PrintString    # jump and link to PrintString 
	jal PrintNewline   # jump and link to PrintNewline
	j _Exit            # jump to _Exit and end this game
	
	
#lose event	
_Lose:
	la $a0, str5       # load address of string to print
	jal PrintString    # jump and link to PrintString 
	jal PrintNewline   # jump and link to PrintNewline
	la $a0, str8	   # load address of string to print
	jal PrintString    # jump and link to PrintString 
	jal PrintNewline   # jump and link to PrintNewline
	j _Exit            # jump to _Exit and end this game
	
#compare case
_Bigger:
	#printf something
	la $a0, str5	   # load address of string to print
	jal PrintString    # jump and link to PrintString 
	jal PrintNewline   # jump and link to PrintNewline
	la $a0, str6       # load address of string to print
	jal PrintString    # jump and link to PrintString 
	jal PrintNewline   # jump and link to PrintNewline
	#counter
	addi $t1,$t1,-1    # decrease the counter by 1
	#return game loop
	j _Start           # jump to _Start and start the next round, continue this game
#compare case 	
_Smaller:
	#printf something
	la $a0, str5	   # load address of string to print
	jal PrintString    # jump and link to PrintString 
	jal PrintNewline   # jump and link to PrintNewline
	la $a0, str7	   # load address of string to print
	jal PrintString    # jump and link to PrintString 
	jal PrintNewline   # jump and link to PrintNewline 
	#counter
	addi $t1,$t1,-1    # decrease the counter by 1
	#return game loop
	j _Start           # jump to _Start and start the next round, continue this game

#terminated	
_Exit:
	li   $v0, 10       # ready to exit this program
  	syscall            # exit
	
PrintNewline:
la $a0, newline  # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
jr $ra           # return

PrintString:
li $v0, 4	 # ready to print string
syscall	         # print
jr $ra           # return 


