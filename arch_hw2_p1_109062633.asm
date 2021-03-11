.data

PHello:   .asciiz "This is the first part of Homework 2. (Load, Store, Add, Sub)"
Pnewline: .asciiz "\n"
PA:      .asciiz "A = "
PB:      .asciiz "B = "
PC:      .asciiz "C = "
Test1:    .asciiz "C - B + A = "
Test2:    .asciiz "A + A + C = "

.text

# Hello! This is the first part of Homework 2 -- Basic MIPS Assembly Language Assignment.
# In this part, you have to fill the code in the region bounded by 2 hashtag lines.
# Hopefully you can enjoy assembly programming.
# =====================================================
# For grading, DO NOT modify the code here
# Print Hello Msg.
la $a0, PHello	   # load address of string to print
li $v0, 4	   # ready to print string
syscall	           # print
jal PrintNewline

# Load and save data (A and B)
li $t0, 77        # load A
sw $t0, 12($gp)    # save A
li $t1, 7       # load B
sw $t1, 0($gp)     # save B
li $t0, 15       # load C
sw $t0, 8($gp)     # save C
# =====================================================

# The following block helps you practice with the R-type instructions,
# including ADD and SUB, and also LOAD and STORE.
# Here, please read data from 12($gp), 0($gp) and 8($gp),
# store C - B + A to 4($gp), and
# store A + A + C to 12($gp)
#####################################################
# @@@ write the code here

 lw $t0,12($gp)   # load A
 lw $t1,0($gp)    # load B
 lw $t2,8($gp)    # load C
 sub $t4,$t2,$t1  # put the result of (C - B) to $t4
 add $t4,$t4,$t0  # p ut the result of ($t4 + A) to $t4
 sw $t4,4($gp)    # store the result of (C - B + A) to 4($gp)

 add $t4,$t0,$t0  # put the result of (A + A) to $t4
 add $t4,$t4,$t2  # put the result of ($t4 + C) to $t4
 sw $t4,12($gp)   # store the result of (A + A + C) to 12($gp)
 
#####################################################

# =====================================================
# For grading, DO NOT modify the code below

# Print A
la $a0, PA	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t0    # load int value to $a0
syscall	         # print
jal PrintNewline

# Print B
la $a0, PB	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t1    # load int value to $a0
syscall	         # print
jal PrintNewline

# Print C
la $a0, PC	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t2    # load int value to $a0
syscall	         # print
jal PrintNewline

# Print C - B + A
lw $t6, 4($gp)

la $a0, Test1	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t6    # load int value to $a0
syscall	         # print
jal PrintNewline

# Print  A + A + C
lw $t7, 12($gp)

la $a0, Test2	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t7    # load int value to $a0
syscall	         # print
j Exit           # jump to exit

#Check Memory
#jal PrintNewline
#lw $t0, 0($gp)
#lw $t1, 4($gp)
#lw $t2, 8($gp)
#lw $t3, 12($gp)



#li $v0, 1        # ready to print int
#move $a0, $t0    # load int value to $a0
#syscall	         # print
#jal PrintNewline

#li $v0, 1        # ready to print int
#move $a0, $t1    # load int value to $a0
#syscall	         # print
#jal PrintNewline

#li $v0, 1        # ready to print int
#move $a0, $t2    # load int value to $a0
#syscall	         # print
#jal PrintNewline

#li $v0, 1        # ready to print int
#move $a0, $t3    # load int value to $a0
#syscall	         # print
#j Exit

PrintNewline:
la $a0, Pnewline # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
jr $ra           # return

Exit:
# =====================================================
li $v0, 10
syscall
