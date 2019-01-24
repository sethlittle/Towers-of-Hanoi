.data 0x0

newline:	.asciiz "\n"
Move:		.asciiz "Move disk "
From:		.asciiz " from Peg "
To:		.asciiz " to Peg "

.text 0x3000

.globl main
main: 
	ori     $sp, $0, 0x2ffc       # Initialize stack pointer to the top word below .text
                                # The first value on stack will actually go at 0x2ff8
                                #   because $sp is decremented first.
  	addi    $fp, $sp, -4          # Set $fp to the start of main's stack frame
  	
  	
  	li $v0, 5
  	syscall
  	add $s0, $v0, $0	# stores N in s0
  	
  	li $s1, 1
  	li $s2, 3
  	li $s3, 2
  	
  	jal hanoi		# hanoi(N, A, C, B) = hanoi($a0, $a1, $a2, $a3)
  	
  	j end
  	
hanoi:
	addi $sp, $sp, -20		# takes 20 (5) spots on the stack
	sw $ra, 0($sp)			# stores ra on the stack 
	sw $s0, 4($sp)			# stores s0 on the stack - N
	sw $s1, 8($sp)			# stores s1 on the stack - A - 1
	sw $s2, 12($sp)			# stores s2 on the stack - C - 3
  	sw $s3, 16($sp)			# stores s3 on the stack - B - 2
  	
  	beq $s0, 1, if
  	
  	addi $s0, $s0, -1
  	lw $s1, 8($sp)
  	lw $s2, 16($sp)
  	lw $s3, 12($sp)
  	
  	jal hanoi			#hanoi(N-1, A, B, C) = hanoi($a0 - 1, $a1, $a3, $a2)
  	
  	lw $s0, 4($sp)
  	lw $s1, 8($sp)
  	lw $s2, 12($sp)
  	lw $s3, 16($sp)

  	jal print
  	lw $ra, 0($sp)

  	addi $s0, $s0, -1
  	lw $s1, 16($sp)
  	lw $s2, 12($sp)
  	lw $s3, 8($sp)
  	
  	jal hanoi
  	
  	lw $ra, 0($sp)
  	addi $sp, $sp, 20
  	
  	jr $ra
  	
if:
  	jal print
  	lw $ra, 0($sp)
  	addi $sp, $sp, 20
  	jr $ra

print:
	add $t0, $s0, $0

	li $v0, 4
  	la $a0, Move			# prints move to
  	syscall
  			
  	add $a0, $t0, $0		
  	li $v0, 1			# puts 1 into v0 - syscall to print an integer
	syscall
	
	li $v0, 4
  	la $a0, From			# prints from
  	syscall
  	
  	add $a0, $s1, $0
  	li $v0, 1			# puts 1 into v0 - syscall to print an integer
	syscall
  	
  	li $v0, 4
  	la $a0, To			# prints to
  	syscall
  	
  	add $a0, $s2, $0
  	li $v0, 1			# puts 1 into v0 - syscall to print an integer
	syscall
  	
  	li $v0, 4
  	la $a0, newline			# prints a newline
  	syscall
  	
	jr $ra
	
  	
end: 
	ori   $v0, $0, 10     # system call 10 for exit
	syscall               # exit