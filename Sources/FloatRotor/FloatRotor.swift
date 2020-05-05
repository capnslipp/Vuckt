// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd



public typealias Rotor = FloatRotor

extension FloatRotor
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	public init(_ bYZ:Float, _ bZX:Float, _ bXY:Float, _ s:Float) {
		self.init(bYZ: bYZ, bZX: bZX, bXY: bXY, s: s)
	}
	
	/// Initialize to a SIMD vector.
	public init(_ value:simd_float4) {
		self = FloatRotorFromSimd(value)
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly three elements.
	public init(array:[Float]) {
		precondition(array.count == 4)
		self.init(array[0], array[1], array[2], array[3])
	}
	
	/// Initialize using the given 4-element tuple.
	public init(tuple:(bYZ:Float,bZX:Float,bXY:Float,s:Float)) {
		self.init(tuple.bYZ, tuple.bZX, tuple.bXY, tuple.s)
	}
	
	/// Initialize using an `Float3` as the `bXY`, `bZX`, `bYZ` values.
	public init(b:Float3, s:Float?=nil) {
		self.init(b[0], b[1], b[2], s ?? 1.0)
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let identity = FloatRotor(0, 0, 0, 1)
	
	public static let rotation90AroundX = FloatRotor(-SquareRootOfOneHalf, 0, 0, SquareRootOfOneHalf)
	public static let rotation90AroundY = FloatRotor(0, -SquareRootOfOneHalf, 0, SquareRootOfOneHalf)
	public static let rotation90AroundZ = FloatRotor(0, 0, -SquareRootOfOneHalf, SquareRootOfOneHalf)
	
	public static let rotation180AroundX = FloatRotor(-1, 0, 0, 0)
	public static let rotation180AroundY = FloatRotor(0, -1, 0, 0)
	public static let rotation180AroundZ = FloatRotor(0, 0, -1, 0)
	
	public static let rotation270AroundX = FloatRotor(-SquareRootOfOneHalf, 0, 0, -SquareRootOfOneHalf)
	public static let rotation270AroundY = FloatRotor(0, -SquareRootOfOneHalf, 0, -SquareRootOfOneHalf)
	public static let rotation270AroundZ = FloatRotor(0, 0, -SquareRootOfOneHalf, -SquareRootOfOneHalf)
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	public subscript(index:Float) -> Float {
		get {
			switch index {
				case 0: return self.bYZ
				case 1: return self.bZX
				case 2: return self.bXY
				case 3: return self.s
				
				default: return Float.nan // TODO: Instead, do whatever simd_quatf does.
			}
		}
		set {
			switch index {
				case 0: self.bYZ = newValue
				case 1: self.bZX = newValue
				case 2: self.bXY = newValue
				case 3: self.s = newValue
				
				default: break // TODO: Instead, do whatever simd_quatf does.
			}
		}
	}
	
	
	// MARK: `replace` Functionality
	
	public mutating func replace(bYZ:Float?=nil, bZX:Float?=nil, bXY:Float?=nil, s:Float?=nil) {
		if let bYZValue = bYZ { self.bYZ = bYZValue }
		if let bZXValue = bZX { self.bZX = bZXValue }
		if let bXYValue = bXY { self.bXY = bXYValue }
		if let sValue = s { self.s = sValue }
	}
	public func replacing(bYZ:Float?=nil, bZX:Float?=nil, bXY:Float?=nil, s:Float?=nil) -> FloatRotor {
		return FloatRotor(
			bYZ ?? self.bYZ,
			bZX ?? self.bZX,
			bXY ?? self.bXY,
			s ?? self.s
		)
	}
	
	
	// MARK: `as…` Functionality
	
	public var asTuple:(bYZ:Float,bZX:Float,bXY:Float,s:Float) {
		return ( self.bYZ, self.bZX, self.bXY, self.s )
	}
	
	@_transparent public var asArray:[Float] {
		return [ self.bYZ, self.bZX, self.bXY, self.s ]
	}
	
	
	// MARK: Matrix Conversion
	
	//@_transparent public init(rotation rotationMatrix:Float3x3) {
	//	self.init(simd_quaternion(rotationMatrbXY.simdValue))
	//}
	
	@_transparent public var toRotationMatrix:Float3x3 {
		return Float3x3(columns:
			self.rotate(Float3.unitX),
			self.rotate(Float3.unitY),
			self.rotate(Float3.unitZ)
		)
	}
	
	
	
	// MARK: Angle/Axis Initializer & Accessors
	
	public init(angle angle_radians:Float, axis:Float3) {
		self.init(angle: angle_radians, plane: axis)
	}
	@available(macOS 10.12, iOS 10.10, tvOS 10.10, *)
	public init(angle angleMeasurement:Measurement<UnitAngle>, axis:Float3) {
		let angleRadiansMeasurement = angleMeasurement.converted(to: .radians)
		self.init(angle: Float(angleRadiansMeasurement.value), axis: axis)
	}
	
	public init(angle angle_radians:Float, plane bivectorPlane:Float3) {
		self.init(
			b: -sin(angle_radians * 0.5) * bivectorPlane, // the left side of the products have b a, not a b, so flip
			s: cos(angle_radians * 0.5)
		)
	}
	@available(macOS 10.12, iOS 10.10, tvOS 10.10, *)
	public init(angle angleMeasurement:Measurement<UnitAngle>, plane bivectorPlane:Float3) {
		let angleRadiansMeasurement = angleMeasurement.converted(to: .radians)
		self.init(angle: Float(angleRadiansMeasurement.value), plane: bivectorPlane)
	}
	
	//public var angle:Float {
	//	get { return simd_angle(self.simdValue) }
	//	set {
	//		let existingAxis = Float3(simd_axis(self.simdValue))
	//		self = FloatRotor(angle: newValue, axis: existingAxis)
	//	}
	//}
	//@available(macOS 10.12, iOS 10.10, tvOS 10.10, *)
	//public var angleMeasurement:Measurement<UnitAngle> {
	//	get { return Measurement<UnitAngle>(value: Double(self.angle), unit: .radians) }
	//	set {
	//		let angleRadiansMeasurement = newValue.converted(to: .radians)
	//		self.angle = Float(angleRadiansMeasurement.value)
	//	}
	//}
	//
	//public var axis:Float3 {
	//	get { return Float3(simd_axis(self.simdValue)) }
	//	set {
	//		let existingAngle = simd_angle(self.simdValue)
	//		self = FloatRotor(angle: existingAngle, axis: newValue)
	//	}
	//}
	//
	//public var angleAxis:(Float, Float3) {
	//	get { return ( self.angle, self.axis ) }
	//	set { self = FloatRotor(angle: newValue.0, axis: newValue.1) }
	//}
	//@available(macOS 10.12, iOS 10.10, tvOS 10.10, *)
	//public var angleMeasurementAxis:(Measurement<UnitAngle>, Float3) {
	//	get { return ( self.angleMeasurement, self.axis ) }
	//	set { self = FloatRotor(angle: newValue.0, axis: newValue.1) }
	//}
	
	public init(eulerAngles eulerAngles_radians:Float3, order:RotationOrder = .zxy) {
		let sinOfHalfAngles = __tg_sin(eulerAngles_radians.simdValue * 0.5)
		let cosOfHalfAngles = __tg_cos(eulerAngles_radians.simdValue * 0.5)
		
		let xRotation = Self(-sinOfHalfAngles.x, 0, 0, cosOfHalfAngles.x)
		let yRotation = Self(0, -sinOfHalfAngles.y, 0, cosOfHalfAngles.y)
		let zRotation = Self(0, 0, -sinOfHalfAngles.z, cosOfHalfAngles.z)
		let rotationsInOrder:[Self] = {
			switch order {
				case .xyz: return [ xRotation, yRotation, zRotation ]
				case .xzy: return [ xRotation, zRotation, yRotation ]
				case .yxz: return [ yRotation, xRotation, zRotation ]
				case .yzx: return [ yRotation, zRotation, xRotation ]
				case .zxy: return [ zRotation, xRotation, yRotation ]
				case .zyx: return [ zRotation, yRotation, xRotation ]
			}
		}()
		
		self = rotationsInOrder[2] * rotationsInOrder[1] * rotationsInOrder[0]
	}
	@available(macOS 10.12, iOS 10.10, tvOS 10.10, *)
	@_transparent public init(eulerAngles eulerAnglesMeasurements:(x:Measurement<UnitAngle>,y:Measurement<UnitAngle>,z:Measurement<UnitAngle>), order:RotationOrder = .zxy) {
		let eulerAnglesMeasurements_radians = (
			x: eulerAnglesMeasurements.x.converted(to: .radians),
			y: eulerAnglesMeasurements.y.converted(to: .radians),
			z: eulerAnglesMeasurements.z.converted(to: .radians)
		)
		self.init(
			eulerAngles: Float3(
				Float(eulerAnglesMeasurements_radians.x.value),
				Float(eulerAnglesMeasurements_radians.y.value),
				Float(eulerAnglesMeasurements_radians.z.value)
			),
			order: order
		)
	}
	
	
	// MARK: From-To Initializer
	
	/// It is necessary to normalize the `fromUnitVector` and `toUnitVector` to be unit-length in order to result in a normal rotation Rotor.
	public init(from fromUnitVector:Float3, to toUnitVector:Float3) {
		self = FloatRotor(
			b: wedgeProductOf(toUnitVector, fromUnitVector), // the left side of the products have b a, not a b, so flip
			s: 1.0 + dotProductOf(fromUnitVector, toUnitVector)
		).normalized()
	}
	
	public init(from fromVector:Float3, to toVector:Float3, axisWhenVectorsAreOpposed:Float3)
	{
		// TODO: Make this more efficient— normalizing on the spot isn't the fasted way to check if they're opposed, but I know it works.
		// TODO: Check that the `normalsDot` vs. `-1` works in practice with float accuracy.  Check against the LOLEngine implementation (also used by Unreal Engine).
		let normalsDot = dotProductOf(fromVector.normalized(), toVector.normalized())
		if normalsDot < (-1.0 + Float.leastNormalMagnitude) {
			self.init(angle: Float.pi, axis: axisWhenVectorsAreOpposed)
		} else {
			self.init(from: fromVector, to: toVector)
		}
	}
	
	
	// MARK: Scalar- & Bivector-Part Accessors
	
	public var scalarPartValue:Float {
		get { return self.s }
		set { self = FloatRotor(b: self.bivectorPartValue, s: newValue) }
	}
	
	public var bivectorPartValue:Float3 {
		get { return Float3(self.bYZ, self.bZX, self.bXY) }
		set { self = FloatRotor(b: newValue, s: self.scalarPartValue) }
	}
	
	
	// MARK: `simdValue` Functionality
	
	public var simdValue:simd_float4 {
		return FloatRotorToSimd(self)
	}
}


extension FloatRotor : CustomStringConvertible
{
	public var description:String {
		return "(\(self.bYZ), \(self.bZX), \(self.bXY), \(self.s))"
	}
}


extension FloatRotor : ExpressibleByArrayLiteral
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


extension FloatRotor : Equatable
{
	public static func ==(a:FloatRotor, b:FloatRotor) -> Bool {
		return simd_equal(a.simdValue, b.simdValue)
	}
}


extension FloatRotor // Rotor Math Operations
{
	@_transparent public static func * (a:FloatRotor, b:FloatRotor) -> FloatRotor { return a.product(b) }
	//@_transparent public static func / (a:FloatRotor, b:FloatRotor) -> FloatRotor {
	//	return a.product(b.inversed())
	//}
	@_transparent public func product(_ other:FloatRotor) -> FloatRotor {
		return productOf(self, other)
	}
	@_transparent public static func *= (r:inout FloatRotor, o:FloatRotor) { r.formProduct(o) }
	//@_transparent public static func /= (r:inout FloatRotor, o:FloatRotor) {
	//	r.formProduct(o.inversed())
	//}
	@_transparent public mutating func formProduct(_ other:FloatRotor) {
		self = productOf(self, other)
	}
	
	
	@_transparent public static func * (r:FloatRotor, vector:Float3) -> Float3 { return r.rotate(vector) }
	public func rotate(_ vector:Float3) -> Float3 {
		let bivector = self.bivectorPartValue
		// q = P x (where P is `self`)
		let q:Float3 = (self.s * vector) + wedgeProductOf(vector, bivector)
		let trivector:Float = -dotProductOf(vector, bivector)
		// r = q P*
		let r:Float3 = (self.s * q) + wedgeProductOf(q, bivector) - (trivector * bivector)
		return r
	}
	//@_transparent public func unrotate(_ vector:Float3) -> Float3 {
	//	return self.inversed().rotate(vector)
	//}
	
	
	@_transparent public func reversed() -> FloatRotor {
		return FloatRotor(b: -self.bivectorPartValue, s: self.s)
	}
	@_transparent public mutating func reverse() {
		self = self.reversed()
	}
	
	
	@_transparent public func normalized() -> FloatRotor {
		let lengthReciprocal = 1.0 / self.length()
		return FloatRotor(self.simdValue * lengthReciprocal)
	}
	@_transparent public mutating func normalize() {
		self = self.normalized()
	}
	
	
	@_transparent public func length() -> Float {
		return self.lengthSquared().squareRoot()
	}
	/// Alias of: `length()`
	@_transparent public func magnitude() -> Float { return self.length() }
	
	@_transparent public func lengthSquared() -> Float {
		return simd_reduce_add(self.simdValue * self.simdValue)
	}
	/// Alias of: `lengthSquared()`
	@_transparent public func magnitudeSquared() -> Float { return self.lengthSquared() }
	
	
	//public enum SphericalLinearInterpolationMethod {
	//	case shortest
	//	case longest
	//}
	//public enum SphericalCubicInterpolationMethod {
	//	case bezier
	//	case spline
	//}
	//@_transparent public func interpolated(to other:FloatRotor, ratio:Float, //method:FloatRotor.SphericalLinearInterpolationMethod = .shortest) -> FloatRotor {
	//	return interpolateBetween(self, other, ratio: ratio, method: method)
	//}
	//@_transparent public mutating func interpolate(to other:FloatRotor, ratio:Float, //method:FloatRotor.SphericalLinearInterpolationMethod = .shortest) {
	//	self = interpolateBetween(self, other, ratio: ratio, method: method)
	//}
	//@_transparent public func interpolated(to other:FloatRotor, control1:FloatRotor, control2:FloatRotor, ratio:Float, //method:FloatRotor.SphericalCubicInterpolationMethod) -> FloatRotor {
	//	return interpolateBetween(self, control1, control2, other, ratio: ratio, method: method)
	//}
	//@_transparent public mutating func interpolate(to other:FloatRotor, control1:FloatRotor, control2:FloatRotor, //ratio:Float, method:FloatRotor.SphericalCubicInterpolationMethod) {
	//	self = interpolateBetween(self, control1, control2, other, ratio: ratio, method: method)
	//}
}

public func productOf(_ a:FloatRotor, _ b:FloatRotor) -> FloatRotor {
	let aBivector = a.bivectorPartValue
	let bBivector = b.bivectorPartValue
	return FloatRotor(
		b: (aBivector * b.s) + (a.s * bBivector) + wedgeProductOf(bBivector, aBivector),
		s: (a.s * b.s) - dotProductOf(aBivector, bBivector)
	)
}

/// Geometric product (for reference), produces twice the angle, negative direction.
public func geometricProductOf(_ a:Float3, _ b:Float3) -> FloatRotor {
	return FloatRotor(b: wedgeProductOf(a, b), s: dotProductOf(a, b))
}


extension FloatRotor : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083, 4_259_235_067, 454_923_701 ]
	
	#if swift(>=4.2)
		public func hash(into hasher:inout Hasher) {
			self.asArray.forEach{ hasher.combine($0) }
		}
	#else
		public var hashValue:Int {
			let uintHashValue = self.asArray.enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Float)) in
				let elementHash = UInt(element.value.bitPattern) &* FloatRotor._hashingLargePrimes[element.index]
				return hashValue &+ elementHash
			}
			return Int(bitPattern: uintHashValue)
		}
	#endif
}
