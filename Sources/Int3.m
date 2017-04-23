// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

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
