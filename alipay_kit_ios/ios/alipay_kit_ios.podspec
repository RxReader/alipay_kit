#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint alipay_kit_ios.podspec` to validate before publishing.
#

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

calling_dir = File.dirname(__FILE__)
flutter_project_dir = calling_dir.slice(0..(calling_dir.index('/ios/.symlinks')))
# cfg = YAML.load_file(File.join(File.expand_path('../../../../..', File.dirname(__FILE__)), 'pubspec.yaml'))
cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'))
if cfg['alipay_kit']
    if cfg['alipay_kit']['ios'] == 'noutdid'
        alipay_kit_subspec = 'noutdid'
    else
        alipay_kit_subspec = 'utdid'
    end
else
    # 5.x.y 版本将删除
    if defined?($AlipayKitSubspec)
      alipay_kit_subspec = $AlipayKitSubspec
    else
      alipay_kit_subspec = 'utdid'
    end
end
Pod::UI.puts "alipaysdk #{alipay_kit_subspec}"

Pod::Spec.new do |s|
  s.name             = 'alipay_kit_ios'
  s.version          = library_version
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
  s.platform = :ios, '9.0'

  # v15.8.10
  # s.default_subspecs = :none
  s.default_subspec = alipay_kit_subspec

  s.subspec 'utdid' do |sp|
    sp.resources = "Libraries/utdid/*.bundle"
    sp.vendored_frameworks = 'Libraries/utdid/*.framework'
    sp.frameworks = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation', 'CFNetwork', 'CoreMotion', 'WebKit'
    sp.libraries = 'c++', 'z'
  end

  s.subspec 'noutdid' do |sp|
    sp.resources = "Libraries/noutdid/*.bundle"
    sp.vendored_frameworks = 'Libraries/noutdid/*.framework'
    sp.frameworks = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation', 'CFNetwork', 'CoreMotion', 'WebKit'
    sp.libraries = 'c++', 'z'
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
