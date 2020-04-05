// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/simd.h>
#import <SceneKit/SceneKitTypes.h>
#if !TARGET_OS_WATCH
	#import <GLKit/GLKVector3.h>
	#import <CoreImage/CIVector.h>
#endif



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct Float3 { // @expected: Padding size of 'Float3' with 4 bytes to alignment boundary
	float x, y, z;
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



#pragma mark SIMD-Accelerated Operator Access

NS_INLINE Float3 Float3Add(Float3 a, Float3 b) {
	return Float3FromSimd(Float3ToSimd(a) + Float3ToSimd(b));
}
NS_INLINE Float3 Float3Subtract(Float3 a, Float3 b) {
	return Float3FromSimd(Float3ToSimd(a) - Float3ToSimd(b));
}
NS_INLINE Float3 Float3Negate(Float3 v) {
	return Float3FromSimd(-Float3ToSimd(v));
}
NS_INLINE Float3 Float3Multiply(Float3 a, Float3 b) {
	return Float3FromSimd(Float3ToSimd(a) * Float3ToSimd(b));
}
NS_INLINE Float3 Float3Divide(Float3 a, Float3 b) {
	return Float3FromSimd(Float3ToSimd(a) / Float3ToSimd(b));
}
NS_INLINE Float3 Float3Modulus(Float3 a, Float3 b) {
	#ifdef __cplusplus
		return Float3FromSimd(simd::fmod(Float3ToSimd(a), Float3ToSimd(b)));
	#else
		return Float3FromSimd(fmod(Float3ToSimd(a), Float3ToSimd(b)));
	#endif
}
NS_INLINE Float3 Float3MultiplyByScalar(Float3 v, float s) {
	return Float3FromSimd(Float3ToSimd(v) * s);
}
NS_INLINE Float3 Float3MultiplyingScalar(float s, Float3 v) {
	return Float3FromSimd(Float3ToSimd(v) * s);
}
NS_INLINE Float3 Float3DivideByScalar(Float3 v, float s) {
	return Float3FromSimd(Float3ToSimd(v) / s);
}
NS_INLINE Float3 Float3DividingScalar(float s, Float3 v) {
	return Float3FromSimd(s / Float3ToSimd(v));
}
NS_INLINE Float3 Float3ModulusByScalar(Float3 v, float s) {
	return Float3Modulus(v, (Float3){ s, s, s });
}
NS_INLINE Float3 Float3ModulusingScalar(float s, Float3 v) {
	return Float3Modulus((Float3){ s, s, s }, v);
}

NS_INLINE BOOL Float3LessThan(Float3 a, Float3 b) {
	return simd_all(Float3ToSimd(a) < Float3ToSimd(b));
}
NS_INLINE BOOL Float3LessThanOrEqual(Float3 a, Float3 b) {
	return simd_all(Float3ToSimd(a) <= Float3ToSimd(b));
}
NS_INLINE BOOL Float3GreaterThan(Float3 a, Float3 b) {
	return simd_all(Float3ToSimd(a) > Float3ToSimd(b));
}
NS_INLINE BOOL Float3GreaterThanOrEqual(Float3 a, Float3 b) {
	return simd_all(Float3ToSimd(a) >= Float3ToSimd(b));
}

NS_INLINE Float3 Float3WedgeProduct(Float3 a, Float3 b) {
	simd_float3 exteriorProduct_simd = (simd_float3){ a.x, a.x, a.y } * (simd_float3){ b.y, b.z, b.z } - (simd_float3){ a.y, a.z, a.z } * (simd_float3){ b.x, b.x, b.y };
	return Float3FromSimd(exteriorProduct_simd);
}



#pragma mark SceneKit Conversion

/// Converts an `Float3` struct to `SCNVector3` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
NS_INLINE SCNVector3 Float3ToSCN(Float3 structValue) {
	return SCNVector3FromFloat3(Float3ToSimd(structValue));
}
/// Converts an `Float3` struct from `SCNVector3` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
NS_INLINE Float3 Float3FromSCN(SCNVector3 scnValue) {
	return Float3FromSimd(SCNVector3ToFloat3(scnValue));
}



#if !TARGET_OS_WATCH
	#pragma mark GLKit Conversion

	/// Converts an `Float3` struct to `GLKVector3` struct using passing-individual-members initialization.
	NS_INLINE GLKVector3 Float3ToGLK(Float3 structValue) {
		return GLKVector3Make(structValue.x, structValue.y, structValue.z);
	}
	/// Converts an `Float3` struct from `GLKVector3` struct using passing-individual-members initialization.
	NS_INLINE Float3 Float3FromGLK(GLKVector3 glkValue) {
		return (Float3){ glkValue.v[0], glkValue.v[1], glkValue.v[2] };
	}
#endif // !TARGET_OS_WATCH



#if !TARGET_OS_WATCH
	#pragma mark CoreImage Conversion

	/// Converts an `Float3` struct to `CIVector` class using passing-individual-members initialization.
	NS_INLINE CIVector *Float3ToCI(Float3 structValue) {
		return [CIVector vectorWithX:(CGFloat)structValue.x Y:(CGFloat)structValue.y Z:(CGFloat)structValue.z];
	}
	/// Converts an `Float3` struct from `CIVector` class using passing-individual-members initialization.
	NS_INLINE Float3 Float3FromCI(CIVector *ciVector) {
		assert(ciVector.count == 3);
		return (Float3){ (simd_float1)ciVector.X, (simd_float1)ciVector.Y, (simd_float1)ciVector.Z };
	}
#endif // !TARGET_OS_WATCH



#pragma mark `NSValue`-Wrapping

@interface NSValue (Float3Additions)

+ (NSValue *)valueWithFloat3:(Float3)float3Value;

@property(nonatomic, readonly) Float3 float3Value;

@end



NS_ASSUME_NONNULL_END
