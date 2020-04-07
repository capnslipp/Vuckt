// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd
#if !os(watchOS)
	import CoreImage.CIVector
#endif
import CoreGraphics.CGGeometry



extension Float2
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	@_transparent public init(_ x:Float, _ y:Float) {
		self.init(x: x, y: y)
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	@_transparent public init(scalar:Float) {
		self.init(scalar, scalar)
	}
	
	/// Initialize a vector with the specified elements.
	@_transparent public init(x:Float) {
		self.init(x, 0)
	}
	@_transparent public init(y:Float) {
		self.init(0, y)
	}
	
	/// Initialize to a SIMD vector.
	@_transparent public init(_ value:simd_float2) {
		self = Float2FromSimd(value)
	}
	
	/// Initialize from an `Int2` value.  May be inexact if the int values are large (due to float precision).
	@_transparent public init(_ int2Value:Int2) {
		self.init(simd_float(int2Value.simdValue))
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly two elements.
	@_transparent public init(array:[Float]) {
		precondition(array.count == 2)
		self.init(array[0], array[1])
	}
	
	/// Initialize using the given 2-element tuple.
	@_transparent public init(tuple:(x:Float,y:Float)) {
		self.init(tuple.x, tuple.y)
	}
	
	/// Initialize using a different `FloatN`'s `x` & `y` values.
	@_transparent public init(xy:Float3) {
		self.init(xy.x, xy.y)
	}
	@_transparent public init(xy:Float4) {
		self.init(xy.x, xy.y)
	}
	/// Initialize using a different `FloatN`'s `x` & `z` values.
	@_transparent public init(xz:Float3) {
		self.init(xz.x, xz.z)
	}
	@_transparent public init(xz:Float4) {
		self.init(xz.x, xz.z)
	}
	/// Initialize using a different `FloatN`'s `y` & `z` values.
	@_transparent public init(yz:Float3) {
		self.init(yz.y, yz.z)
	}
	@_transparent public init(yz:Float4) {
		self.init(yz.y, yz.z)
	}
	/// Initialize using an `Float4`'s `x` & `w` values.
	@_transparent public init(xw:Float4) {
		self.init(xw.x, xw.w)
	}
	/// Initialize using an `Float4`'s `y` & `w` values.
	@_transparent public init(yw:Float4) {
		self.init(yw.y, yw.w)
	}
	/// Initialize using an `Float4`'s `z` & `w` values.
	@_transparent public init(zw:Float4) {
		self.init(zw.z, zw.w)
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let zero = Float2(scalar: 0)
	
	public static let one = Self.positiveOne
	public static let positiveOne = Float2(scalar: 1)
	public static let negativeOne = Float2(scalar: -1)
	
	public static let unitX = Self.unitXPositive
	public static let unitXPositive = Float2(x: 1)
	public static let unitY = Self.unitYPositive
	public static let unitYPositive = Float2(y: 1)
	
	public static let unitXNegative = Float2(x: -1)
	public static let unitYNegative = Float2(y: -1)
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	@inlinable public subscript(index:Int) -> Float {
		switch index {
			case 0: return self.x
			case 1: return self.y
			
			default: return Float.nan // TODO: Instead, do whatever simd_float2 does.
		}
	}
	
	
	// MARK: `replace` Functionality
	
	@inlinable public mutating func replace(x:Float?=nil, y:Float?=nil) {
		if let xValue = x { self.x = xValue }
		if let yValue = y { self.y = yValue }
	}
	@inlinable public func replacing(x:Float?=nil, y:Float?=nil) -> Float2 {
		return Float2(
			x ?? self.x,
			y ?? self.y
		)
	}
	
	
	// MARK: `clamp` Functionality
	
	@_transparent public mutating func clamp(to range:ClosedRange<Float2>) {
		self = self.clamped(to: range)
	}
	@_transparent public func clamped(to range:ClosedRange<Float2>) -> Float2 {
		return Float2(simd_clamp(self.simdValue, range.lowerBound.simdValue, range.upperBound.simdValue))
	}
	
	
	// MARK: `random` Functionality
	
	@inlinable public static func random(in range:ClosedRange<Float2>) -> Float2 {
		return Float2(
			Float.random(in: range.lowerBound.x...range.upperBound.x),
			Float.random(in: range.lowerBound.y...range.upperBound.y)
		)
	}
	
	@inlinable public static func random(in range:Range<Float2>) -> Float2 {
		return Float2(
			Float.random(in: range.lowerBound.x..<range.upperBound.x),
			Float.random(in: range.lowerBound.y..<range.upperBound.y)
		)
	}
	
	
	// MARK: `asTuple` Functionality
	
	@_transparent public var asTuple:(x:Float,y:Float) {
		return ( self.x, self.y )
	}
	
	
	// MARK: `simdValue` Functionality
	
	@_transparent public var simdValue:simd_float2 {
		return Float2ToSimd(self)
	}
	
	
	// MARK: Is… Flags
	
	@_transparent public var isFinite:Bool {
		return self.x.isFinite && self.y.isFinite
	}
	@_transparent public var isInfinite:Bool {
		return self.x.isInfinite || self.y.isInfinite
	}
	@_transparent public var isNaN:Bool {
		return self.x.isNaN || self.y.isNaN
	}
	@_transparent public var isZero:Bool {
		return self == Self.zero
	}
}


#if !os(watchOS)
	extension Float2 // CoreImage Conversion
	{
		/// Initialize to a CoreImage vector.
		@_transparent public init(ciVector:CIVector) {
			self = Float2FromCI(ciVector)
		}
		
		@_transparent public var toCIVector:CIVector {
			return Float2ToCI(self)
		}
	}
#endif // #if !watchOS

extension Float2 // CoreGraphics Conversion
{
	/// Initialize to a CGVector.
	@_transparent public init(cgVector value:CGVector) {
		self = Float2FromCGVector(value)
	}
	/// Initialize to a CGPoint.
	@_transparent public init(cgPoint value:CGPoint) {
		self = Float2FromCGPoint(value)
	}
	/// Initialize to a CGSize.
	@_transparent public init(cgSize value:CGSize) {
		self = Float2FromCGSize(value)
	}
	
	@_transparent public var toCGVector:CGVector {
		return Float2ToCGVector(self)
	}
	@_transparent public var toCGPoint:CGPoint {
		return Float2ToCGPoint(self)
	}
	@_transparent public var toCGSize:CGSize {
		return Float2ToCGSize(self)
	}
}


extension Float2 : CustomStringConvertible
{
	public var description:String {
		return "(\(self.x), \(self.y))"
	}
}


// MARK: Element-wise `min`/`max`

@_transparent public func min(_ a:Float2, _ b:Float2) -> Float2 {
	return Float2(simd_min(a.simdValue, b.simdValue))
}

@inlinable public func min(_ a:Float2, _ b:Float2, _ c:Float2, _ rest:Float2...) -> Float2 {
	var minSimdValue = simd_min(simd_min(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		minSimdValue = simd_min(minSimdValue, value.simdValue)
	}
	return Float2(minSimdValue)
}

@_transparent public func max(_ a:Float2, _ b:Float2) -> Float2 {
	return Float2(simd_max(a.simdValue, b.simdValue))
}

@inlinable public func max(_ a:Float2, _ b:Float2, _ c:Float2, _ rest:Float2...) -> Float2 {
	var maxSimdValue = simd_max(simd_max(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		maxSimdValue = simd_max(maxSimdValue, value.simdValue)
	}
	return Float2(maxSimdValue)
}


extension Float2 : ExpressibleByArrayLiteral
{
	public typealias Element = Float
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly two elements.
	@_transparent public init(arrayLiteral elements:Float...) {
		precondition(elements.count == 2)
		self.init(elements[0], elements[1])
	}
}


extension Float2 : Equatable
{
	@_transparent public static func ==(a:Float2, b:Float2) -> Bool {
		return simd_equal(a.simdValue, b.simdValue)
	}
}


extension Float2 : Comparable
{
	@_transparent public static func < (a:Float2, b:Float2) -> Bool {
		return Float2LessThan(a, b)
	}
	
	@_transparent public static func <= (a:Float2, b:Float2) -> Bool {
		return Float2LessThanOrEqual(a, b)
	}
	
	@_transparent public static func > (a:Float2, b:Float2) -> Bool {
		return Float2GreaterThan(a, b)
	}
	
	@_transparent public static func >= (a:Float2, b:Float2) -> Bool {
		return Float2GreaterThanOrEqual(a, b)
	}
}


extension Float2 // Basic Math Operations
{
	@_transparent public static func + (a:Float2, b:Float2) -> Float2 {
		return Float2Add(a, b)
	}
	@_transparent public static func += (v:inout Float2, o:Float2) {
		v = v + o
	}
	
	
	@_transparent public static func - (a:Float2, b:Float2) -> Float2 {
		return Float2Subtract(a, b)
	}
	@_transparent public static func -= (v:inout Float2, o:Float2) {
		v = v - o
	}
	
	
	@_transparent public static func * (a:Float2, b:Float2) -> Float2 {
		return Float2Multiply(a, b)
	}
	@_transparent public static func *= (v:inout Float2, o:Float2) {
		v = v * o
	}
	
	
	@_transparent public static func / (a:Float2, b:Float2) -> Float2 {
		return Float2Divide(a, b)
	}
	@_transparent public static func /= (v:inout Float2, o:Float2) {
		v = v / o
	}
	
	
	@_transparent public static func % (a:Float2, b:Float2) -> Float2 {
		return Float2Modulus(a, b)
	}
	@_transparent public static func %= (v:inout Float2, o:Float2) {
		v = v % o
	}
	
	
	@_transparent public static func * (v:Float2, scale:Float) -> Float2 {
		return Float2MultiplyByScalar(v, scale)
	}
	@_transparent public static func *= (v:inout Float2, scale:Float) {
		v = v * scale
	}
	
	
	@_transparent public static func / (v:Float2, inverseScale:Float) -> Float2 {
		return Float2DivideByScalar(v, inverseScale)
	}
	@_transparent public static func /= (v:inout Float2, inverseScale:Float) {
		v = v / inverseScale
	}
	
	
	@_transparent public static func % (v:Float2, inverseScale:Float) -> Float2 {
		return Float2ModulusByScalar(v, inverseScale)
	}
	@_transparent public static func %= (v:inout Float2, inverseScale:Float) {
		v = v % inverseScale
	}
	@_transparent public static func % (inverseScale:Float, v:Float2) -> Float2 {
		return Float2ModulusingScalar(inverseScale, v)
	}
	
	
	@_transparent public static prefix func - (v:Float2) -> Float2 { return v.negated() }
	@_transparent public func negated() -> Float2 {
		return Float2Negate(self)
	}
	@_transparent public mutating func negate() {
		self = self.negated()
	}
	
	
	@_transparent public func reciprocal() -> Float2 {
		return Float2(simd_recip(self.simdValue))
	}
	@_transparent public mutating func formReciprocal() {
		self = self.reciprocal()
	}
	@_transparent public func inversed() -> Float2 {
		return self.reciprocal()
	}
	@_transparent public mutating func inverse() {
		self.formReciprocal()
	}
}


extension Float2 // Geometric Math Operations
{
	/// Produces a unit-length vector.  (Not to be confused with a “normal”/“normal vector”.)
	/// See: https://mathworld.wolfram.com/NormalVector.html
	@_transparent public func normalized() -> Float2 {
		return Float2(simd_normalize(self.simdValue))
	}
	/// Modifies the vector to be unit-length.  (Not to be confused with a “normal”/“normal vector”.)
	/// See: https://mathworld.wolfram.com/NormalVector.html
	@_transparent public mutating func normalize() {
		self = self.normalized()
	}
	
	
	@_transparent public func length() -> Float {
		return simd_length(self.simdValue)
	}
	@_transparent public func magnitude() -> Float { return self.length() }
	@_transparent public func lengthSquared() -> Float {
		return simd_length_squared(self.simdValue)
	}
	@_transparent public func magnitudeSquared() -> Float { return self.lengthSquared() }
	
	
	@_transparent public func lOneNorm() -> Float {
		return simd_norm_one(self.simdValue)
	}
	@_transparent public func taxicabLength() -> Float { return self.lOneNorm() }
	@_transparent public func lInfinityNorm() -> Float {
		return simd_norm_inf(self.simdValue)
	}
	@_transparent public func uniformNorm() -> Float { return self.lInfinityNorm() }
	
	
	@_transparent public func dotProduct(_ other:Float2) -> Float {
		return dotProductOf(self, other)
	}
	
	
	@_transparent public func crossProduct(_ other:Float2) -> Float3 {
		return crossProductOf(self, other)
	}
	
	
	@_transparent public func projected(onto other:Float2) -> Float2 {
		return Float2(simd_project(self.simdValue, other.simdValue))
	}
	@_transparent public mutating func project(onto other:Float2) {
		self = self.projected(onto: other)
	}
	
	
	@_transparent public func reflected(across planeNormal:Float2) -> Float2 {
		return Float2(simd_reflect(self.simdValue, planeNormal.simdValue))
	}
	@_transparent public mutating func reflect(across planeNormal:Float2) {
		self = self.reflected(across: planeNormal)
	}
	
	
	@_transparent public func refracted(through surfaceNormal:Float2, index refractiveIndex:Float) -> Float2 {
		return Float2(simd_refract(self.simdValue, surfaceNormal.simdValue, refractiveIndex))
	}
	@_transparent public mutating func refract(through surfaceNormal:Float2, index refractionIndex:Float) {
		self = self.refracted(through: surfaceNormal, index: refractionIndex)
	}
	
	
	public enum InterpolationMethod {
		case linear
		case hermite
	}
	@_transparent public func interpolated(to other:Float2, ratio:Float, method:Float2.InterpolationMethod = .linear) -> Float2 {
		return interpolateBetween(self, other, ratio: ratio)
	}
	@_transparent public mutating func interpolate(to other:Float2, ratio:Float, method:Float2.InterpolationMethod = .linear) {
		self = interpolateBetween(self, other, ratio: ratio)
	}
	@_transparent public func interpolated(to other:Float2, ratio:Float2, method:Float2.InterpolationMethod = .linear) -> Float2 {
		return interpolateBetween(self, other, ratio: ratio)
	}
	@_transparent public mutating func interpolate(to other:Float2, ratio:Float2, method:Float2.InterpolationMethod = .linear) {
		self = interpolateBetween(self, other, ratio: ratio)
	}
	
	
	@_transparent public func mixed(with other:Float2, ratio:Float) -> Float2 {
		return mixOf(self, other, ratio: ratio)
	}
	@_transparent public mutating func mix(with other:Float2, ratio:Float) {
		self = mixOf(self, other, ratio: ratio)
	}
	@_transparent public func mixed(with other:Float2, ratio:Float2) -> Float2 {
		return mixOf(self, other, ratio: ratio)
	}
	@_transparent public mutating func mix(with other:Float2, ratio:Float2) {
		self = mixOf(self, other, ratio: ratio)
	}
}

@_transparent public func dotProductOf(_ a:Float2, _ b:Float2) -> Float {
	return simd_dot(a.simdValue, b.simdValue)
}

@_transparent public func crossProductOf(_ a:Float2, _ b:Float2) -> Float3 {
	return Float3(simd_cross(a.simdValue, b.simdValue))
}

@_transparent public func distanceBetween(_ a:Float2, _ b:Float2) -> Float {
	return simd_distance(a.simdValue, b.simdValue)
}
@_transparent public func distanceSquaredBetween(_ a:Float2, _ b:Float2) -> Float {
	return simd_distance_squared(a.simdValue, b.simdValue)
}

@_transparent public func taxicabDistanceBetween(_ a:Float2, _ b:Float2) -> Float {
	return (b - a).taxicabLength()
}

@_transparent public func interpolateBetween(_ a:Float2, _ b:Float2, ratio:Float, method:Float2.InterpolationMethod = .linear) -> Float2 {
	return interpolateBetween(a, b, ratio: Float2(scalar: ratio), method: method)
}
@_transparent public func interpolateBetween(_ a:Float2, _ b:Float2, ratio:Float2, method:Float2.InterpolationMethod = .linear) -> Float2 {
	switch method {
		case .linear:
			return Float2(simd_mix(a.simdValue, b.simdValue, ratio.simdValue))
		case .hermite:
			return Float2(simd_smoothstep(a.simdValue, b.simdValue, ratio.simdValue))
	}
}

@_transparent public func mixOf(_ a:Float2, _ b:Float2, ratio:Float) -> Float2 {
	return mixOf(a, b, ratio: Float2(scalar: ratio))
}
@_transparent public func mixOf(_ a:Float2, _ b:Float2, ratio:Float2) -> Float2
{
	return Float2(simd_mix(a.simdValue, b.simdValue, ratio.simdValue))
}


extension Float2 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083 ]
	
	#if swift(>=4.2)
		public func hash(into hasher:inout Hasher) {
			[ self.x, self.y ].forEach{ hasher.combine($0) }
		}
	#else
		public var hashValue:Int {
			let uintHashValue = [ self.x, self.y ].enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Float)) in
				let elementHash = UInt(element.value.bitPattern) &* Float2._hashingLargePrimes[element.index]
				return hashValue &+ elementHash
			}
			return Int(bitPattern: uintHashValue)
		}
	#endif
}
