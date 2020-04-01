// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import simd.vector_types
import SceneKit.SceneKitTypes
import GLKit.GLKQuaternion



// MARK: Struct Definition

public struct FloatQuaternion
{
	public var ix:Float, iy:Float, iz:Float, r:Float
	
	public init() {
		self.ix = Float()
		self.iy = Float()
		self.iz = Float()
		self.r = Float()
	}
	
	public init(ix:Float, iy:Float, iz:Float, r:Float) {
		self.ix = ix
		self.iy = iy
		self.iz = iz
		self.r = r
	}
}



// MARK: SIMD Conversion

/// Converts a `FloatQuaternion` struct to `simd_quatf` vector using passing-individual-members initialization.
@_transparent public func FloatQuaternionToSimd(_ structValue:FloatQuaternion) -> simd_quatf {
	return simd_quatf(ix: structValue.ix, iy: structValue.iy, iz: structValue.iz, r: structValue.r)
}
/// Converts a `FloatQuaternion` struct from `simd_quatf` vector using passing-individual-members initialization.
@_transparent public func FloatQuaternionFromSimd(_ simdValue:simd_quatf) -> FloatQuaternion {
	return FloatQuaternion(ix: simdValue.vector.x, iy: simdValue.vector.y, iz: simdValue.vector.z, r: simdValue.vector.w)
}



// MARK: SceneKit Conversion

/// Converts an `FloatQuaternion` struct to `SCNQuaternion` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
@_transparent public func FloatQuaternionToSCN(_ structValue:FloatQuaternion) -> SCNQuaternion {
	return SCNQuaternion(FloatQuaternionToSimd(structValue).vector)
}
/// Converts an `FloatQuaternion` struct from `SCNQuaternion` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
@_transparent public func FloatQuaternionFromSCN(_ scnValue:SCNQuaternion) -> FloatQuaternion {
	return FloatQuaternionFromSimd(simd_quatf(vector: simd_float4(scnValue)))
}



// MARK: GLKit Conversion

/// Converts an `FloatQuaternion` struct to `GLKQuaternion` struct using passing-individual-members initialization.
@_transparent public func FloatQuaternionToGLK(_ structValue:FloatQuaternion) -> GLKQuaternion {
	return GLKQuaternionMake(structValue.ix, structValue.iy, structValue.iz, structValue.r)
}
/// Converts an `FloatQuaternion` struct from `GLKQuaternion` struct using passing-individual-members initialization.
@_transparent public func FloatQuaternionFromGLK(_ glkValue:GLKQuaternion) -> FloatQuaternion {
	return FloatQuaternion(ix: glkValue.x, iy: glkValue.y, iz: glkValue.z, r: glkValue.w)
}
