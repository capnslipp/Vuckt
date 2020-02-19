// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/simd.h>
#import <CoreImage/CIVector.h>
#import <CoreGraphics/CGGeometry.h>



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct Float2 {
	float x, y;
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



#pragma mark SIMD-Accelerated Operator Access

NS_INLINE Float2 Float2Add(Float2 a, Float2 b) {
	return Float2FromSimd(Float2ToSimd(a) + Float2ToSimd(b));
}
NS_INLINE Float2 Float2Subtract(Float2 a, Float2 b) {
	return Float2FromSimd(Float2ToSimd(a) - Float2ToSimd(b));
}
NS_INLINE Float2 Float2Negate(Float2 v) {
	return Float2FromSimd(-Float2ToSimd(v));
}
NS_INLINE Float2 Float2Multiply(Float2 a, Float2 b) {
	return Float2FromSimd(Float2ToSimd(a) * Float2ToSimd(b));
}
NS_INLINE Float2 Float2Divide(Float2 a, Float2 b) {
	return Float2FromSimd(Float2ToSimd(a) / Float2ToSimd(b));
}
NS_INLINE Float2 Float2Modulus(Float2 a, Float2 b) {
	return Float2FromSimd(__tg_fmod(Float2ToSimd(a), Float2ToSimd(b)));
}

NS_INLINE BOOL Float2Equal(Float2 a, Float2 b) {
	return simd_all(Float2ToSimd(a) == Float2ToSimd(b));
}
NS_INLINE BOOL Float2Inequal(Float2 a, Float2 b) {
	return simd_any(Float2ToSimd(a) != Float2ToSimd(b));
}
NS_INLINE BOOL Float2LessThan(Float2 a, Float2 b) {
	return simd_all(Float2ToSimd(a) < Float2ToSimd(b));
}
NS_INLINE BOOL Float2LessThanOrEqual(Float2 a, Float2 b) {
	return simd_all(Float2ToSimd(a) <= Float2ToSimd(b));
}
NS_INLINE BOOL Float2GreaterThan(Float2 a, Float2 b) {
	return simd_all(Float2ToSimd(a) > Float2ToSimd(b));
}
NS_INLINE BOOL Float2GreaterThanOrEqual(Float2 a, Float2 b) {
	return simd_all(Float2ToSimd(a) >= Float2ToSimd(b));
}



#pragma mark CoreImage Conversion

/// Converts an `Float2` struct to `CIVector` class using passing-individual-members initialization.
NS_INLINE CIVector *Float2ToCI(Float2 structValue) {
	return [CIVector vectorWithX:(CGFloat)structValue.x Y:(CGFloat)structValue.y];
}
/// Converts an `Float2` struct from `CIVector` class using passing-individual-members initialization.
NS_INLINE Float2 Float2FromCI(CIVector *ciVector) {
	assert(ciVector.count == 2);
	return (Float2){ (simd_float1)ciVector.X, (simd_float1)ciVector.Y };
}



#pragma mark CoreGraphics Conversion

/// Converts an `Float2` struct to `CGVector` struct using passing-individual-members initialization.
NS_INLINE CGVector Float2ToCGVector(Float2 structValue) {
	return CGVectorMake((CGFloat)structValue.x, (CGFloat)structValue.y);
}
/// Converts an `Float2` struct from `CGVector` struct using passing-individual-members initialization.
NS_INLINE Float2 Float2FromCGVector(CGVector cgVectorValue) {
	return (Float2){ (simd_float1)cgVectorValue.dx, (simd_float1)cgVectorValue.dy };
}

/// Converts an `Float2` struct to `CGPoint` struct using passing-individual-members initialization.
NS_INLINE CGPoint Float2ToCGPoint(Float2 structValue) {
	return CGPointMake((CGFloat)structValue.x, (CGFloat)structValue.y);
}
/// Converts an `Float2` struct from `CGPoint` struct using passing-individual-members initialization.
NS_INLINE Float2 Float2FromCGPoint(CGPoint cgPointValue) {
	return (Float2){ (simd_float1)cgPointValue.x, (simd_float1)cgPointValue.y };
}

/// Converts an `Float2` struct to `CGSize` struct using passing-individual-members initialization.
NS_INLINE CGSize Float2ToCGSize(Float2 structValue) {
	return CGSizeMake((CGFloat)structValue.x, (CGFloat)structValue.y);
}
/// Converts an `Float2` struct from `CGSize` struct using passing-individual-members initialization.
NS_INLINE Float2 Float2FromCGSize(CGSize cgSizeValue) {
	return (Float2){ (simd_float1)cgSizeValue.width, (simd_float1)cgSizeValue.height };
}



#pragma mark `NSValue`-Wrapping

@interface NSValue (Float2Additions)

+ (NSValue *)valueWithFloat2:(Float2)float2Value;

@property(nonatomic, readonly) Float2 float2Value;

@end



NS_ASSUME_NONNULL_END
