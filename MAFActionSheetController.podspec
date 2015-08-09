Pod::Spec.new do |s|
    s.name             = "MAFActionSheetController"
    s.version          = "0.1.2"
    s.summary      = "Universal customizable action sheet controller for iOS 7+."

    s.description  = <<-DESC
    MAFActionSheetController manages action sheet-style view controllers on iOS 7+ using MAFOverlay to present as an overlay from a bar button item or a view.

    * Similar to UIAlertController, but with full control over layout and works with iOS 7+.
    * Default layout is similar to popover style on iPhone
    * Add custom header and footer
    * Supports vertical scrolling for long sheets
    * Choose primary and detail text attributes.
    * Supply a custom background view for each action item to completely customize appearance.
    * Uses MAFOverlay to coordinate presentations
    DESC

    s.homepage     = "https://github.com/jedlewison/MAFActionSheetController"
    s.screenshots  = "https://raw.githubusercontent.com/jedlewison/MAFActionSheetController/master/MAFActionSheetControlleriPhonePortrait.png", "https://raw.githubusercontent.com/jedlewison/MAFActionSheetController/master/MAFActionSheetControlleriPhoneLandscape.png"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "Jed Lewison" => "jed@magicappfactory.com" }
    s.social_media_url   = "http://twitter.com/jedlewison"
    s.platform     = :ios, "7.0"
    s.source           = { :git => "https://github.com/jedlewison/MAFActionSheetController.git", :tag => "0.1.1" }
    s.requires_arc = true
    s.source_files = 'Pod/Classes/**/*.{h,m}'
    s.public_header_files = 'Pod/Classes/*.h'
    s.private_header_files = 'Pod/Classes/Private/*.h'
    s.frameworks = 'UIKit'
    s.dependency 'MAFOverlay'
end
