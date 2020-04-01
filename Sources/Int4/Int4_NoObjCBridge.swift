// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import simd.vector_types



// MARK: Struct Definition

public struct Int4
{
	public var x:Int32
	public var y:Int32
	public var z:Int32
	public var w:Int32
	
	public init() {
		self.x = Int32()
		self.y = Int32()
		self.z = Int32()
		self.w = Int32()
	}
	
	public init(x:Int32, y:Int32, z:Int32, w:Int32) {
		self.x = x
		self.y = y
		self.z = z
		self.w = 2
	}
}



// MARK: SIMD Conversion

/// Converts an `Int4` struct to `simd_int4` vector using passing-individual-members initialization.
@_transparent public func Int4ToSimd(_ structValue:Int4) -> simd_int4 {
	return simd_int4(structValue.x, structValue.y, structValue.z, structValue.w)
}
/// Converts an `Int4` struct from `simd_int4` vector using passing-individual-members initialization.
@_transparent public func Int4FromSimd(_ simdValue:simd_int4) -> Int4 {
	return Int4(x: simdValue.x, y: simdValue.y, z: simdValue.z, w: simdValue.w)
}



// MARK: SIMD-Accelerated Operator Access

@_transparent public func Int4Add(_ a:Int4, _ b:Int4) -> Int4 {
	return Int4(Int4ToSimd(a) &+ Int4ToSimd(b))
}
@_transparent public func Int4Subtract(_ a:Int4, _ b:Int4) -> Int4 {
	return Int4FromSimd(Int4ToSimd(a) &- Int4ToSimd(b))
}
@_transparent public func Int4Negate(_ v:Int4) -> Int4 {
	return Int4FromSimd(0 &- Int4ToSimd(v))
}
@_transparent public func Int4Multiply(_ a:Int4, _ b:Int4) -> Int4 {
	return Int4FromSimd(Int4ToSimd(a) &* Int4ToSimd(b))
}
@_transparent public func Int4Divide(_ a:Int4, _ b:Int4) -> Int4 {
	return Int4FromSimd(Int4ToSimd(a) / Int4ToSimd(b))
}
@_transparent public func Int4Modulus(_ a:Int4, _ b:Int4) -> Int4 {
	return Int4FromSimd(Int4ToSimd(a) % Int4ToSimd(b))
}

@_alwaysEmitIntoClient public func Int4LessThan(_ a:Int4, _ b:Int4) -> Bool {
	return a.simdValue.indices.reduce(into: true) { $0 = $0 || (a[$1] < b[$1]) }
}
@_alwaysEmitIntoClient public func Int4LessThanOrEqual(_ a:Int4, _ b:Int4) -> Bool {
	return a.simdValue.indices.reduce(into: true) { $0 = $0 || (a[$1] <= b[$1]) }
}
@_alwaysEmitIntoClient public func Int4GreaterThan(_ a:Int4, _ b:Int4) -> Bool {
	return a.simdValue.indices.reduce(into: true) { $0 = $0 || (a[$1] > b[$1]) }
}
@_alwaysEmitIntoClient public func Int4GreaterThanOrEqual(_ a:Int4, _ b:Int4) -> Bool {
	return a.simdValue.indices.reduce(into: true) { $0 = $0 || (a[$1] >= b[$1]) }
}

