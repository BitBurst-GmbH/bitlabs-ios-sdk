#
# Be sure to run `pod lib lint BitLabs.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
    spec.name             = 'BitLabs'
    spec.version          = '3.2.0'
    spec.summary          = 'BitLabs - monetize your app with rewarded surveys.'
    spec.description      = 'BitLabs offers the opportunity to monetize your app with rewarded surveys easily.'
    spec.homepage         = 'https://github.com/BitBurst-GmbH/bitlabs-ios-sdk'
    # s.screenshots       = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    spec.license          = 'Commercial'
    spec.author           = { 'BitBurst GmbH' => 'bitlabs@bitburst.net' }
    spec.source           = { :git => 'https://github.com/BitBurst-GmbH/bitlabs-ios-sdk.git', :tag => spec.version.to_s }
    # s.social_media_url  = 'https://twitter.com/<TWITTER_USERNAME>'
    
    spec.swift_version = '5.0'
    spec.ios.deployment_target = '12.0'
    spec.dependency 'Alamofire', '~> 5.9.0'
    
    spec.default_subspec = 'Core'
    
    spec.subspec 'Core' do |core|
        core.source_files = 'BitLabs/Classes/{Shared,Core}/**/*.swift'
        core.resources = ['BitLabs/Resources/{Shared,Core}/**/*.xib', 'BitLabs/Localizations/**/*.strings', 'BitLabs/Resources/{Shared,Core}/**/*.xcassets']
    end
    
    spec.subspec 'Unity' do |unity|
        unity.source_files = 'BitLabs/Classes/{Shared,Unity}/**/*.swift'
        unity.resources = ['BitLabs/Resources/Shared/**/*.xib', 'BitLabs/Localizations/**/*.strings', 'BitLabs/Resources/Shared/**/*.xcassets']
    end
    
#    spec.app_spec 'AppHost' do |host|
#        host.source_files = 'BitLabs/AppHost/**/*.{swift}'
#        host.resources = 'BitLabs/AppHost/**/*.{xib,storyboard}'
#    end
    
#    spec.test_spec 'UnitTests' do |test_spec|
#      test_spec.source_files = 'BitLabs/Tests/Unit\ Tests/*.swift'
#      test_spec.dependency 'OHHTTPStubs/Swift'
#    end
    
#    spec.test_spec 'UITests' do |test_spec|
#        test_spec.test_type = :ui
#
#        test_spec.requires_app_host = true
#        test_spec.app_host_name = 'BitLabs/AppHost'
#        test_spec.dependency 'BitLabs/AppHost'
#
#        test_spec.source_files = 'BitLabs/Tests/UI\ Tests/*.swift'
#    end
end

