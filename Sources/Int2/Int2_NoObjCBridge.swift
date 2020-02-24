// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import simd.vector_types



// MARK: Struct Definition

public struct Int2
{
	public var x:Int32
	public var y:Int32
	
	public init() {
		self.x = Int32()
		self.y = Int32()
	}
	
	public init(x:Int32, y:Int32) {
		self.x = x
		self.y = y
	}
}



// MARK: SIMD Conversion

/// Converts an `Int2` struct to `simd_int2` vector using passing-individual-members initialization.
@_transparent public func Int2ToSimd(_ structValue:Int2) -> simd_int2 {
	return simd_int2(structValue.x, structValue.y)
}
/// Converts an `Int2` struct from `simd_int2` vector using passing-individual-members initialization.
@_transparent public func Int2FromSimd(_ simdValue:simd_int2) -> Int2 {
	return Int2(x: simdValue.x, y: simdValue.y)
}



// MARK: SIMD-Accelerated Operator Access

@_transparent public func Int2Add(_ a:Int2, _ b:Int2) -> Int2 {
	return Int2(Int2ToSimd(a) &+ Int2ToSimd(b))
}
@_transparent public func Int2Subtract(_ a:Int2, _ b:Int2) -> Int2 {
	return Int2FromSimd(Int2ToSimd(a) &- Int2ToSimd(b))
}
@_transparent public func Int2Negate(_ v:Int2) -> Int2 {
	return Int2FromSimd(0 &- Int2ToSimd(v))
}
@_transparent public func Int2Multiply(_ a:Int2, _ b:Int2) -> Int2 {
	return Int2FromSimd(Int2ToSimd(a) &* Int2ToSimd(b))
}
@_transparent public func Int2Divide(_ a:Int2, _ b:Int2) -> Int2 {
	return Int2FromSimd(Int2ToSimd(a) / Int2ToSimd(b))
}
@_transparent public func Int2Modulus(_ a:Int2, _ b:Int2) -> Int2 {
	return Int2FromSimd(Int2ToSimd(a) % Int2ToSimd(b))
}

@_transparent public func Int2Equal(_ a:Int2, _ b:Int2) -> Bool {
	return Int2ToSimd(a) == Int2ToSimd(b)
}
@_transparent public func Int2Inequal(_ a:Int2, _ b:Int2) -> Bool {
	return Int2ToSimd(a) != Int2ToSimd(b)
}
@_alwaysEmitIntoClient public func Int2LessThan(_ a:Int2, _ b:Int2) -> Bool {
	return a.simdValue.indices.reduce(into: true) { $0 = $0 || (a[$1] < b[$1]) }
}
@_alwaysEmitIntoClient public func Int2LessThanOrEqual(_ a:Int2, _ b:Int2) -> Bool {
	return a.simdValue.indices.reduce(into: true) { $0 = $0 || (a[$1] <= b[$1]) }
}
@_alwaysEmitIntoClient public func Int2GreaterThan(_ a:Int2, _ b:Int2) -> Bool {
	return a.simdValue.indices.reduce(into: true) { $0 = $0 || (a[$1] > b[$1]) }
}
@_alwaysEmitIntoClient public func Int2GreaterThanOrEqual(_ a:Int2, _ b:Int2) -> Bool {
	return a.simdValue.indices.reduce(into: true) { $0 = $0 || (a[$1] >= b[$1]) }
}
