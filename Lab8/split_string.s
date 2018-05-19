.text

## int
## split_string(char **solution, char *str, const dictionary *dict) {
##     *solution = NULL;
##     char *ptr = str;
##     if (*ptr == 0) {
##         return 1;
##     }
##     for (; *ptr != 0; ptr++) {
##         char *prefix = sub_str(str, ptr + 1 - str);
##         if (in_dict(prefix, dict->words, dict->size)) {
##             if (split_string(solution + 1, ptr + 1, dict)) {
##                 // if the prefix is in dictionary and
##                 // if the rest of the string is also "splittable"
##                 // insert the prefix into solution
##                 *solution = prefix;
##                 return 1;
##             }
##         }
##     }
##     return 0;
## }


.globl split_string
split_string:
	# Your code goes here :)
	sub	$sp, $sp, ()
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)	
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)

	move	$s0, $a0		# $s0 = solution          
	move	$s1, $a1		# $s1 = str
	move	$s2, $a2		# $s2 = dict
	sw	$0, 0($s0)		# *solution = null
	move	$s3, $s1		# $s3 = ptr
	lb	$s4, 0($s3)		# $s4 = *ptr
	beq	$s4, $0, ret_1
for_loop:
	beq	$s4, $0, return_0 	
	move	$a0, $s1
	add	$t0, $s3, 1
	sub	$a1, $t0, $s1		# ptr + 1- str
	jal	sub_str
	move	$s5, $v0		# $s5 = prefix
		


	add	
ret_1:
	li	$v0, 1
	#restore value crap...
	jr	$ra
ret_0:
	li	$v0, 0
	#restore value crap...
	jr	$ra
