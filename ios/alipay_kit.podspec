#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint alipay_kit.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'alipay_kit'
  s.version          = '1.0.0'
  s.summary          = 'A powerful alipay plugin for Flutter.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.resources = "Libraries/*.bundle"
  s.vendored_frameworks = 'Libraries/*.framework'
  s.frameworks = 'CFNetwork', 'CoreGraphics', 'CoreMotion', 'CoreTelephony', 'CoreText', 'Foundation', 'SystemConfiguration', 'UIKit', 'WebKit'
  s.libraries = 'c++', 'z'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
