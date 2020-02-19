// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/simd.h>



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct Int2 {
	int x, y;
} __attribute__((aligned(__alignof__(simd_int2))));
typedef struct Int2 Int2;



#pragma mark SIMD Conversion

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



#pragma mark SIMD-Accelerated Operator Access

NS_INLINE Int2 Int2Add(Int2 a, Int2 b) {
	return Int2FromSimd(Int2ToSimd(a) + Int2ToSimd(b));
}
NS_INLINE Int2 Int2Subtract(Int2 a, Int2 b) {
	return Int2FromSimd(Int2ToSimd(a) - Int2ToSimd(b));
}
NS_INLINE Int2 Int2Negate(Int2 v) {
	return Int2FromSimd(-Int2ToSimd(v));
}
NS_INLINE Int2 Int2Multiply(Int2 a, Int2 b) {
	return Int2FromSimd(Int2ToSimd(a) * Int2ToSimd(b));
}
NS_INLINE Int2 Int2Divide(Int2 a, Int2 b) {
	return Int2FromSimd(Int2ToSimd(a) / Int2ToSimd(b));
}
NS_INLINE Int2 Int2Modulus(Int2 a, Int2 b) {
	return Int2FromSimd(Int2ToSimd(a) % Int2ToSimd(b));
}

NS_INLINE BOOL Int2Equal(Int2 a, Int2 b) {
	return simd_all(Int2ToSimd(a) == Int2ToSimd(b));
}
NS_INLINE BOOL Int2Inequal(Int2 a, Int2 b) {
	return simd_any(Int2ToSimd(a) != Int2ToSimd(b));
}
NS_INLINE BOOL Int2LessThan(Int2 a, Int2 b) {
	return simd_all(Int2ToSimd(a) < Int2ToSimd(b));
}
NS_INLINE BOOL Int2LessThanOrEqual(Int2 a, Int2 b) {
	return simd_all(Int2ToSimd(a) <= Int2ToSimd(b));
}
NS_INLINE BOOL Int2GreaterThan(Int2 a, Int2 b) {
	return simd_all(Int2ToSimd(a) > Int2ToSimd(b));
}
NS_INLINE BOOL Int2GreaterThanOrEqual(Int2 a, Int2 b) {
	return simd_all(Int2ToSimd(a) >= Int2ToSimd(b));
}



#pragma mark `NSValue`-Wrapping

@interface NSValue (Int2Additions)

+ (NSValue *)valueWithInt2:(Int2)int2Value;

@property(nonatomic, readonly) Int2 int2Value;

@end



NS_ASSUME_NONNULL_END
