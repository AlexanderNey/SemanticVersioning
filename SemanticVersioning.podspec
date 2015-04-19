Pod::Spec.new do |s|
  s.name = 'SemanticVersioning'
  s.version = '1.0.0-beta'
  s.license = { :type => "MIT" }
  s.summary = 'Elegant Semantic Versioning in Swift'
  s.homepage = 'https://github.com/AlexanderNey/SemanticVersioning'
  s.social_media_url = 'http://twitter.com/Ajax64'
  s.authors = { 'Alexander Ney' => 'alexander.ney@me.com' }
  s.source = { :git => 'https://github.com/AlexanderNey/SemanticVersioning.git', :tag => s.version }

  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Source/*.swift'

end