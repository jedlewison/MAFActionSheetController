//  MAFActionSheetController.h
//
// Copyright (c) 2015 Magic App Factory, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

@import UIKit;
#import "MAFActionSheetItem.h"
#import <MAFOverlay/MAFOverlayPresentationCoordinator.h>

/**
 When the action sheet controller fires the appropriate completion handler.
 */
typedef NS_ENUM(NSUInteger, MAFActionSheetItemHandlerTiming){
    /**
     Action item handlers will be called after actionSheetController is dismissed MAFActionSheetItemHandlerTimingBeforeStartingDismissal. This is the default behavior.
     */
    MAFActionSheetItemHandlerTimingAfterCompletingDismissal,
    /**
     Action item handlers called before actionSheetController is dismissed.
     */
    MAFActionSheetItemHandlerTimingBeforeStartingDismissal
};

/**
 `MAFActionSheetController` manages action sheet-style view controllers on iOS 7+ using MAFOverlay to present as an overlay from a bar button item or a view.

 - Similar to UIAlertController, but with full control over layout and works with iOS 7+.
 - Default layout is similar to popover style on iPhone
 - Add custom header and footer
 - Supports vertical scrolling for long sheets
 - Choose primary and detail text attributes.
 - Supply a custom background view for each action item to completely customize appearance.
 - Uses MAFOverlay to coordinate presentations
 */


@interface MAFActionSheetController : UIViewController

/**
 Creates a new action sheet controller instance with the specified header and footer view.

 Action sheet items must be added to the controller before presenting it. To handle cancellation, add an cancellation item.
 
 The controller's presentation is managed by an overlay presentation coordinator, which it creates on intialization.
 
@param headerView An optional header view that will appear at the top of the action sheet.
@param footerView An optional footer view that will appear at the top of the action sheet.

@note Header and footer width will be expanded if necessary. Their initial height will equal the the frame height at the time the action sheet controller is presented. If action sheet must scroll for all action items to be visible, the header and footer will expand as necessary.
 
@return The newly-created action sheet controller.
 */
+ (instancetype)actionSheetControllerWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView;

/**
The action sheet controller's overlay presentation coordinator, which manages its presentation. Set the coordinator's sourceView, sourceBarButtonItem, or anchor point to control the controller's location when presented.
 */

@property (nonatomic, readonly) MAFOverlayPresentationCoordinator *overlayPresentationCoordinator;

/**
 Add actionSheetItems to the controller. The number and contents of the items determine the size of the controller.
 
 To handle cancellation, create an MAFActionSheetItem with a cancellation handler. The cancellation handler will fire when the user taps outside the presented action sheet controller. Only the last cancellation handler added will be used; all others will be discarded. The cancellation handler will not fire if the action sheet controller is programmatically dismissed.
 
 @param actionSheetItem The item to add.
 */
- (void)addItem:(MAFActionSheetItem *)actionSheetItem;

/** Determines whether actions are fired before or after the action sheet controller is dismissed. Default is after. */
@property (nonatomic) MAFActionSheetItemHandlerTiming itemHandlerTiming; //

/** Attributes dictionary for title label attributed text */
@property (nonatomic) NSDictionary *titleLabelAttributes;

/** Attributes dictionary for detail text label attributed text. */
@property (nonatomic) NSDictionary *detailTextlabelAttributes;

/** The color separating footer and header content from the items. Set to clear for no color. Default black with 35% opacity. */
@property (nonatomic) UIColor *footerHeaderSeparatorColor;

@end
