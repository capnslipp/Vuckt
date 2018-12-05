// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#import "Int2.h"



#pragma mark Struct↔SIMD Data Size/Alignment Sanity Checks

static_assert(sizeof(Int2) == sizeof(simd_int2),
	"Int2's size does not match simd_int2's on this platform.");
static_assert(sizeof_member(Int2, x) == sizeof_member(simd_int2, x),
	"Int2's first member's size does not match simd_int2's first member's on this platform.");
static_assert(alignof(Int2) == alignof(simd_int2),
	"Int2's alignment requirements does not match simd_int2's on this platform.");



#pragma mark `NSValue`-Wrapping

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
