
Pod::Spec.new do |s|
  s.name             = "MMImagePicker"
  s.version          = "1.0"
  s.summary          = "A image picker used on iOS."
  s.description      = <<-DESC
                       It is a image picker used on iOS, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/dexianyinjiu/MMImagePicker"
  # s.screenshots    = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "LEA" => "1625977078@qq.com" }
  s.source           = { :git => "https://github.com/dexianyinjiu/MMImagePicker.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/NAME'

  s.platform         = :ios, '7.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'MMImagePicker/*'
  # s.resources = 'Assets'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'AssetsLibrary', 'UIKit'

end
