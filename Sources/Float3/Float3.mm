// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#import "Float3.h"



#pragma mark Struct↔SIMD Data Size/Alignment Sanity Checks

static_assert(sizeof_member(Float3, x) == sizeof(simd_float1),
	"Float3's first member's size does not match simd_float1's on this platform.");
static_assert(sizeof(Float3) == sizeof(simd_float3),
	"Float3's size does not match simd_float3's on this platform.");
static_assert(sizeof_member(Float3, x) == sizeof_member(simd_float3, x),
	"Float3's first member's size does not match simd_float3's first member's on this platform.");
static_assert(alignof(Float3) == alignof(simd_float3),
	"Float3's alignment requirements does not match simd_float3's on this platform.");

// Doesn't work, unfortunately.  Compiler spits “error: Offsetof requires struct, union, or class type, 'simd_float3' (vector of 3 'float' values) invalid” and “error: Address of vector element requested”.
//static_assert(
//		offsetof(Float3, x) == offsetof(simd_float3, x) &&
//		offsetof(Float3, y) == offsetof(simd_float3, y) &&
//		offsetof(Float3, z) == &((simd_float3 *)0)->z,
//	"Float3's members' offsets do not match simd_float3's members' on this platform.");



#pragma mark `NSValue`-Wrapping

@implementation NSValue (Float3Additions)


+ (NSValue *)valueWithFloat3:(Float3)float3Value
{
	return [self valueWithBytes:&float3Value objCType:@encode(Float3)];
}

- (Float3)float3Value
{
	Float3 float3Value;
	[self getValue:&float3Value];
	return float3Value;
}


@end
