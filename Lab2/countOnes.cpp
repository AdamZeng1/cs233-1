/**
 * @file
 * Contains the implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	unsigned odd = input & 0x55555555;
	unsigned even = input & 0xaaaaaaaa;
	unsigned sum = odd + (even >>1);
	sum = (sum & 0x33333333) + ((sum & 0xcccccccc) >>2);
	sum = (sum & 0x0f0f0f0f) + ((sum & 0xf0f0f0f0) >>4);
	sum = (sum & 0x00ff00ff) + ((sum & 0xff00ff00) >>8);
	sum = (sum & 0x0000ffff) + ((sum & 0xffff0000) >>16);
	
	return sum;
}
