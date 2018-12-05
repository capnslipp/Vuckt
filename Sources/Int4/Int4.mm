// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#import "Int4.h"



#pragma mark Struct↔SIMD Data Size/Alignment Sanity Checks

static_assert(sizeof(Int4) == sizeof(simd_int4),
	"Int4's size does not match simd_int4's on this platform.");
static_assert(sizeof_member(Int4, x) == sizeof_member(simd_int4, x),
	"Int4's first member's size does not match simd_int4's first member's on this platform.");
static_assert(alignof(Int4) == alignof(simd_int4),
	"Int4's alignment requirements does not match simd_int4's on this platform.");



#pragma mark `NSValue`-Wrapping

@implementation NSValue (Int4Additions)


+ (NSValue *)valueWithInt4:(Int4)int4Value
{
	return [self valueWithBytes:&int4Value objCType:@encode(Int4)];
}

- (Int4)int4Value
{
	Int4 int4Value;
	[self getValue:&int4Value];
	return int4Value;
}


@end
