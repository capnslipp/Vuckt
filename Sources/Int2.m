// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#import "Int2.h"



@implementation NSValue (Int2Additions)


+ (NSValue *)valueWithInt2:(Int2)int2Value
{
	return [self valueWithBytes:&int2Value objCType:@encode(Int2)];
}

- (Int2)int2Value
{
	Int2 int2Value;
	[self getValue:&int2Value];
	return int2Value;
}


@end
