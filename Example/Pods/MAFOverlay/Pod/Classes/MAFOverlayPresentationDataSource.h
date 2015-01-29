//
//  MAFOverlayPresentationDataSource.h
//  MAFOverlay
//
//  Created by Jed Lewison on 1/4/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

@import UIKit;
#import "MAFOverlayPresentationContext.h"
#import "MAFOverlayPresentationLayoutAttributes.h"

/**
 Presentation contexts use an object implementing the `MAFOverlayPresentationDataSource` protocol to determine layout and add views.
 */
@protocol MAFOverlayPresentationDataSource <NSObject>

/**
 @param presentationContext The presentation's context.

 @return The initial layout attributes for a presented view controller.
 */
- (MAFOverlayPresentationLayoutAttributes *)initialPresentationLayoutAttributesForContext:(id<MAFOverlayPresentationContext>)presentationContext;

/**
 @param presentationContext The presentation's context.

 @return The layout attributes for a presented view controller when it's presented. May be called multiple times during a presentation.
 */
- (MAFOverlayPresentationLayoutAttributes *)presentationLayoutAttributesForContext:(id<MAFOverlayPresentationContext>)presentationContext;

/**
 @param presentationContext The presentation's context.

 @return The final layout attributes for a presented view controller.
 */
- (MAFOverlayPresentationLayoutAttributes *)dismissedPresentationLayoutAttributesForContext:(id<MAFOverlayPresentationContext>)presentationContext;

/**
 @param presentationContext The presentation's context.

 @return The background view for the presentation. The default background view has 40% opacity and dismisses the presentation when tapped.
 */
- (UIView *)containerDimmingViewInOverlayPresentationContext:(id<MAFOverlayPresentationContext>)presentationContext;

/**
 @param presentationContext The presentation's context.

 @return The decoration view for the presentation. The default decoration view is an arrow view for presentations witha a source view or bar button item.
 */
- (UIView *)decorationView:(id<MAFOverlayPresentationContext>)presentationContext;

/**
 @param presentationContext The presentation's context.

 @return The motion group impacts the parallax effect. It needs to be updated on iOS 7 during rotation events (this happens automatically by default).
 */
- (UIMotionEffectGroup *)motionEffectGroup:(id<MAFOverlayPresentationContext>)presentationContext;

@end
