Pod::Spec.new do |s|
  s.name = 'Int3'
  s.version = '1.2.1'
  s.summary = 'A Swift µ-Library Providing a 3-Int Vector Type'
  s.description = "A Swift micro-library that provides an Obj-C-compatible Int3 struct type— which is a 3D vector like SCNVector3/GLKVector3/simd.float3, but with Int x/y/z values."
  s.homepage = 'https://github.com/capnslipp/Int3'
  s.license = { :type => 'Public Domain', :file => 'LICENSE' }
  s.author = { 'capnslipp' => 'Int3@capnslipp.com' }
  s.source = { :git => 'https://github.com/capnslipp/Int3.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/capnslipp'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.source_files = 'Sources/**/*'
end
