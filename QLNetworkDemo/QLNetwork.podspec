Pod::Spec.new do |s|
  s.name         = "QLNetwork"
  s.version      = "0.0.1"
  s.summary      = "对ANNetworking 封装"
  s.description  = <<-DESC
	    对ANNetworking 进行封装以方便自己使用
                   DESC
  s.homepage     = "https://github.com/mark1225/QLNetwork"
  s.license 	 = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "qilong" => "915464855@qq.com" }
  s.platform	 = :ios
  s.platform 	 = :ios,"9.0"
  s.source       = { :git => "https://github.com/mark1225/QLNetwork.git", :tag => "#{s.version}" }
  s.source_files  = "QLNetwork/*.{h,m}"

  s.dependency 'AFNetworking', '~> 3.2.1'
  s.dependency 'YYCache', '~> 1.0.4'
  s.requires_arc = true
end
