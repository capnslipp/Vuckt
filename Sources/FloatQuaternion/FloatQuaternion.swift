// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation
import simd
import SceneKit.SceneKitTypes
#if !os(watchOS)
	import GLKit.GLKQuaternion
	import GameController.GCMotion
#endif
#if !os(tvOS)
	import CoreMotion.CMAttitude
#endif



fileprivate let SquareRootOfOneHalf = Float(0.5).squareRoot()



public typealias Quaternion = FloatQuaternion

extension FloatQuaternion
{
	// MARK: `init`s
	
	/// Initialize a vector with the specified elements.
	public init(_ ix:Float, _ iy:Float, _ iz:Float, _ r:Float) {
		self.init(ix: ix, iy: iy, iz: iz, r: r)
	}
	
	/// Initialize to a SIMD vector.
	public init(_ value:simd_quatf) {
		self = FloatQuaternionFromSimd(value)
	}
	
	/// Initialize to a vector with elements taken from `array`.
	///
	/// - Precondition: `array` must have exactly three elements.
	public init(array:[Float]) {
		precondition(array.count == 4)
		self.init(array[0], array[1], array[2], array[3])
	}
	
	/// Initialize using the given 4-element tuple.
	public init(tuple:(ix:Float,iy:Float,iz:Float,r:Float)) {
		self.init(tuple.ix, tuple.iy, tuple.iz, tuple.r)
	}
	
	/// Initialize using an `Float3` as the `ix`, `iy`, `iz` values.
	public init(xyz:Float3, r:Float?=nil) {
		self.init(xyz[0], xyz[1], xyz[2], r ?? 0)
	}
	
	
	// MARK: commonly-used “presets”
	
	public static let identity = FloatQuaternion(0, 0, 0, 1)
	
	public static let rotation90AroundX = FloatQuaternion(SquareRootOfOneHalf, 0, 0, SquareRootOfOneHalf)
	public static let rotation90AroundY = FloatQuaternion(0, SquareRootOfOneHalf, 0, SquareRootOfOneHalf)
	public static let rotation90AroundZ = FloatQuaternion(0, 0, SquareRootOfOneHalf, SquareRootOfOneHalf)
	
	public static let rotation180AroundX = FloatQuaternion(1, 0, 0, 0)
	public static let rotation180AroundY = FloatQuaternion(0, 1, 0, 0)
	public static let rotation180AroundZ = FloatQuaternion(0, 0, 1, 0)
	
	public static let rotation270AroundX = FloatQuaternion(-SquareRootOfOneHalf, 0, 0, SquareRootOfOneHalf)
	public static let rotation270AroundY = FloatQuaternion(0, -SquareRootOfOneHalf, 0, SquareRootOfOneHalf)
	public static let rotation270AroundZ = FloatQuaternion(0, 0, -SquareRootOfOneHalf, SquareRootOfOneHalf)
	
	
	
	// MARK: `subscript`-Getter
	
	/// Access individual elements of the vector via subscript.
	public subscript(index:Float) -> Float {
		get {
			switch index {
				case 0: return self.ix
				case 1: return self.iy
				case 2: return self.iz
				case 3: return self.r
				
				default: return Float.nan // TODO: Instead, do whatever simd_quatf does.
			}
		}
		set {
			switch index {
				case 0: self.ix = newValue
				case 1: self.iy = newValue
				case 2: self.iz = newValue
				case 3: self.r = newValue
				
				default: break // TODO: Instead, do whatever simd_quatf does.
			}
		}
	}
	
	
	// MARK: `replace` Functionality
	
	public mutating func replace(ix:Float?=nil, iy:Float?=nil, iz:Float?=nil, r:Float?=nil) {
		if let ixValue = ix { self.ix = ixValue }
		if let iyValue = iy { self.iy = iyValue }
		if let izValue = iz { self.iz = izValue }
		if let rValue = r { self.r = rValue }
	}
	public func replacing(ix:Float?=nil, iy:Float?=nil, iz:Float?=nil, r:Float?=nil) -> FloatQuaternion {
		return FloatQuaternion(
			ix ?? self.ix,
			iy ?? self.iy,
			iz ?? self.iz,
			r ?? self.r
		)
	}
	
	
	// MARK: `asTuple` Functionality
	
	public var asTuple:(ix:Float,iy:Float,iz:Float,r:Float) {
		return ( self.ix, self.iy, self.iz, self.r )
	}
	
	
	// MARK: Angle/Axis Initializer & Accessors
	
