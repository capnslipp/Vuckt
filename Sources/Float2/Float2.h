// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/vector_types.h>



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct Float2 {
	simd_float1 x, y;
} __attribute__((aligned(__alignof__(simd_float2))));
typedef struct Float2 Float2;



#pragma mark SIMD Conversion

/// Converts an `Float2` struct to `simd_float2` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE simd_float2 Float2ToSimd(Float2 structValue) {
	return *(simd_float2 *)&structValue;
}
/// Converts an `Float2` struct from `simd_float2` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE Float2 Float2FromSimd(simd_float2 simdValue) {
	return *(Float2 *)&simdValue;
}



#pragma mark `NSValue`-Wrapping

@interface NSValue (Float2Additions)

+ (NSValue *)valueWithFloat2:(Float2)float2Value;

@property(nonatomic, readonly) Float2 float2Value;

@end



NS_ASSUME_NONNULL_END
