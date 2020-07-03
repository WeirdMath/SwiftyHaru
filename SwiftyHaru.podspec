Pod::Spec.new do |s|
  s.name             = 'SwiftyHaru'
  s.version          = '0.3.0'
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
  s.social_media_url = 'https://twitter.com/broadway_lamb'

  # FIXME: Remove this as soon as we find a way to compile libpng for non-macOS targets
  s.platform = :osx

  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.swift_version = '4.2'

  s.source_files = 'Sources/**/*.{swift,h,c}'
  s.public_header_files = 'Sources/CLibPNG/include/*.h', 'Sources/CLibHaru/include/*.h'
  s.private_header_files = 'Sources/CLibPNG/include/pngpriv.h',
                           'Sources/CLibPNG/include/pnginfo.h',
                           'Sources/CLibPNG/include/pngstruct.h'
  s.libraries = 'z'
end
