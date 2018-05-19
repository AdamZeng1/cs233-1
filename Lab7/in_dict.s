.text

## int
## in_dict(const char *str, const char **dict, const int dict_size) {
##     for (int i = 0; i < dict_size; i++) {
##         // equivalent to if (str_cmp(str, dict[i]) == 0)
##         if (!str_cmp(str, dict[i])) {
##             return 1;
##         }
##     }
##     return 0;
## }

.globl in_dict
in_dict:
	# Your code goes here :)
	sub	$sp, $sp, 24
	sw	$ra, 0($sp)		
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)

	move	$s1, $a0		# store *str in $s1
	move	$s2, $a1		# store **dict in $s2
	move	$s3, $a2		# store dict_size in $s3
	li	$s0, 0			# i in $s0
id_loop:
	bge	$s0, $s3, ret_0
	move	$a0, $s1
	mul	$t0, $s0, 4		# element type is *char
	add	$s4, $s2, $t0		# store &dict[i] in $s4
	lw	$a1, 0($s4)		# store dict[i] in $a1
	jal	str_cmp
	bne	$v0, 0, id_loop_next
	j	ret_1
id_loop_next:
	add	$s0, $s0, 1		# i++
	j	id_loop
ret_1:
	li	$v0, 1
	lw	$ra, 0($sp)		
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	add	$sp, $sp, 24
	jr	$ra
ret_0:
	li	$v0, 0			# return 0
	lw	$ra, 0($sp)		
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	add	$sp, $sp, 24
	jr	$ra
