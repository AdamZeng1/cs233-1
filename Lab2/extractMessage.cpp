/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include "extractMessage.h"

using namespace std;

string extractMessage(const bmp & image) {
	string message;

	// TODO: write your code here
	// http://en.cppreference.com/w/cpp/string/basic_string#Operations might be of use
	// because image is a const reference, any pixel you get needs to be stored in a const pointer
	// i.e. you need to do
	// const pixel * p = image(x, y);
	// just doing
	// pixel * p = image(x, y);
	// would give a compilation error
	
	int count = 0;	
	int cum = 0;
	int hex = 0;
	int width = image.width();
	int height = image.height();
	bool flag = false;

	for(int y = 0; y < height; y++) {
		if(flag)
			break;	
		for(int x = 0; x < width; x++) {
			const pixel *p = image(x, y);
			int temp = p->green & 0x01;		
			//cout<< temp << endl;
			if(count == 0 || count == 4)
				cum += 8*temp;

			else if(count == 1 || count ==5)
				cum += 4*temp;

			else if(count== 2 || count == 6)
				cum += 2*temp;

			else if(count == 3 ) {
				cum += temp;
				hex += cum*16;
				cum = 0;
			}
			else if(count == 7) {
				cum += temp;
				hex += cum;
				cum = 0;

				message = message + (char)hex;

				if(hex == 0){
					flag = true;
					break;
				}
			}
			if(count == 8) {
				hex = 0;
				cum = 0;
				cum += 8*temp;
				count = 0;
			}
			count++;
		}	
	}
	return message;
}
