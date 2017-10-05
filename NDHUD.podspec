Pod::Spec.new do |s|

  s.name             = "NDHUD"
  s.version          = "0.1.6"
  s.summary          = "NDHUD is loading HUD for iOS"
  
  s.homepage         = "https://github.com/dhnghia22/NDHUD"
  s.license          = 'MIT'
  s.author           = { "Nghia Dinh" => "dhnghia22@gmail.com" }
  s.source           = { :git => "https://github.com/dhnghia22/NDHUD.git", :tag => s.version.to_s }

  s.platform     = :ios
  s.ios.deployment_target = '9.0'
  s.source_files = 'NDHUD/NDHUD/*.swift'
  s.resources    =  ['NDHUD/NDHUD/NDHUD.bundle', 'NDHUD/NDHUD/*.{xib}']

end