	public init(angle angle_radians:Float, axis:Float3) {
		self = FloatQuaternion(simd_quaternion(angle_radians, axis.simdValue))
	}
	@available(macOS 10.12, iOS 10.10, tvOS 10.10, *)
	public init(angle angleMeasurement:Measurement<UnitAngle>, axis:Float3) {
		let angleRadiansMeasurement = angleMeasurement.converted(to: .radians)
		self.init(angle: Float(angleRadiansMeasurement.value), axis: axis)
	}
	
	public var angle:Float {
		get { return simd_angle(self.simdValue) }
		set {
			let existingAxis = Float3(simd_axis(self.simdValue))
			self = FloatQuaternion(angle: newValue, axis: existingAxis)
		}
	}
	@available(macOS 10.12, iOS 10.10, tvOS 10.10, *)
	public var angleMeasurement:Measurement<UnitAngle> {
		get { return Measurement<UnitAngle>(value: Double(self.angle), unit: .radians) }
		set {
			let angleRadiansMeasurement = newValue.converted(to: .radians)
			self.angle = Float(angleRadiansMeasurement.value)
		}
	}
	
	public var axis:Float3 {
		get { return Float3(simd_axis(self.simdValue)) }
		set {
			let existingAngle = simd_angle(self.simdValue)
			self = FloatQuaternion(angle: existingAngle, axis: newValue)
		}
	}
	
	public var angleAxis:(Float, Float3) {
		get { return ( self.angle, self.axis ) }
		set { self = FloatQuaternion(angle: newValue.0, axis: newValue.1) }
	}
	@available(macOS 10.12, iOS 10.10, tvOS 10.10, *)
	public var angleMeasurementAxis:(Measurement<UnitAngle>, Float3) {
		get { return ( self.angleMeasurement, self.axis ) }
		set { self = FloatQuaternion(angle: newValue.0, axis: newValue.1) }
	}
	
	public init(eulerAngles eulerAngles_radians:Float3, order:RotationOrder = .zxy) {
		let sinOfHalfAngles = __tg_sin(eulerAngles_radians.simdValue * 0.5)
		let cosOfHalfAngles = __tg_cos(eulerAngles_radians.simdValue * 0.5)
		
		let xRotation = Self(sinOfHalfAngles.x, 0, 0, cosOfHalfAngles.x)
		let yRotation = Self(0, sinOfHalfAngles.y, 0, cosOfHalfAngles.y)
		let zRotation = Self(0, 0, sinOfHalfAngles.z, cosOfHalfAngles.z)
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
	
	/// It is necessary to normalize the `fromUnitVector` and `toUnitVector` to be unit-length in order to result in a normal rotation Quaternion.
	public init(from fromUnitVector:Float3, to toUnitVector:Float3) {
		self = FloatQuaternion(simd_quaternion(fromUnitVector.simdValue, toUnitVector.simdValue))
	}
	
	public init(from fromVector:Float3, to toVector:Float3, axisWhenVectorsAreOpposed:Float3)
	{
		// Based on http://lolengine.net/blog/2014/02/24/quaternion-from-two-vectors-final
		// TODO: Make this more efficient— normalizing on the spot isn't the fasted way to check if they're opposed, but I know it works.
		// TODO: Check that the `normalsDot` vs. `-1` works in practice with float accuracy.  Check against the LOLEngine implementation (also used by Unreal Engine).
		let normalsDot = dotProductOf(fromVector.normalized(), toVector.normalized())
		if normalsDot < (-1.0 + Float.leastNormalMagnitude) {
			self = FloatQuaternion(angle: Float.pi, axis: axisWhenVectorsAreOpposed)
		} else {
			self = FloatQuaternion(from: fromVector, to: toVector)
		}
	}
	
	
	// MARK: Real- & Imaginary-Part Accessors
	
	public var realPartValue:Float {
		get { return self.simdValue.real }
		set {
			var simdValue = self.simdValue
			simdValue.real = newValue
			self = FloatQuaternion(simdValue)
		}
	}
	
	public var imaginaryPartValue:Float3 {
		get { return Float3(self.simdValue.imag) }
		set {
			var simdValue = self.simdValue
			simdValue.imag = newValue.simdValue
			self = FloatQuaternion(simdValue)
		}
	}
	
	
	// MARK: `simdValue` Functionality
	
	public var simdValue:simd_quatf {
		return FloatQuaternionToSimd(self)
	}
}


extension FloatQuaternion // SceneKit Conversion
{
	/// Initialize to a SceneKit quaternion.
	public init(scnQuaternion value:SCNQuaternion) {
		self = FloatQuaternionFromSCN(value)
	}
	
	public var toSCNQuaternion:SCNQuaternion {
		return FloatQuaternionToSCN(self)
	}
}

#if !os(watchOS)
	extension FloatQuaternion // GLKit Conversion
	{
		/// Initialize to a GLKit quaternion.
		public init(glkQuaternion value:GLKQuaternion) {
			self = FloatQuaternionFromGLK(value)
		}
		
