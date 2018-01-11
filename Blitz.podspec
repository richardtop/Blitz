Pod::Spec.new do |s|
  s.name             = 'Blitz'
  s.version          = '0.1.0'
  s.summary          = 'Component layout framework based on UICollectionView'
  s.homepage         = "https://github.com/richardtop/Blitz"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Richard Topchii" => "richardtop@users.noreply.github.com" }
  s.source           = { :git => "https://github.com/richardtop/Blitz.git", :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/richardtop'
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.source_files = 'Source/**/*'
end
