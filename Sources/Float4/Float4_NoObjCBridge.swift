// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import simd.vector_types
import SceneKit.SceneKitTypes
import GLKit.GLKVector4
import CoreImage.CIVector



// MARK: Struct Definition

public struct Float4
{
	public var x:simd_float1, y:simd_float1
	public var z:simd_float1
	public var w:simd_float1
	
	public init() {
		self.x = simd_float1()
		self.y = simd_float1()
		self.z = simd_float1()
		self.w = simd_float1()
	}
	
	public init(x:simd_float1, y:simd_float1, z:simd_float1, w:simd_float1) {
		self.x = x
		self.y = y
		self.z = z
		self.w = w
	}
}



// MARK: SIMD Conversion

/// Converts a `Float4` struct to `simd_float4` vector using passing-individual-members initialization.
public func Float4ToSimd(_ structValue:Float4) -> simd_float4 {
	return simd_float4(structValue.x, structValue.y, structValue.z, structValue.w)
}
/// Converts a `Float4` struct from `simd_float4` vector using passing-individual-members initialization.
public func Float4FromSimd(_ simdValue:simd_float4) -> Float4 {
	return Float4(x: simdValue.x, y: simdValue.y, z: simdValue.z, w: simdValue.w)
}



// MARK: SceneKit Conversion

/// Converts an `Float4` struct to `SCNVector4` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
public func Float4ToSCN(_ structValue:Float4) -> SCNVector4 {
	return SCNVector4(Float4ToSimd(structValue))
}
/// Converts an `Float4` struct from `SCNVector4` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
public func Float4FromSCN(_ scnValue:SCNVector4) -> Float4 {
	return Float4FromSimd(simd_float4(scnValue))
}



// MARK: GLKit Conversion

/// Converts an `Float4` struct to `GLKVector4` struct using passing-individual-members initialization.
public func Float4ToGLK(_ structValue:Float4) -> GLKVector4 {
	return GLKVector4Make(structValue.x, structValue.y, structValue.z, structValue.w)
}
/// Converts an `Float4` struct from `GLKVector4` struct using passing-individual-members initialization.
public func Float4FromGLK(_ glkValue:GLKVector4) -> Float4 {
	return Float4(x: glkValue.x, y: glkValue.y, z: glkValue.z, w: glkValue.w)
}



// MARK: CoreImage Conversion

/// Converts an `Float4` struct to `CIVector` class using passing-individual-members initialization.
public func Float4ToCI(_ structValue:Float4) -> CIVector {
	return CIVector(x: CGFloat(structValue.x), y: CGFloat(structValue.y), z: CGFloat(structValue.z), w: CGFloat(structValue.w))
}
/// Converts an `Float4` struct from `CIVector` class using passing-individual-members initialization.
public func Float4FromCI(_ ciVector:CIVector) -> Float4 {
	return Float4(x: simd_float1(ciVector.x), y: simd_float1(ciVector.y), z: simd_float1(ciVector.z), w: simd_float1(ciVector.w))
}
