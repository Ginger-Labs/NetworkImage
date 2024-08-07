Pod::Spec.new do |spec|
  spec.name             = 'NetworkImage'
  spec.summary          = 'NetworkImage'
  spec.version          = '6.0.0'
  spec.homepage         = 'https://github.com/Ginger-Labs/NetworkImage'
  spec.license          = 'MIT'
  spec.author           = 'Guille Gonzalez'
  spec.source           = {
    :git => 'https://github.com/Ginger-Labs/NetworkImage.git',
    :branch => 'main'
  }

  spec.ios.deployment_target = '15.0'
  spec.osx.deployment_target = '12.0'
  spec.tvos.deployment_target = '15.0'
  spec.watchos.deployment_target = '8.0'

  spec.source_files = 'Sources/**/*'
  spec.ios.framework = 'SwiftUI'
end
