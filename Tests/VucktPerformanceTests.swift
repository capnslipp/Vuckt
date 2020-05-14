// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import XCTest
import Vuckt
import simd
import SceneKit



class VucktPerformanceTests : XCTestCase
{
	static let iterationCount = 1_000_000
	
	
	override func setUp()
	{
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown()
	{
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	
	func testFloat3Performance()
	{
		var testSetA:[Float3] = []
		var testSetB:[Float3] = []
		(0..<Self.iterationCount).forEach{ i in
			let value = Float(i)
			testSetA.append(Float3(
				x: value,
				y: value - 500,
				z: value * 2.5
			))
			testSetB.append(Float3(
				x: value + 500,
				y: -value * 10.0,
				z: value / 2.0
			))
		}
		
		
		self.measure {
			(0..<Self.iterationCount).forEach{ i in
				_ = testSetA[i] + testSetB[i]
				_ = testSetA[i] - testSetB[i]
				_ = testSetA[i] * testSetB[i]
				_ = testSetA[i] / testSetB[i]
				_ = testSetA[i] < testSetB[i]
				_ = testSetA[i] <= testSetB[i]
				_ = testSetA[i] == testSetB[i]
			}
		}
	}
	
	private func randomFloatFromNegOneToPosOne() -> Float {
		let randomFloat = Float(arc4random() % (UInt32(RAND_MAX) + 1)) / Float(RAND_MAX)
		return randomFloat * 2.0 - 1.0;
	}
	
	func testSIMDFloat3Performance()
	{
		var testSetA:[simd.float3] = []
		var testSetB:[simd.float3] = []
		(0..<Self.iterationCount).forEach{ i in
			let value = Float(i)
			testSetA.append(simd.float3(
				x: value + (0 + randomFloatFromNegOneToPosOne()),
				y: value - (500 + randomFloatFromNegOneToPosOne()),
				z: value * (2.5 + randomFloatFromNegOneToPosOne())
			))
			testSetB.append(simd.float3(
				x: value + (500 + randomFloatFromNegOneToPosOne()),
				y: -value * (10.0 + randomFloatFromNegOneToPosOne()),
				z: value / (2.0 + randomFloatFromNegOneToPosOne())
			))
		}
		
		
		self.measure {
			(0..<Self.iterationCount).forEach{ i in
				_ = testSetA[i] + testSetB[i]
				_ = testSetA[i] - testSetB[i]
				_ = testSetA[i] * testSetB[i]
				_ = testSetA[i] / testSetB[i]
				_ = all(testSetA[i] .< testSetB[i])
				_ = all(testSetA[i] .<= testSetB[i])
				_ = testSetA[i] == testSetB[i]
			}
		}
	}
	
	func testGLKVector3Performance()
	{
		var testSetA:[GLKVector3] = []
		var testSetB:[GLKVector3] = []
		(0..<Self.iterationCount).forEach{ i in
			let value = Float(i)
			testSetA.append(GLKVector3Make(
				value,
				value - 500,
				value * 2.5
			))
			testSetB.append(GLKVector3Make(
				value + 500,
				-value * 10.0,
				value / 2.0
			))
		}
		
		
		self.measure {
			(0..<Self.iterationCount).forEach{ i in
				_ = GLKVector3Add(testSetA[i], testSetB[i])
				_ = GLKVector3Subtract(testSetA[i], testSetB[i])
				_ = GLKVector3Multiply(testSetA[i], testSetB[i])
				_ = GLKVector3Divide(testSetA[i], testSetB[i])
				_ = GLKVector3AllGreaterThanVector3(testSetB[i], testSetA[i])
				_ = GLKVector3AllGreaterThanOrEqualToVector3(testSetB[i], testSetA[i])
				_ = GLKVector3AllEqualToVector3(testSetA[i], testSetB[i])
			}
		}
	}

}
