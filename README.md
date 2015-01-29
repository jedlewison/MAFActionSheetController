# MAFActionSheetController

[![CI Status](http://img.shields.io/travis/Jed Lewison/MAFActionSheetController.svg?style=flat)](https://travis-ci.org/Jed Lewison/MAFActionSheetController)
[![Version](https://img.shields.io/cocoapods/v/MAFActionSheetController.svg?style=flat)](http://cocoadocs.org/docsets/MAFActionSheetController)
[![License](https://img.shields.io/cocoapods/l/MAFActionSheetController.svg?style=flat)](http://cocoadocs.org/docsets/MAFActionSheetController)
[![Platform](https://img.shields.io/cocoapods/p/MAFActionSheetController.svg?style=flat)](http://cocoadocs.org/docsets/MAFActionSheetController)

## About

MAFActionSheetController manages action sheet-style view controllers on iOS 7+ using MAFOverlay to present as an overlay from a bar button item or a view.

<img src="https://raw.githubusercontent.com/jedlewison/MAFActionSheetController/master/MAFActionSheetControlleriPhonePortrait.png" width=180 height=320>
<img src="https://raw.githubusercontent.com/jedlewison/MAFActionSheetController/master/MAFActionSheetControlleriPhoneLandscape.png" width=320 height=180>
## Details

* Similar to UIAlertController, but with full control over layout and works with iOS 7+.
* Default layout is similar to popover style on iPhone
* Add custom header and footer
* Supports vertical scrolling for long sheets
* Choose primary and detail text attributes.
* Supply a custom background view for each action item to completely customize appearance.
* Uses MAFOverlay to coordinate presentations

# Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Try it using `pod try MAFActionSheetController`

## Requirements

`MAFOverlay` // iOS 7+

## Installation

MAFActionSheetController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "MAFActionSheetController"

## Author

Jed Lewison, jed@magicappfactory.com

## License

MAFActionSheetController is available under the MIT license. See the LICENSE file for more info.

