// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import XCTest
import IntN



class IntNTests : XCTestCase
{
	let _int2TestValues:[Int2] = [
		Int2(0, 0),
		Int2(1, 2),
		Int2(Int32.min, Int32.max),
		Int2(-179_424_719, 2_038_074_503),
	]
	let _int3TestValues:[Int3] = [
		Int3(0, 0, 0),
		Int3(1, 2, 3),
		Int3(Int32.min, Int32.max, Int32.min),
		Int3(-179_424_719, 2_038_074_503, -982_450_327),
	]
	
	
	override func setUp()
	{
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown()
	{
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	
	func testNSValueRountripping()
	{
		_int2TestValues.forEach{
			let nsValue = NSValue(int2: $0)
			let value = nsValue.int2Value
			XCTAssertEqual($0, value)
		}
		
		_int3TestValues.forEach{
			let nsValue = NSValue(int3: $0)
			let value = nsValue.int3Value
			XCTAssertEqual($0, value)
		}
	}
	
	func testSIMDRountripping()
	{
		_int2TestValues.forEach{
			let simdValue = $0.simdValue
			let value = Int2(simdValue)
			XCTAssertEqual($0, value)
		}
		
		_int3TestValues.forEach{
			let simdValue = $0.simdValue
			let value = Int3(simdValue)
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
			Int2(1, 2) != Int2(10, 20)
		)
		XCTAssertTrue(
			Int3(1, 2, 3) != Int3(10, 20, 30)
		)
	}
	
	func testAddMath()
	{
		XCTAssertEqual(
			Int2(1, 2) + Int2(-10, -20),
			Int2(-9, -18)
		)
		XCTAssertEqual(
			Int3(1, 2, 3) + Int3(-10, -20, -30),
			Int3(-9, -18, -27)
		)
	}
	
	func testSubtractMath()
	{
		XCTAssertEqual(
			Int2(1, 2) - Int2(-10, -20),
			Int2(11, 22)
		)
		XCTAssertEqual(
			Int3(1, 2, 3) - Int3(-10, -20, -30),
			Int3(11, 22, 33)
		)
	}
	
	func testMultiplyMath()
	{
		XCTAssertEqual(
			Int2(1, 2) * Int2(-10, -20),
			Int2(-10, -40)
		)
		XCTAssertEqual(
			Int3(1, 2, 3) * Int3(-10, -20, -30),
			Int3(-10, -40, -90)
		)
	}
	
	func testDivideMath()
	{
		XCTAssertEqual(
			Int2(-10, -20) / Int2(2, 3),
			Int2(-5, -6)
		)
		XCTAssertEqual(
			Int3(-10, -20, -30) / Int3(2, 3, 4),
			Int3(-5, -6, -7)
		)
	}
	
	func testModulusMath()
	{
		XCTAssertEqual(
			Int2(-10, -20) % Int2(2, 3),
			Int2(0, -2)
		)
		XCTAssertEqual(
			Int3(-10, -20, -30) % Int3(2, 3, 4),
			Int3(0, -2, -2)
		)
	}
	
	func testNegationMath()
	{
		XCTAssertEqual(
			-Int2(1, 2),
			Int2(-1, -2)
		)
		XCTAssertEqual(
			-Int3(1, 2, 3),
			Int3(-1, -2, -3)
		)
	}
	
	func testPerformanceExample()
	{
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}

}
