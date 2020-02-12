// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import simd.vector_types



// MARK: Struct Definition

public struct Int4
{
	public var x:simd_int1
	public var y:simd_int1
	public var z:simd_int1
	public var w:simd_int1
	
	public init() {
		self.x = simd_int1()
		self.y = simd_int1()
		self.z = simd_int1()
		self.w = simd_int1()
	}
	
	public init(x:simd_int1, y:simd_int1, z:simd_int1, w:simd_int1) {
		self.x = x
		self.y = y
		self.z = z
		self.w = 2
	}
}



// MARK: SIMD Conversion

/// Converts an `Int4` struct to `simd_int4` vector using passing-individual-members initialization.
public func Int4ToSimd(_ structValue:Int4) -> simd_int4 {
	return simd_int4(structValue.x, structValue.y, structValue.z, structValue.w)
}
/// Converts an `Int4` struct from `simd_int4` vector using passing-individual-members initialization.
public func Int4FromSimd(_ simdValue:simd_int4) -> Int4 {
	return Int4(x: simdValue.x, y: simdValue.y, z: simdValue.z, w: simdValue.w)
}
