// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd



extension Float4
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	public init(_ x:Float, _ y:Float, _ z:Float, _ w:Float) {
		self.init(x: x, y: y, z: z, w: w)
	}
	
	/// Initialize to a vector with all elements equal to `scalar`.
	public init(_ scalar:Float) {
		self.init(scalar, scalar, scalar, scalar)
	}
	
	/// Initialize a vector with the specified elements.
	public init(x:Float) {
		self.init(x, 0, 0, 0)
	}
	public init(y:Float) {
		self.init(0, y, 0, 0)
	}
	public init(z:Float) {
		self.init(0, 0, z, 0)
	}
	public init(w:Float) {
		self.init(0, 0, 0, w)
	}
	public init(x:Float, y:Float) {
		self.init(x, y, 0, 0)
	}
	public init(x:Float, z:Float) {
		self.init(x, 0, z, 0)
	}
	public init(x:Float, w:Float) {
		self.init(x, 0, 0, w)
	}
	public init(y:Float, z:Float) {
		self.init(0, y, z, 0)
	}
	public init(y:Float, w:Float) {
		self.init(0, y, 0, w)
	}
	public init(z:Float, w:Float) {
		self.init(0, 0, z, w)
	}
	public init(x:Float, y:Float, z:Float) {
		self.init(x, y, z, 0)
	}
	public init(x:Float, y:Float, w:Float) {
		self.init(x, y, 0, w)
	}
	public init(x:Float, z:Float, w:Float) {
		self.init(x, 0, z, w)
	}
	public init(y:Float, z:Float, w:Float) {
		self.init(0, y, z, w)
	}
	
	/// Initialize to a SIMD vector.
	public init(_ value:simd.float4) {
		self = Float4FromSimd(value)
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly three elements.
	public init(array:[Float]) {
		precondition(array.count == 4)
		self.init(array[0], array[1], array[2], array[3])
	}
	
	/// Initialize using the given 4-element tuple.
	public init(tuple:(x:Float,y:Float,z:Float,w:Float)) {
		self.init(tuple.x, tuple.y, tuple.z, tuple.w)
	}
	
	/// Initialize using an `Float2` as the `x` & `y` values.
	public init(xy:Float2, z:Float?=nil, w:Float?=nil) {
		self.init(xy[0], xy[1], z ?? 0, w ?? 0)
	}
	/// Initialize using an `Float2` as the `x` & `z` values.
	public init(xz:Float2, y:Float?=nil, w:Float?=nil) {
		self.init(xz[0], y ?? 0, xz[1], w ?? 0)
	}
	/// Initialize using an `Float2` as the `x` & `w` values.
	public init(xw:Float2, y:Float?=nil, z:Float?=nil) {
		self.init(xw[0], y ?? 0, z ?? 0, xw[1])
	}
	/// Initialize using an `Float2` as the `y` & `z` values.
	public init(yz:Float2, x:Float?=nil, w:Float?=nil) {
		self.init(x ?? 0, yz[0], yz[1], w ?? 0)
	}
	/// Initialize using an `Float2` as the `y` & `w` values.
	public init(yw:Float2, x:Float?=nil, z:Float?=nil) {
		self.init(x ?? 0, yw[0], z ?? 0, yw[1])
	}
	/// Initialize using an `Float2` as the `z` & `w` values.
	public init(zw:Float2, x:Float?=nil, y:Float?=nil) {
		self.init(x ?? 0, y ?? 0, zw[0], zw[1])
	}
	
	/// Initialize using an `Float3` as the `x`, `y`, `z` values.
	public init(xyz:Float3, w:Float?=nil) {
		self.init(xyz[0], xyz[1], xyz[2], w ?? 0)
	}
	/// Initialize using an `Float3` as the `x`, `y`, `w` values.
	public init(xyw:Float3, z:Float?=nil) {
		self.init(xyw[0], xyw[1], z ?? 0, xyw[2])
	}
	/// Initialize using an `Float3` as the `x`, `z`, `w` values.
	public init(xzw:Float3, y:Float?=nil) {
		self.init(xzw[0], y ?? 0, xzw[1], xzw[2])
	}
	/// Initialize using an `Float3` as the `y`, `z`, `w` values.
	public init(yzw:Float3, x:Float?=nil) {
		self.init(x ?? 0, yzw[0], yzw[1], yzw[2])
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let zero = Float4(0)
	
	public static let unitPositive = Float4(1)
	public static let unitNegative = Float4(-1)
	
	public static let unitXPositive = Float4(x: 1)
	public static let unitYPositive = Float4(y: 1)
	public static let unitZPositive = Float4(z: 1)
	public static let unitWPositive = Float4(w: 1)
	public static let unitXNegative = Float4(x: -1)
	public static let unitYNegative = Float4(y: -1)
	public static let unitZNegative = Float4(z: -1)
	public static let unitWNegative = Float4(w: -1)
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	public subscript(index:Float) -> Float {
		switch index {
			case 0: return self.x
			case 1: return self.y
			case 2: return self.z
			case 3: return self.w
			
			default: return Float.nan // TODO: Instead, do whatever simd.float4 does.
		}
	}
	
	
	// MARK: `replace` Functionality
	
	public mutating func replace(x:Float?=nil, y:Float?=nil, z:Float?=nil, w:Float?=nil) {
		if let xValue = x { self.x = xValue }
		if let yValue = y { self.y = yValue }
		if let zValue = z { self.z = zValue }
		if let wValue = w { self.w = wValue }
	}
	public func replacing(x:Float?=nil, y:Float?=nil, z:Float?=nil, w:Float?=nil) -> Float4 {
		return Float4(
			x ?? self.x,
			y ?? self.y,
			z ?? self.z,
			w ?? self.w
		)
	}
	
	
	// MARK: `clamp` Functionality
	
	public mutating func clamp(to range:ClosedRange<Float4>) {
		self = self.clamped(to: range)
	}
	public func clamped(to range:ClosedRange<Float4>) -> Float4 {
		return Float4(simd.clamp(self.simdValue, min: range.lowerBound.simdValue, max: range.upperBound.simdValue))
	}
	
	
	// MARK: `random` Functionality
	
	public static func random(in range:ClosedRange<Float4>) -> Float4 {
		return Float4(
			Float.random(in: range.lowerBound.x...range.upperBound.x),
			Float.random(in: range.lowerBound.y...range.upperBound.y),
			Float.random(in: range.lowerBound.z...range.upperBound.z),
			Float.random(in: range.lowerBound.w...range.upperBound.w)
		)
	}
	
	public static func random(in range:Range<Float4>) -> Float4 {
		return Float4(
			Float.random(in: range.lowerBound.x..<range.upperBound.x),
			Float.random(in: range.lowerBound.y..<range.upperBound.y),
			Float.random(in: range.lowerBound.z..<range.upperBound.z),
			Float.random(in: range.lowerBound.w..<range.upperBound.w)
		)
	}
	
	
	// MARK: `asTuple` Functionality
	
	public var asTuple:(x:Float,y:Float,z:Float,w:Float) {
		return ( self.x, self.y, self.z, self.w )
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
	public var xw:Float2 {
		get { return Float2(xw: self) }
		set { ( self.x, self.w ) = ( newValue[0], newValue[1] ) }
	}
	public var yz:Float2 {
		get { return Float2(yz: self) }
		set { ( self.y, self.z ) = ( newValue[0], newValue[1] ) }
	}
	public var yw:Float2 {
		get { return Float2(yw: self) }
		set { ( self.y, self.w ) = ( newValue[0], newValue[1] ) }
	}
	public var zw:Float2 {
		get { return Float2(zw: self) }
		set { ( self.z, self.w ) = ( newValue[0], newValue[1] ) }
	}
	
	
	// MARK: 3-component (`Float3`) Accessors
	
	public var xyz:Float3 {
		get { return Float3(xyz: self) }
		set { ( self.x, self.y, self.z ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	public var xyw:Float3 {
		get { return Float3(xyw: self) }
		set { ( self.x, self.y, self.w ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	public var xzw:Float3 {
		get { return Float3(xzw: self) }
		set { ( self.x, self.z, self.w ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	public var yzw:Float3 {
		get { return Float3(yzw: self) }
		set { ( self.y, self.z, self.w ) = ( newValue[0], newValue[1], newValue[2] ) }
	}
	
	
	// MARK: `simdValue` Functionality
	
	public var simdValue:simd.float4 {
		return Float4ToSimd(self)
	}
}


extension Float4 // SceneKit Conversion
{
	/// Initialize to a SceneKit vector.
	public init(scnVector value:SCNVector4) {
		self = Float4FromSCN(value)
	}
	
	public var toSCNVector:SCNVector4 {
		return Float4ToSCN(self)
	}
}

extension Float4 // GLKit Conversion
{
	/// Initialize to a GLKit vector.
	public init(glkVector value:GLKVector4) {
		self = Float4FromGLK(value)
	}
	
	public var toGLKVector:GLKVector4 {
		return Float4ToGLK(self)
	}
}

extension Float4 // CoreImage Conversion
{
	/// Initialize to a CoreImage vector.
	public init(ciVector:CIVector) {
		self = Float4FromCI(ciVector)
	}
	
	public var toCIVector:CIVector {
		return Float4ToCI(self)
	}
}


extension Float4 : CustomStringConvertible
{
	public var description:String {
		return "(\(self.x), \(self.y), \(self.z), \(self.w))"
	}
}


// MARK: Element-wise `min`/`max`

public func min(_ a:Float4, _ b:Float4) -> Float4 {
	return Float4(simd.min(a.simdValue, b.simdValue))
}

public func min(_ a:Float4, _ b:Float4, _ c:Float4, _ rest:Float4...) -> Float4 {
	var minSimdValue = simd.min(simd.min(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		minSimdValue = simd.min(minSimdValue, value.simdValue)
	}
	return Float4(minSimdValue)
}

public func max(_ a:Float4, _ b:Float4) -> Float4 {
	return Float4(simd.max(a.simdValue, b.simdValue))
}

public func max(_ a:Float4, _ b:Float4, _ c:Float4, _ rest:Float4...) -> Float4 {
	var maxSimdValue = simd.max(simd.max(a.simdValue, b.simdValue), c.simdValue)
	for value in rest {
		maxSimdValue = simd.max(maxSimdValue, value.simdValue)
	}
	return Float4(maxSimdValue)
}


extension Float4 : ExpressibleByArrayLiteral
{
	public typealias Element = Float
	
	/// Initialize using `arrayLiteral`.
	///
	/// - Precondition: the array literal must exactly three elements.
	public init(arrayLiteral elements:Float...) {
		precondition(elements.count == 4)
		self.init(elements[0], elements[1], elements[2], elements[3])
	}
}


extension Float4 : Equatable
{
	public static func ==(a:Float4, b:Float4) -> Bool {
		return a.simdValue == b.simdValue
	}
}


extension Float4 : Comparable
{
	public static func < (a:Float4, b:Float4) -> Bool {
		return (a.x < b.x) && (a.y < b.y) && (a.z < b.z) && (a.w < b.w)
	}
	
	public static func <= (a:Float4, b:Float4) -> Bool {
		return (a.x <= b.x) && (a.y <= b.y) && (a.z <= b.z) && (a.w <= b.w)
	}
	
	public static func > (a:Float4, b:Float4) -> Bool {
		return (a.x > b.x) && (a.y > b.y) && (a.z > b.z) && (a.w > b.w)
	}
	
	public static func >= (a:Float4, b:Float4) -> Bool {
		return (a.x >= b.x) && (a.y >= b.y) && (a.z >= b.z) && (a.w >= b.w)
	}
}


extension Float4 // Basic Math Operations
{
	public static func + (a:Float4, b:Float4) -> Float4 {
		return Float4(a.simdValue + b.simdValue)
	}
	public static func += (v:inout Float4, o:Float4) {
		v = v + o
	}
	
	
	public static func - (a:Float4, b:Float4) -> Float4 {
		return Float4(a.simdValue - b.simdValue)
	}
	public static func -= (v:inout Float4, o:Float4) {
		v = v - o
	}
	
	
	public static func * (a:Float4, b:Float4) -> Float4 {
		return Float4(a.simdValue * b.simdValue)
	}
	public static func *= (v:inout Float4, o:Float4) {
		v = v * o
	}
	
	
	public static func / (a:Float4, b:Float4) -> Float4 {
		return Float4(a.simdValue / b.simdValue)
	}
	public static func /= (v:inout Float4, o:Float4) {
		v = v / o
	}
	
	
	public static func % (a:Float4, b:Float4) -> Float4 {
		return Float4(a.x.truncatingRemainder(dividingBy: b.x), a.y.truncatingRemainder(dividingBy: b.y), a.z.truncatingRemainder(dividingBy: b.z), a.w.truncatingRemainder(dividingBy: b.w))
	}
	public static func %= (v:inout Float4, o:Float4) {
		v = v % o
	}
	
	
	public static prefix func - (v:Float4) -> Float4 {
		return Float4(-v.simdValue)
	}
}


extension Float4 : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083, 4_259_235_067, 454_923_701 ]
	
	public var hashValue:Int {
		let uintHashValue = [ self.x, self.y, self.z, self.w ].enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Float)) in
			let elementHash = UInt(element.value.bitPattern) &* Float4._hashingLargePrimes[element.index]
			return hashValue &+ elementHash
		}
		return Int(bitPattern: uintHashValue)
	}
}
