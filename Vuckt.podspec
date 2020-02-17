Pod::Spec.new do |s|
  s.name = 'Vuckt'
  s.version = '3.3.0'
  s.summary = "A Swift Vector Library That Doesn't Suck"
  s.description = "A Swift library providing Obj-C-compatible integral & floating vector struct types with zero-cost SIMD vector bridging, and convenience methods to bridge to/from other vector-ish types throughout Cocoa."
  s.homepage = 'https://github.com/capnslipp/Vuckt'
  s.license = { :type => 'Public Domain', :file => 'LICENSE' }
  s.author = { 'capnslipp' => 'Vuckt@capnslipp.com' }
  s.source = { :git => 'https://github.com/capnslipp/Vuckt.git', :tag => "podspec/#{s.version}" }
  s.social_media_url = 'https://twitter.com/capnslipp'
  s.swift_versions = ['4.0', '4.2', '5.0']
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.source_files = 'Sources/**/*'
  s.exclude_files = 'Sources/**/*.gyb', 'Sources/**/*_NoObjCBridge.swift'
  s.prefix_header_file = 'Sources/Vuckt.pch'
end
