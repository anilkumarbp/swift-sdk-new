Pod::Spec.new do |spec|
    spec.name = "RingCentralSwift"
    spec.version = "0.0.1"
    spec.summary = "NEW RCSDK POD"
    spec.description = <<-DESC
    Sample rcsdk swift pod
    DESC
    spec.homepage = "https://github.com/anilkumarbp/swift-sdk-new"
    spec.platform = :osx, "10.10"
    spec.license = "MIT"
    spec.authors = { "Anil Kumar" => "anil.akbp@gmail.com" }
    spec.source = { :git => "https://github.com/anilkumarbp/RingCentralSwift.git", :commit => "5cb2f282103620b6cf47a0009998248f54f62204" }
    
      spec.subspec 'Core' do |core|
        core.source_files = 'src/Core'
      end
      spec.subspec 'Platform' do |platform|
        platform.source_files = 'src/Platform'
      end
      spec.subspec 'Http' do |http|
        platform.source_files = 'src/Http'
      end
      spec.subspec 'Subscription' do |subscription|
        platform.source_files = 'src/Subscription'
      end
      spec.subspec 'Crpto' do |crypto|
        platform.source_files = 'src/Subscription/crypt'
      end

    spec.exclude_files = "Classes/Exclude"
    spec.requires_arc = true
    spec.dependency 'PubNub', '~>4.0'
end