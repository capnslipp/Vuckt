// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#import "Float3x3.h"



#pragma mark Struct↔SIMD Data Size/Alignment Sanity Checks

static_assert(sizeof_member(Float3x3, m00) == sizeof(simd_float1),
	"Float3x3's first member's size does not match simd_float1's on this platform.");
static_assert((offsetof(Float3x3, m10) - offsetof(Float3x3, m00)) == sizeof(simd_float3),
	"Float3x3's 1st column's size does not match simd_float3's on this platform.");
static_assert((offsetof(Float3x3, m20) - offsetof(Float3x3, m10)) == sizeof(simd_float3),
	"Float3x3's 2nd column's size does not match simd_float3's on this platform.");
static_assert((sizeof(Float3x3) - offsetof(Float3x3, m20)) == sizeof(simd_float3),
	"Float3x3's 3rd column's size does not match simd_float3's on this platform.");
static_assert(sizeof_member(Float3x3, m00) == sizeof_member(simd_float3x3, columns[0].x),
	"Float3x3's first member's size does not match simd_float3x3's first member's on this platform.");
static_assert(sizeof(Float3x3) == sizeof(simd_float3x3),
	"Float3x3's size does not match simd_float3x3's on this platform.");
static_assert(alignof(Float3x3) == alignof(simd_float3x3),
	"Float3x3's alignment requirements does not match simd_float3x3's on this platform.");

// Doesn't work, unfortunately.  Compiler spits “error: Offsetof requires struct, union, or class type, 'simd_float3' (vector of 3 'float' values) invalid” and “error: Address of vector element requested”.
//static_assert(
//		offsetof(Float3x3, columns[0].x) == offsetof(simd_float3x3, columns[0].x) &&
//		offsetof(Float3x3, columns[1].y) == offsetof(simd_float3x3, columns[1].y) &&
//		offsetof(Float3x3, columns[2].z) == &((simd_float3x3 *)0)->columns[2].z,
//	"Float3x3's members' offsets do not match simd_float3x3's members' on this platform.");



#pragma mark `NSValue`-Wrapping

@implementation NSValue (Float3x3Additions)


+ (NSValue *)valueWithFloat3x3:(Float3x3)float3x3Value
{
	return [self valueWithBytes:&float3x3Value objCType:@encode(Float3x3)];
}

- (Float3x3)float3x3Value
{
	Float3x3 float3x3Value;
	[self getValue:&float3x3Value];
	return float3x3Value;
}


@end
