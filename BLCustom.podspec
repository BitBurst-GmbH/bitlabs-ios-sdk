Pod::Spec.new do |spec|
    spec.name             = 'BLCustom'
    spec.version          = '0.1.0'
    spec.summary          = 'BitLabs - monetize your app with rewarded surveys.'
    spec.description      = 'BitLabs offers the opportunity to monetize your app with rewarded surveys easily.'
    spec.homepage         = 'https://github.com/BitBurst-GmbH/bitlabs-ios-sdk'
    spec.license          = 'Commercial'
    spec.author           = { 'BitBurst GmbH' => 'bitlabs@bitburst.net' }
    spec.source           = { :git => 'https://github.com/BitBurst-GmbH/bitlabs-ios-sdk.git', :branch => 'blcustom' }
    
    spec.swift_version = '5.0'
    spec.ios.deployment_target = '12.0'
    
    spec.source_files = 'BitLabs/{Shared,Core}/**/*.swift'
    
    spec.resource_bundles = {
        'BitLabsResources' => ['BitLabs/Shared/Resources/**/*.{xib,strings,xcassets}']
    }
end

