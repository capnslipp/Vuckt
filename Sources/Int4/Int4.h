// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/vector_types.h>



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct Int4 {
	simd_int1 x, y, z, w;
} __attribute__((aligned(__alignof__(simd_int4))));
typedef struct Int4 Int4;



#pragma mark SIMD Conversion

/// Converts an `Int4` struct to `simd_int4` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE simd_int4 Int4ToSimd(Int4 structValue) {
	return *(simd_int4 *)&structValue;
}
/// Converts an `Int4` struct from `simd_int4` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE Int4 Int4FromSimd(simd_int4 simdValue) {
	return *(Int4 *)&simdValue;
}



#pragma mark `NSValue`-Wrapping

@interface NSValue (Int4Additions)

+ (NSValue *)valueWithInt4:(Int4)int4Value;

@property(nonatomic, readonly) Int4 int4Value;

@end



NS_ASSUME_NONNULL_END
