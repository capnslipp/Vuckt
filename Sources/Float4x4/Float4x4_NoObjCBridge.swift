// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation.NSValue
import Darwin.C.tgmath
import simd
import SceneKit.SceneKitTypes
#if !os(watchOS)
	import GLKit.GLKMatrix4
	import QuartzCore.CATransform3D
#endif
//import CoreGraphics.CGAffineTransform
//#if os(macOS) || targetEnvironment(macCatalyst)
//	import Foundation.NSAffineTransform
//#endif
//import CoreImage.CIVector
//import Accelerate // vImage_AffineTransform ?



// MARK: Struct Definition

public struct Float4x4
{
	public var m00: Float
	public var m01: Float
	public var m02: Float
	public var m03: Float
	public var m10: Float
	public var m11: Float
	public var m12: Float
	public var m13: Float
	public var m20: Float
	public var m21: Float
	public var m22: Float
	public var m23: Float
	public var m30: Float
	public var m31: Float
	public var m32: Float
	public var m33: Float
	
	public init() {
		self.m00 = Float()
		self.m01 = Float()
		self.m02 = Float()
		self.m03 = Float()
		self.m10 = Float()
		self.m11 = Float()
		self.m12 = Float()
		self.m13 = Float()
		self.m20 = Float()
		self.m21 = Float()
		self.m22 = Float()
		self.m23 = Float()
		self.m30 = Float()
		self.m31 = Float()
		self.m32 = Float()
		self.m33 = Float()
	}
	
	public init(m00:Float, m01:Float, m02:Float, m03:Float, m10:Float, m11:Float, m12:Float, m13:Float, m20:Float, m21:Float, m22:Float, m23:Float, m30:Float, m31:Float, m32:Float, m33:Float) {
		self.m00 = m00
		self.m01 = m01
		self.m02 = m02
		self.m03 = m03
		self.m10 = m10
		self.m11 = m11
		self.m12 = m12
		self.m13 = m13
		self.m20 = m20
		self.m21 = m21
		self.m22 = m22
		self.m23 = m23
		self.m30 = m30
		self.m31 = m31
		self.m32 = m32
		self.m33 = m33
	}
}



// MARK: SIMD Conversion

/// Converts a `Float4x4` struct to `simd_float4x4` vector using passing-individual-members initialization.
@_transparent public func Float4x4ToSimd(_ structValue:Float4x4) -> simd_float4x4 {
	return simd_float4x4(
		simd_float4(structValue.m00, structValue.m01, structValue.m02, structValue.m03),
		simd_float4(structValue.m10, structValue.m11, structValue.m12, structValue.m13),
		simd_float4(structValue.m20, structValue.m21, structValue.m22, structValue.m23),
		simd_float4(structValue.m30, structValue.m31, structValue.m32, structValue.m33)
	)
}
/// Converts a `Float4x4` struct from `simd_float4x4` vector using passing-individual-members initialization.
@_transparent public func Float4x4FromSimd(_ simdValue:simd_float4x4) -> Float4x4 {
	return Float4x4(
		m00: simdValue[0, 0], m01: simdValue[0, 1], m02: simdValue[0, 2], m03: simdValue[0, 3],
		m10: simdValue[1, 0], m11: simdValue[1, 1], m12: simdValue[1, 2], m13: simdValue[1, 3],
		m20: simdValue[2, 0], m21: simdValue[2, 1], m22: simdValue[2, 2], m23: simdValue[2, 3],
		m30: simdValue[3, 0], m31: simdValue[3, 1], m32: simdValue[3, 2], m33: simdValue[3, 3]
	)
}



// MARK: SIMD-Accelerated Operator Access

@_transparent public func Float4x4OuterProduct(_ a:Float4, _ b:Float4) -> Float4x4 {
	let a_simd = Float4ToSimd(a)
	let b_simd = Float4ToSimd(b)
	return Float4x4FromSimd(simd_matrix(
		(a_simd * b_simd.x), (a_simd * b_simd.y), (a_simd * b_simd.z), (a_simd * b_simd.w)
	))
}



