// swift-tools-version:4.0
import PackageDescription

let package = Package(
	name: "Vuckt",
	products: [
		.library(name: "Vuckt", targets: ["Vuckt"]),
	],
	dependencies: [],
	targets: [
		.target(name: "Vuckt", dependencies: [], path: "Sources/",
			sources: [
				"Vuckt.swift",
				"Float2/Float2_NoObjCBridge.swift",
				"Float2/Float2.swift",
				"Float3/Float3_NoObjCBridge.swift",
				"Float3/Float3.swift",
				"Float4/Float4_NoObjCBridge.swift",
				"Float4/Float4.swift",
				"Int2/Int2_NoObjCBridge.swift",
				"Int2/Int2.swift",
				"Int3/Int3_NoObjCBridge.swift",
				"Int3/Int3.swift",
				"Int4/Int4_NoObjCBridge.swift",
				"Int4/Int4.swift",
			]
		),
		.testTarget(name: "VucktTests", dependencies: ["Vuckt"], path: "Tests/"
		),
	],
	swiftLanguageVersions: [
		4,
		5,
	]
)
