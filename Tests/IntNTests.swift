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
	let _int4TestValues:[Int4] = [
		Int4(0, 0, 0, 0),
		Int4(1, 2, 3, 4),
		Int4(Int32.min, Int32.max, Int32.min, Int32.max),
		Int4(-179_424_719, 2_038_074_503, -982_450_327, 454_923_701),
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
		
		_int4TestValues.forEach{
			let nsValue = NSValue(int4: $0)
			let value = nsValue.int4Value
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
		
		_int4TestValues.forEach{
			let simdValue = $0.simdValue
			let value = Int4(simdValue)
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
			Int2(1, 2) != Int2(10, 20)
		)
		XCTAssertTrue(
			Int3(1, 2, 3) != Int3(10, 20, 30)
		)
		XCTAssertTrue(
			Int4(1, 2, 3, 4) != Int4(10, 20, 30, 40)
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
		XCTAssertEqual(
			Int4(1, 2, 3, 4) + Int4(-10, -20, -30, -40),
			Int4(-9, -18, -27, -36)
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
		XCTAssertEqual(
			Int4(1, 2, 3, 4) - Int4(-10, -20, -30, -40),
			Int4(11, 22, 33, 44)
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
		XCTAssertEqual(
			Int4(1, 2, 3, 4) * Int4(-10, -20, -30, -40),
			Int4(-10, -40, -90, -160)
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
		XCTAssertEqual(
			Int4(-10, -20, -30, -40) / Int4(2, 3, 4, 5),
			Int4(-5, -6, -7, -8)
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
		XCTAssertEqual(
			Int4(-10, -20, -30, -40) % Int4(2, 3, 4, 5),
			Int4(0, -2, -2, 0)
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
		XCTAssertEqual(
			-Int4(1, 2, 3, 4),
			Int4(-1, -2, -3, -4)
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
