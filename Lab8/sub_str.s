.text

## char * 
## sub_str(char *str, size_t n) {
##     char *newstr = (char *)malloc(n + 1);
##     int len = 0;
##     for (len = 0 ; len < n && str[len] != '\0' ; len++) {
##         newstr[len] = str[len]; 
##     }  
##     newstr[len] = '\0';
##     return newstr;
## }

.globl sub_str
sub_str:
	# Your code goes here :)
	sub	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)

	move	$s0, $a0		# str
	move	$s1, $a1		# n

	add	$a0, $s1, 1		# n + 1
	jal	malloc			# malloc(n + 1)
	li	$t0, 0			# len = 0

sub_str_for:
	bge	$t0, $s1, sub_str_ret	# len >= n
	add	$t1, $s0, $t0		# &str[len]
	lb	$t1, 0($t1)		# str[len]
	beq	$t1, 0, sub_str_ret	# str[len] == '\0'

	add	$t2, $v0, $t0		# &newstr[len]
	sb	$t1, 0($t2)		# newstr[len] = str[len]

	add	$t0, $t0, 1		# len++
	j	sub_str_for

sub_str_ret:
	add	$t2, $v0, $t0		# &newstr[len]
	sb	$0, 0($t2)		# newstr[len] = '\0' 

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	add	$sp, $sp, 12
	jr	$ra

