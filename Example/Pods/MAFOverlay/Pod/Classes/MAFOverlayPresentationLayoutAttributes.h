//
//  MAFOverlayPresentationLayoutAttributes.h
//  MAFOverlay
//
//  Created by Jed Lewison on 1/14/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

@import UIKit;
#import "MAFOverlayPresentationContext.h"

/**
 An `MAFOverlayPresentationLayoutAttributes` object defines layout attributes for the presentation. The coordinator will ask its data source for initial and dismissed layout attributes as well as presented layout attributes. It will only ask once for initial and final attributes, but may ask multiple times for presented attributes in response to screen size changes or rotations.
 */
@interface MAFOverlayPresentationLayoutAttributes : NSObject <NSCopying>

/** The frame of the presented view controller's view */
@property (nonatomic) CGRect frame;

/** The alpha value of the presented view controller's view */
@property (nonatomic) CGFloat alpha; // default 1.

/** The transform of the presented view controller's view. Not currently implemented. */
@property (nonatomic) CGAffineTransform transform; // default identify

/** The transparency level for the dimming view */
@property (nonatomic) CGFloat dimmingViewAlpha; //default 1.f

/** The frame for the decoration view. MAFOverlayPresentationCoordinator uses this rectangle to define the frame for the arrow in presentations with source views and/or bar button items */
@property (nonatomic) CGRect decorationViewFrame;

/** The corner radius to be applied to the presented view controller's view. Default is 10. */
@property (nonatomic) CGFloat cornerRadius;

/** Tint adjustment mode for presentedViewController. Default is UIViewTintAdjustmentModeAutomatic. */
@property (nonatomic) UIViewTintAdjustmentMode presentedViewTintAdjustmentMode;

/** Tint adjustment mode for presentingViewController. Default is UIViewTintAdjustmentModeDimmed. */
@property (nonatomic) UIViewTintAdjustmentMode presentingViewTintAdjustmentMode;

/** The minimum margin insets for presentations. Default is 8 points on all edges. */
@property (nonatomic) UIEdgeInsets minimumMargin;

/** Applies the attributes to the presentation, making adjustments if necessary for iOS 7 in Landscape and portrait updside down orientations

 @param presentationContext The presentation context to which to apply the layout. */
- (void)applyToPresentationContext:(id<MAFOverlayPresentationContext>)presentationContext;

@end
