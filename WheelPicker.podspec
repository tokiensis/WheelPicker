Pod::Spec.new do |s|
  s.name             = "WheelPicker"
  s.version          = "1.0.0"
  s.summary          = "A short description of WheelPicker."
  s.homepage         = "https://github.com/tokiensis/WheelPicker"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { "tokiensis" => "tokiensis@wataku-city.com" }
  s.source           = { git: "https://github.com/tokiensis/WheelPicker.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/tokiensis'
  s.ios.deployment_target = '13.0'
  s.requires_arc = true
  s.ios.source_files = 'WheelPicker/Sources/**/*.{swift}'
  # s.resource_bundles = {
  #   'WheelPicker' => ['WheelPicker/Sources/**/*.xib']
  # }
  # s.ios.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'Eureka', '~> 4.0'
end
