# MAFOverlay

[![CI Status](http://img.shields.io/travis/Jed Lewison/MAFOverlay.svg?style=flat)](https://travis-ci.org/Jed Lewison/MAFOverlay)
[![Version](https://img.shields.io/cocoapods/v/MAFOverlay.svg?style=flat)](http://cocoadocs.org/docsets/MAFOverlay)
[![License](https://img.shields.io/cocoapods/l/MAFOverlay.svg?style=flat)](http://cocoadocs.org/docsets/MAFOverlay)
[![Platform](https://img.shields.io/cocoapods/p/MAFOverlay.svg?style=flat)](http://cocoadocs.org/docsets/MAFOverlay)

## About

MAFOverlay brings popover-style overlay presentations to iPhone and iPad on iOS 7+.

* MAFOverlay presents view controllers as overlays
* Default setup should work for most cases—simply create a coordinator object for the presented view controller
* Handles iOS 7 rotation—simply let the coordinator know about willanimaterotation events
* Works well with MAFOptionActionController for customizable ActionSheet style presentations
* Supports a subset of popover features, including presenting from Bar Button or View
* Supports Cross Dissolve and Cover Vertical transitions, but is customizable
* Uses UIKit's custom modal presentation API
* Provides grain control over animation and layout through layout attributes object and datasource

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

You can also run `pod try MAFOverlay`.

## Note

There's an occasional bug in the iOS simulator when presenting from a bar button item, but this bug is not visible on devices.

## Requirements

## Installation

MAFOverlay is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "MAFOverlay"

## Author

Jed Lewison, jed@magicappfactory.com

## License

MAFOverlay is available under the MIT license. See the LICENSE file for more info.

