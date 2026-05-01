# Vuckt<br/>_<sub>A Swift Vector Library That Doesn't Suck It</sub>_

[![Swift Build & Test](https://github.com/capnslipp/Vuckt/actions/workflows/swift-build-test.yml/badge.svg)](https://github.com/capnslipp/Vuckt/actions/workflows/swift-build-test.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcapnslipp%2FVuckt%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/capnslipp/Vuckt)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcapnslipp%2FVuckt%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/capnslipp/Vuckt)

Vuckt is Swift library providing Obj-C-compatible integral & floating vector struct types with zero-cost SIMD vector bridging, and convenience methods to bridge to/from other vector-ish types throughout Cocoa.  Vuckt is designed to be a “plumbing-level” vector library, that is, it makes as little distinction as possible about the intended purpose or usage of its types (such as a vector3 being used as a position, or as an offset, or as a normal, or as a scale, or as a euler-angles or rotor rotation, etc.) and instead focuses on just providing vector types and every vector math method could could want to operator on those vectors.  (A specialized quaternion type is present because it's not a true uniform vector4, but really a imaginary-vector3 & real-vector1, so the math is significantly different).  Also, Vuckt is built on optimized C underpinnings, and is significantly faster than Swift's native SIMD library.

It was born out of frustration with Swift/Cocoa's built-in SIMD types not being fully Objective-C compatible _(particularly, they cause major problems when used with KVC, `NSInvocation`, or any other situation requiring `NSValue`-boxing)_, and has grown to try to cover as much of what native-SIMD can do with modern Swift syntax, and to be easily convertable to/from any other vector type you might be using in Swift _(e.g. `SCNVector3`, `CGVector`, etc.)_.

I might add more documentation here, but I don't really expect anyone else to find/use this lib— _I built it for my own use when Swift's native SIMD library wasn't meeting my needs, so I said “**f*ck it**; I'll write my own library“_.  If there are SIMD types or operations that you need that haven't been implemented in Vuckt yet, I'm happy to add them for you— just create an issue on [GitHub](https://github.com/capnslipp/Vuckt/issues), [GitLab](https://gitlab.com/capnslipp/IntN/issues), or [BitBucket](https://bitbucket.org/capnslipp/vuckt/issues) and if it's plausible _(packed types are a notable exception)_ and mirrors what SIMD does, I'll do it.  There's a good chance I already need the same feature you'd request, I just haven't added it yet.

Vuckt currently offers the following types:

* [Int2](Sources/Int2/Int2.swift)
* [Int3](Sources/Int3/Int3.swift)
* [Int4](Sources/Int4/Int4.swift)
* [Float2](Sources/Float2/Float2.swift)
* [Float3](Sources/Float3/Float3.swift)
* [Float4](Sources/Float4/Float4.swift)
* [FloatQuaternion](Sources/FloatQuaternion/FloatQuaternion.swift)
* [Float3x3](Sources/Float3/Float3x3.swift)
* [Float4x4](Sources/Float4/Float4x4.swift)

See also: [Vuckt's full documentation](https://swiftpackageindex.com/capnslipp/Vuckt/master/documentation/vuckt)

## Performance

**Vuckt is _fast_**.  Vuckt performs significantly faster than Swift-native SIMD (and similarly to the C APIs of SIMD & GLKVector3), both in **Release** builds:

|                     | iPhone 13 Pro<br/>_<sub>Geekbench 6 CPU<br/>single-core score: 2364</sub>_ | iPad Pro M4 11"<br/>_<sub>Geekbench 6 CPU<br/>single-core score: 3744</sub>_ | Mac Studio M2 Max<br/>_<sub>Geekbench 6 CPU<br/>single-core score: 2727</sub>_ |
|-----------------------|--------------------|--------------------|--------------------|
| **Vuckt `Float3`**    |  **0.277 s**       |  **0.265 s**       |  **0.286 s**       |
| Swift `SIMD3<Float>`  |  0.803 s _(+190%)_ |  0.465 s _(+75%)_  |  0.497 s _(+74%)_  |
| C/Obj-C `GLKVector3`  |  0.275 s _(-1%)_   |  0.271 s _(+2%)_   |  0.273 s _(-5%)_   |
| C/Obj-C `simd_float3` |  0.927 s _(+235%)_ |  0.540 s _(+104%)_ |  0.581 s _(+103%)_ |

and **Debug** builds:

|                     | iPhone 13 Pro<br/>_<sub>Geekbench 6 CPU<br/>single-core score: 2364</sub>_ | iPad Pro M4 11"<br/>_<sub>Geekbench 6 CPU<br/>single-core score: 3744</sub>_ | Mac Studio M2 Max<br/>_<sub>Geekbench 6 CPU<br/>single-core score: 2727</sub>_ |
|-----------------------|--------------------|--------------------|---------------------|
| **Vuckt `Float3`**    |  **3.323 s**       |  **2.176 s**       |  **2.979 s**        |
| Swift `SIMD3<Float>`  | 18.005 s _(+442%)_ |  9.556 s _(+339%)_ |  14.038 s _(+371%)_ |
| C/Obj-C `GLKVector3`  |  2.712 s _(-18%)_  |  1.858 s _(-15%)_  |  2.319 s _(-22%)_   |
| C/Obj-C `simd_float3` |  1.615 s _(-51%)_  |  1.108 s _(-49%)_  |  1.287 s _(-57%)_   |

<sub>_(Lower seconds and percentages are better.  Tests performed with `VucktPerformanceTests.swift` and `VucktCPerformanceTests.m` using Xcode 26.4.1 and Swift 6.3.1.)_</sub>

## License

Vuckt is provided with a fully-permissive Public Domain license, because it really should've been built-into Swift.  I'm not one to claim rights over something so straight-forward and essential as a solid, interoperable, effecient vector library.

## To Do List

* [ ] Implement `Float2x2`
* [ ] Make the `Package.swift` use the C backend (which is significantly faster), eliminating the `…_NoObjCBridge.swift` variants  
	‣ Perhaps still offer “…_NoObjCBridge” as an alternate target, for cases/platforms where Obj-C isn't available.
* [ ] More unit test coverage
* [ ] More thorough performance tests
* [ ] Double & Half floating vectors
* [ ] Char, UChar, Short, UShort, UInt, Long, & ULong integer vectors
* [ ] Add conversions to/from Spatial types
	* [ ] Add performance tests for Spatial Vector3D operations, and add perf results to README
* [ ] Implement [Penner easing](https://robertpenner.com/easing/) functions for each type?
