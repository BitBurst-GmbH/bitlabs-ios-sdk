#
# Be sure to run `pod lib lint BitLabSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name             = 'BitLabSDK'
  spec.version          = '0.1.0'
  spec.summary          = 'A short description of BitLabSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  spec.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  spec.homepage         = 'https://github.com/Frank Marx/BitLabSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'Frank Marx' => 'marxfr@web.de' }
  spec.source           = { :git => 'https://github.com/Frank Marx/BitLabSDK.git', :tag => spec.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  spec.ios.deployment_target = '12.0'

  spec.source_files = 'BitLabSDK/Classes/Rest/**/*.swift'
  
 # spec.resource_bundles = {
 #     'BitLabSDK' => [ 'BitLabSDK/Classes/**/*.{xib}' , 'BitLabSDK/Classes/Localizations/*.lproj/*.strings' ]
 # }
  # s.resources = ['UICommon/Classes/**/*.{xib}', 'UICommon/Classes/**/*.{xcassets}']
 spec.resources = ['BitLabSDK/Classes/**/*.{xib}' , 'BitLabSDK/Localizations/en.lproj/Localizable.strings' , 'BitLabSDK/Localizations/de-DE.lproj/Localizable.strings']

  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  spec.dependency 'Alamofire', '~> 5.2'
  spec.dependency 'SwiftyJSON' , '~> 5.0'
end

