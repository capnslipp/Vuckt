// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import simd.vector_types
import CoreImage.CIVector
import CoreGraphics.CGGeometry



// MARK: Struct Definition

public struct Float2
{
	public var x:simd_float1
	public var y:simd_float1
	
	public init() {
		self.x = simd_float1()
		self.y = simd_float1()
	}
	
	public init(x:simd_float1, y:simd_float1) {
		self.x = x
		self.y = y
	}
}



// MARK: SIMD Conversion

/// Converts a `Float2` struct to `simd_float2` vector using passing-individual-members initialization.
public func Float2ToSimd(_ structValue:Float2) -> simd_float2 {
	return simd_float2(structValue.x, structValue.y)
}
/// Converts a `Float2` struct from `simd_float2` vector using passing-individual-members initialization.
public func Float2FromSimd(_ simdValue:simd_float2) -> Float2 {
	return Float2(x: simdValue.x, y: simdValue.y)
}



// MARK: CoreImage Conversion

/// Converts an `Float2` struct to `CIVector` class using passing-individual-members initialization.
public func Float2ToCI(_ structValue:Float2) -> CIVector {
	return CIVector(x: CGFloat(structValue.x), y: CGFloat(structValue.y))
}
/// Converts an `Float2` struct from `CIVector` class using passing-individual-members initialization.
public func Float2FromCI(_ ciVector:CIVector) -> Float2 {
	assert(ciVector.count == 2)
	return Float2(x: simd_float1(ciVector.x), y: simd_float1(ciVector.y))
}



// MARK: CoreGraphics Conversion

/// Converts an `Float2` struct to `CGVector` struct using passing-individual-members initialization.
public func Float2ToCGVector(_ structValue:Float2) -> CGVector {
	return CGVector(dx: CGFloat(structValue.x), dy: CGFloat(structValue.y))
}
/// Converts an `Float2` struct from `CGVector` struct using passing-individual-members initialization.
public func Float2FromCGVector(_ cgVectorValue:CGVector) -> Float2 {
	return Float2(x: simd_float1(cgVectorValue.dx), y: simd_float1(cgVectorValue.dy))
}

/// Converts an `Float2` struct to `CGPoint` struct using passing-individual-members initialization.
public func Float2ToCGPoint(_ structValue:Float2) -> CGPoint {
	return CGPoint(x: CGFloat(structValue.x), y: CGFloat(structValue.y))
}
/// Converts an `Float2` struct from `CGPoint` struct using passing-individual-members initialization.
public func Float2FromCGPoint(_ cgPointValue:CGPoint) -> Float2 {
	return Float2(x: simd_float1(cgPointValue.x), y: simd_float1(cgPointValue.y))
}

/// Converts an `Float2` struct to `CGSize` struct using passing-individual-members initialization.
public func Float2ToCGSize(_ structValue:Float2) -> CGSize {
	return CGSize(width: CGFloat(structValue.x), height: CGFloat(structValue.y))
}
/// Converts an `Float2` struct from `CGSize` struct using passing-individual-members initialization.
public func Float2FromCGSize(_ cgSizeValue:CGSize) -> Float2 {
	return Float2(x: simd_float1(cgSizeValue.width), y: simd_float1(cgSizeValue.height))
}
