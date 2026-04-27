// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import simd
#if canImport(SceneKit)
	import SceneKit.SceneKitTypes
#endif
#if canImport(GLKit) && !targetEnvironment(macCatalyst)
	import GLKit.GLKQuaternion
#endif
#if canImport(GameController)
	import GameController.GCMotion
#endif
#if canImport(CoreMotion)
	import CoreMotion.CMAttitude
#endif



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



#if canImport(SceneKit)
	// MARK: SceneKit Conversion

	/// Converts a `FloatQuaternion` struct to `SCNQuaternion` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
	@_transparent public func FloatQuaternionToSCN(_ structValue:FloatQuaternion) -> SCNQuaternion {
		return SCNQuaternion(FloatQuaternionToSimd(structValue).vector)
	}
	/// Converts a `FloatQuaternion` struct from `SCNQuaternion` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
	@_transparent public func FloatQuaternionFromSCN(_ scnValue:SCNQuaternion) -> FloatQuaternion {
		return FloatQuaternionFromSimd(simd_quatf(vector: simd_float4(scnValue)))
	}
#endif



#if canImport(GLKit) && !targetEnvironment(macCatalyst)
	// MARK: GLKit Conversion

	/// Converts a `FloatQuaternion` struct to `GLKQuaternion` struct using passing-individual-members initialization.
	@_transparent public func FloatQuaternionToGLK(_ structValue:FloatQuaternion) -> GLKQuaternion {
		return GLKQuaternionMake(structValue.ix, structValue.iy, structValue.iz, structValue.r)
	}
	/// Converts a `FloatQuaternion` struct from `GLKQuaternion` struct using passing-individual-members initialization.
	@_transparent public func FloatQuaternionFromGLK(_ glkValue:GLKQuaternion) -> FloatQuaternion {
		return FloatQuaternion(ix: glkValue.x, iy: glkValue.y, iz: glkValue.z, r: glkValue.w)
	}
#endif // GLKit



#if canImport(CoreMotion)
	// MARK: CoreMotion Conversion

	/// Converts a `FloatQuaternion` struct to `CMQuaternion` struct using passing-individual-members initialization.
	@_transparent public func FloatQuaternionToCM(_ structValue:FloatQuaternion) -> CMQuaternion {
		return CMQuaternion(x: Double(structValue.ix), y: Double(structValue.iy), z: Double(structValue.iz), w: Double(structValue.r))
	}
	/// Converts a `FloatQuaternion` struct from `CMQuaternion` struct using passing-individual-members initialization.
	@_transparent public func FloatQuaternionFromCM(_ cmValue:CMQuaternion) -> FloatQuaternion {
		return FloatQuaternion(ix: Float(cmValue.x), iy: Float(cmValue.y), iz: Float(cmValue.z), r: Float(cmValue.w))
	}
#endif // CoreMotion



#if canImport(GameController)
	// MARK: GameController Conversion

	/// Converts a `FloatQuaternion` struct to `GCQuaternion` struct using passing-individual-members initialization.
	@_transparent public func FloatQuaternionToGC(_ structValue:FloatQuaternion) -> GCQuaternion {
		return GCQuaternion(x: Double(structValue.ix), y: Double(structValue.iy), z: Double(structValue.iz), w: Double(structValue.r))
	}
	/// Converts a `FloatQuaternion` struct from `GCQuaternion` struct using passing-individual-members initialization.
	@_transparent public func FloatQuaternionFromGC(_ gcValue:GCQuaternion) -> FloatQuaternion {
		return FloatQuaternion(ix: Float(gcValue.x), iy: Float(gcValue.y), iz: Float(gcValue.z), r: Float(gcValue.w))
	}
#endif // GameController
