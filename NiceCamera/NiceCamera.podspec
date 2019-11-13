Pod::Spec.new do |spec|

  spec.name         = "NiceCamera"
  spec.version      = "1.0.0"
  spec.summary      = "Framework for custom camera to iOS devices in swift."
  spec.description  = "Framework for custom camera to iOS devices in swift, to help get and take pictures"
  spec.homepage     = "https://github.com/moraesdan/NiceCamera"
  spec.license      = "MIT"
  spec.author       = { "moraesdan89" => "moraesdan89@gmail.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/moraesdan/NiceCamera.git", :tag => "#{spec.version}" }
  spec.source_files = "NiceCamera/**/*"
  spec.exclude_files= "NiceCamera/NiceCamera/*.plist"
 
end
