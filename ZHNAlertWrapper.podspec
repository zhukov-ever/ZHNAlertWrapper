Pod::Spec.new do |s|
  s.name                      = "ZHNAlertWrapper"
  s.version                   = "0.1.0"
  s.summary                   = "Category for UIViewController"
  s.homepage                  = "https://github.com/zhukov-ever/ZHNAlertWrapper"
  s.license                   = { :type => "MIT", :file => "LICENSE" }
  s.author                    = { "Zhn" => "zhukov.ever@gmail.com" }
  s.platform                  = :ios, '7.0'
  s.source                    = { :git => "https://github.com/zhukov-ever/ZHNAlertWrapper.git", :tag => s.version.to_s, :submodules => true }
  s.source_files              = "Classes", "Classes/**/*.{h,m}"
  s.public_header_files       = "Classes/**/*.h"
  s.framework                 = "Foundation"
  s.requires_arc              = true

  s.dependency 'MBProgressHUD', '~> 0.9'
end
