Pod::Spec.new do |s|
  s.name = 'IntN'
  s.version = '2.0.0'
  s.summary = 'A Swift µ-Library Providing 2-Int & 3-Int Vector Types'
  s.description = "A Swift micro-library that provides Obj-C-compatible Int2 and Int3 struct types— which are 2D/3D vectors like SCNVector3/GLKVector3/simd.float3, but with Int x/y/z values."
  s.homepage = 'https://github.com/capnslipp/IntN'
  s.license = { :type => 'Public Domain', :file => 'LICENSE' }
  s.author = { 'capnslipp' => 'IntN@capnslipp.com' }
  s.source = { :git => 'https://github.com/capnslipp/IntN.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/capnslipp'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.source_files = 'Sources/**/*'
end
