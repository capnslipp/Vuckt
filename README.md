# Vuckt

[![Swift Build & Test](https://github.com/capnslipp/Vuckt/actions/workflows/swift-build-test.yml/badge.svg)](https://github.com/capnslipp/Vuckt/actions/workflows/swift-build-test.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcapnslipp%2FVuckt%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/capnslipp/Vuckt)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcapnslipp%2FVuckt%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/capnslipp/Vuckt)

Vuckt is Swift library providing Obj-C-compatible integral & floating vector struct types with zero-cost SIMD vector bridging, and convenience methods to bridge to/from other vector-ish types throughout Cocoa.

It was born out of frustration with Swift/Cocoa's built-in SIMD types not being fully Objective-C compatible _(particularly, they cause major problems when used with KVC, `NSInvocation`, or any other situation requiring `NSValue`-boxing)_, and has grown to try to cover as much of what native-SIMD can do, and to be easily convertable to/from any other vector type you might be using in Swift _(e.g. `SCNVector3`, `CGVector`, etc.)_.

I might add more documentation here, but I don't really expect anyone else to find/use this lib— _I built it for my own use when Swift/Foundation's native SIMD library wasn't meeting my needs, so I said **f*ck it; I'll write my own library**_.  If there are SIMD types or operations that you need that haven't been implemented in Vuckt yet, I'm happy to add them for you— just create an issue on [GitHub](https://github.com/capnslipp/Vuckt/issues), [GitLab](https://gitlab.com/capnslipp/IntN/issues), or [BitBucket](https://bitbucket.org/capnslipp/vuckt/issues) and if it's plausible _(packed types are a notable exception)_ and mirrors what SIMD does, I'll do it.  There's a good chance I already need the same feature you'd request, I just haven't added it yet.

## Performance

To my testing, Vuckt performs significantly faster than Swift-native SIMD (and similarly to the C API of GLKVector3), both in **Debug** builds:

![VucktPerformanceTests - Debug - iPhone 13 Pro](README%20Assets/VucktPerformanceTests%20-%20Debug%20-%20iPhone%2013%20Pro.png)

and **Release** builds:

![VucktPerformanceTests - Release - iPhone 13 Pro](README%20Assets/VucktPerformanceTests%20-%20Release%20-%20iPhone%2013%20Pro.png)

<sub>_(Test results shown performed on an iPhone 13 Pro.)_</sub>

## License

Vuckt is provided with a fully-permissive Public Domain license, because it really should've been built-into Swift.  I'm not one to claim rights over something so straight-forward and essential as a solid, interoperable, effecient vector library.
