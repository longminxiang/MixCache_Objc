Pod::Spec.new do |s|
  s.name         = "MixCache_Objc"
  s.version      = "1.0.0"
  s.summary      = "easy cache object"
  s.description  = "easy cache objc object"
  s.homepage     = "https://github.com/longminxiang/MixCache_Objc"
  s.license      = "MIT"
  s.author       = { "Eric Lung" => "longminxiang@gmail.com" }
  s.source       = { :git => "https://github.com/longminxiang/MixCache_Objc.git", :tag => "v" + s.version.to_s }
  s.requires_arc = true
  s.platform     = :ios, '8.0'
  s.source_files = "MixCache/MixCache/*.{h, m}"
end
