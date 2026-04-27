// swift-tools-version:5.0
import PackageDescription



let isSimdAvailable: Bool
#if canImport(simd)
	isSimdAvailable = true
#else // !canImport(simd)
	isSimdAvailable = false
#endif // !canImport(simd)

extension Array
{
	func appendingOnlyIfSimdUnavailable(_ element: Element) -> Self {
		if !isSimdAvailable {
			return self + [ element ]
		} else {
			return self
		}
	}
}



let package = Package(
	name: "Vuckt",
	products: [
		.library(name: "Vuckt", targets: ["Vuckt"]),
	],
	dependencies: []
		.appendingOnlyIfSimdUnavailable(
			.package(url: "https://github.com/keyvariable/kvSIMD.swift.git", from: "1.1.0")
		),
	targets: [
		.target(name: "Vuckt",
			dependencies: []
				.appendingOnlyIfSimdUnavailable(
					.product(name: "kvSIMD", package: "kvSIMD.swift")
				),
			path: "Sources/",
			sources: [
				"Vuckt.swift",
				"Float2/Float2_NoObjCBridge.swift",
				"Float2/Float2.swift",
				"Float3/Float3_NoObjCBridge.swift",
				"Float3/Float3.swift",
				"Float4/Float4_NoObjCBridge.swift",
				"Float4/Float4.swift",
				"FloatQuaternion/FloatQuaternion_NoObjCBridge.swift",
				"FloatQuaternion/FloatQuaternion.swift",
				"Int2/Int2_NoObjCBridge.swift",
				"Int2/Int2.swift",
				"Int3/Int3_NoObjCBridge.swift",
				"Int3/Int3.swift",
				"Int4/Int4_NoObjCBridge.swift",
				"Int4/Int4.swift",
				"Float3x3/Float3x3_NoObjCBridge.swift",
				"Float3x3/Float3x3.swift",
				"Float4x4/Float4x4_NoObjCBridge.swift",
				"Float4x4/Float4x4.swift",
			],
			swiftSettings: [ .define("NO_OBJC_BRIDGE") ]
		),
		.testTarget(name: "VucktTests", dependencies: ["Vuckt"], path: "Tests/",
			sources: [ "VucktTests.swift", "VucktPerformanceTests.swift" ],
			swiftSettings: [ .define("NO_OBJC_BRIDGE") ]
		),
	],
	swiftLanguageVersions: [
		.version("4"),
		.version("4.2"),
		.version("5"),
	]
)
