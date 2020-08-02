Pod::Spec.new do |spec|
  spec.name                  = "SimplePermissions"
  spec.version               = "0.1.1"
  spec.summary               = "Simple solution for working with iOS permissions"
  spec.requires_arc          = true

  spec.license               = { :type => "MIT", :file => "LICENSE" }

  spec.author                = { "Ruslan Shevtsov" => "ruslan.shevtsov.dev@gmail.com" }
  spec.homepage              = "https://github.com/RuslanShevtsovDev/SimplePermissions"


  spec.platform              = :ios
  spec.ios.deployment_target = "13.0"

  spec.source                = { :git => "https://github.com/RuslanShevtsovDev/SimplePermissions.git", :tag => "#{s.version}" }

  spec.source_files          = "Classes", "SimplePermissions/**/*.{swift}"
  spec.swift_version         = "5.0"
end
