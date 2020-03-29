Pod::Spec.new do |s|
  s.name = 'SemanticVersioning'
  s.version = '2.1.0'
  s.license = { :type => "MIT" }
  s.summary = 'Elegant Semantic Versioning in Swift 5'
  s.homepage = 'https://github.com/AlexanderNey/SemanticVersioning'
  s.social_media_url = 'http://twitter.com/Ajax64'
  s.authors = { 'Alexander Ney' => 'alexander.ney@me.com' }
  s.source = { :git => 'https://github.com/AlexanderNey/SemanticVersioning.git', :branch => 'master', :tag => "v#{s.version}" }
  s.requires_arc = true
  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'
  s.osx.deployment_target = '10.13'
  s.swift_version = '5.0'
  s.source_files = 'Source/*.swift'
end