// MARK: SceneKit Conversion
	
/// Converts a `Float4x4` struct to `SCNMatrix4` struct using SceneKit-provided SIMD↔SCNMatrix conversion helper function.
@_transparent public func Float4x4ToSCN(_ structValue:Float4x4) -> SCNMatrix4 {
	return SCNMatrix4(Float4x4ToSimd(structValue));
}
/// Converts a `Float4x4` struct from `SCNMatrix4` struct using SceneKit-provided SIMD↔SCNMatrix conversion helper function.
@_transparent public func Float4x4FromSCN(_ scnValue:SCNMatrix4) -> Float4x4 {
	return Float4x4FromSimd(simd_float4x4(scnValue));
}



#if !os(watchOS)
	// MARK: GLKit Conversion
	
	/// Converts a `Float4x4` struct to `GLKMatrix4` struct using passing-individual-members initialization.
	@_transparent public func Float4x4ToGLK(_ structValue: Float4x4) -> GLKMatrix4 {
		return GLKMatrix4Make(
			structValue.m00, structValue.m01, structValue.m02, structValue.m03,
			structValue.m10, structValue.m11, structValue.m12, structValue.m13,
			structValue.m20, structValue.m21, structValue.m22, structValue.m23,
			structValue.m30, structValue.m31, structValue.m32, structValue.m33
		)
	}
	/// Converts a `Float4x4` struct from `GLKMatrix4` struct using passing-individual-members initialization.
	@_transparent public func Float4x4FromGLK(_ glkValue: GLKMatrix4) -> Float4x4 {
		return Float4x4(
			m00: glkValue.m00, m01: glkValue.m01, m02: glkValue.m02, m03: glkValue.m03,
			m10: glkValue.m10, m11: glkValue.m11, m12: glkValue.m12, m13: glkValue.m13,
			m20: glkValue.m20, m21: glkValue.m21, m22: glkValue.m22, m23: glkValue.m23,
			m30: glkValue.m30, m31: glkValue.m31, m32: glkValue.m32, m33: glkValue.m33
		)
	}
#endif // !watchOS



//// MARK: CGAffineTransform Conversion
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



//#if os(macOS) || targetEnvironment(macCatalyst)
//	// MARK: NSAffineTransform Conversion
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
//#endif // macOS || macCatalyst



#if !os(watchOS)
	// MARK: CATransform3D Conversion

	/// Converts a `Float4x4` struct to `CATransform3D` struct using passing-individual-members initialization.
	@_transparent public func Float4x4ToCA(_ structValue:Float4x4) -> CATransform3D {
		return CATransform3D(
			m11: CGFloat(structValue.m00), m12: CGFloat(structValue.m01), m13: CGFloat(structValue.m02), m14: CGFloat(structValue.m03),
			m21: CGFloat(structValue.m10), m22: CGFloat(structValue.m11), m23: CGFloat(structValue.m12), m24: CGFloat(structValue.m13),
			m31: CGFloat(structValue.m20), m32: CGFloat(structValue.m21), m33: CGFloat(structValue.m22), m34: CGFloat(structValue.m23),
			m41: CGFloat(structValue.m30), m42: CGFloat(structValue.m31), m43: CGFloat(structValue.m32), m44: CGFloat(structValue.m33)
		)
	}
	/// Converts a `Float4x4` struct from `CATransform3D` struct using passing-individual-members initialization.
	@_transparent public func Float4x4FromCA(_ caValue:CATransform3D) -> Float4x4 {
		return Float4x4(
			Float(caValue.m11), Float(caValue.m12), Float(caValue.m13), Float(caValue.m14),
			Float(caValue.m21), Float(caValue.m22), Float(caValue.m23), Float(caValue.m24),
			Float(caValue.m31), Float(caValue.m32), Float(caValue.m33), Float(caValue.m34),
			Float(caValue.m41), Float(caValue.m42), Float(caValue.m43), Float(caValue.m44)
		)
	}
#endif // !watchOS



//// MARK: CoreImage Conversion
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
