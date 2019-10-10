Pod::Spec.new do |s|
  s.name = 'SemanticVersioning'
  s.version = '2.0.1'
  s.license = { :type => "MIT" }
  s.summary = 'Elegant Semantic Versioning in Swift 4'
  s.homepage = 'https://github.com/AlexanderNey/SemanticVersioning'
  s.social_media_url = 'http://twitter.com/Ajax64'
  s.authors = { 'Alexander Ney' => 'alexander.ney@me.com' }
  s.source = { :git => 'https://github.com/AlexanderNey/SemanticVersioning.git', :branch => 'master', :tag => "v#{s.version}" }
  s.requires_arc = true
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'
  s.swift_version = '5.0'
  s.source_files = 'Source/*.swift'

end
