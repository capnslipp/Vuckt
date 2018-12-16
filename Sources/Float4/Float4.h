// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/vector_types.h>



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct Float4 {
	simd_float1 x, y, z, w;
} __attribute__((aligned(__alignof__(simd_float4))));
typedef struct Float4 Float4;



#pragma mark SIMD Conversion

/// Converts an `Float4` struct to `simd_float4` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE simd_float4 Float4ToSimd(Float4 structValue) {
	return *(simd_float4 *)&structValue;
}
/// Converts an `Float4` struct from `simd_float4` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE Float4 Float4FromSimd(simd_float4 simdValue) {
	return *(Float4 *)&simdValue;
}



#pragma mark `NSValue`-Wrapping

@interface NSValue (Float4Additions)

+ (NSValue *)valueWithFloat4:(Float4)float4Value;

@property(nonatomic, readonly) Float4 float4Value;

@end



NS_ASSUME_NONNULL_END
