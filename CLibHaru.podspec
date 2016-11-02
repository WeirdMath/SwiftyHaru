Pod::Spec.new do |s|
  s.name             = 'CLibHaru'
  s.version          = '0.1.0'
  s.summary          = 'libharu - free PDF library'

  s.homepage         = 'http://libharu.org'
  s.license = { :type => 'ZLIB/LIBPNG', :text => <<-LICENSE
                  Copyright (C) 1999-2006 Takeshi Kanno
                  Copyright (C) 2007-2009 Antony Dovgal

                  This software is provided 'as-is', without any express or implied warranty.

                  In no event will the authors be held liable for any damages arising from the
                  use of this software.

                  Permission is granted to anyone to use this software for any purpose,including
                  commercial applications, and to alter it and redistribute it freely, subject
                  to the following restrictions:

                  1. The origin of this software must not be misrepresented; you must not claim
                  that you wrote the original software. If you use this software in a
                  product, an acknowledgment in the product documentation would be
                  appreciated but is not required.
                  2. Altered source versions must be plainly marked as such, and must not be
                  misrepresented as being the original software.
                  3. This notice may not be removed or altered from any source distribution.
                 LICENSE
               }
  s.author           = 'Takeshi Kanno', 'Antony Dovgal'
  s.source           = { :git => 'https://github.com/WeirdMath/SwiftyHaru.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.dependency 'CLibPNG', '~> 0.1'

  s.source_files = 'Sources/CLibHaru/**/*.{h,c}'
  s.libraries = 'z'
  s.module_map = 'Sources/CLibHaru/module.modulemap'
end
