// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#import "Float2.h"



#pragma mark Struct↔SIMD Data Size/Alignment Sanity Checks

static_assert(sizeof_member(Float2, x) == sizeof(simd_float1),
	"Float2's first member's size does not match simd_float1's on this platform.");
static_assert(sizeof(Float2) == sizeof(simd_float2),
	"Float2's size does not match simd_float2's on this platform.");
static_assert(sizeof_member(Float2, x) == sizeof_member(simd_float2, x),
	"Float2's first member's size does not match simd_float2's first member's on this platform.");
static_assert(alignof(Float2) == alignof(simd_float2),
	"Float2's alignment requirements does not match simd_float2's on this platform.");



#pragma mark `NSValue`-Wrapping

@implementation NSValue (Float2Additions)


+ (NSValue *)valueWithFloat2:(Float2)float2Value
{
	return [self valueWithBytes:&float2Value objCType:@encode(Float2)];
}

- (Float2)float2Value
{
	Float2 float2Value;
	[self getValue:&float2Value];
	return float2Value;
}


@end
