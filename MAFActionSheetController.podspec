Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "MAFActionSheetController"
  s.version      = "0.0.2"
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
  s.screenshots  = "https://raw.githubusercontent.com/jedlewison/MAFActionSheetController/master/MAFActionSheetController%20iPhone%20Portrait.png", "https://raw.githubusercontent.com/jedlewison/MAFActionSheetController/master/MAFActionSheetController%20iPhone%20Landscape.png"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Jed Lewison" => "jed@magicappfactory.com" }
  s.social_media_url   = "http://twitter.com/jedlewison"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/jedlewison/MAFActionSheetController.git", :tag => "0.0.2" }
  s.source_files  = "MAFActionSheetController", "MAFActionSheetController/*.{h,m}"
  s.dependency 'MAFOverlay', '~> 0.0.1'
  s.framework = "UIKit"
  s.requires_arc = true
end
