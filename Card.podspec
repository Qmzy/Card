Pod::Spec.new do |s|
  s.name         = 'Card'
  s.summary      = 'A card view used on iOS.'
  s.version      = '1.0.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'Qmzy' => '1070963935@qq.com' }
  s.social_media_url = ''
  s.homepage     = 'https://github.com/Qmzy/Card'
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/Qmzy/Card.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'Card/Card/**/*.{h,m}'
  s.public_header_files = 'Card/Card/**/*.{h}'
  
  s.frameworks = 'UIKit', 'Foundation'

end
