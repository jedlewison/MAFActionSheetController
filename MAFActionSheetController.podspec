Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "MAFOverlay"
  s.version      = "0.0.1"
  s.summary      = "Popover-style overlay presentation coordinator for both iPhone and iPad on iOS 7+."

  s.description  = <<-DESC
                   MAFOverlay brings popover-style overlay presentations to iPhone and iPad on iOS 7+.

                   * MAFOverlay presents view controllers as overlays
                   * Default setup should work for most cases—simply create a coordinator object for the presented view controller
                   * Handles iOS 7 rotation—simply let the coordinator know about willanimaterotation events
                   * Works well with MAFOptionActionController for customizable ActionSheet style presentations
                   * Supports a subset of popover features, including presenting from Bar Button or View
                   * Supports Cross Dissolve and Cover Vertical transitions, but is customizable
                   * Uses UIKit's custom modal presentation API
                   * Provides grain control over animation and layout through layout attributes object and datasource
                   DESC

  s.homepage     = "https://github.com/jedlewison/MAFOverlay"
  s.screenshots  = "https://raw.githubusercontent.com/jedlewison/MAFOverlay/master/OverlayPortrait.png", "https://raw.githubusercontent.com/jedlewison/MAFOverlay/master/OverlayLandscape.png"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Jed Lewison" => "jed@magicappfactory.com" }
  s.social_media_url   = "http://twitter.com/jedlewison"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/jedlewison/MAFOverlay.git", :tag => "0.0.1" }
  s.source_files  = "MAFOverlay", "MAFOverlay/**/*.{h,m}"
  s.framework = "UIKit"
  s.requires_arc = true
end