		public var toGLKQuaternion:GLKQuaternion {
			return FloatQuaternionToGLK(self)
		}
	}
#endif // !watchOS

#if !os(tvOS)
	extension FloatQuaternion // CoreMotion Conversion
	{
		/// Initialize to a CoreMotion quaternion.
		public init(cmQuaternion value:CMQuaternion) {
			self = FloatQuaternionFromCM(value)
		}
		
		public var toCMQuaternion:CMQuaternion {
			return FloatQuaternionToCM(self)
		}
	}
#endif // !tvOS

#if !os(watchOS)
	extension FloatQuaternion // GameController Conversion
	{
		/// Initialize to a GameController quaternion.
		public init(gcQuaternion value:GCQuaternion) {
			self = FloatQuaternionFromGC(value)
		}
		
		public var toGCQuaternion:GCQuaternion {
			return FloatQuaternionToGC(self)
		}
	}
#endif // !watchOS


extension FloatQuaternion : CustomStringConvertible
{
	public var description:String {
		return "(\(self.ix), \(self.iy), \(self.iz), \(self.r))"
	}
}


extension FloatQuaternion : ExpressibleByArrayLiteral
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


extension FloatQuaternion : Equatable
{
	public static func ==(a:FloatQuaternion, b:FloatQuaternion) -> Bool {
		return simd_equal(a.simdValue.vector, b.simdValue.vector)
	}
}


extension FloatQuaternion // Quaternion Math Operations
{
	@_transparent public static func + (a:FloatQuaternion, b:FloatQuaternion) -> FloatQuaternion {
		return FloatQuaternion(simd_add(a.simdValue, b.simdValue))
	}
	@_transparent public static func += (v:inout FloatQuaternion, o:FloatQuaternion) {
		v = v + o
	}
	
	
	@_transparent public static func - (a:FloatQuaternion, b:FloatQuaternion) -> FloatQuaternion {
		return FloatQuaternion(simd_sub(a.simdValue, b.simdValue))
	}
	@_transparent public static func -= (v:inout FloatQuaternion, o:FloatQuaternion) {
		v = v - o
	}
	
	
	@_transparent public static prefix func - (v:FloatQuaternion) -> FloatQuaternion { return v.negated() }
	@_transparent public func negated() -> FloatQuaternion {
		return FloatQuaternion(simd_negate(self.simdValue))
	}
	@_transparent public mutating func negate() {
		self = self.negated()
	}
	
	
	@_transparent public static func * (a:FloatQuaternion, b:FloatQuaternion) -> FloatQuaternion { return a.hamiltonProduct(b) }
	@_transparent public static func / (a:FloatQuaternion, b:FloatQuaternion) -> FloatQuaternion {
		return a.hamiltonProduct(b.inversed())
	}
	@_transparent public func hamiltonProduct(_ other:FloatQuaternion) -> FloatQuaternion {
		return hamiltonProductOf(self, other)
	}
	@_transparent public static func *= (q:inout FloatQuaternion, o:FloatQuaternion) { q.formHamiltonProduct(o) }
	@_transparent public static func /= (q:inout FloatQuaternion, o:FloatQuaternion) {
		q.formHamiltonProduct(o.inversed())
	}
	@_transparent public mutating func formHamiltonProduct(_ other:FloatQuaternion) {
		self = hamiltonProductOf(self, other)
	}
	
	
	@_transparent public static func * (q:FloatQuaternion, scale:Float) -> FloatQuaternion { return q.scaled(by: scale) }
	@_transparent public static func / (q:FloatQuaternion, inverseScale:Float) -> FloatQuaternion {
		return q.scaled(by: 1.0 / inverseScale)
	}
	@_transparent public func scaled(by scale:Float) -> FloatQuaternion {
		return FloatQuaternion(simd_mul(self.simdValue, scale))
	}
	@_transparent public static func *= (q:inout FloatQuaternion, scale:Float) { q.scale(by: scale) }
	@_transparent public static func /= (q:inout FloatQuaternion, inverseScale:Float) {
		q.scale(by: 1.0 / inverseScale)
	}
	@_transparent public mutating func scale(by scale:Float) {
		self = self.scaled(by: scale)
	}
	
	
	@_transparent public static func * (q:FloatQuaternion, vector:Float3) -> Float3 { return q.rotate(vector) }
	@_transparent public func rotate(_ vector:Float3) -> Float3 {
		return Float3(simd_act(self.simdValue, vector.simdValue))
	}
	@_transparent public func unrotate(_ vector:Float3) -> Float3 {
		return self.inversed().rotate(vector)
	}
	
	
	@_transparent public func dotProduct(_ other:FloatQuaternion) -> Float {
		return dotProductOf(self, other)
	}
	
	
	@_transparent public func inversed() -> FloatQuaternion {
		return FloatQuaternion(simd_inverse(self.simdValue))
	}
	@_transparent public mutating func inverse() {
		self = self.inversed()
	}
	
	
	@_transparent public func conjugated() -> FloatQuaternion {
		return FloatQuaternion(simd_conjugate(self.simdValue))
	}
	@_transparent public mutating func conjugate() {
		self = self.conjugated()
	}
	
	
	@_transparent public func normalized() -> FloatQuaternion {
		return FloatQuaternion(simd_normalize(self.simdValue))
	}
	@_transparent public mutating func normalize() {
		self = self.normalized()
	}
	
	
	@_transparent public func length() -> Float {
		return simd_length(self.simdValue)
	}
	@_transparent public func magnitude() -> Float { return self.length() }
	
	
	public enum SphericalLinearInterpolationMethod {
		case shortest
		case longest
	}
	public enum SphericalCubicInterpolationMethod {
		case bezier
		case spline
	}
	@_transparent public func interpolated(to other:FloatQuaternion, ratio:Float, method:FloatQuaternion.SphericalLinearInterpolationMethod = .shortest) -> FloatQuaternion {
		return interpolateBetween(self, other, ratio: ratio, method: method)
	}
	@_transparent public mutating func interpolate(to other:FloatQuaternion, ratio:Float, method:FloatQuaternion.SphericalLinearInterpolationMethod = .shortest) {
		self = interpolateBetween(self, other, ratio: ratio, method: method)
	}
	@_transparent public func interpolated(to other:FloatQuaternion, control1:FloatQuaternion, control2:FloatQuaternion, ratio:Float, method:FloatQuaternion.SphericalCubicInterpolationMethod) -> FloatQuaternion {
		return interpolateBetween(self, control1, control2, other, ratio: ratio, method: method)
	}
	@_transparent public mutating func interpolate(to other:FloatQuaternion, control1:FloatQuaternion, control2:FloatQuaternion, ratio:Float, method:FloatQuaternion.SphericalCubicInterpolationMethod) {
		self = interpolateBetween(self, control1, control2, other, ratio: ratio, method: method)
	}
}

@_transparent public func hamiltonProductOf(_ a:FloatQuaternion, _ b:FloatQuaternion) -> FloatQuaternion {
	return FloatQuaternion(simd_mul(a.simdValue, b.simdValue))
}

@_transparent public func dotProductOf(_ a:FloatQuaternion, _ b:FloatQuaternion) -> Float {
	return simd_dot(a.simdValue, b.simdValue)
}

@_transparent public func interpolateBetween(_ a:FloatQuaternion, _ b:FloatQuaternion, ratio:Float, method:FloatQuaternion.SphericalLinearInterpolationMethod = .shortest) -> FloatQuaternion
{
	switch method {
		case .shortest:
			return FloatQuaternion(simd_slerp(a.simdValue, b.simdValue, ratio))
		case .longest:
			return FloatQuaternion(simd_slerp_longest(a.simdValue, b.simdValue, ratio))
	}
}

@_transparent public func interpolateBetween(_ a:FloatQuaternion, _ control1:FloatQuaternion, _ control2:FloatQuaternion, _ b:FloatQuaternion, ratio:Float, method:FloatQuaternion.SphericalCubicInterpolationMethod) -> FloatQuaternion
{
	switch method {
		case .bezier:
			return FloatQuaternion(simd_bezier(a.simdValue, control1.simdValue, control2.simdValue, b.simdValue, ratio))
		case .spline:
			return FloatQuaternion(simd_spline(a.simdValue, control1.simdValue, control2.simdValue, b.simdValue, ratio)) // TODO: Verify that the `a`/`b` start/end points and control point args are in the right order.
	}
}


extension FloatQuaternion : Hashable
{
	private static let _hashingLargePrimes:[UInt] = [ 982_917_223, 3_572_352_083, 4_259_235_067, 454_923_701 ]
	
	#if swift(>=4.2)
		public func hash(into hasher:inout Hasher) {
			[ self.ix, self.iy, self.iz, self.r ].forEach{ hasher.combine($0) }
		}
	#else
		public var hashValue:Int {
			let uintHashValue = [ self.ix, self.iy, self.iz, self.r ].enumerated().reduce(UInt(0)){ (hashValue, element:(index:Int,value:Float)) in
				let elementHash = UInt(element.value.bitPattern) &* FloatQuaternion._hashingLargePrimes[element.index]
				return hashValue &+ elementHash
			}
			return Int(bitPattern: uintHashValue)
		}
	#endif
}
