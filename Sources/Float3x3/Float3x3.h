// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import "Vuckt/Float3.h"

#import <Foundation/NSValue.h>
#import <tgmath.h>
#import <simd/simd.h>
#import <SceneKit/SceneKitTypes.h>
#if !TARGET_OS_WATCH && !TARGET_OS_XR
	#import <GLKit/GLKMatrix3.h>
#endif
//#import <CoreGraphics/CGAffineTransform.h>
//#if TARGET_OS_OSX || TARGET_OS_MACCATALYST
//	#import <Foundation/NSAffineTransform.h>
//#endif
//#import <QuartzCore/CATransform3D.h>
//#import <CoreImage/CIVector.h>
//#import <Accelerate/Accelerate.h> // vImage_AffineTransform ?



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct Float3x3 { // @expected: Padding size of 'Float3x3' with 4 bytes to alignment boundary
	float m00 __attribute__((aligned(__alignof__(simd_float3))));
	float m01;
	float m02;
	float m10 __attribute__((aligned(__alignof__(simd_float3)))); // @expected: Padding struct 'Float3x3' with 4 bytes to align 'm10'
	float m11;
	float m12;
	float m20 __attribute__((aligned(__alignof__(simd_float3)))); // @expected: Padding struct 'Float3x3' with 4 bytes to align 'm20'
	float m21;
	float m22;
} __attribute__((aligned(__alignof__(simd_float3x3))));
typedef struct Float3x3 Float3x3;



#pragma mark SIMD Conversion

/// Converts a `Float3x3` struct to `simd_float3x3` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE simd_float3x3 Float3x3ToSimd(Float3x3 structValue) {
	return *(simd_float3x3 *)&structValue;
}
/// Converts a `Float3x3` struct from `simd_float3x3` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE Float3x3 Float3x3FromSimd(simd_float3x3 simdValue) {
	return *(Float3x3 *)&simdValue;
}



#pragma mark SIMD-Accelerated Operator Access

NS_INLINE Float3x3 Float3x3OuterProduct(Float3 a, Float3 b) {
	simd_float3 a_simd = Float3ToSimd(a);
	simd_float3 b_simd = Float3ToSimd(b);
	return Float3x3FromSimd(simd_matrix(
		(a_simd * b_simd.x), (a_simd * b_simd.y), (a_simd * b_simd.z)
	));
}



//#pragma mark SceneKit Conversion
//
///// Converts a `Float4x4` struct to `SCNMatrix4` struct using SceneKit-provided SIMD↔SCNMatrix conversion helper function.
//NS_INLINE SCNMatrix4 Float4x4ToSCN(Float3 structValue) {
//	return SCNMatrix4FromMat4(Float4x4ToSimd(structValue));
//}
///// Converts a `Float4x4` struct from `SCNMatrix4` struct using SceneKit-provided SIMD↔SCNMatrix conversion helper function.
//NS_INLINE Float4x4 Float4x4FromSCN(SCNMatrix4 scnValue) {
//	return Float4x4FromSimd(SCNMatrix4ToMat4(scnValue));
//}



#if !TARGET_OS_WATCH && !TARGET_OS_XR
	#pragma mark GLKit Conversion

	/// Converts a `Float3x3` struct to `GLKMatrix3` struct using passing-individual-members initialization.
	NS_INLINE GLKMatrix3 Float3x3ToGLK(Float3x3 structValue) {
		return GLKMatrix3Make(
			structValue.m00, structValue.m01, structValue.m02,
			structValue.m10, structValue.m11, structValue.m12,
			structValue.m20, structValue.m21, structValue.m22
		);
	}
	/// Converts a `Float3x3` struct from `GLKMatrix3` struct using passing-individual-members initialization.
	NS_INLINE Float3x3 Float3x3FromGLK(GLKMatrix3 glkValue) {
		return (Float3x3){
			glkValue.m00, glkValue.m01, glkValue.m02,
			glkValue.m10, glkValue.m11, glkValue.m12,
			glkValue.m20, glkValue.m21, glkValue.m22,
		};
	}
#endif // !TARGET_OS_WATCH



//#pragma mark CGAffineTransform Conversion
//
///// Converts a `Float3x3` struct to `CGAffineTransform` struct using passing-individual-members initialization.
///// Note: the 3rd (#2) column is discarded; affine transforms have an implied 3rd column of [ 0, 0, 1 ].
//NS_INLINE CGAffineTransform Float3x3ToCGAffine(Float3x3 structValue) {
//	return (CGAffineTransform){
//		/*m11:*/ structValue.m00, /*m12:*/ structValue.m01,
//		/*m21:*/ structValue.m10, /*m22:*/ structValue.m11,
//		/*tX:*/ structValue.m20, /*mtY:*/ structValue.m21
//	};
//}
///// Converts a `Float3x3` struct from `CGAffineTransform` struct using passing-individual-members initialization.
//NS_INLINE Float3x3 Float3x3FromCGAffine(CGAffineTransform cgAffineValue) {
//	return (Float3x3){
//		/*m00:*/ (float)cgAffineValue.a, /*m01:*/ (float)cgAffineValue.b, /*m02:*/ 0.0,
//		/*m10:*/ (float)cgAffineValue.c, /*m11:*/ (float)cgAffineValue.d, /*m12:*/ 0.0,
//		/*m20:*/ (float)cgAffineValue.tx, /*m21:*/ (float)cgAffineValue.ty, /*m22:*/ 1.0,
//	};
//}



