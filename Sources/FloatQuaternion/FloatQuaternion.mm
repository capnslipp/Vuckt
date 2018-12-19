// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#import "FloatQuaternion.h"



#pragma mark Struct↔SIMD Data Size/Alignment Sanity Checks

static_assert(sizeof_member(FloatQuaternion, ix) == sizeof(simd_float1),
	"FloatQuaternion's first member's size does not match simd_float1's on this platform.");
static_assert(sizeof(FloatQuaternion) == sizeof(simd_quatf),
	"FloatQuaternion's size does not match simd_quatf's on this platform.");
static_assert(sizeof_member(FloatQuaternion, ix) == sizeof_member(simd_quatf, vector.x),
	"FloatQuaternion's first member's size does not match simd_quatf's first member's on this platform.");
static_assert(alignof(FloatQuaternion) == alignof(simd_quatf),
	"FloatQuaternion's alignment requirements does not match simd_quatf's on this platform.");



#pragma mark `NSValue`-Wrapping

@implementation NSValue (FloatQuaternionAdditions)


+ (NSValue *)valueWithFloatQuaternion:(FloatQuaternion)floatQuaternionValue
{
	return [self valueWithBytes:&floatQuaternionValue objCType:@encode(FloatQuaternion)];
}

- (FloatQuaternion)floatQuaternionValue
{
	FloatQuaternion floatQuaternionValue;
	[self getValue:&floatQuaternionValue];
	return floatQuaternionValue;
}


@end
