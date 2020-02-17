// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd
import SceneKit.SceneKitTypes
import GLKit.GLKVector3
import CoreImage.CIVector



extension Float3
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	public init(_ x:Float, _ y:Float, _ z:Float) {
		self.init(x: x, y: y, z: z)
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	public init(_ scalar:Float) {
		self.init(scalar, scalar, scalar)
	}
	
	/// Initialize a vector with the specified elements.
	public init(x:Float) {
		self.init(x, 0, 0)
	}
	public init(y:Float) {
		self.init(0, y, 0)
	}
	public init(z:Float) {
		self.init(0, 0, z)
	}
	public init(x:Float, y:Float) {
		self.init(x, y, 0)
	}
	public init(x:Float, z:Float) {
		self.init(x, 0, z)
	}
	public init(y:Float, z:Float) {
		self.init(0, y, z)
	}
	
	/// Initialize to a SIMD vector.
	public init(_ value:simd_float3) {
		self = Float3FromSimd(value)
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly three elements.
	public init(array:[Float]) {
		precondition(array.count == 3)
		self.init(array[0], array[1], array[2])
	}
	
	/// Initialize using the given 3-element tuple.
	public init(tuple:(x:Float,y:Float,z:Float)) {
		self.init(tuple.x, tuple.y, tuple.z)
	}
	
	/// Initialize using an `Float2` as the `x` & `y` values.
	public init(xy:Float2, z:Float?=nil) {
		self.init(xy[0], xy[1], z ?? 0)
	}
	/// Initialize using an `Float2` as the `x` & `z` values.
	public init(xz:Float2, y:Float?=nil) {
		self.init(xz[0], y ?? 0, xz[1])
	}
	/// Initialize using an `Float2` as the `y` & `z` values.
	public init(yz:Float2, x:Float?=nil) {
		self.init(x ?? 0, yz[0], yz[1])
	}
	
	/// Initialize using an `Float4`'s `x`, `y`, `z` values.
	public init(xyz:Float4) {
		self.init(xyz.x, xyz.y, xyz.z)
	}
	/// Initialize using an `Float4`'s `x`, `y`, `w` values.
	public init(xyw:Float4) {
		self.init(xyw.x, xyw.y, xyw.w)
	}
	/// Initialize using an `Float4`'s `x`, `z`, `w` values.
	public init(xzw:Float4) {
		self.init(xzw.x, xzw.z, xzw.w)
	}
	/// Initialize using an `Float4`'s `y`, `z`, `w` values.
	public init(yzw:Float4) {
		self.init(yzw.y, yzw.z, yzw.w)
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let zero = Float3(0)
	
	public static let unitPositive = Float3(1)
	public static let unitNegative = Float3(-1)
	
	public static let unitXPositive = Float3(x: 1)
	public static let unitYPositive = Float3(y: 1)
	public static let unitZPositive = Float3(z: 1)
	public static let unitXNegative = Float3(x: -1)
	public static let unitYNegative = Float3(y: -1)
	public static let unitZNegative = Float3(z: -1)
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	public subscript(index:Int) -> Float {
		switch index {
			case 0: return self.x
			case 1: return self.y
			case 2: return self.z
			
			default: return Float.nan // TODO: Instead, do whatever simd_float3 does.
		}
	}
	
	
	// MARK: `replace` Functionality
	
	public mutating func replace(x:Float?=nil, y:Float?=nil, z:Float?=nil) {
		if let xValue = x { self.x = xValue }
		if let yValue = y { self.y = yValue }
		if let zValue = z { self.z = zValue }
	}
	public func replacing(x:Float?=nil, y:Float?=nil, z:Float?=nil) -> Float3 {
		return Float3(
			x ?? self.x,
			y ?? self.y,
			z ?? self.z
		)
	}
	
	
	// MARK: `clamp` Functionality
	
	public mutating func clamp(to range:ClosedRange<Float3>) {
		self = self.clamped(to: range)
	}
	public func clamped(to range:ClosedRange<Float3>) -> Float3 {
		return Float3(simd.clamp(self.simdValue, min: range.lowerBound.simdValue, max: range.upperBound.simdValue))
	}
	
	
	// MARK: `random` Functionality
	
	public static func random(in range:ClosedRange<Float3>) -> Float3 {
		return Float3(
			Float.random(in: range.lowerBound.x...range.upperBound.x),
			Float.random(in: range.lowerBound.y...range.upperBound.y),
			Float.random(in: range.lowerBound.z...range.upperBound.z)
		)
	}
	
	public static func random(in range:Range<Float3>) -> Float3 {
		return Float3(
			Float.random(in: range.lowerBound.x..<range.upperBound.x),
			Float.random(in: range.lowerBound.y..<range.upperBound.y),
			Float.random(in: range.lowerBound.z..<range.upperBound.z)
		)
	}
	
	
	// MARK: `asTuple` Functionality
	
	public var asTuple:(x:Float,y:Float,z:Float) {
		return ( self.x, self.y, self.z )
	}
	
	
	// MARK: 2-component (`Float2`) Accessors
	
	public var xy:Float2 {
		get { return Float2(xy: self) }
		set { ( self.x, self.y ) = ( newValue[0], newValue[1] ) }
	}
	public var xz:Float2 {
		get { return Float2(xz: self) }
		set { ( self.x, self.z ) = ( newValue[0], newValue[1] ) }
	}
	public var yz:Float2 {
		get { return Float2(yz: self) }
		set { ( self.y, self.z ) = ( newValue[0], newValue[1] ) }
	}
	
	
	// MARK: `simdValue` Functionality
	
	public var simdValue:simd_float3 {
		return Float3ToSimd(self)
	}
}


extension Float3 // SceneKit Conversion
{
	/// Initialize to a SceneKit vector.
	public init(scnVector value:SCNVector3) {
		self = Float3FromSCN(value)
	}
	
	public var toSCNVector:SCNVector3 {
		return Float3ToSCN(self)
	}
}

extension Float3 // GLKit Conversion
{
	/// Initialize to a GLKit vector.
	public init(glkVector value:GLKVector3) {
		self = Float3FromGLK(value)
	}
	
	public var toGLKVector:GLKVector3 {
		return Float3ToGLK(self)
	}
}

extension Float3 // CoreImage Conversion
{
	/// Initialize to a CoreImage vector.
	public init(ciVector:CIVector) {
		self = Float3FromCI(ciVector)
	}
	
	public var toCIVector:CIVector {
		return Float3ToCI(self)
	}
}


extension Float3 : CustomStringConvertible
{
	public var description:String {
		return "(\(self.x), \(self.y), \(self.z))"
	}
}


// MARK: Element-wise `min`/`max`

public func min(_ a:Float3, _ b:Float3) -> Float3 {
	return Float3(simd.min(a.simdValue, b.simdValue))
}

public func min(_ a:Float3, _ b:Float3, _ c:Float3, _ rest:Float3...) -> Float3 {
	var minSimdValue = simd.min(simd.min(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		minSimdValue = simd.min(minSimdValue, value.simdValue)
	}
	return Float3(minSimdValue)
}

public func max(_ a:Float3, _ b:Float3) -> Float3 {
	return Float3(simd.max(a.simdValue, b.simdValue))
}

public func max(_ a:Float3, _ b:Float3, _ c:Float3, _ rest:Float3...) -> Float3 {
	var maxSimdValue = simd.max(simd.max(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		maxSimdValue = simd.max(maxSimdValue, value.simdValue)
	}
	return Float3(maxSimdValue)
}


extension Float3 : ExpressibleByArrayLiteral
{
	public typealias Element = Float
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly three elements.
	public init(arrayLiteral elements:Float...) {
		precondition(elements.count == 3)
		self.init(elements[0], elements[1], elements[2])
	}
}


extension Float3 : Equatable
{
	public static func ==(a:Float3, b:Float3) -> Bool {
		return a.simdValue == b.simdValue
	}
}


extension Float3 : Comparable
{
	public static func < (a:Float3, b:Float3) -> Bool {
		return (a.x < b.x) && (a.y < b.y) && (a.z < b.z)
	}
	
	public static func <= (a:Float3, b:Float3) -> Bool {
		return (a.x <= b.x) && (a.y <= b.y) && (a.z <= b.z)
	}
	
	public static func > (a:Float3, b:Float3) -> Bool {
		return (a.x > b.x) && (a.y > b.y) && (a.z > b.z)
	}
	
	public static func >= (a:Float3, b:Float3) -> Bool {
		return (a.x >= b.x) && (a.y >= b.y) && (a.z >= b.z)
	}
}


extension Float3 // Basic Math Operations
{
	public static func + (a:Float3, b:Float3) -> Float3 {
		return Float3(a.simdValue + b.simdValue)
	}
	public static func += (v:inout Float3, o:Float3) {
		v = v + o
	}
	
	
	public static func - (a:Float3, b:Float3) -> Float3 {
		return Float3(a.simdValue - b.simdValue)
	}
	public static func -= (v:inout Float3, o:Float3) {
		v = v - o
	}
	
	
	public static func * (a:Float3, b:Float3) -> Float3 {
		return Float3(a.simdValue * b.simdValue)
	}
	public static func *= (v:inout Float3, o:Float3) {
		v = v * o
	}
	
	
	public static func / (a:Float3, b:Float3) -> Float3 {
		return Float3(a.simdValue / b.simdValue)
	}
	public static func /= (v:inout Float3, o:Float3) {
		v = v / o
	}
	
	
	public static func % (a:Float3, b:Float3) -> Float3 {
		return Float3(a.x.truncatingRemainder(dividingBy: b.x), a.y.truncatingRemainder(dividingBy: b.y), a.z.truncatingRemainder(dividingBy: b.z))
	}
	public static func %= (v:inout Float3, o:Float3) {
		v = v % o
	}
	
	
	public static prefix func - (v:Float3) -> Float3 {
		return Float3(-v.simdValue)
	}
}


extension Float3 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083, 4_259_235_067 ]
	
	#if swift(>=4.2)
		public func hash(into hasher:inout Hasher) {
			[ self.x, self.y, self.z ].forEach{ hasher.combine($0) }
		}
	#else
		public var hashValue:Int {
			let uintHashValue = [ self.x, self.y, self.z ].enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Float)) in
				let elementHash = UInt(element.value.bitPattern) &* Float3._hashingLargePrimes[element.index]
				return hashValue &+ elementHash
			}
			return Int(bitPattern: uintHashValue)
		}
	#endif
}

