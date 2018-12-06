// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#import "Float4.h"



#pragma mark Struct↔SIMD Data Size/Alignment Sanity Checks

static_assert(sizeof(Float4) == sizeof(simd_float4),
	"Float4's size does not match simd_float4's on this platform.");
static_assert(sizeof_member(Float4, x) == sizeof_member(simd_float4, x),
	"Float4's first member's size does not match simd_float4's first member's on this platform.");
static_assert(alignof(Float4) == alignof(simd_float4),
	"Float4's alignment requirements does not match simd_float4's on this platform.");



#pragma mark `NSValue`-Wrapping

@implementation NSValue (Float4Additions)


+ (NSValue *)valueWithFloat4:(Float4)float4Value
{
	return [self valueWithBytes:&float4Value objCType:@encode(Float4)];
}

- (Float4)float4Value
{
	Float4 float4Value;
	[self getValue:&float4Value];
	return float4Value;
}


@end
