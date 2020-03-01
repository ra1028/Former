Pod::Spec.new do |spec|
  spec.name         = "Former"
  spec.version      = "1.8.1"
  spec.author       = { "ra1028" => "r.fe51028.r@gmail.com" }
  spec.homepage     = "https://github.com/ra1028"
  spec.summary      = "Former is a fully customizable Swift library for easy creating UITableView based form."
  spec.source       = { :git => "https://github.com/ra1028/Former.git", :tag => spec.version.to_s }
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.platform = :ios, '10.0'
  spec.source_files = "Former", "Former/**/*.{swift}"
  spec.requires_arc = true
  spec.ios.deployment_target = '10.0'
  spec.ios.frameworks = ['UIKit', 'Foundation']
  spec.swift_version = '4.2'
end
