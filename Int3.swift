// SlidingPuzzleCity
// @copyright: Slipp Douglas Thompson
// @copyright date: The date(s) of version control check-ins corresponding to this file and this project as a whole; or in lieu of, no earlier than October 2016.

import Foundation



/// A vector of three `Int`s.
@objc public final class Int3 : NSObject, ExpressibleByArrayLiteral, Comparable, IntegerArithmetic
{
	public var x:Int, y:Int, z:Int
	
	
	// MARK: `init`s
	
	/// Initialize to the zero vector.
	public override init() {
		(self.x, self.y, self.z) = ( 0, 0, 0 )
	}
	
	/// Initialize a vector with the specified elements.
	public convenience init(_ x:Int, _ y:Int, _ z:Int) {
		self.init(x: x, y: y, z: z)
	}
	
	/// Initialize a vector with the specified elements.
	public required init(x:Int, y:Int, z:Int) {
		(self.x, self.y, self.z) = ( x, y, z )
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	public init(_ scalar:Int) {
		(self.x, self.y, self.z) = ( scalar, scalar, scalar )
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly three elements.
	public init(array:[Int]) {
		precondition(array.count == 3)
		(self.x, self.y, self.z) = ( array[0], array[1], array[2] )
	}
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly three elements.
	public required init(arrayLiteral elements:Int...) {
		precondition(elements.count == 3)
		(self.x, self.y, self.z) = ( elements[0], elements[1], elements[2] )
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
	public override var debugDescription:String {
		return "(\(self.x), \(self.y), \(self.z))"
	}
	
	
	// MARK: `replace` Functionality
	
	public func replace(x:Int?=nil, y:Int?=nil, z:Int?=nil) {
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
	
	
	// MARK: `Equatable` Conformance
	
	public static func ==(a:Int3, b:Int3) -> Bool {
		return a.x == b.x && a.y == b.y && a.z == b.z
	}
	
	
	// MARK: `Comparable` Conformance
	
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
	
	
	// MARK: `IntegerArithmetic` Conformance
	
	private static func doComponentCalculationWithOverflow(
		_ a:Int3, _ b:Int3,
		componentCalculationMethod:(Int,Int)->(Int,overflow:Bool)
	) -> (Int3,overflow:Bool)
	{
		let result = Int3()
		var overflows = ( x: false, y: false, z: false )
		( result.x, overflows.x ) = componentCalculationMethod(a.x, b.x)
		( result.y, overflows.y ) = componentCalculationMethod(a.y, b.y)
		( result.z, overflows.z ) = componentCalculationMethod(a.z, b.z)
		return (
			result,
			overflow: (overflows.x || overflows.y || overflows.z)
		)
	}
	
	
	public static func + (a:Int3, b:Int3) -> Self {
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
