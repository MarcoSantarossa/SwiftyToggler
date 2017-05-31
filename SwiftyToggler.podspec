Pod::Spec.new do |s|
  s.name = 'SwiftyToggler'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'A Swifty way to toggle your features.'
  s.homepage = 'https://github.com/MarcoSantarossa/SwiftyToggler'
  s.social_media_url = 'http://twitter.com/MarcoSantaDev'
  s.authors = { 'Marco Santarossa' => 'marcosantadev@gmail.com' }
  s.source = { :git => 'https://github.com/MarcoSantarossa/SwiftyToggler.git', :tag => s.version }
  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/**/*.swift'
  s.exclude_files = ['Tests/**/*.swift', 'Examples/**/*.*']

end