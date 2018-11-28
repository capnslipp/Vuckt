// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/vector_types.h>



NS_ASSUME_NONNULL_BEGIN



struct Int2 {
	simd_int1 x, y;
} __attribute__((aligned(__alignof__(simd_int2))));
typedef struct Int2 Int2;



/// Converts an `Int2` struct to `simd_int2` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE simd_int2 Int2ToSimd(Int2 structValue) {
	return *(simd_int2 *)&structValue;
}
/// Converts an `Int2` struct from `simd_int2` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE Int2 Int2FromSimd(simd_int2 simdValue) {
	return *(Int2 *)&simdValue;
}



@interface NSValue (Int2Additions)

+ (NSValue *)valueWithInt2:(Int2)int2Value;

@property(nonatomic, readonly) Int2 int2Value;

@end



NS_ASSUME_NONNULL_END
