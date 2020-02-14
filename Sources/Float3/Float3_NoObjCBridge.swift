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
	public var x:simd_float1
	public var y:simd_float1
	public var z:simd_float1
	
	public init() {
		self.x = simd_float1()
		self.y = simd_float1()
		self.z = simd_float1()
	}
	
	public init(x:simd_float1, y:simd_float1, z:simd_float1) {
		self.x = x
		self.y = y
		self.z = z
	}
}



// MARK: SIMD Conversion

/// Converts an `Float3` struct to `simd_float3` vector using passing-individual-members initialization.
public func Float3ToSimd(_ structValue:Float3) -> simd_float3 {
	return simd_float3(structValue.x, structValue.y, structValue.z)
}
/// Converts a `Float3` struct from `simd_float3` vector using passing-individual-members initialization.
public func Float3FromSimd(_ simdValue:simd_float3) -> Float3 {
	return Float3(x: simdValue.x, y: simdValue.y, z: simdValue.z)
}



// MARK: SceneKit Conversion

/// Converts an `Float3` struct to `SCNVector3` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
public func Float3ToSCN(_ structValue:Float3) -> SCNVector3 {
	return SCNVector3(Float3ToSimd(structValue))
}
/// Converts an `Float3` struct from `SCNVector3` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
public func Float3FromSCN(_ scnValue:SCNVector3) -> Float3 {
	return Float3FromSimd(simd_float3(scnValue))
}



// MARK: GLKit Conversion

/// Converts an `Float3` struct to `GLKVector3` struct using passing-individual-members initialization.
public func Float3ToGLK(_ structValue:Float3) -> GLKVector3 {
	return GLKVector3Make(structValue.x, structValue.y, structValue.z)
}
/// Converts an `Float3` struct from `GLKVector3` struct using passing-individual-members initialization.
public func Float3FromGLK(_ glkValue:GLKVector3) -> Float3 {
	return Float3(x: glkValue.x, y: glkValue.y, z: glkValue.z)
}



// MARK: CoreImage Conversion

/// Converts an `Float3` struct to `CIVector` class using passing-individual-members initialization.
public func Float3ToCI(_ structValue:Float3) -> CIVector {
	return CIVector(x: CGFloat(structValue.x), y: CGFloat(structValue.y), z: CGFloat(structValue.z))
}
/// Converts an `Float3` struct from `CIVector` class using passing-individual-members initialization.
public func Float3FromCI(_ ciVector:CIVector) -> Float3 {
	return Float3(x: simd_float1(ciVector.x), y: simd_float1(ciVector.y), z: simd_float1(ciVector.z))
}