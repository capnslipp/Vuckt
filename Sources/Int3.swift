// Int3
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation



/// A vector of three `Int`s.
public struct Int3
{
	public var x:Int, y:Int, z:Int
	
	
	// MARK: `init`s
	
	/// Initialize to the zero vector.
	public init() {
		self.init(0)
	}
	
	/// Initialize a vector with the specified elements.
	public init(_ x:Int, _ y:Int, _ z:Int) {
		( self.x, self.y, self.z ) = ( x, y, z )
	}
	
	/// Initialize a vector with the specified elements.
	public init(x:Int?=nil, y:Int?=nil, z:Int?=nil) {
		self.init(x ?? 0, y ?? 0, z ?? 0)
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	public init(_ scalar:Int) {
		self.init(scalar, scalar, scalar)
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly three elements.
	public init(array:[Int]) {
		precondition(array.count == 3)
		self.init(array[0], array[1], array[2])
	}
	
	/// Initialize using the given 3-element tuple.
	public init(tuple:(x:Int,y:Int,z:Int)) {
		self.init(tuple.x, tuple.y, tuple.z)
	}
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	public subscript(index:Int) -> Int {
		switch index {
			case 0: return self.x
			case 1: return self.y
			case 2: return self.z
			
			default: return Int.min // TODO: Instead, do whatever simd.int3 does.
		}
	}
	
	
	// MARK: `NSObject` Conformance
	
	/// Debug string representation
	public var debugDescription:String {
		return "(\(self.x), \(self.y), \(self.z))"
	}
	
	
	// MARK: `replace` Functionality
	
	public mutating func replace(x:Int?=nil, y:Int?=nil, z:Int?=nil) {
		if let xValue = x { self.x = xValue }
		if let yValue = y { self.y = yValue }
		if let zValue = z { self.z = zValue }
	}
	public func replacing(x:Int?=nil, y:Int?=nil, z:Int?=nil) -> Int3 {
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
			min.x + Int(arc4random_uniform(UInt32(max.x - min.x + 1))),
			min.y + Int(arc4random_uniform(UInt32(max.y - min.y + 1))),
			min.z + Int(arc4random_uniform(UInt32(max.z - min.z + 1)))
		)
	}
	
	
	// MARK: `asTuple` Functionality
	
	public var asTuple:(x:Int,y:Int,z:Int) {
		return ( self.x, self.y, self.z )
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
	public typealias Element = Int
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly three elements.
	public init(arrayLiteral elements:Int...) {
		precondition(elements.count == 3)
		(self.x, self.y, self.z) = ( elements[0], elements[1], elements[2] )
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


extension Int3 : IntegerArithmetic
{
	private static func doComponentCalculationWithOverflow(
		_ a:Int3, _ b:Int3,
		componentCalculationMethod:(Int,Int)->(Int,overflow:Bool)
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
	
	
	public static func + (a:Int3, b:Int3) -> Int3 {
		return self.init(x: (a.x + b.x), y: (a.y + b.y), z: (a.z + b.z))
	}
	public static func += (v:inout Int3, o:Int3) {
		v = v + o
	}
	
	public static func addWithOverflow(_ a:Int3, _ b:Int3) -> (Int3,overflow:Bool) {
		return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int.addWithOverflow)
	}
	
	
	public static func - (a:Int3, b:Int3) -> Int3 {
		return Int3(a.x - b.x, a.y - b.y, a.z - b.z)
	}
	public static func -= (v:inout Int3, o:Int3) {
		v = v - o
	}
	
	public static func subtractWithOverflow(_ a:Int3, _ b:Int3) -> (Int3,overflow:Bool) {
		return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int.subtractWithOverflow)
	}
	
	
	public static func * (a:Int3, b:Int3) -> Int3 {
		return Int3(a.x * b.x, a.y * b.y, a.z * b.z)
	}
	public static func *= (v:inout Int3, o:Int3) {
		v = v * o
	}
	
	public static func multiplyWithOverflow(_ a:Int3, _ b:Int3) -> (Int3,overflow:Bool) {
		return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int.multiplyWithOverflow)
	}
	
	
	public static func / (a:Int3, b:Int3) -> Int3 {
		return Int3(a.x / b.x, a.y / b.y, a.z / b.z)
	}
	public static func /= (v:inout Int3, o:Int3) {
		v = v / o
	}
	
	public static func divideWithOverflow(_ a:Int3, _ b:Int3) -> (Int3,overflow:Bool) {
		return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int.divideWithOverflow)
	}
	
	
	public static func % (a:Int3, b:Int3) -> Int3 {
		return Int3(a.x % b.x, a.y % b.y, a.z % b.z)
	}
	public static func %= (v:inout Int3, o:Int3) {
		v = v % o
	}
	
	public static func remainderWithOverflow(_ a:Int3, _ b:Int3) -> (Int3,overflow:Bool) {
		return doComponentCalculationWithOverflow(a, b, componentCalculationMethod: Int.remainderWithOverflow)
	}
	
	
	public static prefix func - (v:Int3) -> Int3 {
		return Int3(0) - v
	}
	
	
	public func toIntMax() -> IntMax {
		enum Error : Swift.Error {
			case conversionToIntMaxDoesntMakeSenseForVectors
			public func trap() {
				try! { throw self }()
			}
		}
		
		Error.conversionToIntMaxDoesntMakeSenseForVectors.trap()
		return IntMax(0)
	}
}


#if !SWIFT_PACKAGE
extension Int3 : _ObjectiveCBridgeable
{
	public func _bridgeToObjectiveC() -> NSValue {
		var myself = self
		return NSValue(bytes: &myself, objCType: Int3_CStruct_objCTypeEncoding)
	}
	
	public static func _forceBridgeFromObjectiveC(_ source:NSValue, result:inout Int3?) {
		precondition(strcmp(source.objCType, Int3_CStruct_objCTypeEncoding) == 0, "NSValue does not contain the right type to bridge to Int3")
		result = Int3()
		source.getValue(&result!)
	}
	
	public static func _conditionallyBridgeFromObjectiveC(_ source:NSValue, result:inout Int3?) -> Bool {
		if strcmp(source.objCType, Int3_CStruct_objCTypeEncoding) != 0 {
			result = nil
			return false
		}
		result = Int3()
		source.getValue(&result!)
		return true
	}
	
	public static func _unconditionallyBridgeFromObjectiveC(_ source:NSValue?) -> Int3 {
		let unwrappedSource = source!
		precondition(strcmp(unwrappedSource.objCType, Int3_CStruct_objCTypeEncoding) == 0, "NSValue does not contain the right type to bridge to Int3")
		var result = Int3()
		unwrappedSource.getValue(&result)
		return result
	}
}
#endif // !SWIFT_PACKAGE
