#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint alipay_kit.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'alipay_kit'
  s.version          = '2.2.0'
  s.summary          = 'A powerful Flutter plugin allowing developers to auth/pay with natvie Android & iOS Alipay SDKs.'
  s.description      = <<-DESC
A powerful Flutter plugin allowing developers to auth/pay with natvie Android & iOS Alipay SDKs.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # v15.8.01
  s.subspec 'vendor' do |sp|
    sp.resources = "Libraries/*.bundle"
    sp.vendored_frameworks = 'Libraries/*.framework'
    sp.frameworks = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation', 'CFNetwork', 'CoreMotion', 'WebKit'
    sp.libraries = 'c++', 'z'
  end

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
