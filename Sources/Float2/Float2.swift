// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd



extension Float2
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	public init(_ x:Float, _ y:Float) {
		self.init(x: x, y: y)
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	public init(_ scalar:Float) {
		self.init(scalar, scalar)
	}
	
	/// Initialize a vector with the specified elements.
	public init(x:Float) {
		self.init(x, 0)
	}
	public init(y:Float) {
		self.init(0, y)
	}
	
	/// Initialize to a SIMD vector.
	public init(_ value:simd.float2) {
		self = Float2FromSimd(value)
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly two elements.
	public init(array:[Float]) {
		precondition(array.count == 2)
		self.init(array[0], array[1])
	}
	
	/// Initialize using the given 2-element tuple.
	public init(tuple:(x:Float,y:Float)) {
		self.init(tuple.x, tuple.y)
	}
	
	/// Initialize using a different `FloatN`'s `x` & `y` values.
	public init(xy:Float3) {
		self.init(xy.x, xy.y)
	}
	public init(xy:Float4) {
		self.init(xy.x, xy.y)
	}
	/// Initialize using a different `FloatN`'s `x` & `z` values.
	public init(xz:Float3) {
		self.init(xz.x, xz.z)
	}
	public init(xz:Float4) {
		self.init(xz.x, xz.z)
	}
	/// Initialize using a different `FloatN`'s `y` & `z` values.
	public init(yz:Float3) {
		self.init(yz.y, yz.z)
	}
	public init(yz:Float4) {
		self.init(yz.y, yz.z)
	}
	/// Initialize using an `Float4`'s `x` & `w` values.
	public init(xw:Float4) {
		self.init(xw.x, xw.w)
	}
	/// Initialize using an `Float4`'s `y` & `w` values.
	public init(yw:Float4) {
		self.init(yw.y, yw.w)
	}
	/// Initialize using an `Float4`'s `z` & `w` values.
	public init(zw:Float4) {
		self.init(zw.z, zw.w)
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let zero = Float2(0)
	
	public static let unitPositive = Float2(1)
	public static let unitNegative = Float2(-1)
	
	public static let unitXPositive = Float2(x: 1)
	public static let unitYPositive = Float2(y: 1)
	public static let unitXNegative = Float2(x: -1)
	public static let unitYNegative = Float2(y: -1)
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	public subscript(index:Float) -> Float {
		switch index {
			case 0: return self.x
			case 1: return self.y
			
			default: return Float.nan // TODO: Instead, do whatever simd.float2 does.
		}
	}
	
	
	// MARK: `replace` Functionality
	
	public mutating func replace(x:Float?=nil, y:Float?=nil) {
		if let xValue = x { self.x = xValue }
		if let yValue = y { self.y = yValue }
	}
	public func replacing(x:Float?=nil, y:Float?=nil) -> Float2 {
		return Float2(
			x ?? self.x,
			y ?? self.y
		)
	}
	
	
	// MARK: `clamp` Functionality
	
	public mutating func clamp(to range:ClosedRange<Float2>) {
		self = self.clamped(to: range)
	}
	public func clamped(to range:ClosedRange<Float2>) -> Float2 {
		return Float2(simd.clamp(self.simdValue, min: range.lowerBound.simdValue, max: range.upperBound.simdValue))
	}
	
	
	// MARK: `random` Functionality
	
	public static func random(in range:ClosedRange<Float2>) -> Float2 {
		return Float2(
			Float.random(in: range.lowerBound.x...range.upperBound.x),
			Float.random(in: range.lowerBound.y...range.upperBound.y)
		)
	}
	
	public static func random(in range:Range<Float2>) -> Float2 {
		return Float2(
			Float.random(in: range.lowerBound.x..<range.upperBound.x),
			Float.random(in: range.lowerBound.y..<range.upperBound.y)
		)
	}
	
	
	// MARK: `asTuple` Functionality
	
	public var asTuple:(x:Float,y:Float) {
		return ( self.x, self.y )
	}
	
	
	// MARK: `simdValue` Functionality
	
	public var simdValue:simd.float2 {
		return Float2ToSimd(self)
	}
}


extension Float2 : CustomStringConvertible
{
	public var description:String {
		return "(\(self.x), \(self.y))"
	}
}


// MARK: Element-wise `min`/`max`

public func min(_ a:Float2, _ b:Float2) -> Float2 {
	return Float2(
		x: (b.x < a.x) ? b.x : a.x,
		y: (b.y < a.y) ? b.y : a.y
	)
}
public func min(_ a:Float2, _ b:Float2, _ c:Float2, _ rest:Float2...) -> Float2 {
	var minValue = min(min(a, b), c)
	for value in rest {
		if value.x < minValue.x { minValue.x = value.x }
		if value.y < minValue.y { minValue.y = value.y }
	}
	return minValue
}
public func max(_ a:Float2, _ b:Float2) -> Float2 {
	return Float2(
		x: (b.x > a.x) ? b.x : a.x,
		y: (b.y > a.y) ? b.y : a.y
	)
}
public func max(_ a:Float2, _ b:Float2, _ c:Float2, _ rest:Float2...) -> Float2 {
	var maxValue = max(max(a, b), c)
	for value in rest {
		if value.x > maxValue.x { maxValue.x = value.x }
		if value.y > maxValue.y { maxValue.y = value.y }
	}
	return maxValue
}


extension Float2 : ExpressibleByArrayLiteral
{
	public typealias Element = Float
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly two elements.
	public init(arrayLiteral elements:Float...) {
		precondition(elements.count == 2)
		self.init(elements[0], elements[1])
	}
}


extension Float2 : Equatable
{
	public static func ==(a:Float2, b:Float2) -> Bool {
		return a.simdValue == b.simdValue
	}
}


extension Float2 : Comparable
{
	public static func < (a:Float2, b:Float2) -> Bool {
		return (a.x < b.x) && (a.y < b.y)
	}
	
	public static func <= (a:Float2, b:Float2) -> Bool {
		return (a.x <= b.x) && (a.y <= b.y)
	}
	
	public static func > (a:Float2, b:Float2) -> Bool {
		return (a.x > b.x) && (a.y > b.y)
	}
	
	public static func >= (a:Float2, b:Float2) -> Bool {
		return (a.x >= b.x) && (a.y >= b.y)
	}
}


extension Float2 // Basic Math Operations
{
	public static func + (a:Float2, b:Float2) -> Float2 {
		return Float2(a.simdValue + b.simdValue)
	}
	public static func += (v:inout Float2, o:Float2) {
		v = v + o
	}
	
	
	public static func - (a:Float2, b:Float2) -> Float2 {
		return Float2(a.simdValue - b.simdValue)
	}
	public static func -= (v:inout Float2, o:Float2) {
		v = v - o
	}
	
	
	public static func * (a:Float2, b:Float2) -> Float2 {
		return Float2(a.simdValue * b.simdValue)
	}
	public static func *= (v:inout Float2, o:Float2) {
		v = v * o
	}
	
	
	public static func / (a:Float2, b:Float2) -> Float2 {
		return Float2(a.simdValue / b.simdValue)
	}
	public static func /= (v:inout Float2, o:Float2) {
		v = v / o
	}
	
	
	public static func % (a:Float2, b:Float2) -> Float2 {
		return Float2(a.x.truncatingRemainder(dividingBy: b.x), a.y.truncatingRemainder(dividingBy: b.y))
	}
	public static func %= (v:inout Float2, o:Float2) {
		v = v % o
	}
	
	
	public static prefix func - (v:Float2) -> Float2 {
		return Float2(-v.simdValue)
	}
}


extension Float2 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083 ]
	
	public var hashValue:Int {
		let uintHashValue = [ self.x, self.y ].enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Float)) in
			let elementHash = UInt(element.value.bitPattern) &* Float2._hashingLargePrimes[element.index]
			return hashValue &+ elementHash
		}
		return Int(bitPattern: uintHashValue)
	}
}