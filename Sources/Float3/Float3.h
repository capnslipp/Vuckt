// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/vector_types.h>



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct Float3 {
	simd_float1 x, y, z;
} __attribute__((aligned(__alignof__(simd_float3))));
typedef struct Float3 Float3;



#pragma mark SIMD Conversion

/// Converts an `Float3` struct to `simd_float3` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE simd_float3 Float3ToSimd(Float3 structValue) {
	return *(simd_float3 *)&structValue;
}
/// Converts an `Float3` struct from `simd_float3` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE Float3 Float3FromSimd(simd_float3 simdValue) {
	return *(Float3 *)&simdValue;
}



#pragma mark `NSValue`-Wrapping

@interface NSValue (Float3Additions)

+ (NSValue *)valueWithFloat3:(Float3)float3Value;

@property(nonatomic, readonly) Float3 float3Value;

@end



NS_ASSUME_NONNULL_END
