// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#import "Int3.h"



static_assert(sizeof(Int3) == sizeof(simd_int3),
	"Int3's size does not match simd_int3's on this platform.");
static_assert(sizeof_member(Int3, x) == sizeof_member(simd_int3, x),
	"Int3's first member's size does not match simd_int3's first member's on this platform.");
static_assert(alignof(Int3) == alignof(simd_int3),
	"Int3's alignment requirements does not match simd_int3's on this platform.");

// Doesn't work, unfortunately.  Compiler spits “error: Offsetof requires struct, union, or class type, 'simd_int3' (vector of 3 'int' values) invalid” and “error: Address of vector element requested”.
//static_assert(
//		offsetof(Int3, x) == offsetof(simd_int3, x) &&
//		offsetof(Int3, y) == offsetof(simd_int3, y) &&
//		offsetof(Int3, z) == &((simd_int3 *)0)->z,
//	"Int3's members' offsets do not match simd_int3's members' on this platform.");



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
