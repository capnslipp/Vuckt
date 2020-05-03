// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

import Foundation



internal let SquareRootOfOneHalf = Float(0.5).squareRoot()



#if !swift(>=4.2)
	internal extension Float
	{
		@inlinable static func random(in range:Range<Float>) -> Float {
			let delta = range.upperBound - range.lowerBound
			return Float(arc4random_uniform(UInt32.max)) / Float(UInt32.max - 1) * delta + range.lowerBound
		}
		@inlinable static func random(in range:ClosedRange<Float>) -> Float {
			let delta = range.upperBound - range.lowerBound
			return Float(arc4random_uniform(UInt32.max)) / Float(UInt32.max) * delta + range.lowerBound
		}
	}

	internal extension Int32
	{
		@inlinable static func random(in range:Range<Int32>) -> Int32 {
			let delta = UInt32(range.upperBound - range.lowerBound)
			return Int32(arc4random_uniform(delta)) + range.lowerBound
		}
		@inlinable static func random(in range:ClosedRange<Int32>) -> Int32 {
			let delta = UInt32(range.upperBound - range.lowerBound)
			return Int32(arc4random_uniform(delta + 1)) + range.lowerBound
		}
	}
#endif



public enum RotationOrder : UInt {
	case xyz = 1
	case xzy = 2
	case yxz = 3
	case yzx = 4
	case zxy = 5
	case zyx = 6
}
