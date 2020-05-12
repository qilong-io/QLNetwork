Pod::Spec.new do |s|
  s.name         = "QLNetwork"
  s.version      = "0.0.6"
  s.summary      = "对ANNetworking 封装，删除UIWebView相关"
  s.description  = <<-DESC
	    对ANNetworking 进行封装以方便自己使用
                   DESC
  s.homepage     = "https://github.com/qilong-io/QLNetwork"
  s.license 	 = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "qilong" => "915464855@qq.com" }
  s.platform	 = :ios
  s.platform 	 = :ios,"9.0"
  s.source       = { :git => "https://github.com/qilong-io/QLNetwork.git", :tag => "#{s.version}" }
  s.source_files  = "QLNetworkDemo/QLNetworkDemo/QLNetwork/*.{h,m}"

  s.dependency 'AFNetworking/Reachability', '~> 3.2.1'
  s.dependency 'AFNetworking/Serialization', '~> 3.2.1'
  s.dependency 'AFNetworking/Security', '~> 3.2.1'
  s.dependency 'AFNetworking/NSURLSession', '~> 3.2.1'
  s.dependency 'YYCache', '~> 1.0.4'
  s.requires_arc = true
end
