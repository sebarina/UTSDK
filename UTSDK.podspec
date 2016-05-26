Pod::Spec.new do |s|
  s.name         = "UTSDK"
  s.version      = "0.0.1"
  s.summary      = "UTeacher SDK library"

  s.homepage     = "https://github.com/sebarina/UTSDK"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "sebarina xu" => "sebarinaxu@gmail.com" }

  s.ios.deployment_target = "8.0"
  
  s.source       = { :git => "https://github.com/sebarina/UTSDK.git", :tag => "0.0.1" }


  s.source_files  = "UTSDK/**/*", "Tencent/*.h", "Wechat/*.h", "WeiboSDK/*.h"

  #s.public_header_files = "Tencent/*.h", "Wechat/*.h", "WeiboSDK/*.h", "UTSDK/*h"

  s.resource = "WeiboSDK/WeiboSDK.bundle"

  s.frameworks = 'ImageIO', 'SystemConfiguration', 'CoreText', 'QuartzCore', 'Security', 'UIKit', 'Foundation', 'CoreGraphics','CoreTelephony'
  s.vendored_frameworks = "UTCommonCryto.framework", "TencentOpenAPI.framework"
  s.libraries = "z", "c++", "sqlite3"
  s.vendored_libraries = "libWeChatSDK.a", "libWeiboSDK.a"
  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency 'UTNetwork', '~> 1.0.0'
  s.dependency 'UTKeychainSecurity', '~> 1.1.0'

end
