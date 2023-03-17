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



extension Float3
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	@_transparent public init(_ x:Float, _ y:Float, _ z:Float) {
		self.init(x: x, y: y, z: z)
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	@_transparent public init(scalar:Float) {
		self.init(scalar, scalar, scalar)
	}
	/// Alias of: `init(scalar:)`
	@_transparent public init(_ scalar:Float) { self.init(scalar: scalar) }
	
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
	
	public static let zero = Float3(scalar: 0)
	
	public static let one = Self.positiveOne
	public static let positiveOne = Float3(scalar: 1)
	public static let negativeOne = Float3(scalar: -1) // TODO: Rename; not a unit vector
	
	public static let unitX = Self.unitXPositive
	public static let unitXPositive = Float3(x: 1)
	public static let unitY = Self.unitYPositive
	public static let unitYPositive = Float3(y: 1)
	public static let unitZ = Self.unitZPositive
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
	
	
	// MARK: `as…` Functionality
	
	@_transparent public var asTuple:(x:Float,y:Float,z:Float) {
		return ( self.x, self.y, self.z )
	}
	
	@_transparent public var asArray:[Float] {
		return [ self.x, self.y, self.z ]
	}
	
	
	// MARK: 2-component (`Float2`) Accessors
	
	@_transparent public var xy:Float2 {
		get { return Float2(xy: self) }
		set { ( x, y ) = newValue.asTuple }
	}
	@_transparent public var xz:Float2 {
		get { return Float2(xz: self) }
		set { ( x, z ) = newValue.asTuple }
	}
	@_transparent public var yx:Float2 {
		get { return Float2(y, x) }
		set { ( y, x ) = newValue.asTuple }
	}
	@_transparent public var yz:Float2 {
		get { return Float2(yz: self) }
		set { ( y, z ) = newValue.asTuple }
	}
	@_transparent public var zx:Float2 {
		get { return Float2(z, x) }
		set { ( z, x ) = newValue.asTuple }
	}
	@_transparent public var zy:Float2 {
		get { return Float2(z, y) }
		set { ( z, y ) = newValue.asTuple }
	}
	
	
	// MARK: 3-component (`Float3`) Accessors
	
	@_transparent public var xyz:Float3 {
		get { return self }
		set { self = newValue }
	}
	@_transparent public var xzy:Float3 {
		get { return Float3(x, z, y) }
		set { ( x, z, y ) = newValue.asTuple }
	}
	@_transparent public var yxz:Float3 {
		get { return Float3(y, x, z) }
		set { ( y, x, z ) = newValue.asTuple }
	}
	@_transparent public var yzx:Float3 {
		get { return Float3(y, z, x) }
		set { ( y, z, x ) = newValue.asTuple }
	}
	@_transparent public var zxy:Float3 {
		get { return Float3(z, x, y) }
		set { ( z, x, y ) = newValue.asTuple }
	}
	@_transparent public var zyx:Float3 {
		get { return Float3(z, y, x) }
		set { ( z, y, x ) = newValue.asTuple }
	}
	
	
	// MARK: `simdValue` Functionality
	
	@_transparent public var simdValue:simd_float3 {
		return Float3ToSimd(self)
	}
	
	
	// MARK: Is… Flags
	
	@_transparent public var isFinite:Bool {
		return self.x.isFinite && self.y.isFinite && self.z.isFinite
	}
	@_transparent public var isInfinite:Bool {
		return self.x.isInfinite || self.y.isInfinite || self.z.isInfinite
	}
	@_transparent public var isNaN:Bool {
		return self.x.isNaN || self.y.isNaN || self.z.isNaN
	}
	@_transparent public var isZero:Bool {
		return self == Self.zero
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

#if !os(watchOS)
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
#endif // !watchOS

#if !os(watchOS)
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
#endif // !watchOS


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
	
	
	@_transparent public static func * (v:Float3, scale:Float) -> Float3 {
		return Float3MultiplyByScalar(v, scale)
	}
	@_transparent public static func *= (v:inout Float3, scale:Float) {
		v = v * scale
	}
	@_transparent public static func * (scale:Float, v:Float3) -> Float3 {
		return Float3MultiplyingScalar(scale, v)
	}
	
	
	@_transparent public static func / (v:Float3, inverseScale:Float) -> Float3 {
		return Float3DivideByScalar(v, inverseScale)
	}
	@_transparent public static func /= (v:inout Float3, inverseScale:Float) {
		v = v / inverseScale
	}
	@_transparent public static func / (inverseScale:Float, v:Float3) -> Float3 {
		return Float3DividingScalar(inverseScale, v)
	}
	
	
	@_transparent public static func % (v:Float3, inverseScale:Float) -> Float3 {
		return Float3ModulusByScalar(v, inverseScale)
	}
	@_transparent public static func %= (v:inout Float3, inverseScale:Float) {
		v = v % inverseScale
	}
	@_transparent public static func % (inverseScale:Float, v:Float3) -> Float3 {
		return Float3ModulusingScalar(inverseScale, v)
	}
	
	
	@_transparent public static prefix func - (v:Float3) -> Float3 { return v.negated() }
	@_transparent public func negated() -> Float3 {
		return Float3Negate(self)
	}
	@_transparent public mutating func negate() {
		self = self.negated()
	}
	
	
	@_transparent public func reciprocal() -> Float3 {
		return Float3(simd_recip(self.simdValue))
	}
	@_transparent public mutating func formReciprocal() {
		self = self.reciprocal()
	}
	@_transparent public func inversed() -> Float3 {
		return self.reciprocal()
	}
	@_transparent public mutating func inverse() {
		self.formReciprocal()
	}
}


extension Float3 // Geometric Math Operations
{
	/// Produces a unit-length vector.  (Not to be confused with a “normal”/“normal vector”.)
	/// See: https://mathworld.wolfram.com/NormalVector.html
	@_transparent public func normalized() -> Float3 {
		return Float3(simd_normalize(self.simdValue))
	}
	/// Modifies the vector to be unit-length.  (Not to be confused with a “normal”/“normal vector”.)
	/// See: https://mathworld.wolfram.com/NormalVector.html
	@_transparent public mutating func normalize() {
		self = self.normalized()
	}
	
	
	@_transparent public func length() -> Float {
		return simd_length(self.simdValue)
	}
	/// Alias of: `length()`
	@_transparent public func magnitude() -> Float { return self.length() }
	/// Alias of: `length()`
	@_transparent public func lTwoNorm() -> Float { return self.length() }
	
	@_transparent public func lengthSquared() -> Float {
		return simd_length_squared(self.simdValue)
	}
	/// Alias of: `lengthSquared()`
	@_transparent public func magnitudeSquared() -> Float { return self.lengthSquared() }
	
	
	@_transparent public func lOneNorm() -> Float {
		return simd_norm_one(self.simdValue)
	}
	/// Alias of: `lOneNorm()`
	@_transparent public func taxicabLength() -> Float { return self.lOneNorm() }
	
	@_transparent public func lInfinityNorm() -> Float {
		return simd_norm_inf(self.simdValue)
	}
	/// Alias of: `lInfinityNorm()`
	@_transparent public func uniformNorm() -> Float { return self.lInfinityNorm() }
	
	
	/// Also known as the Interior Product.
	@_transparent public func dotProduct(_ other:Float3) -> Float {
		return dotProductOf(self, other)
	}
	
	
	@_transparent public func crossProduct(_ other:Float3) -> Float3 {
		return crossProductOf(self, other)
	}
	@_transparent public mutating func formCrossProduct(_ other:Float3) {
		self = self.crossProduct(other)
	}
	
	
	/// Also known as the Exterior Product.  Produces a bivector result (as a `Float3`).
	@_transparent public func wedgeProduct(_ other:Float3) -> Float3 {
		return wedgeProductOf(self, other)
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
	
	
	@_transparent public func projected(onto other:Float3) -> Float3 {
		return Float3(simd_project(self.simdValue, other.simdValue))
	}
	@_transparent public mutating func project(onto other:Float3) {
		self = self.projected(onto: other)
	}
	
	
	@_transparent public func reflected(across planeNormal:Float3) -> Float3 {
		return Float3(simd_reflect(self.simdValue, planeNormal.simdValue))
	}
	@_transparent public mutating func reflect(across planeNormal:Float3) {
		self = self.reflected(across: planeNormal)
	}
	
	
	@_transparent public func refracted(through surfaceNormal:Float3, index refractiveIndex:Float) -> Float3 {
		return Float3(simd_refract(self.simdValue, surfaceNormal.simdValue, refractiveIndex))
	}
	@_transparent public mutating func refract(through surfaceNormal:Float3, index refractionIndex:Float) {
		self = self.refracted(through: surfaceNormal, index: refractionIndex)
	}
	
	
	public enum InterpolationMethod {
		case linear
		case hermite
	}
	@_transparent public func interpolated(to other:Float3, ratio:Float, method:Float3.InterpolationMethod = .linear) -> Float3 {
		return interpolateBetween(self, other, ratio: ratio)
	}
	@_transparent public mutating func interpolate(to other:Float3, ratio:Float, method:Float3.InterpolationMethod = .linear) {
		self = interpolateBetween(self, other, ratio: ratio)
	}
	@_transparent public func interpolated(to other:Float3, ratio:Float3, method:Float3.InterpolationMethod = .linear) -> Float3 {
		return interpolateBetween(self, other, ratio: ratio)
	}
	@_transparent public mutating func interpolate(to other:Float3, ratio:Float3, method:Float3.InterpolationMethod = .linear) {
		self = interpolateBetween(self, other, ratio: ratio)
	}
	
	
	@_transparent public func mixed(with other:Float3, ratio:Float) -> Float3 {
		return mixOf(self, other, ratio: ratio)
	}
	@_transparent public mutating func mix(with other:Float3, ratio:Float) {
		self = mixOf(self, other, ratio: ratio)
	}
	@_transparent public func mixed(with other:Float3, ratio:Float3) -> Float3 {
		return mixOf(self, other, ratio: ratio)
	}
	@_transparent public mutating func mix(with other:Float3, ratio:Float3) {
		self = mixOf(self, other, ratio: ratio)
	}
}

/// Also known as the Interior Product.
@_transparent public func dotProductOf(_ a:Float3, _ b:Float3) -> Float {
	return simd_dot(a.simdValue, b.simdValue)
}

@_transparent public func crossProductOf(_ a:Float3, _ b:Float3) -> Float3 {
	return Float3(simd_cross(a.simdValue, b.simdValue))
}

/// Also known as the Exterior Product.  Produces a bivector result (as a `Float3`).
@_transparent public func wedgeProductOf(_ a:Float3, _ b:Float3) -> Float3 {
	return Float3WedgeProduct(a, b)
}

@_transparent public func distanceBetween(_ a:Float3, _ b:Float3) -> Float {
	return simd_distance(a.simdValue, b.simdValue)
}
@_transparent public func distanceSquaredBetween(_ a:Float3, _ b:Float3) -> Float {
	return simd_distance_squared(a.simdValue, b.simdValue)
}

@_transparent public func taxicabDistanceBetween(_ a:Float3, _ b:Float3) -> Float {
	return (b - a).taxicabLength()
}

@_transparent public func interpolateBetween(_ a:Float3, _ b:Float3, ratio:Float, method:Float3.InterpolationMethod = .linear) -> Float3 {
	return interpolateBetween(a, b, ratio: Float3(scalar: ratio), method: method)
}
@_transparent public func interpolateBetween(_ a:Float3, _ b:Float3, ratio:Float3, method:Float3.InterpolationMethod = .linear) -> Float3 {
	switch method {
		case .linear:
			return Float3(simd_mix(a.simdValue, b.simdValue, ratio.simdValue))
		case .hermite:
			return Float3(simd_smoothstep(a.simdValue, b.simdValue, ratio.simdValue))
	}
}

@_transparent public func mixOf(_ a:Float3, _ b:Float3, ratio:Float) -> Float3 {
	return mixOf(a, b, ratio: Float3(scalar: ratio))
}
@_transparent public func mixOf(_ a:Float3, _ b:Float3, ratio:Float3) -> Float3
{
	return Float3(simd_mix(a.simdValue, b.simdValue, ratio.simdValue))
}


extension Float3 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083, 4_259_235_067 ]
	
	#if swift(>=4.2)
		public func hash(into hasher:inout Hasher) {
			self.asArray.forEach{ hasher.combine($0) }
		}
	#else
		public var hashValue:Int {
			let uintHashValue = self.asArray.enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Float)) in
				let elementHash = UInt(element.value.bitPattern) &* Float3._hashingLargePrimes[element.index]
				return hashValue &+ elementHash
			}
			return Int(bitPattern: uintHashValue)
		}
	#endif
}

