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
	
	func testPerformanceExample()
	{
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}

}
