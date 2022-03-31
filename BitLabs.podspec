#
# Be sure to run `pod lib lint BitLabs.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
    spec.name             = 'BitLabs'
    spec.version          = '0.1.7'
    spec.summary          = 'BitLabs - monetize your app with rewarded surveys.'
    spec.description      = 'BitLabs offers the opportunity to monetize your app with rewarded surveys easily.'
    spec.homepage         = 'https://github.com/BitBurst-GmbH/bitlabs-ios-sdk'
    # s.screenshots       = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    spec.license          = 'Commercial'
    spec.author           = { 'BitBurst GmbH' => 'bitlabs@bitburst.net' }
    spec.source           = { :git => 'https://github.com/BitBurst-GmbH/bitlabs-ios-sdk.git', :tag => spec.version.to_s }
    # s.social_media_url  = 'https://twitter.com/<TWITTER_USERNAME>'
    
    spec.default_subspec = 'Core'
    
    spec.ios.deployment_target = '11.0'
    
    spec.source_files = 'BitLabs/Classes/**/*.swift'
    
    spec.resources = ['BitLabs/Classes/**/*.xib', 'BitLabs/Localizations/**/*.strings']
    
    spec.subspec 'Core' do |sp|
        sp.source_files = 'BitLabs/Classes/Shared/**/*.swift', 'BitLabs/Classes/Core/*.swift'
        sp.resources = ['BitLabs/Classes/Shared/**/*.xib', 'BitLabs/Localizations/**/*.strings']
    end
    
    spec.subspec 'Unity' do |sp|
        sp.source_files = 'BitLabs/Classes/Shared/**/*.swift', 'BitLabs/Classes/Unity/*.swift'
        sp.resources = ['BitLabs/Classes/Shared/**/*.xib', 'BitLabs/Localizations/**/*.strings']
    end
        
    spec.swift_version = '5.0'
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    spec.dependency 'Alamofire', '~> 5.5'
end

