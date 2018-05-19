.text

## unsigned
## crc_encoding(unsigned dividend, unsigned divisor) {
##     int divisor_length = length(divisor);
##     unsigned remainder = dividend << (divisor_length - 1);
##     int remainder_length = length(remainder);
##     for (int i = remainder_length; i >= divisor_length; i--) {
##         unsigned msb = remainder >> (i - 1);
##         // equivalent to if (msb != 0)
##         if (msb) {
##             remainder = remainder ^ (divisor << (i - divisor_length));
##         }
##     }
##     return (dividend << (divisor_length - 1)) ^ remainder;
## }

.globl crc_encoding
crc_encoding:
	# Your code goes here :)
	sub	$sp, $sp, 8			# stack pointer	???
	sw	$ra, 0($sp)			# store $ra
	sw	$a0, 4($sp)			# store $a0
	move	$a0, $a1		# prameter
	jal	length
	move	$t0, $v0		# store divisor_length in $t0
	sub	$t1, $t0, 1			# store d_l-1 in $t1
	lw	$t2, 4($sp)			# load dividend to $t2
	sll	$t3, $t2, $t1		# put remainder in $t3, Q shamt==$t1???
	move	$a0, $t3		# parameter for second
	jal	length			
	move	$t4, $v0		# store remainder_length in $t4

loop:	blt	$t4, $t0, ret		# if i < divisor_length branch
	sub	$t5, $t4, 1			# store i-1 in $t5
	srl	$t6, $t3, $t5		# store msb in $t6
	beq	$t6, 0, loop_next
	sub	$t7, $t4, $t0		# store i-divisor_length in $t7
	sll	$t7, $a1, $t7		# store in $t7 after shift
	xor	$t3, $t3, $t7		# update remainder
loop_next:
	sub	$t4, $t4, 1			# i--
	j	loop
ret:
	sub	$t0, $t0, 1			# divisor_length-1
	sll	$t2, $t2, $t0		# dividend after shift
	xor	$v0, $t2, $t3		# update $v0
	lw	$ra, 0($sp)			# load $ra
	add	$sp, $sp, 8			# stack pointer back		 
	jr	$ra
