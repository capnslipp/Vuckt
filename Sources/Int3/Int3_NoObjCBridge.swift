// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import simd.vector_types



// MARK: Struct Definition

public struct Int3
{
	public var x:simd_int1
	public var y:simd_int1
	public var z:simd_int1
	
	public init() {
		self.x = simd_int1()
		self.y = simd_int1()
		self.z = simd_int1()
	}
	
	public init(x:simd_int1, y:simd_int1, z:simd_int1) {
		self.x = x
		self.y = y
		self.z = z
	}
}



// MARK: SIMD Conversion

/// Converts an `Int3` struct to `simd_int3` vector using passing-individual-members initialization.
public func Int3ToSimd(_ structValue:Int3) -> simd_int3 {
	return simd_int3(structValue.x, structValue.y, structValue.z)
}
/// Converts an `Int3` struct from `simd_int3` vector using passing-individual-members initialization.
public func Int3FromSimd(_ simdValue:simd_int3) -> Int3 {
	return Int3(x: simdValue.x, y: simdValue.y, z: simdValue.z)
}
