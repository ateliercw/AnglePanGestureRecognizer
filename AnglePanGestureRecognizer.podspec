Pod::Spec.new do |s|
  s.name             = 'AnglePanGestureRecognizer'
  s.version          = '0.1.1'
  s.summary          = 'A pan gesture recognizer subclass that allows you to lock movement to arbitrary angles.'

  s.description      = <<-DESC
A microframework focused on building an easy to use subclass of a pan gesture recognizer
designed to force touches to snap to arbitrary angles.
                       DESC

  s.homepage         = 'https://github.com/ateliercw/AnglePanGestureRecognizer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Michael Skiba' => 'mike.skiba@atelierclockwork.net', 'Matt Buckley' => 'matt@nicethings.io' }
  s.source           = { :git => 'https://github.com/ateliercw/AnglePanGestureRecognizer.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/atelierclkwrk'

  s.ios.deployment_target = '10.0'

  s.source_files = 'AnglePanGestureRecognizer/**/*'

  s.frameworks   = 'UIKit'

end
