
Pod::Spec.new do |s|
  s.name             = 'HYPickerView-ios'
  s.version          = '0.0.4'
  s.summary          = 'HYPickerView-ios.'
  s.description      = <<-DESC
对系统 UIPickerView 的封装，以及一些常用的 PickerView
                       DESC
  s.homepage         = 'https://github.com/oceanfive/HYPickerView-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'oceanfive' => '849638313@qq.com' }
  s.source           = { :git => 'https://github.com/oceanfive/HYPickerView-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '7.0'
  s.source_files = 'HYPickerView-ios/Classes/**/*'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
