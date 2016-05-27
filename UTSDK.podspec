Pod::Spec.new do |s|
  s.name         = "UTSDK"
  s.version      = "1.0.0"
  s.summary      = "UTeacher SDK library"
  s.homepage     = "https://github.com/sebarina/UTSDK"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "sebarina xu" => "sebarinaxu@gmail.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/sebarina/UTSDK.git", :tag => "1.0.0" }
  s.source_files  = "UTSDK/**/*"
  s.vendored_frameworks = "UTCommonCryto.framework"

  s.requires_arc = true

  s.dependency 'UTNetwork', '~> 1.0.0'
  s.dependency 'UTKeychainSecurity', '~> 1.1.0'

end
