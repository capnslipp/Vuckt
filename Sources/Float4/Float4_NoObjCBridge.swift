// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import simd.vector_types
import SceneKit.SceneKitTypes
#if !os(watchOS) && !os(xrOS)
	import GLKit.GLKVector4
#endif
#if !os(watchOS)
	import CoreImage.CIVector
#endif



// MARK: Struct Definition

public struct Float4
{
	public var x:Float, y:Float
	public var z:Float
	public var w:Float
	
	public init() {
		self.x = Float()
		self.y = Float()
		self.z = Float()
		self.w = Float()
	}
	
	public init(x:Float, y:Float, z:Float, w:Float) {
		self.x = x
		self.y = y
		self.z = z
		self.w = w
	}
}



// MARK: SIMD Conversion

/// Converts a `Float4` struct to `simd_float4` vector using passing-individual-members initialization.
@_transparent public func Float4ToSimd(_ structValue:Float4) -> simd_float4 {
	return simd_float4(structValue.x, structValue.y, structValue.z, structValue.w)
}
/// Converts a `Float4` struct from `simd_float4` vector using passing-individual-members initialization.
@_transparent public func Float4FromSimd(_ simdValue:simd_float4) -> Float4 {
	return Float4(x: simdValue.x, y: simdValue.y, z: simdValue.z, w: simdValue.w)
}



// MARK: SIMD-Accelerated Operator Access

@_transparent public func Float4Add(_ a:Float4, _ b:Float4) -> Float4 {
	return Float4(Float4ToSimd(a) + Float4ToSimd(b))
}
@_transparent public func Float4Subtract(_ a:Float4, _ b:Float4) -> Float4 {
	return Float4FromSimd(Float4ToSimd(a) - Float4ToSimd(b))
}
@_transparent public func Float4Negate(_ v:Float4) -> Float4 {
	return Float4FromSimd(-Float4ToSimd(v))
}
@_transparent public func Float4Multiply(_ a:Float4, _ b:Float4) -> Float4 {
	return Float4FromSimd(Float4ToSimd(a) * Float4ToSimd(b))
}
@_transparent public func Float4Divide(_ a:Float4, _ b:Float4) -> Float4 {
	return Float4FromSimd(Float4ToSimd(a) / Float4ToSimd(b))
}
@_transparent public func Float4Modulus(_ a:Float4, _ b:Float4) -> Float4 {
	return Float4(array: a.simdValue.indices.map{ a[$0].truncatingRemainder(dividingBy: b[$0]) })
}
@_transparent public func Float4MultiplyByScalar(_ v:Float4, _ s:Float) -> Float4 {
	return Float4FromSimd(Float4ToSimd(v) * s);
}
@_transparent public func Float4MultiplyingScalar(_ s:Float, _ v:Float4) -> Float4 {
	return Float4FromSimd(Float4ToSimd(v) * s);
}
@_transparent public func Float4DivideByScalar(_ v:Float4, _ s:Float) -> Float4 {
	return Float4FromSimd(Float4ToSimd(v) / s);
}
@_transparent public func Float4DividingScalar(_ s:Float, _ v:Float4) -> Float4 {
	return Float4FromSimd(s / Float4ToSimd(v));
}
@_transparent public func Float4ModulusByScalar(_ v:Float4, _ s:Float) -> Float4 {
	return Float4Modulus(v, Float4(s, s, s, s));
}
@_transparent public func Float4ModulusingScalar(_ s:Float, _ v:Float4) -> Float4 {
	return Float4Modulus(Float4(s, s, s, s), v);
}

@_alwaysEmitIntoClient public func Float4LessThan(_ a:Float4, _ b:Float4) -> Bool {
	return all(a.simdValue .< b.simdValue)
}
@_alwaysEmitIntoClient public func Float4LessThanOrEqual(_ a:Float4, _ b:Float4) -> Bool {
	return all(a.simdValue .<= b.simdValue)
}
@_alwaysEmitIntoClient public func Float4GreaterThan(_ a:Float4, _ b:Float4) -> Bool {
	return all(a.simdValue .> b.simdValue)
}
@_alwaysEmitIntoClient public func Float4GreaterThanOrEqual(_ a:Float4, _ b:Float4) -> Bool {
	return all(a.simdValue .>= b.simdValue)
}



// MARK: SceneKit Conversion

/// Converts an `Float4` struct to `SCNVector4` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
@_transparent public func Float4ToSCN(_ structValue:Float4) -> SCNVector4 {
	return SCNVector4(Float4ToSimd(structValue))
}
/// Converts an `Float4` struct from `SCNVector4` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
@_transparent public func Float4FromSCN(_ scnValue:SCNVector4) -> Float4 {
	return Float4FromSimd(simd_float4(scnValue))
}



#if !os(watchOS) && !os(xrOS)
	// MARK: GLKit Conversion

	/// Converts an `Float4` struct to `GLKVector4` struct using passing-individual-members initialization.
	@_transparent public func Float4ToGLK(_ structValue:Float4) -> GLKVector4 {
		return GLKVector4Make(structValue.x, structValue.y, structValue.z, structValue.w)
	}
	/// Converts an `Float4` struct from `GLKVector4` struct using passing-individual-members initialization.
	@_transparent public func Float4FromGLK(_ glkValue:GLKVector4) -> Float4 {
		return Float4(x: glkValue.x, y: glkValue.y, z: glkValue.z, w: glkValue.w)
	}
#endif // !watchOS && !xrOS



#if !os(watchOS)
	// MARK: CoreImage Conversion

	/// Converts an `Float4` struct to `CIVector` class using passing-individual-members initialization.
	@_transparent public func Float4ToCI(_ structValue:Float4) -> CIVector {
		return CIVector(x: CGFloat(structValue.x), y: CGFloat(structValue.y), z: CGFloat(structValue.z), w: CGFloat(structValue.w))
	}
	/// Converts an `Float4` struct from `CIVector` class using passing-individual-members initialization.
	@_transparent public func Float4FromCI(_ ciVector:CIVector) -> Float4 {
		return Float4(x: Float(ciVector.x), y: Float(ciVector.y), z: Float(ciVector.z), w: Float(ciVector.w))
	}
#endif // !watchOS
