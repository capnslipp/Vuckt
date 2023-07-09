// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import "Vuckt/Float4.h"

#import <Foundation/NSValue.h>
#import <tgmath.h>
#import <simd/simd.h>
#import <SceneKit/SceneKitTypes.h>
#if !TARGET_OS_WATCH && !TARGET_OS_XR
	#import <GLKit/GLKMatrix4.h>
#endif
#if !TARGET_OS_WATCH
	#import <QuartzCore/CATransform3D.h>
#endif
//#import <CoreGraphics/CGAffineTransform.h>
//#if TARGET_OS_OSX || TARGET_OS_MACCATALYST
//	#import <Foundation/NSAffineTransform.h>
//#endif
//#import <CoreImage/CIVector.h>
//#import <Accelerate/Accelerate.h> // vImage_AffineTransform ?



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct Float4x4 {
	float m00 __attribute__((aligned(__alignof__(simd_float4))));
	float m01;
	float m02;
	float m03;
	float m10 __attribute__((aligned(__alignof__(simd_float4))));
	float m11;
	float m12;
	float m13;
	float m20 __attribute__((aligned(__alignof__(simd_float4))));
	float m21;
	float m22;
	float m23;
	float m30 __attribute__((aligned(__alignof__(simd_float4))));
	float m31;
	float m32;
	float m33;
} __attribute__((aligned(__alignof__(simd_float4x4))));
typedef struct Float4x4 Float4x4;



#pragma mark SIMD Conversion

/// Converts a `Float4x4` struct to `simd_float4x4` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE simd_float4x4 Float4x4ToSimd(Float4x4 structValue) {
	return *(simd_float4x4 *)&structValue;
}
/// Converts a `Float4x4` struct from `simd_float4x4` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE Float4x4 Float4x4FromSimd(simd_float4x4 simdValue) {
	return *(Float4x4 *)&simdValue;
}



#pragma mark SIMD-Accelerated Operator Access

NS_INLINE Float4x4 Float4x4OuterProduct(Float4 a, Float4 b) {
	simd_float4 a_simd = Float4ToSimd(a);
	simd_float4 b_simd = Float4ToSimd(b);
	return Float4x4FromSimd(simd_matrix(
		(a_simd * b_simd.x), (a_simd * b_simd.y), (a_simd * b_simd.z), (a_simd * b_simd.w)
	));
}



#pragma mark SceneKit Conversion

/// Converts a `Float4x4` struct to `SCNMatrix4` struct using SceneKit-provided SIMD↔SCNMatrix conversion helper function.
NS_INLINE SCNMatrix4 Float4x4ToSCN(Float4x4 structValue) {
	return SCNMatrix4FromMat4(Float4x4ToSimd(structValue));
}
/// Converts a `Float4x4` struct from `SCNMatrix4` struct using SceneKit-provided SIMD↔SCNMatrix conversion helper function.
NS_INLINE Float4x4 Float4x4FromSCN(SCNMatrix4 scnValue) {
	return Float4x4FromSimd(SCNMatrix4ToMat4(scnValue));
}



#if !TARGET_OS_WATCH && !TARGET_OS_XR
	#pragma mark GLKit Conversion

	/// Converts a `Float4x4` struct to `GLKMatrix4` struct using passing-individual-members initialization.
	NS_INLINE GLKMatrix4 Float4x4ToGLK(Float4x4 structValue) {
		return GLKMatrix4Make(
			structValue.m00, structValue.m01, structValue.m02, structValue.m03,
			structValue.m10, structValue.m11, structValue.m12, structValue.m13,
			structValue.m20, structValue.m21, structValue.m22, structValue.m23,
			structValue.m30, structValue.m31, structValue.m32, structValue.m33
		);
	}
	/// Converts a `Float4x4` struct from `GLKMatrix4` struct using passing-individual-members initialization.
	NS_INLINE Float4x4 Float4x4FromGLK(GLKMatrix4 glkValue) {
		return (Float4x4){
			glkValue.m00, glkValue.m01, glkValue.m02, glkValue.m03,
			glkValue.m10, glkValue.m11, glkValue.m12, glkValue.m13,
			glkValue.m20, glkValue.m21, glkValue.m22, glkValue.m23,
			glkValue.m30, glkValue.m31, glkValue.m32, glkValue.m33,
		};
	}
#endif // !TARGET_OS_WATCH



//#pragma mark CGAffineTransform Conversion
//
///// Converts a `Float4x4` struct to `CGAffineTransform` struct using passing-individual-members initialization.
///// Note: the 3rd (#2) column is discarded; affine transforms have an implied 3rd column of [ 0, 0, 1 ].
//NS_INLINE CGAffineTransform Float4x4ToCGAffine(Float4x4 structValue) {
//	return (CGAffineTransform){
//		/*m11:*/ structValue.m00, /*m12:*/ structValue.m01,
//		/*m21:*/ structValue.m10, /*m22:*/ structValue.m11,
//		/*tX:*/ structValue.m20, /*mtY:*/ structValue.m21
//	};
//}
///// Converts a `Float4x4` struct from `CGAffineTransform` struct using passing-individual-members initialization.
//NS_INLINE Float4x4 Float4x4FromCGAffine(CGAffineTransform cgAffineValue) {
//	return (Float4x4){
//		/*m00:*/ (float)cgAffineValue.a, /*m01:*/ (float)cgAffineValue.b, /*m02:*/ 0.0,
//		/*m10:*/ (float)cgAffineValue.c, /*m11:*/ (float)cgAffineValue.d, /*m12:*/ 0.0,
//		/*m20:*/ (float)cgAffineValue.tx, /*m21:*/ (float)cgAffineValue.ty, /*m22:*/ 1.0,
//	};
//}



