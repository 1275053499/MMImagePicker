
Pod::Spec.new do |s|
  s.name             = "MMImagePicker"
  s.version          = "2.3"
  s.summary          = "A image picker used on iOS."
  s.homepage         = "https://github.com/dexianyinjiu/MMImagePicker"
  s.license          = 'MIT'
  s.author           = { "得闲饮酒" => "1625977078@qq.com" }
  s.source           = { :git => "https://github.com/dexianyinjiu/MMImagePicker.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = 'MMImagePicker/**/*.{h,m}'
  s.resources        = 'MMImagePicker/MMImagePicker.bundle'
  s.frameworks       = 'Foundation', 'UIKit', 'AssetsLibrary'

end
