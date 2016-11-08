// SlidingPuzzleCity
// @copyright: Slipp Douglas Thompson
// @copyright date: The date(s) of version control check-ins corresponding to this file and this project as a whole; or in lieu of, no earlier than November 2016.

#import "Int3.h"



@implementation NSValue (Int3Additions)


+ (NSValue *)valueWithInt3:(Int3)int3Value
{
	return [self valueWithBytes:&int3Value objCType:@encode(Int3)];
}

- (Int3)int3Value
{
	Int3 int3Value;
	[self getValue:&int3Value];
	return int3Value;
}


@end