//#if TARGET_OS_OSX || TARGET_OS_MACCATALYST
//	#pragma mark NSAffineTransform Conversion
//
//	/// Converts a `Float4x4` struct to `NSAffineTransformStruct` struct using passing-individual-members initialization.
//	/// Note: the 3rd (#2) column is discarded; affine transforms have an implied 3rd column of [ 0, 0, 1 ].
//	NS_INLINE NSAffineTransformStruct Float4x4ToNSAffineStruct(Float4x4 structValue) {
//		return (NSAffineTransformStruct){
//			/*m11:*/ structValue.m00, /*m12:*/ structValue.m01,
//			/*m21:*/ structValue.m10, /*m22:*/ structValue.m11,
//			/*tX:*/ structValue.m20, /*mtY:*/ structValue.m21
//		};
//	}
//	/// Converts a `Float4x4` struct to `NSAffineTransform` object using passing-individual-members initialization.
//	/// Note: the 3rd (#2) column is discarded; affine transforms have an implied 3rd column of [ 0, 0, 1 ].
//	NS_INLINE NSAffineTransform * Float4x4ToNSAffine(Float4x4 structValue) {
//		NSAffineTransform *nsAffine = [NSAffineTransform transform];
//		nsAffine.transformStruct = Float4x4ToNSAffineStruct(structValue);
//		return nsAffine;
//	}
//	/// Converts a `Float4x4` struct from `NSAffineTransformStruct` struct using passing-individual-members initialization.
//	NS_INLINE Float4x4 Float4x4FromNSAffineStruct(NSAffineTransformStruct nsAffineValue) {
//		return (Float4x4){
//			/*m00:*/ (float)nsAffineValue.m11, /*m01:*/ (float)nsAffineValue.m12, /*m02:*/ 0.0,
//			/*m10:*/ (float)nsAffineValue.m21, /*m11:*/ (float)nsAffineValue.m22, /*m12:*/ 0.0,
//			/*m20:*/ (float)nsAffineValue.tX, /*m21:*/ (float)nsAffineValue.tY, /*m22:*/ 1.0,
//		};
//	}
//	/// Converts a `Float4x4` struct from `NSAffineTransform` object using passing-individual-members initialization.
//	NS_INLINE Float4x4 Float4x4FromNSAffine(NSAffineTransform *nsAffine) {
//		return Float4x4FromNSAffineStruct(nsAffine.transformStruct);
//	}
//#endif // TARGET_OS_OSX || TARGET_OS_MACCATALYST



#if !TARGET_OS_WATCH
	#pragma mark CATransform3D Conversion

	/// Converts a `Float4x4` struct to `CATransform3D` struct using passing-individual-members initialization.
	NS_INLINE CATransform3D Float4x4ToCA(Float4x4 structValue) {
		return (CATransform3D){
			structValue.m00, structValue.m01, structValue.m02, structValue.m03,
			structValue.m10, structValue.m11, structValue.m12, structValue.m13,
			structValue.m20, structValue.m21, structValue.m22, structValue.m23,
			structValue.m30, structValue.m31, structValue.m32, structValue.m33,
		};
	}
	/// Converts a `Float4x4` struct from `CATransform3D` struct using passing-individual-members initialization.
	NS_INLINE Float4x4 Float4x4FromCA(CATransform3D caValue) {
		return (Float4x4){
			(float)caValue.m11, (float)caValue.m12, (float)caValue.m13, (float)caValue.m14,
			(float)caValue.m21, (float)caValue.m22, (float)caValue.m23, (float)caValue.m24,
			(float)caValue.m31, (float)caValue.m32, (float)caValue.m33, (float)caValue.m34,
			(float)caValue.m41, (float)caValue.m42, (float)caValue.m43, (float)caValue.m44,
		};
	}
#endif // !TARGET_OS_WATCH



//#pragma mark CoreImage Conversion
//
///// Converts a `Float4x4` struct to `CIVector` class using passing-individual-members initialization.
//NS_INLINE CIVector *Float4x4ToCI(Float4x4 structValue) {
//	return [CIVector vectorWithCGAffineTransform:Float4x4ToCGAffine(structValue)];
//}
///// Converts a `Float4x4` struct from `CIVector` class using passing-individual-members initialization.
//NS_INLINE Float4x4 Float4x4FromCI(CIVector *ciVector) {
//	assert(ciVector.count == 6);
//	return Float4x4FromCGAffine(ciVector.CGAffineTransformValue);
//}



#pragma mark `NSValue`-Wrapping

@interface NSValue (Float4x4Additions)

+ (NSValue *)valueWithFloat4x4:(Float4x4)Float4x4Value;

@property(nonatomic, readonly) Float4x4 Float4x4Value;

@end



NS_ASSUME_NONNULL_END
