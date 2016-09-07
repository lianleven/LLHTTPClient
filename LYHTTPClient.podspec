#
#  Be sure to run `pod spec lint LYHTTPClient.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  Pod::Spec.new do |s|

  s.name         = 'LYHTTPClient'
  s.version      = '0.0.1'
  s.summary      = '基于AFNetworking3.0，实现简单的缓存'
  s.homepage     = 'https://github.com/lianleven/LYHTTPClient'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'lianleven' => 'lianleven@163.com' }
  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/lianleven/LYHTTPClient.git', :tag => '0.0.1' }
  s.source_files  = 'LYHTTPClient/*.{h,m}'
  s.requires_arc = true
  s.dependency "AFNetworking", "~> 3.1.0"
  s.dependency "YYCache"
  end
