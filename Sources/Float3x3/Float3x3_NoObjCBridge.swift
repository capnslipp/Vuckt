// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation.NSValue
import Darwin.C.tgmath
import simd
import SceneKit.SceneKitTypes
#if !os(watchOS)
	import GLKit.GLKMatrix3
#endif
//import CoreGraphics.CGAffineTransform
//#if os(macOS) || targetEnvironment(macCatalyst)
//	import Foundation.NSAffineTransform
//#endif
//import QuartzCore.CATransform3D
//import CoreImage.CIVector
//import Accelerate // vImage_AffineTransform ?



// MARK: Struct Definition

public struct Float3x3
{
	public var m00: Float
	public var m01: Float
	public var m02: Float
	public var m10: Float
	public var m11: Float
	public var m12: Float
	public var m20: Float
	public var m21: Float
	public var m22: Float
	
	public init() {
		self.m00 = Float()
		self.m01 = Float()
		self.m02 = Float()
		self.m10 = Float()
		self.m11 = Float()
		self.m12 = Float()
		self.m20 = Float()
		self.m21 = Float()
		self.m22 = Float()
	}
	
	public init(m00:Float, m01:Float, m02:Float, m10:Float, m11:Float, m12:Float, m20:Float, m21:Float, m22:Float) {
		self.m00 = m00
		self.m01 = m01
		self.m02 = m02
		self.m10 = m10
		self.m11 = m11
		self.m12 = m12
		self.m20 = m20
		self.m21 = m21
		self.m22 = m22
	}
}



// MARK: SIMD Conversion

/// Converts a `Float3x3` struct to `simd_float3x3` vector using passing-individual-members initialization.
@_transparent public func Float3x3ToSimd(_ structValue:Float3x3) -> simd_float3x3 {
	return simd_float3x3(
		simd_float3(structValue.m00, structValue.m01, structValue.m02),
		simd_float3(structValue.m10, structValue.m11, structValue.m12),
		simd_float3(structValue.m20, structValue.m21, structValue.m22)
	)
}
/// Converts a `Float3x3` struct from `simd_float3x3` vector using passing-individual-members initialization.
@_transparent public func Float3x3FromSimd(_ simdValue:simd_float3x3) -> Float3x3 {
	return Float3x3(
		m00: simdValue[0, 0], m01: simdValue[0, 1], m02: simdValue[0, 2],
		m10: simdValue[1, 0], m11: simdValue[1, 1], m12: simdValue[1, 2],
		m20: simdValue[2, 0], m21: simdValue[2, 1], m22: simdValue[2, 2]
	)
}



// MARK: SIMD-Accelerated Operator Access

@_transparent public func Float3x3OuterProduct(_ a:Float3, _ b:Float3) -> Float3x3 {
	let a_simd = Float3ToSimd(a)
	let b_simd = Float3ToSimd(b)
	return Float3x3FromSimd(simd_matrix(
		(a_simd * b_simd.x), (a_simd * b_simd.y), (a_simd * b_simd.z)
	))
}



//// MARK: SceneKit Conversion
//	
///// Converts a `Float4x4` struct to `SCNMatrix4` struct using SceneKit-provided SIMD↔SCNMatrix conversion helper function.
//NS_INLINE SCNMatrix4 Float4x4ToSCN(Float3 structValue) {
//	return SCNMatrix4FromMat4(Float4x4ToSimd(structValue));
//}
///// Converts a `Float4x4` struct from `SCNMatrix4` struct using SceneKit-provided SIMD↔SCNMatrix conversion helper function.
//NS_INLINE Float4x4 Float4x4FromSCN(SCNMatrix4 scnValue) {
//	return Float4x4FromSimd(SCNMatrix4ToMat4(scnValue));
//}



#if !os(watchOS)
	// MARK: GLKit Conversion
	
	/// Converts a `Float3x3` struct to `GLKMatrix3` struct using passing-individual-members initialization.
	@_transparent public func Float3x3ToGLK(_ structValue: Float3x3) -> GLKMatrix3 {
		return GLKMatrix3Make(
			structValue.m00, structValue.m01, structValue.m02,
			structValue.m10, structValue.m11, structValue.m12,
			structValue.m20, structValue.m21, structValue.m22
		)
	}
	/// Converts a `Float3x3` struct from `GLKMatrix3` struct using passing-individual-members initialization.
	@_transparent public func Float3x3FromGLK(_ glkValue: GLKMatrix3) -> Float3x3 {
		return Float3x3(
			m00: glkValue.m00, m01: glkValue.m01, m02: glkValue.m02,
			m10: glkValue.m10, m11: glkValue.m11, m12: glkValue.m12,
			m20: glkValue.m20, m21: glkValue.m21, m22: glkValue.m22
		)
	}
#endif // !watchOS



//// MARK: CGAffineTransform Conversion
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



//#if os(macOS) || targetEnvironment(macCatalyst)
//	// MARK: NSAffineTransform Conversion
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
//#endif // macOS || macCatalyst



//// MARK: CATransform Conversion
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



//// MARK: CoreImage Conversion
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
