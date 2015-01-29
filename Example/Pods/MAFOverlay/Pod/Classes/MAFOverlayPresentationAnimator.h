//
//  MAFOverlayPresentationAnimator.h
//  MAFOverlay
//
//  Created by Jed Lewison on 1/1/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import "MAFOverlayPresentationDataSource.h"
#import "MAFOverlayPresentationContext.h"

@import UIKit;

/**
 `MAFOverlayPresentationAnimator`
 */
@interface MAFOverlayPresentationAnimator : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, MAFOverlayPresentationContext>

/**
 The controller's data source. You can use a custom data source to completely control the presentation layout. The presentationCoordinator typically is the data source, but if you want to only slightly tweak its default layout selections, your object can forward messages to the coordinator as a starting point.
 */

@property (nonatomic, weak) id<MAFOverlayPresentationDataSource> dataSource;

/**
 Creates a new presentation animator for MAFOverlay presentations. Typically created by a MAFOverlayPresentationCoordinator

 @param dataSource              The animator's datasource. Typically, the controller that created it.
 @param presentedViewController The presented view controller

 @note For use on iOS 7.

 @return Newly created presentation animator.
 */
+ (instancetype)overlayPresentationAnimatorWithDataSource:(id<MAFOverlayPresentationDataSource>)dataSource presentedViewController:(UIViewController *)presentedViewController;

/** To properly handle rotation on iOS 7 devices, call this method in willAnimateRotationToInterfaceOrientation
 @param toInterfaceOrientation The animation's target interface orientation
 */

-(void)performLayoutForRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end
