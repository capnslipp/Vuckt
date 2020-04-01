// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd
import SceneKit.SceneKitTypes
import GLKit.GLKVector3
import CoreImage.CIVector



extension Float3
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	@_transparent public init(_ x:Float, _ y:Float, _ z:Float) {
		self.init(x: x, y: y, z: z)
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	@_transparent public init(_ scalar:Float) {
		self.init(scalar, scalar, scalar)
	}
	
	/// Initialize a vector with the specified elements.
	@_transparent public init(x:Float) {
		self.init(x, 0, 0)
	}
	@_transparent public init(y:Float) {
		self.init(0, y, 0)
	}
	@_transparent public init(z:Float) {
		self.init(0, 0, z)
	}
	@_transparent public init(x:Float, y:Float) {
		self.init(x, y, 0)
	}
	@_transparent public init(x:Float, z:Float) {
		self.init(x, 0, z)
	}
	@_transparent public init(y:Float, z:Float) {
		self.init(0, y, z)
	}
	
	/// Initialize to a SIMD vector.
	@_transparent public init(_ value:simd_float3) {
		self = Float3FromSimd(value)
	}
	
	/// Initialize from an `Int3` value.  May be inexact if the int values are large (due to float precision).
	@_transparent public init(_ int3Value:Int3) {
		self.init(simd_float(int3Value.simdValue))
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly three elements.
	@_transparent public init(array:[Float]) {
		precondition(array.count == 3)
		self.init(array[0], array[1], array[2])
	}
	
	/// Initialize using the given 3-element tuple.
	@_transparent public init(tuple:(x:Float,y:Float,z:Float)) {
		self.init(tuple.x, tuple.y, tuple.z)
	}
	
	/// Initialize using an `Float2` as the `x` & `y` values.
	@_transparent public init(xy:Float2, z:Float?=nil) {
		self.init(xy[0], xy[1], z ?? 0)
	}
	/// Initialize using an `Float2` as the `x` & `z` values.
	@_transparent public init(xz:Float2, y:Float?=nil) {
		self.init(xz[0], y ?? 0, xz[1])
	}
	/// Initialize using an `Float2` as the `y` & `z` values.
	@_transparent public init(yz:Float2, x:Float?=nil) {
		self.init(x ?? 0, yz[0], yz[1])
	}
	
	/// Initialize using an `Float4`'s `x`, `y`, `z` values.
	@_transparent public init(xyz:Float4) {
		self.init(xyz.x, xyz.y, xyz.z)
	}
	/// Initialize using an `Float4`'s `x`, `y`, `w` values.
	@_transparent public init(xyw:Float4) {
		self.init(xyw.x, xyw.y, xyw.w)
	}
	/// Initialize using an `Float4`'s `x`, `z`, `w` values.
	@_transparent public init(xzw:Float4) {
		self.init(xzw.x, xzw.z, xzw.w)
	}
	/// Initialize using an `Float4`'s `y`, `z`, `w` values.
	@_transparent public init(yzw:Float4) {
		self.init(yzw.y, yzw.z, yzw.w)
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let zero = Float3(0)
	
	public static let unitPositive = Float3(1)
	public static let unitNegative = Float3(-1)
	
	public static let unitXPositive = Float3(x: 1)
	public static let unitYPositive = Float3(y: 1)
	public static let unitZPositive = Float3(z: 1)
	public static let unitXNegative = Float3(x: -1)
	public static let unitYNegative = Float3(y: -1)
	public static let unitZNegative = Float3(z: -1)
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	@inlinable public subscript(index:Int) -> Float {
		switch index {
			case 0: return self.x
			case 1: return self.y
			case 2: return self.z
			
			default: return Float.nan // TODO: Instead, do whatever simd_float3 does.
		}
	}
	
	
	// MARK: `replace` Functionality
	
	@inlinable public mutating func replace(x:Float?=nil, y:Float?=nil, z:Float?=nil) {
		if let xValue = x { self.x = xValue }
		if let yValue = y { self.y = yValue }
		if let zValue = z { self.z = zValue }
	}
	@inlinable public func replacing(x:Float?=nil, y:Float?=nil, z:Float?=nil) -> Float3 {
		return Float3(
			x ?? self.x,
			y ?? self.y,
			z ?? self.z
		)
	}
	
	
	// MARK: `clamp` Functionality
	
	@_transparent public mutating func clamp(to range:ClosedRange<Float3>) {
		self = self.clamped(to: range)
	}
	@_transparent public func clamped(to range:ClosedRange<Float3>) -> Float3 {
		return Float3(simd_clamp(self.simdValue, range.lowerBound.simdValue, range.upperBound.simdValue))
	}
	
	
	// MARK: `random` Functionality
	
	@inlinable public static func random(in range:ClosedRange<Float3>) -> Float3 {
		return Float3(
			Float.random(in: range.lowerBound.x...range.upperBound.x),
			Float.random(in: range.lowerBound.y...range.upperBound.y),
			Float.random(in: range.lowerBound.z...range.upperBound.z)
		)
	}
	
	@inlinable public static func random(in range:Range<Float3>) -> Float3 {
		return Float3(
			Float.random(in: range.lowerBound.x..<range.upperBound.x),
			Float.random(in: range.lowerBound.y..<range.upperBound.y),
			Float.random(in: range.lowerBound.z..<range.upperBound.z)
		)
	}
	
	
	// MARK: `asTuple` Functionality
	
	@_transparent public var asTuple:(x:Float,y:Float,z:Float) {
		return ( self.x, self.y, self.z )
	}
	
	
	// MARK: 2-component (`Float2`) Accessors
	
	@_transparent public var xy:Float2 {
		get { return Float2(xy: self) }
		set { ( self.x, self.y ) = ( newValue[0], newValue[1] ) }
	}
	@_transparent public var xz:Float2 {
		get { return Float2(xz: self) }
		set { ( self.x, self.z ) = ( newValue[0], newValue[1] ) }
	}
	@_transparent public var yz:Float2 {
		get { return Float2(yz: self) }
		set { ( self.y, self.z ) = ( newValue[0], newValue[1] ) }
	}
	
	
	// MARK: `simdValue` Functionality
	
	@_transparent public var simdValue:simd_float3 {
		return Float3ToSimd(self)
	}
}


extension Float3 // SceneKit Conversion
{
	/// Initialize to a SceneKit vector.
	@_transparent public init(scnVector value:SCNVector3) {
		self = Float3FromSCN(value)
	}
	
	public var toSCNVector:SCNVector3 {
		return Float3ToSCN(self)
	}
}

extension Float3 // GLKit Conversion
{
	/// Initialize to a GLKit vector.
	@_transparent public init(glkVector value:GLKVector3) {
		self = Float3FromGLK(value)
	}
	
	@_transparent public var toGLKVector:GLKVector3 {
		return Float3ToGLK(self)
	}
}

extension Float3 // CoreImage Conversion
{
	/// Initialize to a CoreImage vector.
	@_transparent public init(ciVector:CIVector) {
		self = Float3FromCI(ciVector)
	}
	
	@_transparent public var toCIVector:CIVector {
		return Float3ToCI(self)
	}
}


extension Float3 : CustomStringConvertible
{
	public var description:String {
		return "(\(self.x), \(self.y), \(self.z))"
	}
}


// MARK: Element-wise `min`/`max`

@_transparent public func min(_ a:Float3, _ b:Float3) -> Float3 {
	return Float3(simd_min(a.simdValue, b.simdValue))
}

@inlinable public func min(_ a:Float3, _ b:Float3, _ c:Float3, _ rest:Float3...) -> Float3 {
	var minSimdValue = simd_min(simd_min(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		minSimdValue = simd_min(minSimdValue, value.simdValue)
	}
	return Float3(minSimdValue)
}

@_transparent public func max(_ a:Float3, _ b:Float3) -> Float3 {
	return Float3(simd_max(a.simdValue, b.simdValue))
}

@inlinable public func max(_ a:Float3, _ b:Float3, _ c:Float3, _ rest:Float3...) -> Float3 {
	var maxSimdValue = simd_max(simd_max(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		maxSimdValue = simd_max(maxSimdValue, value.simdValue)
	}
	return Float3(maxSimdValue)
}


extension Float3 : ExpressibleByArrayLiteral
{
	public typealias Element = Float
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly three elements.
	@_transparent public init(arrayLiteral elements:Float...) {
		precondition(elements.count == 3)
		self.init(elements[0], elements[1], elements[2])
	}
}


extension Float3 : Equatable
{
	@_transparent public static func ==(a:Float3, b:Float3) -> Bool {
		return simd_equal(a.simdValue, b.simdValue)
	}
}


extension Float3 : Comparable
{
	@_transparent public static func < (a:Float3, b:Float3) -> Bool {
		return Float3LessThan(a, b)
	}
	
	@_transparent public static func <= (a:Float3, b:Float3) -> Bool {
		return Float3LessThanOrEqual(a, b)
	}
	
	@_transparent public static func > (a:Float3, b:Float3) -> Bool {
		return Float3GreaterThan(a, b)
	}
	
	@_transparent public static func >= (a:Float3, b:Float3) -> Bool {
		return Float3GreaterThanOrEqual(a, b)
	}
}


extension Float3 // Basic Math Operations
{
	@_transparent public static func + (a:Float3, b:Float3) -> Float3 {
		return Float3Add(a, b)
	}
	@_transparent public static func += (v:inout Float3, o:Float3) {
		v = v + o
	}
	
	
	@_transparent public static func - (a:Float3, b:Float3) -> Float3 {
		return Float3Subtract(a, b)
	}
	@_transparent public static func -= (v:inout Float3, o:Float3) {
		v = v - o
	}
	
	
	@_transparent public static func * (a:Float3, b:Float3) -> Float3 {
		return Float3Multiply(a, b)
	}
	@_transparent public static func *= (v:inout Float3, o:Float3) {
		v = v * o
	}
	
	
	@_transparent public static func / (a:Float3, b:Float3) -> Float3 {
		return Float3Divide(a, b)
	}
	@_transparent public static func /= (v:inout Float3, o:Float3) {
		v = v / o
	}
	
	
	@_transparent public static func % (a:Float3, b:Float3) -> Float3 {
		return Float3Modulus(a, b)
	}
	@_transparent public static func %= (v:inout Float3, o:Float3) {
		v = v % o
	}
	
	
	public static prefix func - (v:Float3) -> Float3 {
		return Float3Negate(v)
	}
}


extension Float3 // Geometric Math Operations
{
	@_transparent public func normalized() -> Float3 {
		return Float3(simd_normalize(self.simdValue))
	}
	@_transparent public mutating func normalize() {
		self = self.normalized()
	}
	
	
	@_transparent public func length() -> Float {
		return simd_length(self.simdValue)
	}
	
	
	@_transparent public func dotProduct(_ other:Float3) -> Float {
		return dotProductOf(self, other)
	}
	
	
	@_transparent public func rotated(by quaternion:FloatQuaternion) -> Float3 {
		return quaternion.rotate(self)
	}
	@_transparent public mutating func rotate(by quaternion:FloatQuaternion) {
		self = self.rotated(by: quaternion)
	}
	
	
	@_transparent public func unrotated(by quaternion:FloatQuaternion) -> Float3 {
		return quaternion.unrotate(self)
	}
	@_transparent public mutating func unrotate(by quaternion:FloatQuaternion) {
		self = self.unrotated(by: quaternion)
	}
}

@_transparent public func dotProductOf(_ a:Float3, _ b:Float3) -> Float {
	return simd_dot(a.simdValue, b.simdValue)
}


extension Float3 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083, 4_259_235_067 ]
	
	#if swift(>=4.2)
		public func hash(into hasher:inout Hasher) {
			[ self.x, self.y, self.z ].forEach{ hasher.combine($0) }
		}
	#else
		public var hashValue:Int {
			let uintHashValue = [ self.x, self.y, self.z ].enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Float)) in
				let elementHash = UInt(element.value.bitPattern) &* Float3._hashingLargePrimes[element.index]
				return hashValue &+ elementHash
			}
			return Int(bitPattern: uintHashValue)
		}
	#endif
}

