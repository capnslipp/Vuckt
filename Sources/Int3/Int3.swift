// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd



extension Int3
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	@_transparent public init(_ x:Int32, _ y:Int32, _ z:Int32) {
		self.init(x: x, y: y, z: z)
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	@_transparent public init(scalar:Int32) {
		self.init(scalar, scalar, scalar)
	}
	/// Alias of: `init(scalar:)`
	@_transparent public init(_ scalar:Int32) { self.init(scalar: scalar) }
	
	/// Initialize a vector with the specified elements.
	@_transparent public init(x:Int32) {
		self.init(x, 0, 0)
	}
	@_transparent public init(y:Int32) {
		self.init(0, y, 0)
	}
	@_transparent public init(z:Int32) {
		self.init(0, 0, z)
	}
	@_transparent public init(x:Int32, y:Int32) {
		self.init(x, y, 0)
	}
	@_transparent public init(x:Int32, z:Int32) {
		self.init(x, 0, z)
	}
	@_transparent public init(y:Int32, z:Int32) {
		self.init(0, y, z)
	}
	
	/// Initialize to a SIMD vector.
	@_transparent public init(_ value:simd_int3) {
		self = Int3FromSimd(value)
	}
	
	/// Initialize from an `Float3` value, clamping to the representable range of the int type.
	@_transparent public init(saturating float3Value:Float3) {
		self.init(simd_int_sat(float3Value.simdValue))
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly three elements.
	@_transparent public init(array:[Int32]) {
		precondition(array.count == 3)
		self.init(array[0], array[1], array[2])
	}
	
	/// Initialize using the given 3-element tuple.
	@_transparent public init(tuple:(x:Int32,y:Int32,z:Int32)) {
		self.init(tuple.x, tuple.y, tuple.z)
	}
	
	/// Initialize using an `Int2` as the `x` & `y` values.
	@_transparent public init(xy:Int2, z:Int32?=nil) {
		self.init(xy[0], xy[1], z ?? 0)
	}
	/// Initialize using an `Int2` as the `x` & `z` values.
	@_transparent public init(xz:Int2, y:Int32?=nil) {
		self.init(xz[0], y ?? 0, xz[1])
	}
	/// Initialize using an `Int2` as the `y` & `z` values.
	@_transparent public init(yz:Int2, x:Int32?=nil) {
		self.init(x ?? 0, yz[0], yz[1])
	}
	
	/// Initialize using an `Int4`'s `x`, `y`, `z` values.
	@_transparent public init(xyz:Int4) {
		self.init(xyz.x, xyz.y, xyz.z)
	}
	/// Initialize using an `Int4`'s `x`, `y`, `w` values.
	@_transparent public init(xyw:Int4) {
		self.init(xyw.x, xyw.y, xyw.w)
	}
	/// Initialize using an `Int4`'s `x`, `z`, `w` values.
	@_transparent public init(xzw:Int4) {
		self.init(xzw.x, xzw.z, xzw.w)
	}
	/// Initialize using an `Int4`'s `y`, `z`, `w` values.
	@_transparent public init(yzw:Int4) {
		self.init(yzw.y, yzw.z, yzw.w)
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let zero = Int3(scalar: 0)
	
	public static let one = Self.positiveOne
	public static let positiveOne = Int3(scalar: 1)
	public static let negativeOne = Int3(scalar: -1)
	
	public static let unitX = Self.unitXPositive
	public static let unitXPositive = Int3(x: 1)
	public static let unitY = Self.unitYPositive
	public static let unitYPositive = Int3(y: 1)
	public static let unitZ = Self.unitZPositive
	public static let unitZPositive = Int3(z: 1)
	
	public static let unitXNegative = Int3(x: -1)
	public static let unitYNegative = Int3(y: -1)
	public static let unitZNegative = Int3(z: -1)
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	@inlinable public subscript(index:Int) -> Int32 {
		switch index {
			case 0: return self.x
			case 1: return self.y
			case 2: return self.z
			
			default: return Int32.min // TODO: Instead, do whatever simd_int3 does.
		}
	}
	
	
	// MARK: `replace` Functionality
	
	@inlinable public mutating func replace(x:Int32?=nil, y:Int32?=nil, z:Int32?=nil) {
		if let xValue = x { self.x = xValue }
		if let yValue = y { self.y = yValue }
		if let zValue = z { self.z = zValue }
	}
	@inlinable public func replacing(x:Int32?=nil, y:Int32?=nil, z:Int32?=nil) -> Int3 {
		return Int3(
			x ?? self.x,
			y ?? self.y,
			z ?? self.z
		)
	}
	
	
	// MARK: `clamp` Functionality
	
	@_transparent public mutating func clamp(to range:ClosedRange<Int3>) {
		self = self.clamped(to: range)
	}
	@_transparent public func clamped(to range:ClosedRange<Int3>) -> Int3 {
		return Int3(simd_clamp(self.simdValue, range.lowerBound.simdValue, range.upperBound.simdValue))
	}
	
	
	// MARK: `random` Functionality
	
	@inlinable public static func random(in range:ClosedRange<Int3>) -> Int3 {
		return Int3(
			Int32.random(in: range.lowerBound.x...range.upperBound.x),
			Int32.random(in: range.lowerBound.y...range.upperBound.y),
			Int32.random(in: range.lowerBound.z...range.upperBound.z)
		)
	}
	
	@inlinable public static func random(in range:Range<Int3>) -> Int3 {
		return Int3(
			Int32.random(in: range.lowerBound.x..<range.upperBound.x),
			Int32.random(in: range.lowerBound.y..<range.upperBound.y),
			Int32.random(in: range.lowerBound.z..<range.upperBound.z)
		)
	}
	
	
	// MARK: `as…` Functionality
	
	@_transparent public var asTuple:(x:Int32,y:Int32,z:Int32) {
		return ( self.x, self.y, self.z )
	}
	
	@_transparent public var asArray:[Int32] {
		return [ self.x, self.y, self.z ]
	}
	
	
	// MARK: 2-component (`Int2`) Accessors
	
	@_transparent public var xy:Int2 {
		get { return Int2(xy: self) }
		set { ( self.x, self.y ) = ( newValue[0], newValue[1] ) }
	}
	@_transparent public var xz:Int2 {
		get { return Int2(xz: self) }
		set { ( self.x, self.z ) = ( newValue[0], newValue[1] ) }
	}
	@_transparent public var yz:Int2 {
		get { return Int2(yz: self) }
		set { ( self.y, self.z ) = ( newValue[0], newValue[1] ) }
	}
	
	
	// MARK: `simdValue` Functionality
	
	@_transparent public var simdValue:simd_int3 {
		return Int3ToSimd(self)
	}
	
	
	// MARK: Is… Flags
	
	@_transparent public var isZero:Bool {
		return self == Self.zero
	}
}

	
extension Int3 : CustomStringConvertible
{
	public var description:String {
		return "(\(self.x), \(self.y), \(self.z))"
	}
}


// MARK: Element-wise `min`/`max`

@_transparent public func min(_ a:Int3, _ b:Int3) -> Int3 {
	return Int3(simd_min(a.simdValue, b.simdValue))
}

@inlinable public func min(_ a:Int3, _ b:Int3, _ c:Int3, _ rest:Int3...) -> Int3 {
	var minSimdValue = simd_min(simd_min(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		minSimdValue = simd_min(minSimdValue, value.simdValue)
	}
	return Int3(minSimdValue)
}

@_transparent public func max(_ a:Int3, _ b:Int3) -> Int3 {
	return Int3(simd_max(a.simdValue, b.simdValue))
}

@inlinable public func max(_ a:Int3, _ b:Int3, _ c:Int3, _ rest:Int3...) -> Int3 {
	var maxSimdValue = simd_max(simd_max(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		maxSimdValue = simd_max(maxSimdValue, value.simdValue)
	}
	return Int3(maxSimdValue)
}


extension Int3 : ExpressibleByArrayLiteral
{
	public typealias Element = Int32
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly three elements.
	@_transparent public init(arrayLiteral elements:Int32...) {
		precondition(elements.count == 3)
		self.init(elements[0], elements[1], elements[2])
	}
}


extension Int3 : Equatable
{
	@_transparent public static func ==(a:Int3, b:Int3) -> Bool {
		return simd_equal(a.simdValue, b.simdValue)
	}
}


extension Int3 : Comparable
{
	@_transparent public static func < (a:Int3, b:Int3) -> Bool {
		return Int3LessThan(a, b)
	}
	
	@_transparent public static func <= (a:Int3, b:Int3) -> Bool {
		return Int3LessThanOrEqual(a, b)
	}
	
	@_transparent public static func > (a:Int3, b:Int3) -> Bool {
		return Int3GreaterThan(a, b)
	}
	
	@_transparent public static func >= (a:Int3, b:Int3) -> Bool {
		return Int3GreaterThanOrEqual(a, b)
	}
}


extension Int3 // pseudo-IntegerArithmetic/FixedWidthInteger
{
	private static func doComponentCalculationWithOverflow(
		_ a:Int3, _ b:Int3,
		componentCalculationMethod:(Int32,Int32)->(Int32,overflow:Bool)
	) -> (Int3,overflow:Bool)
	{
		var result = Int3()
		var overflows = ( x: false, y: false, z: false )
		( result.x, overflows.x ) = componentCalculationMethod(a.x, b.x)
		( result.y, overflows.y ) = componentCalculationMethod(a.y, b.y)
		( result.z, overflows.z ) = componentCalculationMethod(a.z, b.z)
		return (
			result,
			overflow: (overflows.x || overflows.y || overflows.z)
		)
	}
	
	private static func doComponentCalculationWithOverflow(
		_ a:Int3, _ b:Int3,
		componentCalculationMethod:(Int32)->(Int32)->(Int32,overflow:Bool)
	) -> (Int3,overflow:Bool)
	{
		return doComponentCalculationWithOverflow(a, b,
			componentCalculationMethod: { (a:Int32, b:Int32) -> (Int32,overflow:Bool) in componentCalculationMethod(a)(b) }
		)
	}
	
	
	@_transparent public static func + (a:Int3, b:Int3) -> Int3 {
		return Int3Add(a, b)
	}
	@_transparent public static func += (v:inout Int3, o:Int3) {
		v = v + o
	}
	
	#if swift(>=4.0)
		public func addingReportingOverflow(_ other:Int3) -> (partialValue:Int3,overflow:Bool) {
			return Int3.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.addingReportingOverflow)
		}
		
		public func unsafeAdding(_ other:Int3) -> Int3 {
			return self.addingReportingOverflow(other).partialValue
		}
	#else
		public static func addWithOverflow(_ a:Int3, _ b:Int3) -> (Int3,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.addWithOverflow)
		}
	#endif
	
	
	@_transparent public static func - (a:Int3, b:Int3) -> Int3 {
		return Int3Subtract(a, b)
	}
	@_transparent public static func -= (v:inout Int3, o:Int3) {
		v = v - o
	}
	
	#if swift(>=4.0)
		public func subtractingReportingOverflow(_ other:Int3) -> (partialValue:Int3,overflow:Bool) {
			return Int3.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.subtractingReportingOverflow)
		}
		
		public func unsafeSubstracting(_ other:Int3) -> Int3 {
			return self.subtractingReportingOverflow(other).partialValue
		}
	#else
		public static func subtractWithOverflow(_ a:Int3, _ b:Int3) -> (Int3,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.subtractWithOverflow)
		}
	#endif
	
	
	@_transparent public static func * (a:Int3, b:Int3) -> Int3 {
		return Int3Multiply(a, b)
	}
	@_transparent public static func *= (v:inout Int3, o:Int3) {
		v = v * o
	}
	
	#if swift(>=4.0)
		public func multipliedReportingOverflow(by other:Int3) -> (partialValue:Int3,overflow:Bool) {
			return Int3.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.multipliedReportingOverflow(by:))
		}
		
		public func unsafeMultiplied(by other:Int3) -> Int3 {
			return self.multipliedReportingOverflow(by: other).partialValue
		}
	#else
		public static func multiplyWithOverflow(_ a:Int3, _ b:Int3) -> (Int3,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.multiplyWithOverflow)
		}
	#endif
	
	
	@_transparent public static func / (a:Int3, b:Int3) -> Int3 {
		return Int3Divide(a, b)
	}
	@_transparent public static func /= (v:inout Int3, o:Int3) {
		v = v / o
	}
	
	#if swift(>=4.0)
		public func dividedReportingOverflow(by other:Int3) -> (partialValue:Int3,overflow:Bool) {
			return Int3.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.dividedReportingOverflow(by:))
		}
		
		public func unsafeDivided(by other:Int3) -> Int3 {
			return self.dividedReportingOverflow(by: other).partialValue
		}
	#else
		public static func divideWithOverflow(_ a:Int3, _ b:Int3) -> (Int3,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.divideWithOverflow)
		}
	#endif
	
	
	@_transparent public static func % (a:Int3, b:Int3) -> Int3 {
		return Int3Modulus(a, b)
	}
	@_transparent public static func %= (v:inout Int3, o:Int3) {
		v = v % o
	}
	
	#if swift(>=4.0)
		public func remainderReportingOverflow(dividingBy other:Int3) -> (partialValue:Int3,overflow:Bool) {
			return Int3.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.remainderReportingOverflow(dividingBy:))
		}
	#else
		public static func remainderWithOverflow(_ a:Int3, _ b:Int3) -> (Int3,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.remainderWithOverflow)
		}
	#endif
	
	
	@_transparent public static func * (v:Int3, scale:Int32) -> Int3 {
		return Int3MultiplyByScalar(v, scale)
	}
	@_transparent public static func *= (v:inout Int3, scale:Int32) {
		v = v * scale
	}
	@_transparent public static func * (scale:Int32, v:Int3) -> Int3 {
		return Int3MultiplyingScalar(scale, v)
	}
	
	
	@_transparent public static func / (v:Int3, inverseScale:Int32) -> Int3 {
		return Int3DivideByScalar(v, inverseScale)
	}
	@_transparent public static func /= (v:inout Int3, inverseScale:Int32) {
		v = v / inverseScale
	}
	@_transparent public static func / (inverseScale:Int32, v:Int3) -> Int3 {
		return Int3DividingScalar(inverseScale, v)
	}
	
	
	@_transparent public static func % (v:Int3, inverseScale:Int32) -> Int3 {
		return Int3ModulusByScalar(v, inverseScale)
	}
	@_transparent public static func %= (v:inout Int3, inverseScale:Int32) {
		v = v % inverseScale
	}
	@_transparent public static func % (inverseScale:Int32, v:Int3) -> Int3 {
		return Int3ModulusingScalar(inverseScale, v)
	}
	
	
	@_transparent public static prefix func - (v:Int3) -> Int3 {
		return Int3Negate(v)
	}
}


extension Int3 // Geometric Math Operations
{
	@_transparent public func lOneNorm() -> Int32 {
		return simd_reduce_add(simd_abs(self.simdValue))
	}
	/// Alias of: `lOneNorm()`
	@_transparent public func taxicabLength() -> Int32 { return self.lOneNorm() }
	
	@_transparent public func lInfinityNorm() -> Int32 {
		return simd_reduce_max(simd_abs(self.simdValue))
	}
	/// Alias of: `lInfinityNorm()`
	@_transparent public func uniformNorm() -> Int32 { return self.lInfinityNorm() }
}

@_transparent public func taxicabDistanceBetween(_ a:Int3, _ b:Int3) -> Int32 {
	return (b - a).taxicabLength()
}


extension Int3 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083, 4_259_235_067 ]
	
	#if swift(>=4.2)
		public func hash(into hasher:inout Hasher) {
			self.asArray.forEach{ hasher.combine($0) }
		}
	#else
		public var hashValue:Int {
			let uintHashValue = self.asArray.enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Int32)) in
				let elementHash = UInt(bitPattern: Int(element.value)) &* Int3._hashingLargePrimes[element.index]
				return hashValue &+ elementHash
			}
			return Int(bitPattern: uintHashValue)
		}
	#endif
}
