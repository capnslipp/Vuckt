// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd



extension Int3
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	public init(_ x:Int32, _ y:Int32, _ z:Int32) {
		self.init(x: x, y: y, z: z)
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	public init(_ scalar:Int32) {
		self.init(scalar, scalar, scalar)
	}
	
	/// Initialize a vector with the specified elements.
	public init(x:Int32) {
		self.init(x, 0, 0)
	}
	public init(y:Int32) {
		self.init(0, y, 0)
	}
	public init(z:Int32) {
		self.init(0, 0, z)
	}
	public init(x:Int32, y:Int32) {
		self.init(x, y, 0)
	}
	public init(x:Int32, z:Int32) {
		self.init(x, 0, z)
	}
	public init(y:Int32, z:Int32) {
		self.init(0, y, z)
	}
	
	/// Initialize to a SIMD vector.
	public init(_ value:simd.int3) {
		self = Int3FromSimd(value)
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly three elements.
	public init(array:[Int32]) {
		precondition(array.count == 3)
		self.init(array[0], array[1], array[2])
	}
	
	/// Initialize using the given 3-element tuple.
	public init(tuple:(x:Int32,y:Int32,z:Int32)) {
		self.init(tuple.x, tuple.y, tuple.z)
	}
	
	/// Initialize using an `Int2` as the `x` & `y` values.
	public init(xy:Int2, z:Int32?=nil) {
		self.init(xy[0], xy[1], z ?? 0)
	}
	/// Initialize using an `Int2` as the `x` & `z` values.
	public init(xz:Int2, y:Int32?=nil) {
		self.init(xz[0], y ?? 0, xz[1])
	}
	/// Initialize using an `Int2` as the `y` & `z` values.
	public init(yz:Int2, x:Int32?=nil) {
		self.init(x ?? 0, yz[0], yz[1])
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let zero = Int3(0)
	
	public static let unitPositive = Int3(1)
	public static let unitNegative = Int3(-1)
	
	public static let unitXPositive = Int3(x: 1)
	public static let unitYPositive = Int3(y: 1)
	public static let unitZPositive = Int3(z: 1)
	public static let unitXNegative = Int3(x: -1)
	public static let unitYNegative = Int3(y: -1)
	public static let unitZNegative = Int3(z: -1)
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	public subscript(index:Int32) -> Int32 {
		switch index {
			case 0: return self.x
			case 1: return self.y
			case 2: return self.z
			
			default: return Int32.min // TODO: Instead, do whatever simd.int3 does.
		}
	}
	
	
	// MARK: `replace` Functionality
	
	public mutating func replace(x:Int32?=nil, y:Int32?=nil, z:Int32?=nil) {
		if let xValue = x { self.x = xValue }
		if let yValue = y { self.y = yValue }
		if let zValue = z { self.z = zValue }
	}
	public func replacing(x:Int32?=nil, y:Int32?=nil, z:Int32?=nil) -> Int3 {
		return Int3(
			x ?? self.x,
			y ?? self.y,
			z ?? self.z
		)
	}
	
	
	// MARK: `clamp` Functionality
	
	public mutating func clamp(_ range:Range<Int3>) {
		self.clamp(range.lowerBound, range.upperBound - Int3(1))
	}
	public func clamped(_ range:Range<Int3>) -> Int3 {
		return self.clamped(range.lowerBound, range.upperBound - Int3(1))
	}
	
	public mutating func clamp(_ minValue:Int3, _ maxValue:Int3) {
		self = max(minValue, min(maxValue, self))
	}
	public func clamped(_ minValue:Int3, _ maxValue:Int3) -> Int3 {
		return max(minValue, min(maxValue, self))
	}
	
	
	// MARK: `random` Functionality
	
	public static func random(min:Int3=Int3(0), max:Int3) -> Int3 {
		return Int3(
			min.x + Int32(arc4random_uniform(UInt32(max.x - min.x + 1))),
			min.y + Int32(arc4random_uniform(UInt32(max.y - min.y + 1))),
			min.z + Int32(arc4random_uniform(UInt32(max.z - min.z + 1)))
		)
	}
	
	
	// MARK: `asTuple` Functionality
	
	public var asTuple:(x:Int32,y:Int32,z:Int32) {
		return ( self.x, self.y, self.z )
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
	public var yz:Int2 {
		get { return Int2(yz: self) }
		set { ( self.y, self.z ) = ( newValue[0], newValue[1] ) }
	}
	
	
	// MARK: `simdValue` Functionality
	
	public var simdValue:simd.int3 {
		return Int3ToSimd(self)
	}
}

	
extension Int3 : CustomStringConvertible
{
	public var description:String {
		return "(\(self.x), \(self.y), \(self.z))"
	}
}


// MARK: Element-wise `min`/`max`

public func min(_ a:Int3, _ b:Int3) -> Int3 {
	return Int3(
		x: (b.x < a.x) ? b.x : a.x,
		y: (b.y < a.y) ? b.y : a.y,
		z: (b.z < a.z) ? b.z : a.z
	)
}
public func min(_ a:Int3, _ b:Int3, _ c:Int3, _ rest:Int3...) -> Int3 {
	var minValue = min(min(a, b), c)
	for value in rest {
		if value.x < minValue.x { minValue.x = value.x }
		if value.y < minValue.y { minValue.y = value.y }
		if value.z < minValue.z { minValue.z = value.z }
	}
	return minValue
}
public func max(_ a:Int3, _ b:Int3) -> Int3 {
	return Int3(
		x: (b.x > a.x) ? b.x : a.x,
		y: (b.y > a.y) ? b.y : a.y,
		z: (b.z > a.z) ? b.z : a.z
	)
}
public func max(_ a:Int3, _ b:Int3, _ c:Int3, _ rest:Int3...) -> Int3 {
	var maxValue = max(max(a, b), c)
	for value in rest {
		if value.x > maxValue.x { maxValue.x = value.x }
		if value.y > maxValue.y { maxValue.y = value.y }
		if value.z > maxValue.z { maxValue.z = value.z }
	}
	return maxValue
}


extension Int3 : ExpressibleByArrayLiteral
{
	public typealias Element = Int32
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly three elements.
	public init(arrayLiteral elements:Int32...) {
		precondition(elements.count == 3)
		self.init(elements[0], elements[1], elements[2])
	}
}


extension Int3 : Equatable
{
	public static func ==(a:Int3, b:Int3) -> Bool {
		return a.x == b.x && a.y == b.y && a.z == b.z
	}
}


extension Int3 : Comparable
{
	public static func < (a:Int3, b:Int3) -> Bool {
		return a.x < b.x && a.y < b.y && a.z < b.z
	}
	
	public static func <= (a:Int3, b:Int3) -> Bool {
		return a.x <= b.x && a.y <= b.y && a.z <= b.z
	}
	
	public static func > (a:Int3, b:Int3) -> Bool {
		return a.x > b.x && a.y > b.y && a.z > b.z
	}
	
	public static func >= (a:Int3, b:Int3) -> Bool {
		return a.x >= b.x && a.y >= b.y && a.z >= b.z
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
	
	
	public static func + (a:Int3, b:Int3) -> Int3 {
		return self.init(x: (a.x + b.x), y: (a.y + b.y), z: (a.z + b.z))
	}
	public static func += (v:inout Int3, o:Int3) {
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
	
	
	public static func - (a:Int3, b:Int3) -> Int3 {
		return Int3(a.x - b.x, a.y - b.y, a.z - b.z)
	}
	public static func -= (v:inout Int3, o:Int3) {
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
	
	
	public static func * (a:Int3, b:Int3) -> Int3 {
		return Int3(a.x * b.x, a.y * b.y, a.z * b.z)
	}
	public static func *= (v:inout Int3, o:Int3) {
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
	
	
	public static func / (a:Int3, b:Int3) -> Int3 {
		return Int3(a.x / b.x, a.y / b.y, a.z / b.z)
	}
	public static func /= (v:inout Int3, o:Int3) {
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
	
	
	public static func % (a:Int3, b:Int3) -> Int3 {
		return Int3(a.x % b.x, a.y % b.y, a.z % b.z)
	}
	public static func %= (v:inout Int3, o:Int3) {
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
	
	
	public static prefix func - (v:Int3) -> Int3 {
		return Int3(0) - v
	}
}


extension Int3 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083, 4_259_235_067 ]
	
	public var hashValue:Int {
		let uintHashValue = [ self.x, self.y, self.z ].enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Int32)) in
			let elementHash = UInt(bitPattern: Int(element.value)) &* Int3._hashingLargePrimes[element.index]
			return hashValue &+ elementHash
		}
		return Int(bitPattern: uintHashValue)
	}
}


#if _runtime(_ObjC)

private let Int3InNSValueObjCType = NSValue(int3: Int3()).objCType


extension Int3: _ObjectiveCBridgeable {
  public func _bridgeToObjectiveC() -> NSValue {
    return { NSValue(int3: $0) }(self)
  }

  public static func _forceBridgeFromObjectiveC(_ source: NSValue,
                                                result: inout Int3?) {
    precondition(strcmp(source.objCType,
                        { _ in Int3InNSValueObjCType }(Int3.self)) == 0,
                 "NSValue does not contain the right type to bridge to Int3")
    result = { $0.int3Value }(source)
  }

  public static func _conditionallyBridgeFromObjectiveC(_ source: NSValue,
                                                        result: inout Int3?)
      -> Bool {
    if strcmp(source.objCType, { _ in Int3InNSValueObjCType }(Int3.self)) != 0 {
      result = nil
      return false
    }
    result = { $0.int3Value }(source)
    return true
  }

  public static func _unconditionallyBridgeFromObjectiveC(_ source: NSValue?)
      -> Int3 {
    let unwrappedSource = source!
    precondition(strcmp(unwrappedSource.objCType,
                        { _ in Int3InNSValueObjCType }(Int3.self)) == 0,
                 "NSValue does not contain the right type to bridge to Int3")
    return { $0.int3Value }(unwrappedSource)
  }
}


#endif // _runtime(_ObjC)
