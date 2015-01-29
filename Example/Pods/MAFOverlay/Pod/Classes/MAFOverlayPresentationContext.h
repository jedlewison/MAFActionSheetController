//
//  MAFOverlayPresentationContext.h
//  MAFOverlay
//
//  Created by Jed Lewison on 1/12/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

@import UIKit;
@protocol MAFOverlayPresentationDataSource;
/**
`MAFOverlayPresentationContext` protocol defines methods adopted by objects used by the `MAFOverlayPresentationCoordinator` and its data source to perform presentation layout. On iOS 8, this is the `MAFOverlayPresentationController` and on iOS 7 it is the `MAFOverlayPresentationAnimator.`
 */

@protocol MAFOverlayPresentationContext <NSObject>

/** The presentation's presented view controller */
-(UIViewController *)presentedViewController;

/** The presentation's presenting view controller */
-(UIViewController *)presentingViewController;

/** The container view for the entire presentation */
-(UIView *)containerView;

/** The presentation's decoration view (by default, an arrow view for presentations with a source) */
-(UIView *)decorationView;

/** The presentation's dimming background view */
-(UIView *)dimmingView;

/**
 The controller's data source. You can use a custom data source to completely control the presentation layout. The presentationCoordinator typically is the data source, but if you want to only slightly tweak its default layout selections, your object can forward messages to the coordinator as a starting point.
 */
@property (nonatomic, weak) id<MAFOverlayPresentationDataSource> dataSource;

@end

/**
 `MAFOverlayPresentationContextTransitioning` protocol defines methods sent by the `MAFOverlayPresentationCoordinator` to notify presented and presentingViewControllers of transition events.
 */

@protocol MAFOverlayPresentationContextTransitioning <NSObject>
@optional
/**  Sent just before the presentation begins
 @param presentationContext The context for the presentation */
-(void)presentationContextWillPresent:(id<MAFOverlayPresentationContext>)presentationContext;
/**  Sent just after the presentation has finished presenting
 @param presentationContext The context for the presentation */
-(void)presentationContextDidPresent:(id<MAFOverlayPresentationContext>)presentationContext;
/**  Sent just before the presentation dismisses
 @param presentationContext The context for the presentation */
-(void)presentationContextWillDismiss:(id<MAFOverlayPresentationContext>)presentationContext;
/**  Sent just after the presentation completes
 @param presentationContext The context for the presentation */
-(void)presentationContextDidDismiss:(id<MAFOverlayPresentationContext>)presentationContext;
@end