//#if TARGET_OS_OSX || TARGET_OS_MACCATALYST
//	#pragma mark NSAffineTransform Conversion
//
//	/// Converts a `Float3x3` struct to `NSAffineTransformStruct` struct using passing-individual-members initialization.
//	/// Note: the 3rd (#2) column is discarded; affine transforms have an implied 3rd column of [ 0, 0, 1 ].
//	NS_INLINE NSAffineTransformStruct Float3x3ToNSAffineStruct(Float3x3 structValue) {
//		return (NSAffineTransformStruct){
//			/*m11:*/ structValue.m00, /*m12:*/ structValue.m01,
//			/*m21:*/ structValue.m10, /*m22:*/ structValue.m11,
//			/*tX:*/ structValue.m20, /*mtY:*/ structValue.m21
//		};
//	}
//	/// Converts a `Float3x3` struct to `NSAffineTransform` object using passing-individual-members initialization.
//	/// Note: the 3rd (#2) column is discarded; affine transforms have an implied 3rd column of [ 0, 0, 1 ].
//	NS_INLINE NSAffineTransform * Float3x3ToNSAffine(Float3x3 structValue) {
//		NSAffineTransform *nsAffine = [NSAffineTransform transform];
//		nsAffine.transformStruct = Float3x3ToNSAffineStruct(structValue);
//		return nsAffine;
//	}
//	/// Converts a `Float3x3` struct from `NSAffineTransformStruct` struct using passing-individual-members initialization.
//	NS_INLINE Float3x3 Float3x3FromNSAffineStruct(NSAffineTransformStruct nsAffineValue) {
//		return (Float3x3){
//			/*m00:*/ (float)nsAffineValue.m11, /*m01:*/ (float)nsAffineValue.m12, /*m02:*/ 0.0,
//			/*m10:*/ (float)nsAffineValue.m21, /*m11:*/ (float)nsAffineValue.m22, /*m12:*/ 0.0,
//			/*m20:*/ (float)nsAffineValue.tX, /*m21:*/ (float)nsAffineValue.tY, /*m22:*/ 1.0,
//		};
//	}
//	/// Converts a `Float3x3` struct from `NSAffineTransform` object using passing-individual-members initialization.
//	NS_INLINE Float3x3 Float3x3FromNSAffine(NSAffineTransform *nsAffine) {
//		return Float3x3FromNSAffineStruct(nsAffine.transformStruct);
//	}
//#endif // TARGET_OS_OSX || TARGET_OS_MACCATALYST



//#pragma mark CATransform Conversion
//
///// Converts a `Float3x3` struct to `CATransform` struct using passing-individual-members initialization.
///// Note: the 3rd (#2) column is discarded; affine transforms have an implied 3rd column of [ 0, 0, 1 ].
//NS_INLINE CATransform Float3x3ToCGAffine(Float3x3 structValue) {
//	return (CATransform){
//		/*m11:*/ structValue.m00, /*m12:*/ structValue.m01,
//		/*m21:*/ structValue.m10, /*m22:*/ structValue.m11,
//		/*tX:*/ structValue.m20, /*mtY:*/ structValue.m21
//	};
//}
///// Converts a `Float3x3` struct from `CATransform` struct using passing-individual-members initialization.
//NS_INLINE Float3x3 Float3x3FromCGAffine(CATransform caValue) {
//	return (Float3x3){
//		/*m00:*/ (float)caValue.a, /*m01:*/ (float)caValue.b, /*m02:*/ 0.0,
//		/*m10:*/ (float)caValue.c, /*m11:*/ (float)caValue.d, /*m12:*/ 0.0,
//		/*m20:*/ (float)caValue.tx, /*m21:*/ (float)caValue.ty, /*m22:*/ 1.0,
//	};
//}



//#pragma mark CoreImage Conversion
//
///// Converts a `Float3x3` struct to `CIVector` class using passing-individual-members initialization.
//NS_INLINE CIVector *Float3x3ToCI(Float3x3 structValue) {
//	return [CIVector vectorWithCGAffineTransform:Float3x3ToCGAffine(structValue)];
//}
///// Converts a `Float3x3` struct from `CIVector` class using passing-individual-members initialization.
//NS_INLINE Float3x3 Float3x3FromCI(CIVector *ciVector) {
//	assert(ciVector.count == 6);
//	return Float3x3FromCGAffine(ciVector.CGAffineTransformValue);
//}



#pragma mark `NSValue`-Wrapping

@interface NSValue (Float3x3Additions)

+ (NSValue *)valueWithFloat3x3:(Float3x3)float3x3Value;

@property(nonatomic, readonly) Float3x3 float3x3Value;

@end



NS_ASSUME_NONNULL_END
