// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd



extension Int2
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	public init(_ x:Int32, _ y:Int32) {
		self.init(x: x, y: y)
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	public init(_ scalar:Int32) {
		self.init(scalar, scalar)
	}
	
	/// Initialize a vector with the specified elements.
	public init(x:Int32) {
		self.init(x, 0)
	}
	public init(y:Int32) {
		self.init(0, y)
	}
	
	/// Initialize to a SIMD vector.
	public init(_ value:simd.int2) {
		self = Int2FromSimd(value)
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly two elements.
	public init(array:[Int32]) {
		precondition(array.count == 2)
		self.init(array[0], array[1])
	}
	
	/// Initialize using the given 2-element tuple.
	public init(tuple:(x:Int32,y:Int32)) {
		self.init(tuple.x, tuple.y)
	}
	
	/// Initialize using a different `Vuckt`'s `x` & `y` values.
	public init(xy:Int3) {
		self.init(xy.x, xy.y)
	}
	public init(xy:Int4) {
		self.init(xy.x, xy.y)
	}
	/// Initialize using a different `Vuckt`'s `x` & `z` values.
	public init(xz:Int3) {
		self.init(xz.x, xz.z)
	}
	public init(xz:Int4) {
		self.init(xz.x, xz.z)
	}
	/// Initialize using a different `Vuckt`'s `y` & `z` values.
	public init(yz:Int3) {
		self.init(yz.y, yz.z)
	}
	public init(yz:Int4) {
		self.init(yz.y, yz.z)
	}
	/// Initialize using an `Int4`'s `x` & `w` values.
	public init(xw:Int4) {
		self.init(xw.x, xw.w)
	}
	/// Initialize using an `Int4`'s `y` & `w` values.
	public init(yw:Int4) {
		self.init(yw.y, yw.w)
	}
	/// Initialize using an `Int4`'s `z` & `w` values.
	public init(zw:Int4) {
		self.init(zw.z, zw.w)
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let zero = Int2(0)
	
	public static let unitPositive = Int2(1)
	public static let unitNegative = Int2(-1)
	
	public static let unitXPositive = Int2(x: 1)
	public static let unitYPositive = Int2(y: 1)
	public static let unitXNegative = Int2(x: -1)
	public static let unitYNegative = Int2(y: -1)
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	public subscript(index:Int) -> Int32 {
		switch index {
			case 0: return self.x
			case 1: return self.y
			
			default: return Int32.min // TODO: Instead, do whatever simd.int2 does.
		}
	}
	
	
	// MARK: `replace` Functionality
	
	public mutating func replace(x:Int32?=nil, y:Int32?=nil) {
		if let xValue = x { self.x = xValue }
		if let yValue = y { self.y = yValue }
	}
	public func replacing(x:Int32?=nil, y:Int32?=nil) -> Int2 {
		return Int2(
			x ?? self.x,
			y ?? self.y
		)
	}
	
	
	// MARK: `clamp` Functionality
	
	public mutating func clamp(to range:ClosedRange<Int2>) {
		self = self.clamped(to: range)
	}
	public func clamped(to range:ClosedRange<Int2>) -> Int2 {
		return Int2(simd.clamp(self.simdValue, min: range.lowerBound.simdValue, max: range.upperBound.simdValue))
	}
	
	
	// MARK: `random` Functionality
	
	public static func random(in range:ClosedRange<Int2>) -> Int2 {
		return Int2(
			Int32.random(in: range.lowerBound.x...range.upperBound.x),
			Int32.random(in: range.lowerBound.y...range.upperBound.y)
		)
	}
	
	public static func random(in range:Range<Int2>) -> Int2 {
		return Int2(
			Int32.random(in: range.lowerBound.x..<range.upperBound.x),
			Int32.random(in: range.lowerBound.y..<range.upperBound.y)
		)
	}
	
	
	// MARK: `asTuple` Functionality
	
	public var asTuple:(x:Int32,y:Int32) {
		return ( self.x, self.y )
	}
	
	
	// MARK: `simdValue` Functionality
	
	public var simdValue:simd.int2 {
		return Int2ToSimd(self)
	}
}

	
extension Int2 : CustomStringConvertible
{
	public var description:String {
		return "(\(self.x), \(self.y))"
	}
}


// MARK: Element-wise `min`/`max`

public func min(_ a:Int2, _ b:Int2) -> Int2 {
	return Int2(simd.min(a.simdValue, b.simdValue))
}

public func min(_ a:Int2, _ b:Int2, _ c:Int2, _ rest:Int2...) -> Int2 {
	var minSimdValue = simd.min(simd.min(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		minSimdValue = simd.min(minSimdValue, value.simdValue)
	}
	return Int2(minSimdValue)
}

public func max(_ a:Int2, _ b:Int2) -> Int2 {
	return Int2(simd.max(a.simdValue, b.simdValue))
}

public func max(_ a:Int2, _ b:Int2, _ c:Int2, _ rest:Int2...) -> Int2 {
	var maxSimdValue = simd.max(simd.max(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		maxSimdValue = simd.max(maxSimdValue, value.simdValue)
	}
	return Int2(maxSimdValue)
}


extension Int2 : ExpressibleByArrayLiteral
{
	public typealias Element = Int32
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly two elements.
	public init(arrayLiteral elements:Int32...) {
		precondition(elements.count == 2)
		self.init(elements[0], elements[1])
	}
}


extension Int2 : Equatable
{
	public static func ==(a:Int2, b:Int2) -> Bool {
		return a.simdValue == b.simdValue
	}
}


extension Int2 : Comparable
{
	public static func < (a:Int2, b:Int2) -> Bool {
		return (a.x < b.x) && (a.y < b.y)
	}
	
	public static func <= (a:Int2, b:Int2) -> Bool {
		return (a.x <= b.x) && (a.y <= b.y)
	}
	
	public static func > (a:Int2, b:Int2) -> Bool {
		return (a.x > b.x) && (a.y > b.y)
	}
	
	public static func >= (a:Int2, b:Int2) -> Bool {
		return (a.x >= b.x) && (a.y >= b.y)
	}
}


extension Int2 // pseudo-IntegerArithmetic/FixedWidthInteger
{
	private static func doComponentCalculationWithOverflow(
		_ a:Int2, _ b:Int2,
		componentCalculationMethod:(Int32,Int32)->(Int32,overflow:Bool)
	) -> (Int2,overflow:Bool)
	{
		var result = Int2()
		var overflows = ( x: false, y: false, z: false )
		( result.x, overflows.x ) = componentCalculationMethod(a.x, b.x)
		( result.y, overflows.y ) = componentCalculationMethod(a.y, b.y)
		return (
			result,
			overflow: (overflows.x || overflows.y)
		)
	}
	
	private static func doComponentCalculationWithOverflow(
		_ a:Int2, _ b:Int2,
		componentCalculationMethod:(Int32)->(Int32)->(Int32,overflow:Bool)
	) -> (Int2,overflow:Bool)
	{
		return doComponentCalculationWithOverflow(a, b,
			componentCalculationMethod: { (a:Int32, b:Int32) -> (Int32,overflow:Bool) in componentCalculationMethod(a)(b) }
		)
	}
	
	
	public static func + (a:Int2, b:Int2) -> Int2 {
		return Int2(a.simdValue &+ b.simdValue)
	}
	public static func += (v:inout Int2, o:Int2) {
		v = v + o
	}
	
	#if swift(>=4.0)
		public func addingReportingOverflow(_ other:Int2) -> (partialValue:Int2,overflow:Bool) {
			return Int2.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.addingReportingOverflow)
		}
		
		public func unsafeAdding(_ other:Int2) -> Int2 {
			return self.addingReportingOverflow(other).partialValue
		}
	#else
		public static func addWithOverflow(_ a:Int2, _ b:Int2) -> (Int2,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.addWithOverflow)
		}
	#endif
	
	
	public static func - (a:Int2, b:Int2) -> Int2 {
		return Int2(a.simdValue &- b.simdValue)
	}
	public static func -= (v:inout Int2, o:Int2) {
		v = v - o
	}
	
	#if swift(>=4.0)
		public func subtractingReportingOverflow(_ other:Int2) -> (partialValue:Int2,overflow:Bool) {
			return Int2.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.subtractingReportingOverflow)
		}
		
		public func unsafeSubstracting(_ other:Int2) -> Int2 {
			return self.subtractingReportingOverflow(other).partialValue
		}
	#else
		public static func subtractWithOverflow(_ a:Int2, _ b:Int2) -> (Int2,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.subtractWithOverflow)
		}
	#endif
	
	
	public static func * (a:Int2, b:Int2) -> Int2 {
		return Int2(a.simdValue &* b.simdValue)
	}
	public static func *= (v:inout Int2, o:Int2) {
		v = v * o
	}
	
	#if swift(>=4.0)
		public func multipliedReportingOverflow(by other:Int2) -> (partialValue:Int2,overflow:Bool) {
			return Int2.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.multipliedReportingOverflow(by:))
		}
		
		public func unsafeMultiplied(by other:Int2) -> Int2 {
			return self.multipliedReportingOverflow(by: other).partialValue
		}
	#else
		public static func multiplyWithOverflow(_ a:Int2, _ b:Int2) -> (Int2,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.multiplyWithOverflow)
		}
	#endif
	
	
	public static func / (a:Int2, b:Int2) -> Int2 {
		return Int2(a.simdValue / b.simdValue)
	}
	public static func /= (v:inout Int2, o:Int2) {
		v = v / o
	}
	
	#if swift(>=4.0)
		public func dividedReportingOverflow(by other:Int2) -> (partialValue:Int2,overflow:Bool) {
			return Int2.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.dividedReportingOverflow(by:))
		}
		
		public func unsafeDivided(by other:Int2) -> Int2 {
			return self.dividedReportingOverflow(by: other).partialValue
		}
	#else
		public static func divideWithOverflow(_ a:Int2, _ b:Int2) -> (Int2,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.divideWithOverflow)
		}
	#endif
	
	
	public static func % (a:Int2, b:Int2) -> Int2 {
		return Int2(a.x % b.x, a.y % b.y)
	}
	public static func %= (v:inout Int2, o:Int2) {
		v = v % o
	}
	
	#if swift(>=4.0)
		public func remainderReportingOverflow(dividingBy other:Int2) -> (partialValue:Int2,overflow:Bool) {
			return Int2.doComponentCalculationWithOverflow(self, other, componentCalculationMethod: Int32.remainderReportingOverflow(dividingBy:))
		}
	#else
		public static func remainderWithOverflow(_ a:Int2, _ b:Int2) -> (Int2,overflow:Bool) {
			return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int32.remainderWithOverflow)
		}
	#endif
	
	
	public static prefix func - (v:Int2) -> Int2 {
		return Int2(0 &- v.simdValue)
	}
}


extension Int2 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083 ]
	
	#if swift(>=4.2)
		public func hash(into hasher:inout Hasher) {
			[ self.x, self.y ].forEach{ hasher.combine($0) }
		}
	#else
		public var hashValue:Int {
			let uintHashValue = [ self.x, self.y ].enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Int32)) in
				let elementHash = UInt(bitPattern: Int(element.value)) &* Int2._hashingLargePrimes[element.index]
				return hashValue &+ elementHash
			}
			return Int(bitPattern: uintHashValue)
		}
	#endif
}
