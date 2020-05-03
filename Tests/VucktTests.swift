// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import XCTest
import Vuckt
import simd



@_transparent func assertAlmostEqual<T>(
	_ expression1: @autoclosure () throws -> T,
	_ expression2: @autoclosure () throws -> T,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file,
	line: UInt = #line
) rethrows where T : FloatingPoint {
	let almostEqualTolerance = T.ulpOfOne.squareRoot() // from: https://github.com/apple/swift-evolution/blob/master/proposals/0259-approximately-equal.md
	try XCTAssertEqual(expression1(), expression2(), accuracy: almostEqualTolerance, message(), file: file, line: line)
}

@_transparent func assertAlmostEqual(
	_ expression1: @autoclosure () throws -> Float3,
	_ expression2: @autoclosure () throws -> Float3,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file,
	line: UInt = #line
) rethrows {
	let ( value1, value2 ) = try ( expression1(), expression2() )
	assertAlmostEqual(value1.x, value2.x, message(), file: file, line: line)
	assertAlmostEqual(value1.y, value2.y, message(), file: file, line: line)
	assertAlmostEqual(value1.z, value2.z, message(), file: file, line: line)
}



class VucktTests : XCTestCase
{
	static let _int2TestValues:[[Int32]] = [
		[ 0, 0 ],
		[ 1, 2 ],
		[ Int32.min, Int32.max ],
		[ -179_424_720, 2_038_074_496 ],
	]
	static let _int3TestValues:[[Int32]] = [
		[ 0, 0, 0 ],
		[ 1, 2, 3 ],
		[ Int32.min, Int32.max, Int32.min ],
		[ -179_424_720, 2_038_074_496, -982_450_304 ],
	]
	static let _int4TestValues:[[Int32]] = [
		[ 0, 0, 0, 0 ],
		[ 1, 2, 3, 4 ],
		[ Int32.min, Int32.max, Int32.min, Int32.max ],
		[ -179_424_720, 2_038_074_496, -982_450_304, 454_923_712 ],
	]
	static let _float2TestValues:[[Float]] = [
		[ 0, 0 ],
		[ 1, 2 ],
		[ Float.infinity, Float.leastNonzeroMagnitude ],
		[ -179_424_720, 2_038_074_496 ],
	]
	static let _float3RegularTestValues:[[Float]] = [
		[ 0, 0, 0 ],
		[ 1, 2, 3 ],
		[ -10, 26, 0.333 ],
		[ 0.1, 3.14159, -100 ],
	]
	static let _float3TestValues:[[Float]] = _float3RegularTestValues + [
		[ Float.infinity, Float.leastNonzeroMagnitude, Float.greatestFiniteMagnitude ],
		[ -179_424_720, 2_038_074_496, -982_450_304 ],
	]
	static let _float3SimpleTestValues:[[Float]] = [
		[ 1, 0, 0 ], // unit X
		[ 0, 1, 0 ], // unit Y
		[ 0, 0, 1 ], // unit Z
		[ -1, 0, 0 ], // negative unit X
		[ 0, -1, 0 ], // negative unit Y
		[ 0, 0, -1 ], // negative unit Z
		[ 2, 0, 0 ], // longer unit X
		[ 0, 2, 0 ], // longer unit Y
		[ 0, 0, 2 ], // longer unit Z
	]
	static let _float3SimpleRotatedExpectedValues:[[[Float]]] = [
		[ // rotated 90° CCW around X
			[ 1, 0, 0 ], // unit X
			[ 0, 0, 1 ], // unit Y
			[ 0, -1, 0 ], // unit Z
			[ -1, 0, 0 ], // negative unit X
			[ 0, 0, -1 ], // negative unit Y
			[ 0, 1, 0 ], // negative unit Z
			[ 2, 0, 0 ], // longer unit X
			[ 0, 0, 2 ], // longer unit Y
			[ 0, -2, 0 ], // longer unit Z
		],
		[ // rotated 90° CCW around Y
			[ 0, 0, -1 ], // unit X
			[ 0, 1, 0 ], // unit Y
			[ 1, 0, 0 ], // unit Z
			[ 0, 0, 1 ], // negative unit X
			[ 0, -1, 0 ], // negative unit Y
			[ -1, 0, 0 ], // negative unit Z
			[ 0, 0, -2 ], // longer unit X
			[ 0, 2, 0 ], // longer unit Y
			[ 2, 0, 0 ], // longer unit Z
		],
		[ // rotated 90° CCW around Z
			[ 0, 1, 0 ], // unit X
			[ -1, 0, 0 ], // unit Y
			[ 0, 0, 1 ], // unit Z
			[ 0, -1, 0 ], // negative unit X
			[ 1, 0, 0 ], // negative unit Y
			[ 0, 0, -1 ], // negative unit Z
			[ 0, 2, 0 ], // longer unit X
			[ -2, 0, 0 ], // longer unit Y
			[ 0, 0, 2 ], // longer unit Z
		],
		[ // rotated 90° CCW around Z, then 90° CCW around X
			[ 0, 1, 0 ], // unit X
			[ 0, 0, 1 ], // unit Y
			[ 1, 0, 0 ], // unit Z
			[ 0, -1, 0 ], // negative unit X
			[ 0, 0, -1 ], // negative unit Y
			[ -1, 0, 0 ], // negative unit Z
			[ 0, 2, 0 ], // longer unit X
			[ 0, 0, 2 ], // longer unit Y
			[ 2, 0, 0 ], // longer unit Z
		],
		[ // rotated 90° CCW around Z, then 90° CCW around Y, then 90° CCW around X
			[ 0, 0, -1 ], // unit X
			[ 0, 1, 0 ], // unit Y
			[ 1, 0, 0 ], // unit Z
			[ 0, 0, 1 ], // negative unit X
			[ 0, -1, 0 ], // negative unit Y
			[ -1, 0, 0 ], // negative unit Z
			[ 0, 0, -2 ], // longer unit X
			[ 0, 2, 0 ], // longer unit Y
			[ 2, 0, 0 ], // longer unit Z
		],
	]
	static let _float4TestValues:[[Float]] = [
		[ 0, 0, 0, 0 ],
		[ 1, 2, 3, 4 ],
		[ Float.infinity, Float.leastNonzeroMagnitude, Float.greatestFiniteMagnitude, Float.leastNormalMagnitude ],
		[ -179_424_720, 2_038_074_496, -982_450_304, 454_923_712 ],
	]
	static let _angleAxisRotationTestValues:[(angle_rad:Float,axis:Float3)] = [
		( 1.0 * Float.pi, Float3(1, 1, 1).normalized() ),
		( 0.3 * Float.pi, Float3(1, 0.5, 0.25).normalized() ),
		( 0.5 * Float.pi, Float3(-1, -0.5, 0).normalized() ),
		( 1.5 * Float.pi, Float3(-1, -0.5, 0).normalized() ),
	]
	static let _angleAxisRotationSimpleTestValues:[(angle_rad:Float,axis:Float3)] = [
		( 0.5 * Float.pi, Float3.unitXPositive ),
		( 0.5 * Float.pi, Float3.unitYPositive ),
		( 0.5 * Float.pi, Float3.unitZPositive ),
	]
	// Computed using GLM's `axisAngleMatrix(…)`.
	static let _angleAxisRotationGLMComputedMatrixes:[simd_float3x3] = [
		simd_float3x3(
			simd_float3(-0.333333, 0.666667, 0.666667),
			simd_float3(0.666667, -0.333333, 0.666667),
			simd_float3(0.666667, 0.666667, -0.333333)
		),
		simd_float3x3(
			simd_float3(0.901854, 0.333576, -0.274567),
			simd_float3(-0.019508, 0.666302, 0.745427),
			simd_float3(0.431601, -0.666910, 0.607414)
		),
		simd_float3x3(
			simd_float3(0.800000, 0.400000, 0.447214),
			simd_float3(0.400000, 0.200000, -0.894427),
			simd_float3(-0.447214, 0.894427, -0.000000)
		),
		simd_float3x3(
			simd_float3(0.800000, 0.400000, -0.447214),
			simd_float3(0.400000, 0.200000, 0.894427),
			simd_float3(0.447214, -0.894427, 0.000000)
		),
	]
	// Computed using GLM's `rotate(identityQuaternion, …)`.
	static let _angleAxisRotationGLMComputedQuaternions:[simd_quatf] = [
		simd_quatf(real: -0.000000, imag: simd_float3(0.577350, 0.577350, 0.577350)),
		simd_quatf(real: 0.891007, imag: simd_float3(0.396275, 0.198138, 0.099069)),
		simd_quatf(real: 0.707107, imag: simd_float3(-0.632456, -0.316228, 0.000000)),
		simd_quatf(real: -0.707107, imag: simd_float3(-0.632456, -0.316228, 0.000000))
	]
	static let _eulerAnglesRotationTestValues:[Float3] = [
		Float3(1.0, 0.5, 0.25) * Float.pi,
		Float3(-1.0, 0.0, 0.1) * Float.pi,
		Float3(0.0, -0.5, -2.0) * Float.pi,
		Float3(0.5, 0.0, 0.5) * Float.pi,
	]
	static let _eulerAnglesRotationSimpleTestValues:[Float3] = [
		Float3.unitXPositive * (0.5 * Float.pi),
		Float3.unitYPositive * (0.5 * Float.pi),
		Float3.unitZPositive * (0.5 * Float.pi),
		Float3(0.5, 0, 0.5) * Float.pi,
		Float3(0.5, 0.5, 0.5) * Float.pi,
	]
	// Computed using GLM's `eulerAngleZYX(…)` (which does “XYZ”/Z*Y*X rotation order).
	// Note: GLM's listed axis order is the matrix/quaternion multiplication order, not the 3D-software rotation order (reversed, listed right-to-left).
	static let _eulerAnglesRotationGLMComputedXYZMatrixes:[simd_float3x3] = [
		simd_float3x3(
			simd_float3(-0.000000, -0.000000, -1.000000),
			simd_float3(0.707107, -0.707107, 0.000000),
			simd_float3(-0.707107, -0.707107, 0.000000)
		),
		simd_float3x3(
			simd_float3(0.951057, 0.309017, -0.000000),
			simd_float3(0.309017, -0.951057, 0.000000),
			simd_float3(0.000000, -0.000000, -1.000000)
		),
		simd_float3x3(
			simd_float3(-0.000000, 0.000000, 1.000000),
			simd_float3(0.000000, 1.000000, -0.000000),
			simd_float3(-1.000000, 0.000000, -0.000000)
		),
		simd_float3x3(
			simd_float3(-0.000000, 1.000000, -0.000000),
			simd_float3(0.000000, 0.000000, 1.000000),
			simd_float3(1.000000, 0.000000, -0.000000)
		),
	]
	// Computed with GLM using `rotate(identityQuaternion, …, vec3(0, 0, 1)) * rotate(identityQuaternion, …, vec3(0, 1, 0)) * rotate(identityQuaternion, …, vec3(1, 0, 0))`.
	static let _eulerAnglesRotationGLMComputedXYZQuaternions:[simd_quatf] = [
		simd_quatf(real: 0.270598, imag: simd_float3(0.653281, 0.270598, -0.653281)),
		simd_quatf(real: -0.000000, imag: simd_float3(-0.987688, -0.156434, -0.000000)),
		simd_quatf(real: -0.707107, imag: simd_float3(0.000000, 0.707107, 0.000000)),
		simd_quatf(real: 0.500000, imag: simd_float3(0.500000, 0.500000, 0.500000)),
	]
	
	
	override func setUp()
	{
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown()
	{
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	
	#if !NO_OBJC_BRIDGE
	func testNSValueRoundtripping()
	{
		Self._int2TestValues.map(Int2.init).forEach{
			let nsValue = NSValue(int2: $0)
			let value = nsValue.int2Value
			XCTAssertEqual($0, value)
		}
		
		Self._int3TestValues.map(Int3.init).forEach{
			let nsValue = NSValue(int3: $0)
			let value = nsValue.int3Value
			XCTAssertEqual($0, value)
		}
		
		Self._int4TestValues.map(Int4.init).forEach{
			let nsValue = NSValue(int4: $0)
			let value = nsValue.int4Value
			XCTAssertEqual($0, value)
		}
		
		Self._float2TestValues.map(Float2.init).forEach{
			let nsValue = NSValue(float2: $0)
			let value = nsValue.float2Value
			XCTAssertEqual($0, value)
		}
		
		Self._float3TestValues.map(Float3.init).forEach{
			let nsValue = NSValue(float3: $0)
			let value = nsValue.float3Value
			XCTAssertEqual($0, value)
		}
		
		Self._float4TestValues.map(Float4.init).forEach{
			let nsValue = NSValue(float4: $0)
			let value = nsValue.float4Value
			XCTAssertEqual($0, value)
		}
	}
	#endif
	
	func testSIMDRoundtripping()
	{
		Self._int2TestValues.map(Int2.init).forEach{
			let simdValue = $0.simdValue
			let value = Int2(simdValue)
			XCTAssertEqual($0, value)
		}
		
		Self._int3TestValues.map(Int3.init).forEach{
			let simdValue = $0.simdValue
			let value = Int3(simdValue)
			XCTAssertEqual($0, value)
		}
		
		Self._int4TestValues.map(Int4.init).forEach{
			let simdValue = $0.simdValue
			let value = Int4(simdValue)
			XCTAssertEqual($0, value)
		}
		
		Self._float2TestValues.map(Float2.init).forEach{
			let simdValue = $0.simdValue
			let value = Float2(simdValue)
			XCTAssertEqual($0, value)
		}
		
		Self._float3TestValues.map(Float3.init).forEach{
			let simdValue = $0.simdValue
			let value = Float3(simdValue)
			XCTAssertEqual($0, value)
		}
		
		Self._float4TestValues.map(Float4.init).forEach{
			let simdValue = $0.simdValue
			let value = Float4(simdValue)
			XCTAssertEqual($0, value)
		}
	}
	
	func testEquality()
	{
		XCTAssertTrue(
			Int2(1, 2) == Int2(1, 2)
		)
		XCTAssertTrue(
			Int3(1, 2, 3) == Int3(1, 2, 3)
		)
		XCTAssertTrue(
			Int4(1, 2, 3, 4) == Int4(1, 2, 3, 4)
		)
		XCTAssertTrue(
			Float2(1, 2) == Float2(1, 2)
		)
		XCTAssertTrue(
			Float3(1, 2, 3) == Float3(1, 2, 3)
		)
		XCTAssertTrue(
			Float4(1, 2, 3, 4) == Float4(1, 2, 3, 4)
		)
		
		XCTAssertTrue(
			Int2(1, 2) != Int2(10, 20)
		)
		XCTAssertTrue(
			Int3(1, 2, 3) != Int3(10, 20, 30)
		)
		XCTAssertTrue(
			Int4(1, 2, 3, 4) != Int4(10, 20, 30, 40)
		)
		XCTAssertTrue(
			Float2(1, 2) != Float2(10, 20)
		)
		XCTAssertTrue(
			Float3(1, 2, 3) != Float3(10, 20, 30)
		)
		XCTAssertTrue(
			Float4(1, 2, 3, 4) != Float4(10, 20, 30, 40)
		)
	}
	
	func testAddMath()
	{
		XCTAssertEqual(
			Int2(1, 2) + Int2(-10, -20),
			Int2(simd_int2(1, 2) &+ simd_int2(-10, -20))
		)
		XCTAssertEqual(
			Int3(1, 2, 3) + Int3(-10, -20, -30),
			Int3(simd_int3(1, 2, 3) &+ simd_int3(-10, -20, -30))
		)
		XCTAssertEqual(
			Int4(1, 2, 3, 4) + Int4(-10, -20, -30, -40),
			Int4(simd_int4(1, 2, 3, 4) &+ simd_int4(-10, -20, -30, -40))
		)
		
		XCTAssertEqual(
			Float2(1, 2) + Float2(-10, -20),
			Float2(simd_float2(1, 2) + simd_float2(-10, -20))
		)
		XCTAssertEqual(
			Float3(1, 2, 3) + Float3(-10, -20, -30),
			Float3(simd_float3(1, 2, 3) + simd_float3(-10, -20, -30))
		)
		XCTAssertEqual(
			Float4(1, 2, 3, 4) + Float4(-10, -20, -30, -40),
			Float4(simd_float4(1, 2, 3, 4) + simd_float4(-10, -20, -30, -40))
		)
	}
	
	func testSubtractMath()
	{
		XCTAssertEqual(
			Int2(1, 2) - Int2(-10, -20),
			Int2(simd_int2(1, 2) &- simd_int2(-10, -20))
		)
		XCTAssertEqual(
			Int3(1, 2, 3) - Int3(-10, -20, -30),
			Int3(simd_int3(1, 2, 3) &- simd_int3(-10, -20, -30))
		)
		XCTAssertEqual(
			Int4(1, 2, 3, 4) - Int4(-10, -20, -30, -40),
			Int4(simd_int4(1, 2, 3, 4) &- simd_int4(-10, -20, -30, -40))
		)
		
		XCTAssertEqual(
			Float2(1, 2) - Float2(-10, -20),
			Float2(simd_float2(1, 2) - simd_float2(-10, -20))
		)
		XCTAssertEqual(
			Float3(1, 2, 3) - Float3(-10, -20, -30),
			Float3(simd_float3(1, 2, 3) - simd_float3(-10, -20, -30))
		)
		XCTAssertEqual(
			Float4(1, 2, 3, 4) - Float4(-10, -20, -30, -40),
			Float4(simd_float4(1, 2, 3, 4) - simd_float4(-10, -20, -30, -40))
		)
	}
	
	func testMultiplyMath()
	{
		XCTAssertEqual(
			Int2(1, 2) * Int2(-10, -20),
			Int2(simd_int2(1, 2) &* simd_int2(-10, -20))
		)
		XCTAssertEqual(
			Int3(1, 2, 3) * Int3(-10, -20, -30),
			Int3(simd_int3(1, 2, 3) &* simd_int3(-10, -20, -30))
		)
		XCTAssertEqual(
			Int4(1, 2, 3, 4) * Int4(-10, -20, -30, -40),
			Int4(simd_int4(1, 2, 3, 4) &* simd_int4(-10, -20, -30, -40))
		)
		
		XCTAssertEqual(
			Float2(1, 2) * Float2(-10, -20),
			Float2(simd_float2(1, 2) * simd_float2(-10, -20))
		)
		XCTAssertEqual(
			Float3(1, 2, 3) * Float3(-10, -20, -30),
			Float3(simd_float3(1, 2, 3) * simd_float3(-10, -20, -30))
		)
		XCTAssertEqual(
			Float4(1, 2, 3, 4) * Float4(-10, -20, -30, -40),
			Float4(simd_float4(1, 2, 3, 4) * simd_float4(-10, -20, -30, -40))
		)
	}
	
	func testDivideMath()
	{
		XCTAssertEqual(
			Int2(-10, -20) / Int2(2, 3),
			Int2(simd_int2(-10, -20) / simd_int2(2, 3))
		)
		XCTAssertEqual(
			Int3(-10, -20, -30) / Int3(2, 3, 4),
			Int3(simd_int3(-10, -20, -30) / simd_int3(2, 3, 4))
		)
		XCTAssertEqual(
			Int4(-10, -20, -30, -40) / Int4(2, 3, 4, 5),
			Int4(simd_int4(-10, -20, -30, -40) / simd_int4(2, 3, 4, 5))
		)
		
		XCTAssertEqual(
			Float2(-10, -20) / Float2(2, 3),
			Float2(simd_float2(-10, -20) / simd_float2(2, 3))
		)
		XCTAssertEqual(
			Float3(-10, -20, -30) / Float3(2, 3, 4),
			Float3(simd_float3(-10, -20, -30) / simd_float3(2, 3, 4))
		)
		XCTAssertEqual(
			Float4(-10, -20, -30, -40) / Float4(2, 3, 4, 5),
			Float4(simd_float4(-10, -20, -30, -40) / simd_float4(2, 3, 4, 5))
		)
	}
	
	func testModulusMath()
	{
		XCTAssertEqual(
			Int2(-10, -20) % Int2(2, 3),
			Int2(simd_int2(-10, -20) % simd_int2(2, 3))
		)
		XCTAssertEqual(
			Int3(-10, -20, -30) % Int3(2, 3, 4),
			Int3(simd_int3(-10, -20, -30) % simd_int3(2, 3, 4))
		)
		XCTAssertEqual(
			Int4(-10, -20, -30, -40) % Int4(2, 3, 4, 5),
			Int4(simd_int4(-10, -20, -30, -40) % simd_int4(2, 3, 4, 5))
		)
		
		XCTAssertEqual(
			Float2(-10, -20) % Float2(2, 3),
			Float2(0, -2)
		)
		XCTAssertEqual(
			Float3(-10, -20, -30) % Float3(2, 3, 4),
			Float3(0, -2, -2)
		)
		XCTAssertEqual(
			Float4(-10, -20, -30, -40) % Float4(2, 3, 4, 5),
			Float4(0, -2, -2, 0)
		)
	}
	
	func testNegationMath()
	{
		XCTAssertEqual(
			-Int2(1, 2),
			Int2(0 &- simd_int2(1, 2))
		)
		XCTAssertEqual(
			-Int3(1, 2, 3),
			Int3(0 &- simd_int3(1, 2, 3))
		)
		XCTAssertEqual(
			-Int4(1, 2, 3, 4),
			Int4(0 &- simd_int4(1, 2, 3, 4))
		)
		
		XCTAssertEqual(
			-Float2(1, 2),
			Float2(-simd_float2(1, 2))
		)
		XCTAssertEqual(
			-Float3(1, 2, 3),
			Float3(-simd_float3(1, 2, 3))
		)
		XCTAssertEqual(
			-Float4(1, 2, 3, 4),
			Float4(-simd_float4(1, 2, 3, 4))
		)
	}
	
	func testSimpleAngleAxisConstructors()
	{
		for (rotationIndex, (angle_rad, axis)) in Self._angleAxisRotationSimpleTestValues.enumerated() {
			let simdQuaternion = simd_quaternion(angle_rad, axis.simdValue)
			let vucktQuaternion = FloatQuaternion(angle: angle_rad, axis: axis)
			let vucktRotor = FloatRotor(angle: angle_rad, axis: axis)
			let vucktMatrix3 = Float3x3(rotationAngle: angle_rad, axis: axis)
			
			for (valueIndex, vector) in Self._float3SimpleTestValues.enumerated() {
				let vector = Float3(array: vector)
				
				let expectedRotatedValue = Float3(array: Self._float3SimpleRotatedExpectedValues[rotationIndex][valueIndex])
				
				let simdQuaternionRotatedVector = Float3(simd_act(simdQuaternion, vector.simdValue))
				let vucktQuaternionRotatedVector = vucktQuaternion * vector
				let vucktRotorRotatedVector = vucktRotor * vector
				let vucktMatrixRotatedVector = vucktMatrix3 * vector
				
				assertAlmostEqual(simdQuaternionRotatedVector, expectedRotatedValue,
					"\"\(simdQuaternionRotatedVector)\" is not almost equal to (\"\(expectedRotatedValue)\")"
				)
				assertAlmostEqual(vucktQuaternionRotatedVector, expectedRotatedValue,
					"\"\(vucktQuaternionRotatedVector)\" is not almost equal to (\"\(expectedRotatedValue)\")"
				)
				assertAlmostEqual(vucktRotorRotatedVector, expectedRotatedValue,
					"\"\(vucktRotorRotatedVector)\" is not almost equal to (\"\(expectedRotatedValue)\")"
				)
				assertAlmostEqual(vucktMatrixRotatedVector, expectedRotatedValue,
					"\"\(vucktMatrixRotatedVector)\" is not almost equal to (\"\(expectedRotatedValue)\")"
				)
			}
		}
	}
	
	func testAngleAxisConstructors()
	{
		for (rotationIndex, (angle_rad, axis)) in Self._angleAxisRotationTestValues.enumerated() {
			let glmQuaternion = Self._angleAxisRotationGLMComputedQuaternions[rotationIndex]
			let glmMatrix = Self._angleAxisRotationGLMComputedMatrixes[rotationIndex]
			
			let simdQuaternion = simd_quaternion(angle_rad, axis.simdValue)
			let vucktQuaternion = FloatQuaternion(angle: angle_rad, axis: axis)
			let vucktRotor = FloatRotor(angle: angle_rad, axis: axis)
			let vucktMatrix3 = Float3x3(rotationAngle: angle_rad, axis: axis)
			
			for (valueIndex, vector) in Self._float3RegularTestValues.enumerated() {
				let vector = Float3(array: vector)
				
				let simdQuaternionRotatedVector = Float3(simd_act(simdQuaternion, vector.simdValue))
				let glmMatrixRotatedVector = Float3(glmMatrix * vector.simdValue)
				let glmQuaternionRotatedVector = Float3(simd_act(glmQuaternion, vector.simdValue))
				let vucktQuaternionRotatedVector = vucktQuaternion * vector
				let vucktRotorRotatedVector = vucktRotor * vector
				let vucktMatrixRotatedVector = vucktMatrix3 * vector
				
				assertAlmostEqual(glmMatrixRotatedVector, simdQuaternionRotatedVector,
					"\"\(glmMatrixRotatedVector)\" is not almost equal to (\"\(simdQuaternionRotatedVector)\")"
				)
				assertAlmostEqual(glmQuaternionRotatedVector, simdQuaternionRotatedVector,
					"\"\(glmQuaternionRotatedVector)\" is not almost equal to (\"\(simdQuaternionRotatedVector)\")"
				)
				assertAlmostEqual(vucktQuaternionRotatedVector, simdQuaternionRotatedVector,
					"\"\(vucktQuaternionRotatedVector)\" is not almost equal to (\"\(simdQuaternionRotatedVector)\")"
				)
				assertAlmostEqual(vucktRotorRotatedVector, simdQuaternionRotatedVector,
					"\"\(vucktRotorRotatedVector)\" is not almost equal to (\"\(simdQuaternionRotatedVector)\")"
				)
				assertAlmostEqual(vucktMatrixRotatedVector, simdQuaternionRotatedVector,
					"\"\(vucktMatrixRotatedVector)\" is not almost equal to (\"\(simdQuaternionRotatedVector)\")"
				)
			}
		}
	}
	
	func testSimpleEulerAnglesXYZConstructors()
	{
		for (rotationIndex, eulerAngles_rad) in Self._eulerAnglesRotationSimpleTestValues.enumerated() {
			let simdQuaternion:simd_quatf = {
				let zRotation = simd_quaternion(eulerAngles_rad.z, Float3.unitZPositive.simdValue)
				let yRotation = simd_quaternion(eulerAngles_rad.y, Float3.unitYPositive.simdValue)
				let xRotation = simd_quaternion(eulerAngles_rad.x, Float3.unitXPositive.simdValue)
				return zRotation * yRotation * xRotation
			}()
			let vucktQuaternion = FloatQuaternion(eulerAngles: eulerAngles_rad, order: .xyz)
			let vucktRotor = FloatRotor(eulerAngles: eulerAngles_rad, order: .xyz)
			let vucktMatrix3 = Float3x3(rotationEulerAngles: eulerAngles_rad, order: .xyz)
			
			for (valueIndex, vector) in Self._float3SimpleTestValues.enumerated() {
				let vector = Float3(array: vector)
				
				let expectedRotatedValue = Float3(array: Self._float3SimpleRotatedExpectedValues[rotationIndex][valueIndex])
				
				let simdQuaternionRotatedVector = Float3(simd_act(simdQuaternion, vector.simdValue))
				let vucktQuaternionRotatedVector = vucktQuaternion * vector
				let vucktRotorRotatedVector = vucktRotor * vector
				let vucktMatrixRotatedVector = vucktMatrix3 * vector
				
				assertAlmostEqual(simdQuaternionRotatedVector, expectedRotatedValue,
					"\"\(simdQuaternionRotatedVector)\" is not almost equal to (\"\(expectedRotatedValue)\")"
				)
				assertAlmostEqual(vucktQuaternionRotatedVector, expectedRotatedValue,
					"\"\(vucktQuaternionRotatedVector)\" is not almost equal to (\"\(expectedRotatedValue)\")"
				)
				assertAlmostEqual(vucktRotorRotatedVector, expectedRotatedValue,
					"\"\(vucktRotorRotatedVector)\" is not almost equal to (\"\(expectedRotatedValue)\")"
				)
				assertAlmostEqual(vucktMatrixRotatedVector, expectedRotatedValue,
					"\"\(vucktMatrixRotatedVector)\" is not almost equal to (\"\(expectedRotatedValue)\")"
				)
			}
		}
	}
	
	func testEulerAnglesXYZConstructors()
	{
		for (rotationIndex, eulerAngles_rad) in Self._eulerAnglesRotationTestValues.enumerated() {
			let glmQuaternion = Self._eulerAnglesRotationGLMComputedXYZQuaternions[rotationIndex]
			let glmMatrix = Self._eulerAnglesRotationGLMComputedXYZMatrixes[rotationIndex]
			
			let simdQuaternion:simd_quatf = {
				let zRotation = simd_quaternion(eulerAngles_rad.z, Float3.unitZPositive.simdValue)
				let yRotation = simd_quaternion(eulerAngles_rad.y, Float3.unitYPositive.simdValue)
				let xRotation = simd_quaternion(eulerAngles_rad.x, Float3.unitXPositive.simdValue)
				return zRotation * yRotation * xRotation
			}()
			let vucktQuaternion = FloatQuaternion(eulerAngles: eulerAngles_rad, order: .xyz)
			let vucktRotor = FloatRotor(eulerAngles: eulerAngles_rad, order: .xyz)
			let vucktMatrix3 = Float3x3(rotationEulerAngles: eulerAngles_rad, order: .xyz)
			
			for (valueIndex, vector) in Self._float3RegularTestValues.enumerated() {
				let vector = Float3(array: vector)
				
				let simdQuaternionRotatedVector = Float3(simd_act(simdQuaternion, vector.simdValue))
				let glmMatrixRotatedVector = Float3(glmMatrix * vector.simdValue)
				let glmQuaternionRotatedVector = Float3(simd_act(glmQuaternion, vector.simdValue))
				let vucktQuaternionRotatedVector = vucktQuaternion * vector
				let vucktRotorRotatedVector = vucktRotor * vector
				let vucktMatrixRotatedVector = vucktMatrix3 * vector
				
				assertAlmostEqual(glmMatrixRotatedVector, simdQuaternionRotatedVector,
					"\"\(glmMatrixRotatedVector)\" is not almost equal to (\"\(simdQuaternionRotatedVector)\")"
				)
				assertAlmostEqual(glmQuaternionRotatedVector, simdQuaternionRotatedVector,
					"\"\(glmQuaternionRotatedVector)\" is not almost equal to (\"\(simdQuaternionRotatedVector)\")"
				)
				assertAlmostEqual(vucktQuaternionRotatedVector, simdQuaternionRotatedVector,
					"\"\(vucktQuaternionRotatedVector)\" is not almost equal to (\"\(simdQuaternionRotatedVector)\")"
				)
				assertAlmostEqual(vucktRotorRotatedVector, simdQuaternionRotatedVector,
					"\"\(vucktRotorRotatedVector)\" is not almost equal to (\"\(simdQuaternionRotatedVector)\")"
				)
				assertAlmostEqual(vucktMatrixRotatedVector, simdQuaternionRotatedVector,
					"\"\(vucktMatrixRotatedVector)\" is not almost equal to (\"\(simdQuaternionRotatedVector)\")"
				)
			}
		}
	}
	
	func testPerformanceExample()
	{
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}

}
