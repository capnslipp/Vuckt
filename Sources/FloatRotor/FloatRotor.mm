// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#import "FloatRotor.h"



#pragma mark Struct↔SIMD Data Size/Alignment Sanity Checks

static_assert(sizeof_member(FloatRotor, b01) == sizeof(simd_float1),
	"FloatRotor's first member's size does not match simd_float1's on this platform.");
static_assert(sizeof(FloatRotor) == sizeof(simd_float4),
	"FloatRotor's size does not match simd_float4's on this platform.");
static_assert(sizeof_member(FloatRotor, b01) == sizeof_member(simd_float4, x),
	"FloatRotor's first member's size does not match simd_float4's first member's on this platform.");
static_assert(alignof(FloatRotor) == alignof(simd_float4),
	"FloatRotor's alignment requirements does not match simd_float4's on this platform.");



#pragma mark `NSValue`-Wrapping

@implementation NSValue (FloatRotorAdditions)


+ (NSValue *)valueWithFloatRotor:(FloatRotor)floatRotorValue
{
	return [self valueWithBytes:&floatRotorValue objCType:@encode(FloatRotor)];
}

- (FloatRotor)floatRotorValue
{
	FloatRotor floatRotorValue;
	[self getValue:&floatRotorValue];
	return floatRotorValue;
}


@end
