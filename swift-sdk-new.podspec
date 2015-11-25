
Pod::Spec.new do |s|
  s.name         = "swift-sdk-new"
  s.version      = "0.0.1"
  s.summary      = "NEW RCSDK POD"
  s.description  = <<-DESC
                   Sample rcsdk swift pod
                   DESC

  s.homepage     = "https://github.com/anilkumarbp/swift-sdk-new"
  s.platform     = :osx, "10.10"
  s.license      = "MIT"
  s.author             = { "Anil Kumar" => "anil.akbp@gmail.com" }
  s.source       = { :git => "https://github.com/anilkumarbp/swift-sdk-new.git", :commit => "5cb2f282103620b6cf47a0009998248f54f62204" }
  s.source_files  = "src/Core","src/Http","src/Platform","src/Subscription","src/Subscription/crypt"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
  s.dependency 'PubNub', '~>4.0'
end
