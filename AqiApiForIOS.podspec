Pod::Spec.new do |s|
  s.name         = "AqiApiForIOS"
  s.version      = "0.0.1"
  s.summary      = "AqiApiForIOS."
  s.homepage     = "https://github.com/xuyannan/AqiApiForIOS"
  s.license      = {:type => "MIT", :text => "LICENSE"} 
  s.author       = { "xuyannan" => "xyn0563@gmail.com" }
  s.source       = { :git => "https://github.com/xuyannan/AqiApiForIOS.git", :tag => "0.0.1" }
  s.platform     = :ios, '6.0'
  s.source_files = 'AqiApiForIOS/AqiAPI.{h,m}'
  s.dependency 'KissXML', '~> 5.0'
end
