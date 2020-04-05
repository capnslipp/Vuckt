// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/simd.h>



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct Int3 { // @expected: Padding size of 'Int3' with 4 bytes to alignment boundary
	int x, y, z;
} __attribute__((aligned(__alignof__(simd_int3))));
typedef struct Int3 Int3;



#pragma mark SIMD Conversion

/// Converts an `Int3` struct to `simd_int3` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE simd_int3 Int3ToSimd(Int3 structValue) {
	return *(simd_int3 *)&structValue;
}
/// Converts an `Int3` struct from `simd_int3` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE Int3 Int3FromSimd(simd_int3 simdValue) {
	return *(Int3 *)&simdValue;
}



#pragma mark SIMD-Accelerated Operator Access

NS_INLINE Int3 Int3Add(Int3 a, Int3 b) {
	return Int3FromSimd(Int3ToSimd(a) + Int3ToSimd(b));
}
NS_INLINE Int3 Int3Subtract(Int3 a, Int3 b) {
	return Int3FromSimd(Int3ToSimd(a) - Int3ToSimd(b));
}
NS_INLINE Int3 Int3Negate(Int3 v) {
	return Int3FromSimd(-Int3ToSimd(v));
}
NS_INLINE Int3 Int3Multiply(Int3 a, Int3 b) {
	return Int3FromSimd(Int3ToSimd(a) * Int3ToSimd(b));
}
NS_INLINE Int3 Int3Divide(Int3 a, Int3 b) {
	return Int3FromSimd(Int3ToSimd(a) / Int3ToSimd(b));
}
NS_INLINE Int3 Int3Modulus(Int3 a, Int3 b) {
	return Int3FromSimd(Int3ToSimd(a) % Int3ToSimd(b));
}
NS_INLINE Int3 Int3MultiplyByScalar(Int3 v, int s) {
	return Int3FromSimd(Int3ToSimd(v) * s);
}
NS_INLINE Int3 Int3MultiplyingScalar(int s, Int3 v) {
	return Int3FromSimd(Int3ToSimd(v) * s);
}
NS_INLINE Int3 Int3DivideByScalar(Int3 v, int s) {
	return Int3FromSimd(Int3ToSimd(v) / s);
}
NS_INLINE Int3 Int3DividingScalar(int s, Int3 v) {
	return Int3FromSimd(s / Int3ToSimd(v));
}
NS_INLINE Int3 Int3ModulusByScalar(Int3 v, int s) {
	return Int3FromSimd(Int3ToSimd(v) % s);
}
NS_INLINE Int3 Int3ModulusingScalar(int s, Int3 v) {
	return Int3FromSimd(s % Int3ToSimd(v));
}

NS_INLINE BOOL Int3LessThan(Int3 a, Int3 b) {
	return simd_all(Int3ToSimd(a) < Int3ToSimd(b));
}
NS_INLINE BOOL Int3LessThanOrEqual(Int3 a, Int3 b) {
	return simd_all(Int3ToSimd(a) <= Int3ToSimd(b));
}
NS_INLINE BOOL Int3GreaterThan(Int3 a, Int3 b) {
	return simd_all(Int3ToSimd(a) > Int3ToSimd(b));
}
NS_INLINE BOOL Int3GreaterThanOrEqual(Int3 a, Int3 b) {
	return simd_all(Int3ToSimd(a) >= Int3ToSimd(b));
}



#pragma mark `NSValue`-Wrapping

@interface NSValue (Int3Additions)

+ (NSValue *)valueWithInt3:(Int3)int3Value;

@property(nonatomic, readonly) Int3 int3Value;

@end



NS_ASSUME_NONNULL_END
