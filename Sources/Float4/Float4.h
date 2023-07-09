// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/simd.h>
#import <SceneKit/SceneKitTypes.h>
#if !TARGET_OS_WATCH && !TARGET_OS_XR
	#import <GLKit/GLKVector4.h>
#endif
#if !TARGET_OS_WATCH
	#import <CoreImage/CIVector.h>
#endif



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct Float4 {
	float x, y, z, w;
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



#pragma mark SIMD-Accelerated Operator Access

NS_INLINE Float4 Float4Add(Float4 a, Float4 b) {
	return Float4FromSimd(Float4ToSimd(a) + Float4ToSimd(b));
}
NS_INLINE Float4 Float4Subtract(Float4 a, Float4 b) {
	return Float4FromSimd(Float4ToSimd(a) - Float4ToSimd(b));
}
NS_INLINE Float4 Float4Negate(Float4 v) {
	return Float4FromSimd(-Float4ToSimd(v));
}
NS_INLINE Float4 Float4Multiply(Float4 a, Float4 b) {
	return Float4FromSimd(Float4ToSimd(a) * Float4ToSimd(b));
}
NS_INLINE Float4 Float4Divide(Float4 a, Float4 b) {
	return Float4FromSimd(Float4ToSimd(a) / Float4ToSimd(b));
}
NS_INLINE Float4 Float4Modulus(Float4 a, Float4 b) {
	#ifdef __cplusplus
		return Float4FromSimd(simd::fmod(Float4ToSimd(a), Float4ToSimd(b)));
	#else
		return Float4FromSimd(fmod(Float4ToSimd(a), Float4ToSimd(b)));
	#endif
}
NS_INLINE Float4 Float4MultiplyByScalar(Float4 v, float s) {
	return Float4FromSimd(Float4ToSimd(v) * s);
}
NS_INLINE Float4 Float4MultiplyingScalar(float s, Float4 v) {
	return Float4FromSimd(Float4ToSimd(v) * s);
}
NS_INLINE Float4 Float4DivideByScalar(Float4 v, float s) {
	return Float4FromSimd(Float4ToSimd(v) / s);
}
NS_INLINE Float4 Float4DividingScalar(float s, Float4 v) {
	return Float4FromSimd(s / Float4ToSimd(v));
}
NS_INLINE Float4 Float4ModulusByScalar(Float4 v, float s) {
	return Float4Modulus(v, (Float4){ s, s, s, s });
}
NS_INLINE Float4 Float4ModulusingScalar(float s, Float4 v) {
	return Float4Modulus((Float4){ s, s, s, s }, v);
}

NS_INLINE BOOL Float4LessThan(Float4 a, Float4 b) {
	return simd_all(Float4ToSimd(a) < Float4ToSimd(b));
}
NS_INLINE BOOL Float4LessThanOrEqual(Float4 a, Float4 b) {
	return simd_all(Float4ToSimd(a) <= Float4ToSimd(b));
}
NS_INLINE BOOL Float4GreaterThan(Float4 a, Float4 b) {
	return simd_all(Float4ToSimd(a) > Float4ToSimd(b));
}
NS_INLINE BOOL Float4GreaterThanOrEqual(Float4 a, Float4 b) {
	return simd_all(Float4ToSimd(a) >= Float4ToSimd(b));
}



#pragma mark SceneKit Conversion

/// Converts an `Float4` struct to `SCNVector4` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
NS_INLINE SCNVector4 Float4ToSCN(Float4 structValue) {
	return SCNVector4FromFloat4(Float4ToSimd(structValue));
}
/// Converts an `Float4` struct from `SCNVector4` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
NS_INLINE Float4 Float4FromSCN(SCNVector4 scnValue) {
	return Float4FromSimd(SCNVector4ToFloat4(scnValue));
}



#if !TARGET_OS_WATCH && !TARGET_OS_XR
	#pragma mark GLKit Conversion

	/// Converts an `Float4` struct to `GLKVector4` struct using passing-individual-members initialization.
	NS_INLINE GLKVector4 Float4ToGLK(Float4 structValue) {
		return GLKVector4Make(structValue.x, structValue.y, structValue.z, structValue.w);
	}
	/// Converts an `Float4` struct from `GLKVector4` struct using passing-individual-members initialization.
	NS_INLINE Float4 Float4FromGLK(GLKVector4 glkValue) {
		return (Float4){ glkValue.v[0], glkValue.v[1], glkValue.v[2], glkValue.v[3] };
	}
#endif // !TARGET_OS_WATCH



#if !TARGET_OS_WATCH
	#pragma mark CoreImage Conversion

	/// Converts an `Float4` struct to `CIVector` class using passing-individual-members initialization.
	NS_INLINE CIVector *Float4ToCI(Float4 structValue) {
		return [CIVector vectorWithX:(CGFloat)structValue.x Y:(CGFloat)structValue.y Z:(CGFloat)structValue.z W:(CGFloat)structValue.w];
	}
	/// Converts an `Float4` struct from `CIVector` class using passing-individual-members initialization.
	NS_INLINE Float4 Float4FromCI(CIVector *ciVector) {
		assert(ciVector.count == 4);
		return (Float4){ (simd_float1)ciVector.X, (simd_float1)ciVector.Y, (simd_float1)ciVector.Z, (simd_float1)ciVector.W };
	}
#endif // !TARGET_OS_WATCH



#pragma mark `NSValue`-Wrapping

@interface NSValue (Float4Additions)

+ (NSValue *)valueWithFloat4:(Float4)float4Value;

@property(nonatomic, readonly) Float4 float4Value;

@end



NS_ASSUME_NONNULL_END
