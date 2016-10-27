Pod::Spec.new do |s|
  s.name             = 'SwiftyHaru'
  s.version          = '0.1.0'
  s.summary          = 'Object-oriented and safe Swift wrapper for LibHaru — a library for creating PDF documents'

  s.description      = <<-DESC
                       SwiftyHaru is an object-oriented Swift wrapper for LibHaru,
                       a C library for creating PDF documents. It brings the safety of Swift
                       itself to the process of creating PDFs on different platforms like Linux,
                       macOS, iOS, watchOS and tvOS.
                       DESC

  s.homepage         = 'https://github.com/WeirdMath/SwiftyHaru'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sergej Jaskiewicz' => 'jaskiewiczs@icloud.com' }
  s.source           = { :git => 'https://github.com/WeirdMath/SwiftyHaru.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"
  s.requires_arc = true

  s.subspec 'CLibPNG' do |ss|
    ss.source_files = 'Sources/CLibPNG/**/*.{h,c}'
    ss.preserve_paths = 'Sources/CLibPNG/module.modulemap'
    ss.libraries = 'z'
  end
  s.subspec 'CLibHaru' do |ss|
    ss.dependency 'SwiftyHaru/CLibPNG'
    ss.source_files = 'Sources/CLibHaru/**/*.{h,c}'
    ss.preserve_paths = 'Sources/CLibHaru/module.modulemap'
    ss.libraries = 'z'
  end
  s.subspec 'SwiftyHaru' do |ss|
    ss.dependency 'SwiftyHaru/CLibHaru'
    ss.source_files = 'Sources/SwiftyHaru/**/*.swift'
    ss.pod_target_xcconfig = {'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/SwiftyHaru/Sources/CLibHaru/**'}
  end
end
