Pod::Spec.new do |s|

  s.name         = "Card"
  s.version      = "1.0.0"
  s.summary      = "A Card Scroll View"
  s.homepage     = "https://github.com/Qmzy/Card"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.author             = { "Qmzy" => "email@address.com" }
  s.source       = { :git => "https://github.com/Qmzy/Card.git", :tag => "#{s.version}" }
  s.source_files  = "Card", "Card/Card/Card/*.{h,m}"
  s.requires_arc = true
  s.dependency "Masonry", "~> 0.6.2"

end
