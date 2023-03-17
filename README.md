# Vuckt _(formerly IntN)_

[![Swift Build & Test](https://github.com/capnslipp/Vuckt/actions/workflows/swift-build-test.yml/badge.svg)](https://github.com/capnslipp/Vuckt/actions/workflows/swift-build-test.yml)

Vuckt is Swift library providing Obj-C-compatible integral & floating vector struct types with zero-cost SIMD vector bridging, and convenience methods to bridge to/from other vector-ish types throughout Cocoa.

It was born out of frustration with Swift/Cocoa's built-in SIMD types not being fully Objective-C compatible _(particularly, they cause major problems when used with KVC, `NSInvocation`, or any other situation requiring `NSValue`-boxing)_, and has grown to try to cover as much of what native-SIMD can do, and to be easily convertable to/from any other vector type you might be using in Swift _(e.g. `SCNVector3`, `CGVector`, etc.)_.

I might add more documentation here, but I don't really expect anyone else to find/use this lib— _I built it for my own use and **Don't Give A Vuckt** if anyone else uses it, or about trying to popularlize a lib that does what should be built-into Swift_.  That said, if there are SIMD types or operations that you need that haven't been implemented in Vuckt yet, I'm happy to add them for you— just create an issue on [GitHub](https://github.com/capnslipp/Vuckt/issues), [GitLab](https://gitlab.com/capnslipp/IntN/issues), or [BitBucket](https://bitbucket.org/capnslipp/vuckt/issues) and if it's plausible _(packed types are a notable exception)_ and mirrors what SIMD does, I'll do it.  There's a good chance I already need the same feature you'd request, I just haven't added it yet, so don't be shy.

Vuckt is provided with a fully-permissive Public Domain license, because it really should've been built-into Swift.  I'm not one to claim rights over something so straight-forward and essential as a solid, interoperable, effecient vector library.
