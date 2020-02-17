// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd



extension Int4
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	public init(_ x:Int32, _ y:Int32, _ z:Int32, _ w:Int32) {
		self.init(x: x, y: y, z: z, w: w)
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	public init(_ scalar:Int32) {
		self.init(scalar, scalar, scalar, scalar)
	}
	
	/// Initialize a vector with the specified elements.
	public init(x:Int32) {
		self.init(x, 0, 0, 0)
	}
	public init(y:Int32) {
		self.init(0, y, 0, 0)
	}
	public init(z:Int32) {
		self.init(0, 0, z, 0)
	}
	public init(w:Int32) {
		self.init(0, 0, 0, w)
	}
	public init(x:Int32, y:Int32) {
		self.init(x, y, 0, 0)
	}
	public init(x:Int32, z:Int32) {
		self.init(x, 0, z, 0)
	}
	public init(x:Int32, w:Int32) {
		self.init(x, 0, 0, w)
	}
	public init(y:Int32, z:Int32) {
		self.init(0, y, z, 0)
	}
	public init(y:Int32, w:Int32) {
		self.init(0, y, 0, w)
	}
	public init(z:Int32, w:Int32) {
		self.init(0, 0, z, w)
	}
	public init(x:Int32, y:Int32, z:Int32) {
		self.init(x, y, z, 0)
	}
	public init(x:Int32, y:Int32, w:Int32) {
		self.init(x, y, 0, w)
	}
	public init(x:Int32, z:Int32, w:Int32) {
		self.init(x, 0, z, w)
	}
	public init(y:Int32, z:Int32, w:Int32) {
		self.init(0, y, z, w)
	}
	
	/// Initialize to a SIMD vector.
	public init(_ value:simd_int4) {
		self = Int4FromSimd(value)
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly three elements.
	public init(array:[Int32]) {
		precondition(array.count == 4)
		self.init(array[0], array[1], array[2], array[3])
	}
	
	/// Initialize using the given 4-element tuple.
	public init(tuple:(x:Int32,y:Int32,z:Int32,w:Int32)) {
		self.init(tuple.x, tuple.y, tuple.z, tuple.w)
	}
	
	/// Initialize using an `Int2` as the `x` & `y` values.
	public init(xy:Int2, z:Int32?=nil, w:Int32?=nil) {
		self.init(xy[0], xy[1], z ?? 0, w ?? 0)
	}
	/// Initialize using an `Int2` as the `x` & `z` values.
	public init(xz:Int2, y:Int32?=nil, w:Int32?=nil) {
		self.init(xz[0], y ?? 0, xz[1], w ?? 0)
	}
	/// Initialize using an `Int2` as the `x` & `w` values.
	public init(xw:Int2, y:Int32?=nil, z:Int32?=nil) {
		self.init(xw[0], y ?? 0, z ?? 0, xw[1])
	}
	/// Initialize using an `Int2` as the `y` & `z` values.
	public init(yz:Int2, x:Int32?=nil, w:Int32?=nil) {
		self.init(x ?? 0, yz[0], yz[1], w ?? 0)
	}
	/// Initialize using an `Int2` as the `y` & `w` values.
	public init(yw:Int2, x:Int32?=nil, z:Int32?=nil) {
		self.init(x ?? 0, yw[0], z ?? 0, yw[1])
	}
	/// Initialize using an `Int2` as the `z` & `w` values.
	public init(zw:Int2, x:Int32?=nil, y:Int32?=nil) {
		self.init(x ?? 0, y ?? 0, zw[0], zw[1])
	}
	
	/// Initialize using an `Int3` as the `x`, `y`, `z` values.
	public init(xyz:Int3, w:Int32?=nil) {
		self.init(xyz[0], xyz[1], xyz[2], w ?? 0)
	}
	/// Initialize using an `Int3` as the `x`, `y`, `w` values.
	public init(xyw:Int3, z:Int32?=nil) {
		self.init(xyw[0], xyw[1], z ?? 0, xyw[2])
	}
	/// Initialize using an `Int3` as the `x`, `z`, `w` values.
	public init(xzw:Int3, y:Int32?=nil) {
		self.init(xzw[0], y ?? 0, xzw[1], xzw[2])
	}
	/// Initialize using an `Int3` as the `y`, `z`, `w` values.
	public init(yzw:Int3, x:Int32?=nil) {
		self.init(x ?? 0, yzw[0], yzw[1], yzw[2])
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let zero = Int4(0)
	
	public static let unitPositive = Int4(1)
	public static let unitNegative = Int4(-1)
	
	public static let unitXPositive = Int4(x: 1)
	public static let unitYPositive = Int4(y: 1)
	public static let unitZPositive = Int4(z: 1)
	public static let unitWPositive = Int4(w: 1)
	public static let unitXNegative = Int4(x: -1)
	public static let unitYNegative = Int4(y: -1)
	public static let unitZNegative = Int4(z: -1)
	public static let unitWNegative = Int4(w: -1)
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	public subscript(index:Int) -> Int32 {
		switch index {
			case 0: return self.x
			case 1: return self.y
			case 2: return self.z
			case 3: return self.w
			
			default: return Int32.min // TODO: Instead, do whatever simd_int4 does.
		}
	}
	
	
	// MARK: `replace` Functionality
	
	public mutating func replace(x:Int32?=nil, y:Int32?=nil, z:Int32?=nil, w:Int32?=nil) {
		if let xValue = x { self.x = xValue }
		if let yValue = y { self.y = yValue }
		if let zValue = z { self.z = zValue }
		if let wValue = w { self.w = wValue }
	}
	public func replacing(x:Int32?=nil, y:Int32?=nil, z:Int32?=nil, w:Int32?=nil) -> Int4 {
		return Int4(
			x ?? self.x,
			y ?? self.y,
			z ?? self.z,
			w ?? self.w
		)
	}
	
	
	// MARK: `clamp` Functionality
	
	public mutating func clamp(to range:ClosedRange<Int4>) {
		self = self.clamped(to: range)
	}
	public func clamped(to range:ClosedRange<Int4>) -> Int4 {
		return Int4(simd.clamp(self.simdValue, min: range.lowerBound.simdValue, max: range.upperBound.simdValue))
	}
	
	
	// MARK: `random` Functionality
	
	public static func random(in range:ClosedRange<Int4>) -> Int4 {
		return Int4(
			Int32.random(in: range.lowerBound.x...range.upperBound.x),
			Int32.random(in: range.lowerBound.y...range.upperBound.y),
			Int32.random(in: range.lowerBound.z...range.upperBound.z),
			Int32.random(in: range.lowerBound.w...range.upperBound.w)
		)
	}
	
	public static func random(in range:Range<Int4>) -> Int4 {
		return Int4(
			Int32.random(in: range.lowerBound.x..<range.upperBound.x),
			Int32.random(in: range.lowerBound.y..<range.upperBound.y),
			Int32.random(in: range.lowerBound.z..<range.upperBound.z),
			Int32.random(in: range.lowerBound.w..<range.upperBound.w)
		)
	}
	
	
	// MARK: `asTuple` Functionality
	
	public var asTuple:(x:Int32,y:Int32,z:Int32,w:Int32) {
		return ( self.x, self.y, self.z, self.w )
	}
	
	
	// MARK: 2-component (`Int2`) Accessors
	
	public var xy:Int2 {
		get { return Int2(xy: self) }
		set { ( self.x, self.y ) = ( newValue[0], newValue[1] ) }
	}
	public var xz:Int2 {
		get { return Int2(xz: self) }
		set { ( self.x, self.z ) = ( newValue[0], newValue[1] ) }
	}
	public var xw:Int2 {
		get { return Int2(xw: self) }
		set { ( self.x, self.w ) = ( newValue[0], newValue[1] ) }
	}
	public var yz:Int2 {
		get { return Int2(yz: self) }
		set { ( self.y, self.z ) = ( newValue[0], newValue[1] ) }
	}
	public var yw:Int2 {
		get { return Int2(yw: self) }
		set { ( self.y, self.w ) = ( newValue[0], newValue[1] ) }
	}
	public var zw:Int2 {
		get { return Int2(zw: self) }
		set { ( self.z, self.w ) = ( newValue[0], newValue[1] ) }
	}
	
	
	// MARK: 3-component (`Int3`) Accessors
	
	public var xyz:Int3 {
		get { return Int3(xyz: self) }
		set { ( self.x, self.y, self.z ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	public var xyw:Int3 {
		get { return Int3(xyw: self) }
		set { ( self.x, self.y, self.w ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	public var xzw:Int3 {
		get { return Int3(xzw: self) }
		set { ( self.x, self.z, self.w ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	public var yzw:Int3 {
		get { return Int3(yzw: self) }
		set { ( self.y, self.z, self.w ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	
	
	// MARK: `simdValue` Functionality
	
	public var simdValue:simd_int4 {
		return Int4ToSimd(self)
	}
}

	
extension Int4 : CustomStringConvertible
{
	public var description:String {
		return "(\(self.x), \(self.y), \(self.z), \(self.w))"
	}
}


// MARK: Element-wise `min`/`max`

public func min(_ a:Int4, _ b:Int4) -> Int4 {
	return Int4(simd.min(a.simdValue, b.simdValue))
}

public func min(_ a:Int4, _ b:Int4, _ c:Int4, _ rest:Int4...) -> Int4 {
	var minSimdValue = simd.min(simd.min(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		minSimdValue = simd.min(minSimdValue, value.simdValue)
	}
	return Int4(minSimdValue)
}

public func max(_ a:Int4, _ b:Int4) -> Int4 {
	return Int4(simd.max(a.simdValue, b.simdValue))
}

public func max(_ a:Int4, _ b:Int4, _ c:Int4, _ rest:Int4...) -> Int4 {
	var maxSimdValue = simd.max(simd.max(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		maxSimdValue = simd.max(maxSimdValue, value.simdValue)
	}
	return Int4(maxSimdValue)
}


extension Int4 : ExpressibleByArrayLiteral
{
	public typealias Element = Int32
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly three elements.
	public init(arrayLiteral elements:Int32...) {
		precondition(elements.count == 4)
		self.init(elements[0], elements[1], elements[2], elements[3])
	}
}


extension Int4 : Equatable
{
	public static func ==(a:Int4, b:Int4) -> Bool {
		return Int4Equal(a, b)
	}
	
	public static func !=(a:Int4, b:Int4) -> Bool {
		return Int4Inequal(a, b)
	}
}


extension Int4 : Comparable
{
	public static func < (a:Int4, b:Int4) -> Bool {
		return Int4LessThan(a, b)
	}
	
	public static func <= (a:Int4, b:Int4) -> Bool {
		return Int4LessThanOrEqual(a, b)
	}
	
	public static func > (a:Int4, b:Int4) -> Bool {
		return Int4GreaterThan(a, b)
	}
	
	public static func >= (a:Int4, b:Int4) -> Bool {
		return Int4GreaterThanOrEqual(a, b)
	}
}


extension Int4 // pseudo-IntegerArithmetic/FixedWidthInteger
{
	private static func doComponentCalculationWithOverflow(
		_ a:Int4, _ b:Int4,
		componentCalculationMethod:(Int32,Int32)->(Int32,overflow:Bool)
	) -> (Int4,overflow:Bool)
	{
		var result = Int4()
		var overflows = ( x: false, y: false, z: false, w: false )
		( result.x, overflows.x ) = componentCalculationMethod(a.x, b.x)
		( result.y, overflows.y ) = componentCalculationMethod(a.y, b.y)
		( result.z, overflows.z ) = componentCalculationMethod(a.z, b.z)
		( result.w, overflows.w ) = componentCalculationMethod(a.w, b.w)
		return (
			result,
			overflow: (overflows.x || overflows.y || overflows.z || overflows.w)
		)
	}
	
	private static func doComponentCalculationWithOverflow(
		_ a:Int4, _ b:Int4,
		componentCalculationMethod:(Int32)->(Int32)->(Int32,overflow:Bool)
	) -> (Int4,overflow:Bool)
	{
		return doComponentCalculationWithOverflow(a, b,
			componentCalculationMethod: { (a:Int32, b:Int32) -> (Int32,overflow:Bool) in componentCalculationMethod(a)(b) }
		)
	}
	
	
	public static func + (a:Int4, b:Int4) -> Int4 {
		return Int4Add(a, b)
	}
	public static func += (v:inout Int4, o:Int4) {
		v = v + o
	}
	
	#if swift(>=4.0)
		public func addingReportingOverflow(_ other:Int4) -> (partialValue:Int4,overflow:Bool) {
			return Int4.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.addingReportingOverflow)
		}
		
		public func unsafeAdding(_ other:Int4) -> Int4 {
			return self.addingReportingOverflow(other).partialValue
		}
	#else
		public static func addWithOverflow(_ a:Int4, _ b:Int4) -> (Int4,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.addWithOverflow)
		}
	#endif
	
	
	public static func - (a:Int4, b:Int4) -> Int4 {
		return Int4Subtract(a, b)
	}
	public static func -= (v:inout Int4, o:Int4) {
		v = v - o
	}
	
	#if swift(>=4.0)
		public func subtractingReportingOverflow(_ other:Int4) -> (partialValue:Int4,overflow:Bool) {
			return Int4.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.subtractingReportingOverflow)
		}
		
		public func unsafeSubstracting(_ other:Int4) -> Int4 {
			return self.subtractingReportingOverflow(other).partialValue
		}
	#else
		public static func subtractWithOverflow(_ a:Int4, _ b:Int4) -> (Int4,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.subtractWithOverflow)
		}
	#endif
	
	
	public static func * (a:Int4, b:Int4) -> Int4 {
		return Int4Multiply(a, b)
	}
	public static func *= (v:inout Int4, o:Int4) {
		v = v * o
	}
	
	#if swift(>=4.0)
		public func multipliedReportingOverflow(by other:Int4) -> (partialValue:Int4,overflow:Bool) {
			return Int4.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.multipliedReportingOverflow(by:))
		}
		
		public func unsafeMultiplied(by other:Int4) -> Int4 {
			return self.multipliedReportingOverflow(by: other).partialValue
		}
	#else
		public static func multiplyWithOverflow(_ a:Int4, _ b:Int4) -> (Int4,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.multiplyWithOverflow)
		}
	#endif
	
	
	public static func / (a:Int4, b:Int4) -> Int4 {
		return Int4Divide(a, b)
	}
	public static func /= (v:inout Int4, o:Int4) {
		v = v / o
	}
	
	#if swift(>=4.0)
		public func dividedReportingOverflow(by other:Int4) -> (partialValue:Int4,overflow:Bool) {
			return Int4.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.dividedReportingOverflow(by:))
		}
		
		public func unsafeDivided(by other:Int4) -> Int4 {
			return self.dividedReportingOverflow(by: other).partialValue
		}
	#else
		public static func divideWithOverflow(_ a:Int4, _ b:Int4) -> (Int4,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.divideWithOverflow)
		}
	#endif
	
	
	public static func % (a:Int4, b:Int4) -> Int4 {
		return Int4Modulus(a, b)
	}
	public static func %= (v:inout Int4, o:Int4) {
		v = v % o
	}
	
	#if swift(>=4.0)
		public func remainderReportingOverflow(dividingBy other:Int4) -> (partialValue:Int4,overflow:Bool) {
			return Int4.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.remainderReportingOverflow(dividingBy:))
		}
	#else
		public static func remainderWithOverflow(_ a:Int4, _ b:Int4) -> (Int4,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.remainderWithOverflow)
		}
	#endif
	
	
	public static prefix func - (v:Int4) -> Int4 {
		return Int4Negate(v)
	}
}


extension Int4 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083, 4_259_235_067, 454_923_701 ]
	
	#if swift(>=4.2)
		public func hash(into hasher:inout Hasher) {
			[ self.x, self.y, self.z, self.w ].forEach{ hasher.combine($0) }
		}
	#else
		public var hashValue:Int {
			let uintHashValue = [ self.x, self.y, self.z, self.w ].enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Int32)) in
				let elementHash = UInt(bitPattern: Int(element.value)) &* Int4._hashingLargePrimes[element.index]
				return hashValue &+ elementHash
			}
			return Int(bitPattern: uintHashValue)
		}
	#endif
}
