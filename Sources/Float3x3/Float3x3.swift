// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd
import SceneKit.SceneKitTypes
#if !os(watchOS) && !os(xrOS)
	import GLKit.GLKVector3
#endif
#if !os(watchOS)
	import CoreImage.CIVector
#endif



public typealias Matrix3 = Float3x3

/// 3×3 `Float`-element matrix, typically used in 3D space for rotating and scaling.
extension Float3x3
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified members.
	@_transparent public init(
		_ m00:Float, _ m01:Float, _ m02:Float,
		_ m10:Float, _ m11:Float, _ m12:Float,
		_ m20:Float, _ m21:Float, _ m22:Float
	) {
		self.init(
			m00: m00, m01: m01, m02: m02,
			m10: m10, m11: m11, m12: m12,
			m20: m20, m21: m21, m22: m22
		)
	}
	/// Initialize a vector with the specified column vectors.
	@_transparent public init(columns c0:Float3, _ c1:Float3, _ c2:Float3) {
		self = Float3x3(simd_matrix(c0.simdValue, c1.simdValue, c2.simdValue))
	}
	
	/// Initialize a vector with the specified row vectors.
	@_transparent public init(rows r0:Float3, _ r1:Float3, _ r2:Float3) {
		self = Float3x3(simd_matrix_from_rows(r0.simdValue, r1.simdValue, r2.simdValue))
	}
	
	///// Initialize to a vector with all elements equal to `scalar`.
	//@_transparent public init(scalar:Float) {
	//	self.init(
	//		scalar, scalar, scalar,
	//		scalar, scalar, scalar,
	//		scalar, scalar, scalar
	//	)
	//}
	
	/// Initialize to a vector with diagonal elements equal to `scalar`.
	@_transparent public init(diagonal scalar:Float) {
		self.init(diagonal: Float3(scalar: scalar))
	}
	
	/// Initialize to a vector with diagonal elements equal to `vector`.
	@_transparent public init(diagonal vector:Float3) {
		self = Float3x3(simd_diagonal_matrix(vector.simdValue))
	}
	
	/// Initialize to a SIMD vector.
	@_transparent public init(_ value:simd_float3x3) {
		self = Float3x3FromSimd(value)
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly nine elements.
	@_transparent public init(array columnMajorArray:[Float]) {
		precondition(columnMajorArray.count == 9)
		self.init(
			columnMajorArray[0], columnMajorArray[1], columnMajorArray[2],
			columnMajorArray[3], columnMajorArray[4], columnMajorArray[5],
			columnMajorArray[4], columnMajorArray[7], columnMajorArray[8]
		)
	}
	
	/// Initialize using the given 9-element tuple.
	@_transparent public init(tuple:(m00:Float,m01:Float,m02:Float,m10:Float,m11:Float,m12:Float,m20:Float,m21:Float,m22:Float)) {
		self.init(tuple.m00, tuple.m01, tuple.m02, tuple.m10, tuple.m11, tuple.m12, tuple.m20, tuple.m21, tuple.m22)
	}
	
	
	// MARK: Quaternion Converison
	
	@_transparent public init(rotation quaternion:FloatQuaternion) {
		self.init(simd_matrix3x3(quaternion.simdValue))
	}
	
	@_transparent public var toRotationQuaternion:FloatQuaternion {
		return FloatQuaternion(rotation: self)
	}
	
	
	// MARK: 3D Transform Initializers
	
	/// `axis` is expected to be a unit-length (“normalized”) vector.
	public init(rotationAngle angle_radians:Float, axis:Float3) {
		let (sinOfAngle, cosOfAngle) = ( sin(angle_radians), cos(angle_radians) )

		/* Based on https://en.wikipedia.org/wiki/Rotation_matrix#Rotation_matrix_from_axis_and_angle and https://github.com/g-truc/glm/blob/master/glm/ext/matrix_transform.inl */
		self.init(columns:
			Float3(cosOfAngle, 0, 0) + ((1 - cosOfAngle) * axis.x * axis) + (sinOfAngle * Float3(0, axis.z, -axis.y)),
			Float3(0, cosOfAngle, 0) + ((1 - cosOfAngle) * axis.y * axis) + (sinOfAngle * Float3(-axis.z, 0, axis.x)),
			Float3(0, 0, cosOfAngle) + ((1 - cosOfAngle) * axis.z * axis) + (sinOfAngle * Float3(axis.y, -axis.x, 0))
		)
	}
	@available(macOS 10.12, iOS 10.10, tvOS 10.10, watchOS 3.0, *)
	@_transparent public init(rotationAngle angleMeasurement:Measurement<UnitAngle>, axis:Float3) {
		let angleMeasurement_radians = angleMeasurement.converted(to: .radians)
		self.init(rotationAngle: Float(angleMeasurement_radians.value), axis: axis)
	}
	
	public init(rotationEulerAngles eulerAngles_radians:Float3, order:RotationOrder = .zxy) {
		let sinOfAngles = __tg_sin(eulerAngles_radians.simdValue)
		let cosOfAngles = __tg_cos(eulerAngles_radians.simdValue)
		
		let xRotation = Self(columns:
			Float3(1, 0, 0),
			Float3(0, cosOfAngles.x, sinOfAngles.x),
			Float3(0, -sinOfAngles.x, cosOfAngles.x)
		)
		let yRotation = Self(columns:
			Float3(cosOfAngles.y, 0, -sinOfAngles.y),
			Float3(0, 1, 0),
			Float3(sinOfAngles.y, 0, cosOfAngles.y)
		)
		let zRotation = Self(columns:
			Float3(cosOfAngles.z, sinOfAngles.z, 0),
			Float3(-sinOfAngles.z, cosOfAngles.z, 0),
			Float3(0, 0, 1)
		)
		let rotationsInOrder:[Self] = {
			switch order {
				case .xyz: return [ xRotation, yRotation, zRotation ]
				case .xzy: return [ xRotation, zRotation, yRotation ]
				case .yxz: return [ yRotation, xRotation, zRotation ]
				case .yzx: return [ yRotation, zRotation, xRotation ]
				case .zxy: return [ zRotation, xRotation, yRotation ]
				case .zyx: return [ zRotation, yRotation, xRotation ]
			}
		}()
		
		self = rotationsInOrder[2] * rotationsInOrder[1] * rotationsInOrder[0]
	}
	@available(macOS 10.12, iOS 10.10, tvOS 10.10, watchOS 3.0, *)
	@_transparent public init(rotationEulerAngles eulerAnglesMeasurements:(x:Measurement<UnitAngle>,y:Measurement<UnitAngle>,z:Measurement<UnitAngle>), order:RotationOrder = .zxy) {
		let eulerAnglesMeasurements_radians = (
			x: eulerAnglesMeasurements.x.converted(to: .radians),
			y: eulerAnglesMeasurements.y.converted(to: .radians),
			z: eulerAnglesMeasurements.z.converted(to: .radians)
		)
		self.init(
			rotationEulerAngles: Float3(
				Float(eulerAnglesMeasurements_radians.x.value),
				Float(eulerAnglesMeasurements_radians.y.value),
				Float(eulerAnglesMeasurements_radians.z.value)
			),
			order: order
		)
	}
	
	public init(scale:Float3) {
		self.init(diagonal: scale)
	}
	
	public init(scale:Float3, rotation quaternion:FloatQuaternion) {
		self = Self(scale: scale) * Self(rotation: quaternion) // TODO: verify & optimize
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let zero = Float3x3()
	public static let identity = Float3x3(matrix_identity_float3x3);
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual column vectors of the matrix via subscript.
	@inlinable public subscript(columnIndex:Int) -> Float3 {
		switch columnIndex {
			case 0: return Float3(self.m00, self.m01, self.m02)
			case 1: return Float3(self.m10, self.m11, self.m12)
			case 2: return Float3(self.m20, self.m21, self.m22)
			
			default: return Float3(scalar: Float.nan) // TODO: Instead, do whatever simd_float3x3 does.
		}
	}
	
	/// Access individual elements of the vector via subscript.
	@inlinable public subscript(columnIndex:Int, rowIndex:Int) -> Float {
		switch ( columnIndex, rowIndex ) {
			case (0, 0): return self.m00
			case (0, 1): return self.m01
			case (0, 2): return self.m02
			case (1, 0): return self.m10
			case (1, 1): return self.m11
			case (1, 2): return self.m12
			case (2, 0): return self.m20
			case (2, 1): return self.m21
			case (2, 2): return self.m22
			
			default: return Float.nan // TODO: Instead, do whatever simd_float3x3 does.
		}
	}
	
	
	// MARK: `replace` Functionality
	
	@inlinable public mutating func replace(
		m00:Float?=nil, m01:Float?=nil, m02:Float?=nil,
		m10:Float?=nil, m11:Float?=nil, m12:Float?=nil,
		m20:Float?=nil, m21:Float?=nil, m22:Float?=nil
	) {
		if let m00 = m00 { self.m00 = m00 }
		if let m01 = m01 { self.m01 = m01 }
		if let m02 = m02 { self.m02 = m02 }
		if let m10 = m10 { self.m10 = m10 }
		if let m11 = m11 { self.m11 = m11 }
		if let m12 = m12 { self.m12 = m12 }
		if let m20 = m20 { self.m20 = m20 }
		if let m21 = m21 { self.m21 = m21 }
		if let m22 = m22 { self.m22 = m22 }
	}
	@inlinable public func replacing(
		m00:Float?=nil, m01:Float?=nil, m02:Float?=nil,
		m10:Float?=nil, m11:Float?=nil, m12:Float?=nil,
		m20:Float?=nil, m21:Float?=nil, m22:Float?=nil
	) -> Float3x3 {
		return Float3x3(
			m00 ?? self.m00,
			m01 ?? self.m01,
			m02 ?? self.m02,
			m10 ?? self.m10,
			m11 ?? self.m11,
			m12 ?? self.m12,
			m20 ?? self.m20,
			m21 ?? self.m21,
			m22 ?? self.m22
		)
	}
	
	@inlinable public mutating func replace(c0:Float3?=nil, c1:Float3?=nil, c2:Float3?=nil) {
		if let c0 = c0 { self.c0 = c0 }
		if let c1 = c1 { self.c1 = c1 }
		if let c2 = c2 { self.c2 = c2 }
	}
	@inlinable public func replacing(c0:Float3?=nil, c1:Float3?=nil, c2:Float3?=nil) -> Float3x3 {
		return Float3x3(columns:
			c0 ?? self.c0,
			c1 ?? self.c1,
			c2 ?? self.c2
		)
	}
	
	@inlinable public mutating func replace(r0:Float3?=nil, r1:Float3?=nil, r2:Float3?=nil) {
		if let r0 = r0 { self.r0 = r0 }
		if let r1 = r1 { self.r1 = r1 }
		if let r2 = r2 { self.r2 = r2 }
	}
	@inlinable public func replacing(r0:Float3?=nil, r1:Float3?=nil, r2:Float3?=nil) -> Float3x3 {
		return Float3x3(rows:
			r0 ?? self.r0,
			r1 ?? self.r1,
			r2 ?? self.r2
		)
	}
	
	
	// MARK: `as…` Functionality
	
	@_transparent public var asTuple:(m00:Float,m01:Float,m02:Float,m10:Float,m11:Float,m12:Float,m20:Float,m21:Float,m22:Float) {
		return ( self.m00, self.m01, self.m02, self.m10, self.m11, self.m12, self.m20, self.m21, self.m22 )
	}
	
	@_transparent public var asArray:[Float] {
		return [ self.m00, self.m01, self.m02, self.m10, self.m11, self.m12, self.m20, self.m21, self.m22 ]
	}
	
	
	// MARK: Column (`Float3`) Accessors
	
	@_transparent public var c0:Float3 {
		get { return Float3(m00, m01, m02) }
		set { ( self.m00, self.m01, self.m02 ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	@_transparent public var c1:Float3 {
		get { return Float3(m10, m11, m12) }
		set { ( self.m10, self.m11, self.m12 ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	@_transparent public var c2:Float3 {
		get { return Float3(m20, m21, m22) }
		set { ( self.m20, self.m21, self.m22 ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	
	
	// MARK: Row (`Float3`) Accessors
	
	@_transparent public var r0:Float3 {
		get { return Float3(m00, m10, m20) }
		set { ( self.m00, self.m10, self.m20 ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	@_transparent public var r1:Float3 {
		get { return Float3(m01, m11, m21) }
		set { ( self.m01, self.m11, self.m21 ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	@_transparent public var r2:Float3 {
		get { return Float3(m02, m12, m22) }
		set { ( self.m02, self.m12, self.m22 ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	
	
	// MARK: `simdValue` Functionality
	
	@_transparent public var simdValue:simd_float3x3 {
		return Float3x3ToSimd(self)
	}
	
	
	// MARK: Is… Flags
	
	@_transparent public var isZero:Bool {
		return self == Self.zero
	}
	@_transparent public var isIdentity:Bool {
		return self == Self.identity
	}
	@_transparent public var isFinite:Bool {
		return self.c0.isFinite && self.c1.isFinite && self.c2.isFinite
	}
	@_transparent public var isInfinite:Bool {
		return self.c0.isInfinite || self.c1.isInfinite || self.c2.isInfinite
	}
	@_transparent public var isNaN:Bool {
		return self.c0.isNaN || self.c1.isNaN || self.c2.isNaN
	}
}


//extension Float3x3 // SceneKit Conversion
//{
//	/// Initialize to a SceneKit vector.
//	@_transparent public init(scnVector value:SCNVector3) {
//		self = Float3x3FromSCN(value)
//	}
//	
//	public var toSCNVector:SCNVector3 {
//		return Float3x3ToSCN(self)
//	}
//}

#if !os(watchOS) && !os(xrOS)
	extension Float3x3 // GLKit Conversion
	{
		/// Initialize to a GLKit vector.
		@_transparent public init(glkMatrix value:GLKMatrix3) {
			self = Float3x3FromGLK(value)
		}
		
		@_transparent public var toGLKMatrix:GLKMatrix3 {
			return Float3x3ToGLK(self)
		}
	}
#endif // !watchOS && !xrOS

//extension Float3x3 // CoreImage Conversion
//{
//	/// Initialize to a CoreImage vector.
//	@_transparent public init(ciVector:CIVector) {
//		self = Float3x3FromCI(ciVector)
//	}
//	
//	@_transparent public var toCIVector:CIVector {
//		return Float3x3ToCI(self)
//	}
//}


extension Float3x3 : CustomStringConvertible
{
	public var description:String {
		var strings:[[String]] = [ self.c0, self.c1, self.c2 ].map{ c in
			c.asArray.map(String.init(describing:))
		}
		let stringsLengths:[[Int]] = strings.map{ c in
			c.map { $0.count }
		}
		let columnMaxLengths:[Int] = stringsLengths.map{ c in
			c.max()!
		}
		strings = zip(strings, columnMaxLengths).map{ c, maxLength in
			c.map{ $0.padding(toLength: maxLength, withPad:" ", startingAt: 0) }
		}
		return
			"⎡\(strings[0][0])  \(strings[1][0])  \(strings[2][0])⎤\n" +
			"⎢\(strings[0][1])  \(strings[1][1])  \(strings[2][1])⎥\n" +
			"⎣\(strings[0][2])  \(strings[1][2])  \(strings[2][2])⎦\n"
	}
}


extension Float3x3 : ExpressibleByArrayLiteral
{
	public typealias Element = Float
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly three elements.
	@_transparent public init(arrayLiteral elements:Float...) {
		precondition(elements.count == 9)
		self.init(array: elements)
	}
}


extension Float3x3 : Equatable
{
	@_transparent public static func ==(a:Float3x3, b:Float3x3) -> Bool {
		return simd_equal(a.simdValue, b.simdValue)
	}
}


extension Float3x3 // Basic Math Operations
{
	@_transparent public static func + (a:Float3x3, b:Float3x3) -> Float3x3 {
		return Float3x3(simd_add(a.simdValue, b.simdValue))
	}
	@_transparent public static func += (v:inout Float3x3, o:Float3x3) {
		v = v + o
	}
	
	
	@_transparent public static func - (a:Float3x3, b:Float3x3) -> Float3x3 {
		return Float3x3(simd_sub(a.simdValue, b.simdValue))
	}
	@_transparent public static func -= (v:inout Float3x3, o:Float3x3) {
		v = v - o
	}
	
	
	@_transparent public static func * (a:Float3x3, b:Float3x3) -> Float3x3 { return a.concatenating(b) }
	@_transparent public func concatenating(_ other:Float3x3) -> Float3x3 {
		return concatenationOf(self, other)
	}
	@_transparent public static func *= (m:inout Float3x3, o:Float3x3) { m.concatenate(o) }
	@_transparent public mutating func concatenate(_ other:Float3x3) {
		self = self.concatenating(other)
	}
	
	
	@_transparent public static func / (a:Float3x3, b:Float3x3) -> Float3x3 {
		return a * b.inversed()
	}
	@_transparent public static func /= (v:inout Float3x3, o:Float3x3) {
		v = v / o
	}
	
	
	@_transparent public static func * (m:Float3x3, columnVector:Float3) -> Float3 {
		return Float3(simd_mul(m.simdValue, columnVector.simdValue))
	}
	@_transparent public static func * (rowVector:Float3, m:Float3x3) -> Float3 {
		return Float3(simd_mul(rowVector.simdValue, m.simdValue))
	}
	
	
	@_transparent public static func / (m:Float3x3, inverseColumnVector:Float3) -> Float3 {
		return Float3(simd_mul(m.simdValue, (1.0 / inverseColumnVector).simdValue))
	}
	@_transparent public static func / (inverseRowVector:Float3, m:Float3x3) -> Float3 {
		return Float3(simd_mul((1.0 / inverseRowVector).simdValue, m.simdValue))
	}
	
	
	@_transparent public static func * (m:Float3x3, scale:Float) -> Float3x3 {
		return Float3x3(simd_mul(scale, m.simdValue))
	}
	@_transparent public static func *= (v:inout Float3x3, scale:Float) {
		v = v * scale
	}
	@_transparent public static func * (scale:Float, m:Float3x3) -> Float3x3 {
		return Float3x3(simd_mul(scale, m.simdValue))
	}
	
	
	@_transparent public static func / (m:Float3x3, inverseScale:Float) -> Float3x3 {
		return Float3x3(simd_mul(1.0 / inverseScale, m.simdValue))
	}
	@_transparent public static func /= (v:inout Float3x3, inverseScale:Float) {
		v = v / inverseScale
	}
	@_transparent public static func / (inverseScale:Float, m:Float3x3) -> Float3x3 {
		return Float3x3(simd_mul(1.0 / inverseScale, m.simdValue))
	}
}

@_transparent public func concatenationOf(_ a:Float3x3, _ b:Float3x3) -> Float3x3 {
	return Float3x3(simd_mul(a.simdValue, b.simdValue))
}


extension Float3x3 // Geometric Math Operations
{
	@_transparent public func determinant() -> Float {
		return simd_determinant(self.simdValue)
	}
	
	
	@_transparent public func trace() -> Float {
		return simd_reduce_add(simd_float3(self.m00, self.m11, self.m22))
	}
	
	
	@_transparent public func inversed() -> Float3x3 {
		return Float3x3(simd_inverse(self.simdValue))
	}
	@_transparent public mutating func inverse() {
		self = self.inversed()
	}
	/// Alias of: `inversed()`
	@_transparent public func reciprocal() -> Float3x3 {
		return self.inversed()
	}
	/// Alias of: `inverse()`
	@_transparent public mutating func formReciprocal() {
		self.inverse()
	}
	
	
	@_transparent public func transposed() -> Float3x3 {
		return Float3x3(simd_transpose(self.simdValue))
	}
	@_transparent public mutating func transpose() {
		self = self.transposed()
	}
	
	
	@_transparent public func rotated(by quaternion:FloatQuaternion) -> Float3x3 {
		let rotationMatrix_simd = simd_matrix3x3(quaternion.simdValue)
		return Float3x3(simd_mul(rotationMatrix_simd, self.simdValue))
	}
	@_transparent public mutating func rotate(by quaternion:FloatQuaternion) {
		self = self.rotated(by: quaternion)
	}
	
	
	@_transparent public func unrotated(by quaternion:FloatQuaternion) -> Float3x3 {
		return self.rotated(by: quaternion.inversed())
	}
	@_transparent public mutating func unrotate(by quaternion:FloatQuaternion) {
		self = self.unrotated(by: quaternion)
	}
	
	
	// 3D Geometric scale
	@_transparent public func scaled(by scale:Float3) -> Float3x3 {
		return Float3x3(columns:
			self.c0 * Float3(scale.x, 1, 1),
			self.c1 * Float3(1, scale.y, 1),
			self.c2 * Float3(1, 1, scale.z)
		)
	}
	// 3D Geometric scale
	@_transparent public mutating func scale(by scale:Float3) {
		self = self.scaled(by: scale)
	}
	
	// 3D Geometric scale
	@_transparent public func unscaled(by scale:Float3) -> Float3x3 {
		return self.scaled(by: 1.0 / scale)
	}
	// 3D Geometric scale
	@_transparent public mutating func unscale(by scale:Float3) {
		self = self.scaled(by: 1.0 / scale)
	}
}

@_transparent public func outerProductOf(_ a:Float3, _ b:Float3) -> Float3x3 {
	return Float3x3OuterProduct(a, b)
}


extension Float3x3 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [
		1_430_140_993, 3_530_278_013, 3_858_576_569,
		2_768_553_721, 996_070_237, 3_694_958_161,
		695_584_271, 3_348_168_251, 1_346_902_097
	]
	
	#if swift(>=4.2)
		public func hash(into hasher:inout Hasher) {
			self.asArray.forEach{ hasher.combine($0) }
		}
	#else
		public var hashValue:Int {
			let uintHashValue = self.asArray.enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Float)) in
				let elementHash = UInt(element.value.bitPattern) &* Float3x3._hashingLargePrimes[element.index]
				return hashValue &+ elementHash
			}
			return Int(bitPattern: uintHashValue)
		}
	#endif
}

