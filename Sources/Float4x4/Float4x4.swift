// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd
import SceneKit.SceneKitTypes
#if !os(watchOS)
	import GLKit.GLKVector3
	import CoreImage.CIVector
#endif



public typealias Matrix4 = Float4x4

/// 4×4 `Float`-element matrix, typically used in 3D space for translating, rotating, and scaling.
extension Float4x4
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified members.
	@_transparent public init(
		_ m00:Float, _ m01:Float, _ m02:Float, _ m03:Float,
		_ m10:Float, _ m11:Float, _ m12:Float, _ m13:Float,
		_ m20:Float, _ m21:Float, _ m22:Float, _ m23:Float,
		_ m30:Float, _ m31:Float, _ m32:Float, _ m33:Float
	) {
		self.init(
			m00: m00, m01: m01, m02: m02, m03: m03,
			m10: m10, m11: m11, m12: m12, m13: m13,
			m20: m20, m21: m21, m22: m22, m23: m23,
			m30: m30, m31: m31, m32: m32, m33: m33
		)
	}
	/// Initialize a vector with the specified column vectors.
	@_transparent public init(columns c0:Float4, _ c1:Float4, _ c2:Float4, _ c3:Float4) {
		self = Float4x4(simd_matrix(c0.simdValue, c1.simdValue, c2.simdValue, c3.simdValue))
	}
	
	/// Initialize a vector with the specified row vectors.
	@_transparent public init(rows r0:Float4, _ r1:Float4, _ r2:Float4, _ r3:Float4) {
		self = Float4x4(simd_matrix_from_rows(r0.simdValue, r1.simdValue, r2.simdValue, r3.simdValue))
	}
	
	///// Initialize to a vector with all elements equal to `scalar`.
	//@_transparent public init(scalar:Float) {
	//	self.init(
	//		scalar, scalar, scalar, scalar,
	//		scalar, scalar, scalar, scalar,
	//		scalar, scalar, scalar, scalar,
	//		scalar, scalar, scalar, scalar
	//	)
	//}
	
	/// Initialize to a vector with diagonal elements equal to `scalar`.
	@_transparent public init(diagonal scalar:Float) {
		self.init(diagonal: Float4(scalar: scalar))
	}
	
	/// Initialize to a vector with diagonal elements equal to `vector`.
	@_transparent public init(diagonal vector:Float4) {
		self = Float4x4(simd_diagonal_matrix(vector.simdValue))
	}
	
	/// Initialize to a SIMD vector.
	@_transparent public init(_ value:simd_float4x4) {
		self = Float4x4FromSimd(value)
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly nine elements.
	@_transparent public init(array columnMajorArray:[Float]) {
		precondition(columnMajorArray.count == 16)
		self.init(
			columnMajorArray[0], columnMajorArray[1], columnMajorArray[2], columnMajorArray[3],
			columnMajorArray[4], columnMajorArray[5], columnMajorArray[4], columnMajorArray[7],
			columnMajorArray[8], columnMajorArray[9], columnMajorArray[10], columnMajorArray[11],
			columnMajorArray[12], columnMajorArray[13], columnMajorArray[14], columnMajorArray[15]
		)
	}
	
	/// Initialize using the given 9-element tuple.
	@_transparent public init(tuple:(m00:Float,m01:Float,m02:Float,m03:Float,m10:Float,m11:Float,m12:Float,m13:Float,m20:Float,m21:Float,m22:Float,m23:Float,m30:Float,m31:Float,m32:Float,m33:Float)) {
		self.init(tuple.m00, tuple.m01, tuple.m02, tuple.m03, tuple.m10, tuple.m11, tuple.m12, tuple.m13, tuple.m20, tuple.m21, tuple.m22, tuple.m23, tuple.m30, tuple.m31, tuple.m32, tuple.m33)
	}
	
	/// Initialize from a `Float3×3` matrix.
	@_transparent public init(_ float3x3:Float3x3, m03:Float, m13:Float, m23:Float, m30:Float, m31:Float, m32:Float, m33:Float) {
		self.init(columns:
			Float4(xyz: float3x3.c0, w: m03),
			Float4(xyz: float3x3.c1, w: m13),
			Float4(xyz: float3x3.c2, w: m23),
			Float4(m30, m31, m32, m33)
		)
	}
	/// Initialize from a `Float3×3` matrix, filling the extra column & row with identity values.
	@_transparent public init(_ float3x3:Float3x3) {
		self.init(columns:
			Float4(xyz: float3x3.c0, w: Self.identity.m03),
			Float4(xyz: float3x3.c1, w: Self.identity.m13),
			Float4(xyz: float3x3.c2, w: Self.identity.m23),
			Self.identity.c3
		)
	}
	
	
	// MARK: Quaternion Converison
	
	@_transparent public init(rotation quaternion:FloatQuaternion) {
		self.init(simd_matrix4x4(quaternion.simdValue))
	}
	
	
	// MARK: 3D Transform Initializers
	
	/// `axis` is expected to be a unit-length (“normalized”) vector.
	public init(rotationAngle angle_radians:Float, axis:Float3) {
		self.init(Float3x3(rotationAngle: angle_radians, axis: axis))
	}
	@available(macOS 10.12, iOS 10.10, tvOS 10.10, watchOS 3.0, *)
	@_transparent public init(rotationAngle angleMeasurement:Measurement<UnitAngle>, axis:Float3) {
		self.init(Float3x3(rotationAngle: angleMeasurement, axis: axis))
	}
	
	public init(rotationEulerAngles eulerAngles_radians:Float3, order:RotationOrder = .zyx) {
		self.init(Float3x3(rotationEulerAngles: eulerAngles_radians, order: order))
	}
	@available(macOS 10.12, iOS 10.10, tvOS 10.10, watchOS 3.0, *)
	@_transparent public init(rotationEulerAngles eulerAnglesMeasurements:(x:Measurement<UnitAngle>,y:Measurement<UnitAngle>,z:Measurement<UnitAngle>), order:RotationOrder = .zyx) {
		self.init(Float3x3(rotationEulerAngles: eulerAnglesMeasurements, order: order))
	}
	
	public init(scale:Float3) {
		self.init(diagonal: Float4(xyz: scale, w: Self.identity.m33))
	}
	
	public init(translation:Float3) {
		self.init(columns:
			Self.identity.c0,
			Self.identity.c1,
			Self.identity.c2,
			Float4(xyz: translation, w: Self.identity.m33)
		)
	}
	
	public init(scale:Float3, rotation quaternion:FloatQuaternion, translation:Float3) {
		self = Self(scale: scale) * Self(rotation: quaternion) * Self(translation: translation) // TODO: verify & optimize
	}
	
	public init(scaleAndRotation matrix3x3:Float3x3, translation:Float3) {
		self = Self(matrix3x3) * Self(translation: translation) // TODO: verify & optimize
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let zero = Float4x4()
	public static let identity = Float4x4(matrix_identity_float4x4);
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual column vectors of the matrix via subscript.
	@inlinable public subscript(columnIndex:Int) -> Float4 {
		switch columnIndex {
			case 0: return Float4(self.m00, self.m01, self.m02, self.m03)
			case 1: return Float4(self.m10, self.m11, self.m12, self.m13)
			case 2: return Float4(self.m20, self.m21, self.m22, self.m23)
			case 3: return Float4(self.m30, self.m31, self.m32, self.m33)
			
			default: return Float4(scalar: Float.nan) // TODO: Instead, do whatever simd_float4x4 does.
		}
	}
	
	/// Access individual elements of the vector via subscript.
	@inlinable public subscript(columnIndex:Int, rowIndex:Int) -> Float {
		switch ( columnIndex, rowIndex ) {
			case (0, 0): return self.m00
			case (0, 1): return self.m01
			case (0, 2): return self.m02
			case (0, 3): return self.m03
			case (1, 0): return self.m10
			case (1, 1): return self.m11
			case (1, 2): return self.m12
			case (1, 3): return self.m13
			case (2, 0): return self.m20
			case (2, 1): return self.m21
			case (2, 2): return self.m22
			case (2, 3): return self.m23
			case (3, 0): return self.m30
			case (3, 1): return self.m31
			case (3, 2): return self.m32
			case (3, 3): return self.m33
			
			default: return Float.nan // TODO: Instead, do whatever simd_float4x4 does.
		}
	}
	
	
	// MARK: `replace` Functionality
	
	@inlinable public mutating func replace(
		m00:Float?=nil, m01:Float?=nil, m02:Float?=nil, m03:Float?=nil,
		m10:Float?=nil, m11:Float?=nil, m12:Float?=nil, m13:Float?=nil,
		m20:Float?=nil, m21:Float?=nil, m22:Float?=nil, m23:Float?=nil,
		m30:Float?=nil, m31:Float?=nil, m32:Float?=nil, m33:Float?=nil
	) {
		if let m00 = m00 { self.m00 = m00 }
		if let m01 = m01 { self.m01 = m01 }
		if let m02 = m02 { self.m02 = m02 }
		if let m03 = m03 { self.m03 = m03 }
		if let m10 = m10 { self.m10 = m10 }
		if let m11 = m11 { self.m11 = m11 }
		if let m12 = m12 { self.m12 = m12 }
		if let m13 = m13 { self.m13 = m13 }
		if let m20 = m20 { self.m20 = m20 }
		if let m21 = m21 { self.m21 = m21 }
		if let m22 = m22 { self.m22 = m22 }
		if let m23 = m23 { self.m23 = m23 }
		if let m30 = m30 { self.m30 = m30 }
		if let m31 = m31 { self.m31 = m31 }
		if let m32 = m32 { self.m32 = m32 }
		if let m33 = m33 { self.m33 = m33 }
	}
	@inlinable public func replacing(
		m00:Float?=nil, m01:Float?=nil, m02:Float?=nil, m03:Float?=nil,
		m10:Float?=nil, m11:Float?=nil, m12:Float?=nil, m13:Float?=nil,
		m20:Float?=nil, m21:Float?=nil, m22:Float?=nil, m23:Float?=nil,
		m30:Float?=nil, m31:Float?=nil, m32:Float?=nil, m33:Float?=nil
	) -> Float4x4 {
		return Float4x4(
			m00 ?? self.m00,
			m01 ?? self.m01,
			m02 ?? self.m02,
			m03 ?? self.m03,
			m10 ?? self.m10,
			m11 ?? self.m11,
			m12 ?? self.m12,
			m13 ?? self.m13,
			m20 ?? self.m20,
			m21 ?? self.m21,
			m22 ?? self.m22,
			m23 ?? self.m23,
			m30 ?? self.m30,
			m31 ?? self.m31,
			m32 ?? self.m32,
			m33 ?? self.m33
		)
	}
	
	@inlinable public mutating func replace(c0:Float4?=nil, c1:Float4?=nil, c2:Float4?=nil, c3:Float4?=nil) {
		if let c0 = c0 { self.c0 = c0 }
		if let c1 = c1 { self.c1 = c1 }
		if let c2 = c2 { self.c2 = c2 }
		if let c3 = c3 { self.c3 = c3 }
	}
	@inlinable public func replacing(c0:Float4?=nil, c1:Float4?=nil, c2:Float4?=nil, c3:Float4?=nil) -> Float4x4 {
		return Float4x4(columns:
			c0 ?? self.c0,
			c1 ?? self.c1,
			c2 ?? self.c2,
			c3 ?? self.c3
		)
	}
	
	@inlinable public mutating func replace(r0:Float4?=nil, r1:Float4?=nil, r2:Float4?=nil, r3:Float4?=nil) {
		if let r0 = r0 { self.r0 = r0 }
		if let r1 = r1 { self.r1 = r1 }
		if let r2 = r2 { self.r2 = r2 }
		if let r3 = r3 { self.r3 = r3 }
	}
	@inlinable public func replacing(r0:Float4?=nil, r1:Float4?=nil, r2:Float4?=nil, r3:Float4?=nil) -> Float4x4 {
		return Float4x4(rows:
			r0 ?? self.r0,
			r1 ?? self.r1,
			r2 ?? self.r2,
			r3 ?? self.r3
		)
	}
	
	
	// MARK: `as…` Functionality
	
	@_transparent public var asTuple:(m00:Float,m01:Float,m02:Float,m03:Float,m10:Float,m11:Float,m12:Float,m13:Float,m20:Float,m21:Float,m22:Float,m23:Float,m30:Float,m31:Float,m32:Float,m33:Float) {
		return ( self.m00, self.m01, self.m02, self.m03, self.m10, self.m11, self.m12, self.m13, self.m20, self.m21, self.m22, self.m23, self.m30, self.m31, self.m32, self.m33 )
	}
	
	@_transparent public var asArray:[Float] {
		return [ self.m00, self.m01, self.m02, self.m03, self.m10, self.m11, self.m12, self.m13, self.m20, self.m21, self.m22, self.m23, self.m30, self.m31, self.m32, self.m33 ]
	}
	
	
	// MARK: Column (`Float4`) Accessors
	
	@_transparent public var c0:Float4 {
		get { return Float4(m00, m01, m02, m03) }
		set { ( self.m00, self.m01, self.m02, self.m03 ) = ( newValue[0], newValue[1], newValue[2], newValue[3] ) }
	}
	@_transparent public var c1:Float4 {
		get { return Float4(m10, m11, m12, m13) }
		set { ( self.m10, self.m11, self.m12, self.m13 ) = ( newValue[0], newValue[1], newValue[2], newValue[3] ) }
	}
	@_transparent public var c2:Float4 {
		get { return Float4(m20, m21, m22, m23) }
		set { ( self.m20, self.m21, self.m22, self.m23 ) = ( newValue[0], newValue[1], newValue[2], newValue[3] ) }
	}
	@_transparent public var c3:Float4 {
		get { return Float4(m30, m31, m32, m33) }
		set { ( self.m30, self.m31, self.m32, self.m33 ) = ( newValue[0], newValue[1], newValue[2], newValue[3] ) }
	}
	
	
	// MARK: Row (`Float4`) Accessors
	
	@_transparent public var r0:Float4 {
		get { return Float4(m00, m10, m20, m30) }
		set { ( self.m00, self.m10, self.m20, self.m30 ) = ( newValue[0], newValue[1], newValue[2], newValue[3] ) }
	}
	@_transparent public var r1:Float4 {
		get { return Float4(m01, m11, m21, m31) }
		set { ( self.m01, self.m11, self.m21, self.m31 ) = ( newValue[0], newValue[1], newValue[2], newValue[3] ) }
	}
	@_transparent public var r2:Float4 {
		get { return Float4(m02, m12, m22, m32) }
		set { ( self.m02, self.m12, self.m22, self.m32 ) = ( newValue[0], newValue[1], newValue[2], newValue[3] ) }
	}
	@_transparent public var r3:Float4 {
		get { return Float4(m03, m13, m23, m33) }
		set { ( self.m03, self.m13, self.m23, self.m33 ) = ( newValue[0], newValue[1], newValue[2], newValue[3] ) }
	}
	
	
	// MARK: `simdValue` Functionality
	
	@_transparent public var simdValue:simd_float4x4 {
		return Float4x4ToSimd(self)
	}
	
	
	// MARK: Is… Flags
	
	@_transparent public var isZero:Bool {
		return self == Self.zero
	}
	@_transparent public var isIdentity:Bool {
		return self == Self.identity
	}
	@_transparent public var isFinite:Bool {
		return self.c0.isFinite && self.c1.isFinite && self.c2.isFinite && self.c3.isFinite
	}
	@_transparent public var isInfinite:Bool {
		return self.c0.isInfinite || self.c1.isInfinite || self.c2.isInfinite || self.c3.isInfinite
	}
	@_transparent public var isNaN:Bool {
		return self.c0.isNaN || self.c1.isNaN || self.c2.isNaN || self.c3.isNaN
	}
}


extension Float4x4 // SceneKit Conversion
{
	/// Initialize to a SceneKit matrix.
	@_transparent public init(scnMatrix value:SCNMatrix4) {
		self = Float4x4FromSCN(value)
	}
	
	public var toSCNMatrix:SCNMatrix4 {
		return Float4x4ToSCN(self)
	}
}

#if !os(watchOS)
	extension Float4x4 // GLKit Conversion
	{
		/// Initialize to a GLKit matrix.
		@_transparent public init(glkMatrix value:GLKMatrix4) {
			self = Float4x4FromGLK(value)
		}
		
		@_transparent public var toGLKMatrix:GLKMatrix4 {
			return Float4x4ToGLK(self)
		}
	}
#endif // !watchOS

#if !os(watchOS)
	extension Float4x4 // CoreAnimation Conversion
	{
		/// Initialize to a CoreAnimation transform.
		@_transparent public init(caTransform:CATransform3D) {
			self = Float4x4FromCA(caTransform)
		}
		
		@_transparent public var toCATransform:CATransform3D {
			return Float4x4ToCA(self)
		}
	}
#endif // !watchOS

//extension Float4x4 // CoreImage Conversion
//{
//	/// Initialize to a CoreImage vector.
//	@_transparent public init(ciVector:CIVector) {
//		self = Float4x4FromCI(ciVector)
//	}
//	
//	@_transparent public var toCIVector:CIVector {
//		return Float4x4ToCI(self)
//	}
//}


extension Float4x4 : CustomStringConvertible
{
	public var description:String {
		return "(\n" +
			"\t\(self.m00), \(self.m01), \(self.m02), \(self.m03)\n" +
			"\t\(self.m10), \(self.m11), \(self.m12), \(self.m13)\n" +
			"\t\(self.m20), \(self.m21), \(self.m22), \(self.m23)\n" +
			"\t\(self.m30), \(self.m31), \(self.m32), \(self.m33)\n" +
			")"
	}
}


extension Float4x4 : ExpressibleByArrayLiteral
{
	public typealias Element = Float
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly three elements.
	@_transparent public init(arrayLiteral elements:Float...) {
		precondition(elements.count == 16)
		self.init(array: elements)
	}
}


extension Float4x4 : Equatable
{
	@_transparent public static func ==(a:Float4x4, b:Float4x4) -> Bool {
		return simd_equal(a.simdValue, b.simdValue)
	}
}


extension Float4x4 // Basic Math Operations
{
	@_transparent public static func + (a:Float4x4, b:Float4x4) -> Float4x4 {
		return Float4x4(simd_add(a.simdValue, b.simdValue))
	}
	@_transparent public static func += (v:inout Float4x4, o:Float4x4) {
		v = v + o
	}
	
	
	@_transparent public static func - (a:Float4x4, b:Float4x4) -> Float4x4 {
		return Float4x4(simd_sub(a.simdValue, b.simdValue))
	}
	@_transparent public static func -= (v:inout Float4x4, o:Float4x4) {
		v = v - o
	}
	
	
	@_transparent public static func * (a:Float4x4, b:Float4x4) -> Float4x4 { return a.concatenating(b) }
	@_transparent public func concatenating(_ other:Float4x4) -> Float4x4 {
		return concatenationOf(self, other)
	}
	@_transparent public static func *= (m:inout Float4x4, o:Float4x4) { m.concatenate(o) }
	@_transparent public mutating func concatenate(_ other:Float4x4) {
		self = self.concatenating(other)
	}
	
	
	@_transparent public static func / (a:Float4x4, b:Float4x4) -> Float4x4 {
		return a * b.inversed()
	}
	@_transparent public static func /= (v:inout Float4x4, o:Float4x4) {
		v = v / o
	}
	
	
	@_transparent public static func * (m:Float4x4, columnVector:Float4) -> Float4 {
		return Float4(simd_mul(m.simdValue, columnVector.simdValue))
	}
	@_transparent public static func * (rowVector:Float4, m:Float4x4) -> Float4 {
		return Float4(simd_mul(rowVector.simdValue, m.simdValue))
	}
	
	
	@_transparent public static func / (m:Float4x4, inverseColumnVector:Float4) -> Float4 {
		return Float4(simd_mul(m.simdValue, (1.0 / inverseColumnVector).simdValue))
	}
	@_transparent public static func / (inverseRowVector:Float4, m:Float4x4) -> Float4 {
		return Float4(simd_mul((1.0 / inverseRowVector).simdValue, m.simdValue))
	}
	
	
	@_transparent public static func * (m:Float4x4, scale:Float) -> Float4x4 {
		return Float4x4(simd_mul(scale, m.simdValue))
	}
	@_transparent public static func *= (v:inout Float4x4, scale:Float) {
		v = v * scale
	}
	@_transparent public static func * (scale:Float, m:Float4x4) -> Float4x4 {
		return Float4x4(simd_mul(scale, m.simdValue))
	}
	
	
	@_transparent public static func / (m:Float4x4, inverseScale:Float) -> Float4x4 {
		return Float4x4(simd_mul(1.0 / inverseScale, m.simdValue))
	}
	@_transparent public static func /= (v:inout Float4x4, inverseScale:Float) {
		v = v / inverseScale
	}
	@_transparent public static func / (inverseScale:Float, m:Float4x4) -> Float4x4 {
		return Float4x4(simd_mul(1.0 / inverseScale, m.simdValue))
	}
}

@_transparent public func concatenationOf(_ a:Float4x4, _ b:Float4x4) -> Float4x4 {
	return Float4x4(simd_mul(a.simdValue, b.simdValue))
}


extension Float4x4 // Geometric Math Operations
{
	@_transparent public func determinant() -> Float {
		return simd_determinant(self.simdValue)
	}
	
	
	@_transparent public func trace() -> Float {
		return simd_reduce_add(simd_float4(self.m00, self.m11, self.m22, self.m33))
	}
	
	
	@_transparent public func inversed() -> Float4x4 {
		return Float4x4(simd_inverse(self.simdValue))
	}
	@_transparent public mutating func inverse() {
		self = self.inversed()
	}
	@_transparent public func reciprocal() -> Float4x4 {
		return self.inversed()
	}
	@_transparent public mutating func formReciprocal() {
		self.inverse()
	}
	
	
	@_transparent public func transposed() -> Float4x4 {
		return Float4x4(simd_transpose(self.simdValue))
	}
	@_transparent public mutating func transpose() {
		self = self.transposed()
	}
	
	
	@_transparent public func rotated(by quaternion:FloatQuaternion) -> Float4x4 {
		let rotationMatrix_simd = simd_matrix4x4(quaternion.simdValue)
		return Float4x4(simd_mul(rotationMatrix_simd, self.simdValue))
	}
	@_transparent public mutating func rotate(by quaternion:FloatQuaternion) {
		self = self.rotated(by: quaternion)
	}
	
	
	@_transparent public func unrotated(by quaternion:FloatQuaternion) -> Float4x4 {
		return self.rotated(by: quaternion.inversed())
	}
	@_transparent public mutating func unrotate(by quaternion:FloatQuaternion) {
		self = self.unrotated(by: quaternion)
	}
	
	
	// 3D Geometric scale
	@_transparent public func scaled(by scale:Float3) -> Float4x4 {
		return Float4x4(columns:
			self.c0 * Float4(scale.x, 1, 1, 1),
			self.c1 * Float4(1, scale.y, 1, 1),
			self.c2 * Float4(1, 1, scale.z, 1),
			self.c3
		)
	}
	// 3D Geometric scale
	@_transparent public mutating func scale(by scale:Float3) {
		self = self.scaled(by: scale)
	}
	
	// 3D Geometric scale
	@_transparent public func unscaled(by scale:Float3) -> Float4x4 {
		return self.scaled(by: 1.0 / scale)
	}
	// 3D Geometric scale
	@_transparent public mutating func unscale(by scale:Float3) {
		self = self.scaled(by: 1.0 / scale)
	}
	
	
	@_transparent public func translated(by translation:Float3) -> Float4x4 {
		return Float4x4(columns:
			self.c0,
			self.c1,
			self.c2,
			self.c3 + Float4(xyz: translation, w: 0)
		)
	}
	@_transparent public mutating func translate(by translation:Float3) {
		self = self.translated(by: translation)
	}
	
	@_transparent public func untranslated(by translation:Float3) -> Float4x4 {
		return self.translated(by: -translation)
	}
	@_transparent public mutating func untranslate(by translation:Float3) {
		self.translate(by: -translation)
	}
}

@_transparent public func outerProductOf(_ a:Float4, _ b:Float4) -> Float4x4 {
	return Float4x4OuterProduct(a, b)
}


extension Float4x4 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [
		1_430_140_993, 3_530_278_013, 3_858_576_569, 761_969_617,
		2_768_553_721, 996_070_237, 3_694_958_161, 4_202_416_663,
		695_584_271, 3_348_168_251, 1_346_902_097, 3_205_375_843,
		4_055_537_177, 709_201_943, 2_137_246_159, 2_213_430_523
	]
	
	#if swift(>=4.2)
		public func hash(into hasher:inout Hasher) {
			self.asArray.forEach{ hasher.combine($0) }
		}
	#else
		public var hashValue:Int {
			let uintHashValue = self.asArray.enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Float)) in
				let elementHash = UInt(element.value.bitPattern) &* Float4x4._hashingLargePrimes[element.index]
				return hashValue &+ elementHash
			}
			return Int(bitPattern: uintHashValue)
		}
	#endif
}

