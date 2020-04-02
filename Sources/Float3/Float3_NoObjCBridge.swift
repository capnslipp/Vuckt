// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import simd.vector_types
import SceneKit.SceneKitTypes
import GLKit.GLKVector3
import CoreImage.CIVector



// MARK: Struct Definition

public struct Float3
{
	public var x:Float
	public var y:Float
	public var z:Float
	
	public init() {
		self.x = Float()
		self.y = Float()
		self.z = Float()
	}
	
	public init(x:Float, y:Float, z:Float) {
		self.x = x
		self.y = y
		self.z = z
	}
}



// MARK: SIMD Conversion

/// Converts an `Float3` struct to `simd_float3` vector using passing-individual-members initialization.
@_transparent public func Float3ToSimd(_ structValue:Float3) -> simd_float3 {
	return simd_float3(structValue.x, structValue.y, structValue.z)
}
/// Converts a `Float3` struct from `simd_float3` vector using passing-individual-members initialization.
@_transparent public func Float3FromSimd(_ simdValue:simd_float3) -> Float3 {
	return Float3(x: simdValue.x, y: simdValue.y, z: simdValue.z)
}



// MARK: SIMD-Accelerated Operator Access

@_transparent public func Float3Add(_ a:Float3, _ b:Float3) -> Float3 {
	return Float3(Float3ToSimd(a) + Float3ToSimd(b))
}
@_transparent public func Float3Subtract(_ a:Float3, _ b:Float3) -> Float3 {
	return Float3FromSimd(Float3ToSimd(a) - Float3ToSimd(b))
}
@_transparent public func Float3Negate(_ v:Float3) -> Float3 {
	return Float3FromSimd(-Float3ToSimd(v))
}
@_transparent public func Float3Multiply(_ a:Float3, _ b:Float3) -> Float3 {
	return Float3FromSimd(Float3ToSimd(a) * Float3ToSimd(b))
}
@_transparent public func Float3Divide(_ a:Float3, _ b:Float3) -> Float3 {
	return Float3FromSimd(Float3ToSimd(a) / Float3ToSimd(b))
}
@_transparent public func Float3Modulus(_ a:Float3, _ b:Float3) -> Float3 {
	return Float3(array: a.simdValue.indices.map{ a[$0].truncatingRemainder(dividingBy: b[$0]) })
}
@_transparent public func Float3MultiplyByScalar(_ v:Float3, _ s:Float) -> Float3 {
	return Float3FromSimd(Float3ToSimd(v) * s);
}
@_transparent public func Float3MultiplyingScalar(_ s:Float, _ v:Float3) -> Float3 {
	return Float3FromSimd(Float3ToSimd(v) * s);
}
@_transparent public func Float3DivideByScalar(_ v:Float3, _ s:Float) -> Float3 {
	return Float3FromSimd(Float3ToSimd(v) / s);
}
@_transparent public func Float3DividingScalar(_ s:Float, _ v:Float3) -> Float3 {
	return Float3FromSimd(s / Float3ToSimd(v));
}
@_transparent public func Float3ModulusByScalar(_ v:Float3, _ s:Float) -> Float3 {
	return Float3Modulus(v, Float3(s, s, s));
}
@_transparent public func Float3ModulusingScalar(_ s:Float, _ v:Float3) -> Float3 {
	return Float3Modulus(Float3(s, s, s), v);
}

@_alwaysEmitIntoClient public func Float3LessThan(_ a:Float3, _ b:Float3) -> Bool {
	return all(a.simdValue .< b.simdValue)
}
@_alwaysEmitIntoClient public func Float3LessThanOrEqual(_ a:Float3, _ b:Float3) -> Bool {
	return all(a.simdValue .<= b.simdValue)
}
@_alwaysEmitIntoClient public func Float3GreaterThan(_ a:Float3, _ b:Float3) -> Bool {
	return all(a.simdValue .> b.simdValue)
}
@_alwaysEmitIntoClient public func Float3GreaterThanOrEqual(_ a:Float3, _ b:Float3) -> Bool {
	return all(a.simdValue .>= b.simdValue)
}



// MARK: SceneKit Conversion

/// Converts an `Float3` struct to `SCNVector3` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
@_transparent public func Float3ToSCN(_ structValue:Float3) -> SCNVector3 {
	return SCNVector3(Float3ToSimd(structValue))
}
/// Converts an `Float3` struct from `SCNVector3` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
@_transparent public func Float3FromSCN(_ scnValue:SCNVector3) -> Float3 {
	return Float3FromSimd(simd_float3(scnValue))
}



// MARK: GLKit Conversion

/// Converts an `Float3` struct to `GLKVector3` struct using passing-individual-members initialization.
@_transparent public func Float3ToGLK(_ structValue:Float3) -> GLKVector3 {
	return GLKVector3Make(structValue.x, structValue.y, structValue.z)
}
/// Converts an `Float3` struct from `GLKVector3` struct using passing-individual-members initialization.
@_transparent public func Float3FromGLK(_ glkValue:GLKVector3) -> Float3 {
	return Float3(x: glkValue.x, y: glkValue.y, z: glkValue.z)
}



// MARK: CoreImage Conversion

/// Converts an `Float3` struct to `CIVector` class using passing-individual-members initialization.
@_transparent public func Float3ToCI(_ structValue:Float3) -> CIVector {
	return CIVector(x: CGFloat(structValue.x), y: CGFloat(structValue.y), z: CGFloat(structValue.z))
}
/// Converts an `Float3` struct from `CIVector` class using passing-individual-members initialization.
@_transparent public func Float3FromCI(_ ciVector:CIVector) -> Float3 {
	return Float3(x: Float(ciVector.x), y: Float(ciVector.y), z: Float(ciVector.z))
}
