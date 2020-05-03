// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd
import SceneKit.SceneKitTypes
#if !os(watchOS)
	import GLKit.GLKVector4
	import CoreImage.CIVector
#endif



extension Float4
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	@_transparent public init(_ x:Float, _ y:Float, _ z:Float, _ w:Float) {
		self.init(x: x, y: y, z: z, w: w)
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	@_transparent public init(scalar:Float) {
		self.init(scalar, scalar, scalar, scalar)
	}
	/// Alias of: `init(scalar:)`
	@_transparent public init(_ scalar:Float) { self.init(scalar: scalar) }
	
	/// Initialize a vector with the specified elements.
	@_transparent public init(x:Float) {
		self.init(x, 0, 0, 0)
	}
	@_transparent public init(y:Float) {
		self.init(0, y, 0, 0)
	}
	@_transparent public init(z:Float) {
		self.init(0, 0, z, 0)
	}
	@_transparent public init(w:Float) {
		self.init(0, 0, 0, w)
	}
	@_transparent public init(x:Float, y:Float) {
		self.init(x, y, 0, 0)
	}
	@_transparent public init(x:Float, z:Float) {
		self.init(x, 0, z, 0)
	}
	@_transparent public init(x:Float, w:Float) {
		self.init(x, 0, 0, w)
	}
	@_transparent public init(y:Float, z:Float) {
		self.init(0, y, z, 0)
	}
	@_transparent public init(y:Float, w:Float) {
		self.init(0, y, 0, w)
	}
	@_transparent public init(z:Float, w:Float) {
		self.init(0, 0, z, w)
	}
	@_transparent public init(x:Float, y:Float, z:Float) {
		self.init(x, y, z, 0)
	}
	@_transparent public init(x:Float, y:Float, w:Float) {
		self.init(x, y, 0, w)
	}
	@_transparent public init(x:Float, z:Float, w:Float) {
		self.init(x, 0, z, w)
	}
	@_transparent public init(y:Float, z:Float, w:Float) {
		self.init(0, y, z, w)
	}
	
	/// Initialize to a SIMD vector.
	@_transparent public init(_ value:simd_float4) {
		self = Float4FromSimd(value)
	}
	
	/// Initialize from an `Int4` value.  May be inexact if the int values are large (due to float precision).
	@_transparent public init(_ int4Value:Int4) {
		self.init(simd_float(int4Value.simdValue))
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly three elements.
	@_transparent public init(array:[Float]) {
		precondition(array.count == 4)
		self.init(array[0], array[1], array[2], array[3])
	}
	
	/// Initialize using the given 4-element tuple.
	@_transparent public init(tuple:(x:Float,y:Float,z:Float,w:Float)) {
		self.init(tuple.x, tuple.y, tuple.z, tuple.w)
	}
	
	/// Initialize using an `Float2` as the `x` & `y` values.
	@_transparent public init(xy:Float2, z:Float?=nil, w:Float?=nil) {
		self.init(xy[0], xy[1], z ?? 0, w ?? 0)
	}
	/// Initialize using an `Float2` as the `x` & `z` values.
	@_transparent public init(xz:Float2, y:Float?=nil, w:Float?=nil) {
		self.init(xz[0], y ?? 0, xz[1], w ?? 0)
	}
	/// Initialize using an `Float2` as the `x` & `w` values.
	@_transparent public init(xw:Float2, y:Float?=nil, z:Float?=nil) {
		self.init(xw[0], y ?? 0, z ?? 0, xw[1])
	}
	/// Initialize using an `Float2` as the `y` & `z` values.
	@_transparent public init(yz:Float2, x:Float?=nil, w:Float?=nil) {
		self.init(x ?? 0, yz[0], yz[1], w ?? 0)
	}
	/// Initialize using an `Float2` as the `y` & `w` values.
	@_transparent public init(yw:Float2, x:Float?=nil, z:Float?=nil) {
		self.init(x ?? 0, yw[0], z ?? 0, yw[1])
	}
	/// Initialize using an `Float2` as the `z` & `w` values.
	@_transparent public init(zw:Float2, x:Float?=nil, y:Float?=nil) {
		self.init(x ?? 0, y ?? 0, zw[0], zw[1])
	}
	
	/// Initialize using an `Float3` as the `x`, `y`, `z` values.
	@_transparent public init(xyz:Float3, w:Float?=nil) {
		self.init(xyz[0], xyz[1], xyz[2], w ?? 0)
	}
	/// Initialize using an `Float3` as the `x`, `y`, `w` values.
	@_transparent public init(xyw:Float3, z:Float?=nil) {
		self.init(xyw[0], xyw[1], z ?? 0, xyw[2])
	}
	/// Initialize using an `Float3` as the `x`, `z`, `w` values.
	@_transparent public init(xzw:Float3, y:Float?=nil) {
		self.init(xzw[0], y ?? 0, xzw[1], xzw[2])
	}
	/// Initialize using an `Float3` as the `y`, `z`, `w` values.
	@_transparent public init(yzw:Float3, x:Float?=nil) {
		self.init(x ?? 0, yzw[0], yzw[1], yzw[2])
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let zero = Float4(scalar: 0)
	
	public static let one = Self.positiveOne
	public static let positiveOne = Float4(scalar: 1)
	public static let negativeOne = Float4(scalar: -1)
	
	public static let unitX = Self.unitXPositive
	public static let unitXPositive = Float4(x: 1)
	public static let unitY = Self.unitYPositive
	public static let unitYPositive = Float4(y: 1)
	public static let unitZ = Self.unitZPositive
	public static let unitZPositive = Float4(z: 1)
	public static let unitW = Self.unitWPositive
	public static let unitWPositive = Float4(w: 1)
	
	public static let unitXNegative = Float4(x: -1)
	public static let unitYNegative = Float4(y: -1)
	public static let unitZNegative = Float4(z: -1)
	public static let unitWNegative = Float4(w: -1)
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	@inlinable public subscript(index:Int) -> Float {
		switch index {
			case 0: return self.x
			case 1: return self.y
			case 2: return self.z
			case 3: return self.w
			
			default: return Float.nan // TODO: Instead, do whatever simd_float4 does.
		}
	}
	
	
	// MARK: `replace` Functionality
	
	@inlinable public mutating func replace(x:Float?=nil, y:Float?=nil, z:Float?=nil, w:Float?=nil) {
		if let xValue = x { self.x = xValue }
		if let yValue = y { self.y = yValue }
		if let zValue = z { self.z = zValue }
		if let wValue = w { self.w = wValue }
	}
	@inlinable public func replacing(x:Float?=nil, y:Float?=nil, z:Float?=nil, w:Float?=nil) -> Float4 {
		return Float4(
			x ?? self.x,
			y ?? self.y,
			z ?? self.z,
			w ?? self.w
		)
	}
	
	
	// MARK: `clamp` Functionality
	
	@_transparent public mutating func clamp(to range:ClosedRange<Float4>) {
		self = self.clamped(to: range)
	}
	@_transparent public func clamped(to range:ClosedRange<Float4>) -> Float4 {
		return Float4(simd_clamp(self.simdValue, range.lowerBound.simdValue, range.upperBound.simdValue))
	}
	
	
	// MARK: `random` Functionality
	
	@inlinable public static func random(in range:ClosedRange<Float4>) -> Float4 {
		return Float4(
			Float.random(in: range.lowerBound.x...range.upperBound.x),
			Float.random(in: range.lowerBound.y...range.upperBound.y),
			Float.random(in: range.lowerBound.z...range.upperBound.z),
			Float.random(in: range.lowerBound.w...range.upperBound.w)
		)
	}
	
	@inlinable public static func random(in range:Range<Float4>) -> Float4 {
		return Float4(
			Float.random(in: range.lowerBound.x..<range.upperBound.x),
			Float.random(in: range.lowerBound.y..<range.upperBound.y),
			Float.random(in: range.lowerBound.z..<range.upperBound.z),
			Float.random(in: range.lowerBound.w..<range.upperBound.w)
		)
	}
	
	
	// MARK: `as…` Functionality
	
	@_transparent public var asTuple:(x:Float,y:Float,z:Float,w:Float) {
		return ( self.x, self.y, self.z, self.w )
	}
	
	@_transparent public var asArray:[Float] {
		return [ self.x, self.y, self.z, self.w ]
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
	@_transparent public var xw:Float2 {
		get { return Float2(xw: self) }
		set { ( self.x, self.w ) = ( newValue[0], newValue[1] ) }
	}
	@_transparent public var yz:Float2 {
		get { return Float2(yz: self) }
		set { ( self.y, self.z ) = ( newValue[0], newValue[1] ) }
	}
	@_transparent public var yw:Float2 {
		get { return Float2(yw: self) }
		set { ( self.y, self.w ) = ( newValue[0], newValue[1] ) }
	}
	@_transparent public var zw:Float2 {
		get { return Float2(zw: self) }
		set { ( self.z, self.w ) = ( newValue[0], newValue[1] ) }
	}
	
	
	// MARK: 3-component (`Float3`) Accessors
	
	@_transparent public var xyz:Float3 {
		get { return Float3(xyz: self) }
		set { ( self.x, self.y, self.z ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	@_transparent public var xyw:Float3 {
		get { return Float3(xyw: self) }
		set { ( self.x, self.y, self.w ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	@_transparent public var xzw:Float3 {
		get { return Float3(xzw: self) }
		set { ( self.x, self.z, self.w ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	@_transparent public var yzw:Float3 {
		get { return Float3(yzw: self) }
		set { ( self.y, self.z, self.w ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	
	
	// MARK: `simdValue` Functionality
	
	@_transparent public var simdValue:simd_float4 {
		return Float4ToSimd(self)
	}
	
	
	// MARK: Is… Flags
	
	@_transparent public var isFinite:Bool {
		return self.x.isFinite && self.y.isFinite && self.z.isFinite && self.w.isFinite
	}
	@_transparent public var isInfinite:Bool {
		return self.x.isInfinite || self.y.isInfinite || self.z.isInfinite || self.w.isInfinite
	}
	@_transparent public var isNaN:Bool {
		return self.x.isNaN || self.y.isNaN || self.z.isNaN || self.w.isNaN
	}
	@_transparent public var isZero:Bool {
		return self == Self.zero
	}
}


extension Float4 // SceneKit Conversion
{
	/// Initialize to a SceneKit vector.
	@_transparent public init(scnVector value:SCNVector4) {
		self = Float4FromSCN(value)
	}
	
	@_transparent public var toSCNVector:SCNVector4 {
		return Float4ToSCN(self)
	}
}

#if !os(watchOS)
	extension Float4 // GLKit Conversion
	{
		/// Initialize to a GLKit vector.
		@_transparent public init(glkVector value:GLKVector4) {
			self = Float4FromGLK(value)
		}
		
		@_transparent public var toGLKVector:GLKVector4 {
			return Float4ToGLK(self)
		}
	}
#endif // !watchOS

#if !os(watchOS)
	extension Float4 // CoreImage Conversion
	{
		/// Initialize to a CoreImage vector.
		@_transparent public init(ciVector:CIVector) {
			self = Float4FromCI(ciVector)
		}
		
		@_transparent public var toCIVector:CIVector {
			return Float4ToCI(self)
		}
	}
#endif // !watchOS


extension Float4 : CustomStringConvertible
{
	public var description:String {
		return "(\(self.x), \(self.y), \(self.z), \(self.w))"
	}
}


// MARK: Element-wise `min`/`max`

@_transparent public func min(_ a:Float4, _ b:Float4) -> Float4 {
	return Float4(simd_min(a.simdValue, b.simdValue))
}

@inlinable public func min(_ a:Float4, _ b:Float4, _ c:Float4, _ rest:Float4...) -> Float4 {
	var minSimdValue = simd_min(simd_min(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		minSimdValue = simd_min(minSimdValue, value.simdValue)
	}
	return Float4(minSimdValue)
}

@_transparent public func max(_ a:Float4, _ b:Float4) -> Float4 {
	return Float4(simd_max(a.simdValue, b.simdValue))
}

@inlinable public func max(_ a:Float4, _ b:Float4, _ c:Float4, _ rest:Float4...) -> Float4 {
	var maxSimdValue = simd_max(simd_max(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		maxSimdValue = simd_max(maxSimdValue, value.simdValue)
	}
	return Float4(maxSimdValue)
}


extension Float4 : ExpressibleByArrayLiteral
{
	public typealias Element = Float
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly three elements.
	@_transparent public init(arrayLiteral elements:Float...) {
		precondition(elements.count == 4)
		self.init(elements[0], elements[1], elements[2], elements[3])
	}
}


extension Float4 : Equatable
{
	@_transparent public static func ==(a:Float4, b:Float4) -> Bool {
		return simd_equal(a.simdValue, b.simdValue)
	}
}


extension Float4 : Comparable
{
	@_transparent public static func < (a:Float4, b:Float4) -> Bool {
		return Float4LessThan(a, b)
	}
	
	@_transparent public static func <= (a:Float4, b:Float4) -> Bool {
		return Float4LessThanOrEqual(a, b)
	}
	
	@_transparent public static func > (a:Float4, b:Float4) -> Bool {
		return Float4GreaterThan(a, b)
	}
	
	@_transparent public static func >= (a:Float4, b:Float4) -> Bool {
		return Float4GreaterThanOrEqual(a, b)
	}
}


extension Float4 // Basic Math Operations
{
	@_transparent public static func + (a:Float4, b:Float4) -> Float4 {
		return Float4Add(a, b)
	}
	@_transparent public static func += (v:inout Float4, o:Float4) {
		v = v + o
	}
	
	
	@_transparent public static func - (a:Float4, b:Float4) -> Float4 {
		return Float4Subtract(a, b)
	}
	@_transparent public static func -= (v:inout Float4, o:Float4) {
		v = v - o
	}
	
	
	@_transparent public static func * (a:Float4, b:Float4) -> Float4 {
		return Float4Multiply(a, b)
	}
	@_transparent public static func *= (v:inout Float4, o:Float4) {
		v = v * o
	}
	
	
	@_transparent public static func / (a:Float4, b:Float4) -> Float4 {
		return Float4Divide(a, b)
	}
	@_transparent public static func /= (v:inout Float4, o:Float4) {
		v = v / o
	}
	
	
	@_transparent public static func % (a:Float4, b:Float4) -> Float4 {
		return Float4Modulus(a, b)
	}
	@_transparent public static func %= (v:inout Float4, o:Float4) {
		v = v % o
	}
	
	
	@_transparent public static func * (v:Float4, scale:Float) -> Float4 {
		return Float4MultiplyByScalar(v, scale)
	}
	@_transparent public static func *= (v:inout Float4, scale:Float) {
		v = v * scale
	}
	@_transparent public static func * (scale:Float, v:Float4) -> Float4 {
		return Float4MultiplyingScalar(scale, v)
	}
	
	
	@_transparent public static func / (v:Float4, inverseScale:Float) -> Float4 {
		return Float4DivideByScalar(v, inverseScale)
	}
	@_transparent public static func /= (v:inout Float4, inverseScale:Float) {
		v = v / inverseScale
	}
	@_transparent public static func / (inverseScale:Float, v:Float4) -> Float4 {
		return Float4DividingScalar(inverseScale, v)
	}
	
	
	@_transparent public static func % (v:Float4, inverseScale:Float) -> Float4 {
		return Float4ModulusByScalar(v, inverseScale)
	}
	@_transparent public static func %= (v:inout Float4, inverseScale:Float) {
		v = v % inverseScale
	}
	@_transparent public static func % (inverseScale:Float, v:Float4) -> Float4 {
		return Float4ModulusingScalar(inverseScale, v)
	}
	
	
	@_transparent public static prefix func - (v:Float4) -> Float4 { return v.negated() }
	@_transparent public func negated() -> Float4 {
		return Float4Negate(self)
	}
	@_transparent public mutating func negate() {
		self = self.negated()
	}
	
	
	@_transparent public func reciprocal() -> Float4 {
		return Float4(simd_recip(self.simdValue))
	}
	@_transparent public mutating func formReciprocal() {
		self = self.reciprocal()
	}
	@_transparent public func inversed() -> Float4 {
		return self.reciprocal()
	}
	@_transparent public mutating func inverse() {
		self.formReciprocal()
	}
}


extension Float4 // Geometric Math Operations
{
	/// Produces a unit-length vector.  (Not to be confused with a “normal”/“normal vector”.)
	/// See: https://mathworld.wolfram.com/NormalVector.html
	@_transparent public func normalized() -> Float4 {
		return Float4(simd_normalize(self.simdValue))
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
	@_transparent public func dotProduct(_ other:Float4) -> Float {
		return dotProductOf(self, other)
	}
	
	
	@_transparent public func projected(onto other:Float4) -> Float4 {
		return Float4(simd_project(self.simdValue, other.simdValue))
	}
	@_transparent public mutating func project(onto other:Float4) {
		self = self.projected(onto: other)
	}
	
	
	@_transparent public func reflected(across planeNormal:Float4) -> Float4 {
		return Float4(simd_reflect(self.simdValue, planeNormal.simdValue))
	}
	@_transparent public mutating func reflect(across planeNormal:Float4) {
		self = self.reflected(across: planeNormal)
	}
	
	
	@_transparent public func refracted(through surfaceNormal:Float4, index refractiveIndex:Float) -> Float4 {
		return Float4(simd_refract(self.simdValue, surfaceNormal.simdValue, refractiveIndex))
	}
	@_transparent public mutating func refract(through surfaceNormal:Float4, index refractionIndex:Float) {
		self = self.refracted(through: surfaceNormal, index: refractionIndex)
	}
	
	
	public enum InterpolationMethod {
		case linear
		case hermite
	}
	@_transparent public func interpolated(to other:Float4, ratio:Float, method:Float4.InterpolationMethod = .linear) -> Float4 {
		return interpolateBetween(self, other, ratio: ratio)
	}
	@_transparent public mutating func interpolate(to other:Float4, ratio:Float, method:Float4.InterpolationMethod = .linear) {
		self = interpolateBetween(self, other, ratio: ratio)
	}
	@_transparent public func interpolated(to other:Float4, ratio:Float4, method:Float4.InterpolationMethod = .linear) -> Float4 {
		return interpolateBetween(self, other, ratio: ratio)
	}
	@_transparent public mutating func interpolate(to other:Float4, ratio:Float4, method:Float4.InterpolationMethod = .linear) {
		self = interpolateBetween(self, other, ratio: ratio)
	}
	
	
	@_transparent public func mixed(with other:Float4, ratio:Float) -> Float4 {
		return mixOf(self, other, ratio: ratio)
	}
	@_transparent public mutating func mix(with other:Float4, ratio:Float) {
		self = mixOf(self, other, ratio: ratio)
	}
	@_transparent public func mixed(with other:Float4, ratio:Float4) -> Float4 {
		return mixOf(self, other, ratio: ratio)
	}
	@_transparent public mutating func mix(with other:Float4, ratio:Float4) {
		self = mixOf(self, other, ratio: ratio)
	}
}

/// Also known as the Interior Product.
@_transparent public func dotProductOf(_ a:Float4, _ b:Float4) -> Float {
	return simd_dot(a.simdValue, b.simdValue)
}

@_transparent public func distanceBetween(_ a:Float4, _ b:Float4) -> Float {
	return simd_distance(a.simdValue, b.simdValue)
}
@_transparent public func distanceSquaredBetween(_ a:Float4, _ b:Float4) -> Float {
	return simd_distance_squared(a.simdValue, b.simdValue)
}

@_transparent public func taxicabDistanceBetween(_ a:Float4, _ b:Float4) -> Float {
	return (b - a).taxicabLength()
}

@_transparent public func interpolateBetween(_ a:Float4, _ b:Float4, ratio:Float, method:Float4.InterpolationMethod = .linear) -> Float4
{
	return interpolateBetween(a, b, ratio: Float4(scalar: ratio), method: method)
}
@_transparent public func interpolateBetween(_ a:Float4, _ b:Float4, ratio:Float4, method:Float4.InterpolationMethod = .linear) -> Float4
{
	switch method {
		case .linear:
			return Float4(simd_mix(a.simdValue, b.simdValue, ratio.simdValue))
		case .hermite:
			return Float4(simd_smoothstep(a.simdValue, b.simdValue, ratio.simdValue))
	}
}

@_transparent public func mixOf(_ a:Float4, _ b:Float4, ratio:Float) -> Float4 {
	return mixOf(a, b, ratio: Float4(scalar: ratio))
}
@_transparent public func mixOf(_ a:Float4, _ b:Float4, ratio:Float4) -> Float4
{
	return Float4(simd_mix(a.simdValue, b.simdValue, ratio.simdValue))
}


extension Float4 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083, 4_259_235_067, 454_923_701 ]
	
	#if swift(>=4.2)
		public func hash(into hasher:inout Hasher) {
			self.asArray.forEach{ hasher.combine($0) }
		}
	#else
		public var hashValue:Int {
			let uintHashValue = self.asArray.enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Float)) in
				let elementHash = UInt(element.value.bitPattern) &* Float4._hashingLargePrimes[element.index]
				return hashValue &+ elementHash
			}
			return Int(bitPattern: uintHashValue)
		}
	#endif
}
