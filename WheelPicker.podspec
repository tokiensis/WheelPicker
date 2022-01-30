Pod::Spec.new do |s|
  s.name             = "WheelPicker-SwiftUI"
  s.version          = "1.0.1"
  s.summary          = "Pure-SwiftUI WheelPicker providing a circular, finite, or infinite selection."
  s.homepage         = "https://github.com/tokiensis/WheelPicker"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { "tokiensis" => "tokiensis@wataku-city.com" }
  s.source           = { git: "https://github.com/tokiensis/WheelPicker.git", tag: s.version }
  s.ios.deployment_target = '14.0'
  s.osx.deployment_target = '11.0'
  s.requires_arc = true
  s.source_files = 'WheelPicker/Sources/*.{swift}'
end
