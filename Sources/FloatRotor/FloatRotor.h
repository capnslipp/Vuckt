// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/vector_types.h>



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct FloatRotor {
	float bYZ, bZX, bXY, s;
} __attribute__((aligned(__alignof__(simd_float4))));
typedef struct FloatRotor FloatRotor;



#pragma mark SIMD Conversion

/// Converts a `FloatRotor` struct to `simd_float4` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE simd_float4 FloatRotorToSimd(FloatRotor structValue) {
	return *(simd_float4 *)&structValue;
}
/// Converts a `FloatRotor` struct from `simd_float4` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE FloatRotor FloatRotorFromSimd(simd_float4 simdValue) {
	return *(FloatRotor *)&simdValue;
}



#pragma mark `NSValue`-Wrapping

@interface NSValue (FloatRotorAdditions)

+ (NSValue *)valueWithFloatRotor:(FloatRotor)floatRotorValue;

@property(nonatomic, readonly) FloatRotor floatRotorValue;

@end



NS_ASSUME_NONNULL_END
