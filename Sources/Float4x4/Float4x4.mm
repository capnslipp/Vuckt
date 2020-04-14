// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#import "Float4x4.h"



#pragma mark Struct↔SIMD Data Size/Alignment Sanity Checks

static_assert(sizeof_member(Float4x4, m00) == sizeof(simd_float1),
	"Float4x4's first member's size does not match simd_float1's on this platform.");
static_assert((offsetof(Float4x4, m10) - offsetof(Float4x4, m00)) == sizeof(simd_float4),
	"Float4x4's 1st column's size does not match simd_float4's on this platform.");
static_assert((offsetof(Float4x4, m20) - offsetof(Float4x4, m10)) == sizeof(simd_float4),
	"Float4x4's 2nd column's size does not match simd_float4's on this platform.");
static_assert((offsetof(Float4x4, m30) - offsetof(Float4x4, m20)) == sizeof(simd_float4),
	"Float4x4's 3rd column's size does not match simd_float4's on this platform.");
static_assert((sizeof(Float4x4) - offsetof(Float4x4, m30)) == sizeof(simd_float4),
	"Float4x4's 4th column's size does not match simd_float4's on this platform.");
static_assert(sizeof_member(Float4x4, m00) == sizeof_member(simd_float4x4, columns[0].x),
	"Float4x4's first member's size does not match simd_float4x4's first member's on this platform.");
static_assert(sizeof(Float4x4) == sizeof(simd_float4x4),
	"Float4x4's size does not match simd_float4x4's on this platform.");
static_assert(alignof(Float4x4) == alignof(simd_float4x4),
	"Float4x4's alignment requirements does not match simd_float4x4's on this platform.");

// Doesn't work, unfortunately.  Compiler spits “error: Offsetof requires struct, union, or class type, 'simd_float3' (vector of 3 'float' values) invalid” and “error: Address of vector element requested”.
//static_assert(
//		offsetof(Float4x4, columns[0].x) == offsetof(simd_float4x4, columns[0].x) &&
//		offsetof(Float4x4, columns[1].y) == offsetof(simd_float4x4, columns[1].y) &&
//		offsetof(Float4x4, columns[2].z) == offsetof(simd_float4x4, columns[2].z) &&
//		offsetof(Float4x4, columns[3].w) == &((simd_float4x4 *)0)->columns[3].w,
//	"Float4x4's members' offsets do not match simd_float4x4's members' on this platform.");



#pragma mark `NSValue`-Wrapping

@implementation NSValue (Float4x4Additions)


+ (NSValue *)valueWithFloat4x4:(Float4x4)Float4x4Value
{
	return [self valueWithBytes:&Float4x4Value objCType:@encode(Float4x4)];
}

- (Float4x4)Float4x4Value
{
	Float4x4 Float4x4Value;
	[self getValue:&Float4x4Value];
	return Float4x4Value;
}


@end
