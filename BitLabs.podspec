#
# Be sure to run `pod lib lint BitLabs.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

info_plist_path = 'Example/Example_BitLabs/Info.plist'
plist = Xcodeproj::Plist.read_from_path(info_plist_path)
version = plist['CFBundleShortVersionString']

Pod::Spec.new do |spec|
    spec.name             = 'BitLabs'
    spec.version          = version
    spec.summary          = 'BitLabs - monetize your app with rewarded surveys.'
    spec.description      = 'BitLabs offers the opportunity to monetize your app with rewarded surveys easily.'
    spec.homepage         = 'https://github.com/BitBurst-GmbH/bitlabs-ios-sdk'
    spec.license          = 'Commercial'
    spec.author           = { 'BitBurst GmbH' => 'bitlabs@bitburst.net' }
    spec.source           = { :git => 'https://github.com/BitBurst-GmbH/bitlabs-ios-sdk.git', :tag => spec.version.to_s }
    
    spec.swift_version = '5.0'
    spec.ios.deployment_target = '12.0'
    
    spec.resource_bundles = {
        'BitLabsResources' => ['BitLabs/Shared/Resources/**/*.{xib,strings,xcassets}']
    }
    
    spec.default_subspec = 'Core'
    
    spec.subspec 'Core' do |core|
        core.source_files = 'BitLabs/{Shared,Core}/**/*.swift'
    end

    spec.subspec 'Unity' do |unity|
        unity.source_files = 'BitLabs/{Shared,Unity}/**/*.swift'
        unity.resources = 'BitLabs/Shared/Resources/**/*.{xib,strings,xcassets}'
    end
end

