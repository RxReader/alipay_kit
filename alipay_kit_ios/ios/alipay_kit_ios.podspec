#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint alipay_kit_ios.podspec` to validate before publishing.
#

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

current_dir = Dir.pwd
calling_dir = File.dirname(__FILE__)
project_dir = calling_dir.slice(0..(calling_dir.index('/.symlinks')))
flutter_project_dir = calling_dir.slice(0..(calling_dir.index('/ios/.symlinks')))
cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'))
if cfg['alipay_kit'] && cfg['alipay_kit']['ios'] == 'noutdid'
    alipay_kit_subspec = 'noutdid'
else
    alipay_kit_subspec = 'utdid'
end
Pod::UI.puts "alipaysdk #{alipay_kit_subspec}"
if cfg['alipay_kit'] && cfg['alipay_kit']['scheme']
    scheme = cfg['alipay_kit']['scheme']
    system("ruby #{current_dir}/alipay_setup.rb -s #{scheme} -p #{project_dir} -n Runner.xcodeproj")
else
    abort("alipay scheme is null, add code in pubspec.yaml:\nalipay_kit:\n  scheme: ${your alipay scheme} # scheme 不能为纯数字，推荐：alipay${appId}\n")
end

Pod::Spec.new do |s|
  s.name             = 'alipay_kit_ios'
  s.version          = library_version
  s.summary          = pubspec['description']
  s.description      = pubspec['description']
  s.homepage         = pubspec['homepage']
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # v15.8.14
  # s.default_subspecs = :none
  s.default_subspecs = alipay_kit_subspec, 'vendor'

  s.subspec 'utdid' do |sp|
    sp.resources = "Libraries/utdid/*.bundle"
    sp.vendored_frameworks = 'Libraries/utdid/*.framework'
  end

  s.subspec 'noutdid' do |sp|
    sp.resources = "Libraries/noutdid/*.bundle"
    sp.vendored_frameworks = 'Libraries/noutdid/*.framework'
  end

  s.subspec 'vendor' do |sp|
    sp.frameworks = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation', 'CFNetwork', 'CoreMotion', 'WebKit'
    sp.libraries = 'c++', 'z'
    sp.pod_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => "ALIPAY_KIT_SCHEME=\\@\\\"#{scheme}\\\""
    }
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
