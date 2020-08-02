Pod::Spec.new do |spec|

  spec.name         = "SimplePermissions"
  spec.version      = "0.1.0"
  spec.summary      = "Simple solution for working with iOS permissions"
  s.requires_arc    = true

  spec.license      = "MIT (example)"

  spec.author       = { "Ruslan Shevtsov" => "ruslan.shevtsov.dev@gmail.com" }


  spec.platform     = :ios
  spec.ios.deployment_target = "13.0"

  spec.source       = { :git => "https://github.com/RuslanShevtsovDev/SimplePermissions.git", :tag => "0.1.0" }

  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"
end
