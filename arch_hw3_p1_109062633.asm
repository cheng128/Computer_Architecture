.data
Pnewline: .asciiz "\n"
PA:	.asciiz "input a:"
PB:	.asciiz "input b:"
PC:	.asciiz "input c:"
PR:	.asciiz "result = "


.text
move $s0,$zero    # a = 0
move $s1,$zero    # b = 0 
move $s2,$zero    # c = 0
move $s3,$zero    # d = 0

la $a0, PA
jal PrintString    # print "input a:"
li $v0,5           # ready to read integer(scanf)
syscall            # read value
move $s0,$v0       # move the input number to $s0 register

la $a0, PB
jal PrintString    # print "input b:"
li $v0,5           # ready to read integer(scanf)
syscall            # read value
move $s1,$v0       # move the input number to $s1 register

la $a0, PC
jal PrintString    # print "input c:"
li $v0,5           # ready to read integer(scanf)
syscall            # read value
move $s2,$v0       # move the input number to $s2 register

move $a0,$s0       # move the value of 'a' to $a0
move $a1,$s1       # move the value of 'b' to $a0
jal _Add	   # jump to _Add to caculate add(a,b)

move $a2,$v0       # move the result of add(a,b) to $a2
move $a3,$s2       # move the value of c to $a3

la $a0, PR
jal PrintString    # print "result = "

jal _MSub          # jump to _MSub to caculate msub(add(a, b), c)


_Add:
	add $v0, $a0, $a1      # add input like x+y
	jr $ra                 # jump back


_MSub:	
	move $v1,$zero	       # set $v1 to 0 
	beq $a2,$a3,_Exit      # if $a2 = $a3 return 0 and exit
	
	slt $t1,$a2,$a3        # test if (x<y), if x!<y then $t1=0, means x>=y
	move $t2,$a2	       # set $t2 as the large (I'll use sub $t2,$t2,$t3 later, means large = large - small)
	move $t3,$a3	       # set $t3 as the small
	beq $t1,$zero,_Loop    # if x>=y go to _Loop
	
	slt $t1,$a3,$a2        # test if (y<x), if y!<x then $t1=0, means y>=x
	move $t2,$a3           # reset large number($t2) cause if it run to this line means that y>=x
	move $t3,$a2	       # reset small
	beq $t1,$zero,_Loop    # if y>=x go to _Loop
	
_Loop:
	slt $t1,$t2,$t3        # test if large < small
	bne $t1,$zero,_Exit    # when $t1=1 means large($t2) < small($t3) then jump to _Exit
	
	sub $t2,$t2,$t3        # large = large - small
	move $v1,$t2	       # move the result to $v1
	j _Loop                # jump back to _Loop
	
_Exit:
	move $a0,$v1          # move the result to $a0
	li $v0, 1             # ready to print integer	   
	syscall               # print integer
	
	li   $v0, 10       # ready to exit this program
  	syscall            # exit


PrintString:
li $v0, 4	 # ready to print string
syscall	         # print
jr $ra           # return 
	           
