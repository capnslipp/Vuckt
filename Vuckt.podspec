Pod::Spec.new do |s|
  s.name = 'Vuckt'
  s.version = ->{
    Dir.chdir(__dir__) do
      semver_regex = /\d+\.\d+\.\d+(?:-[\w\.]+)?(?:\+[\w\.]+)?/
      return `xcodebuild -showBuildSettings 2>/dev/null`.match(/CURRENT_PROJECT_VERSION = (#{semver_regex})/)[1]
    end
  }.call
  s.swift_versions = ['4.0', '4.2', '5.0']
  s.authors = { 'capnslipp' => 'Vuckt@capnslipp.com' }
  s.social_media_url = 'https://twitter.com/capnslipp'
  s.license = { :type => 'Public Domain', :file => 'LICENSE' }
  s.homepage = 'https://github.com/capnslipp/Vuckt'
  s.source = { :git => 'https://github.com/capnslipp/Vuckt.git', :tag => "podspec/#{s.version}" }
  s.summary = "A Swift Vector Library That Doesn't Suck"
  s.description = "A Swift library providing Obj-C-compatible integral & floating vector struct types with zero-cost SIMD vector bridging, and convenience methods to bridge to/from other vector-ish types throughout Cocoa."
  
  # Platform
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  
  # Build Settings
  s.requires_arc = false
  s.prefix_header_file = 'Sources/Vuckt.pch'
  
  # File Patterns
  s.source_files = 'Sources/**/*'
  s.exclude_files = 'Sources/**/*.gyb', 'Sources/**/*_NoObjCBridge.swift'
end
