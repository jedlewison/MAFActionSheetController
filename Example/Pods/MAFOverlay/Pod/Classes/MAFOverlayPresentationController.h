//
//  MAFOverlayPresentationCoordinator.h
//  MAFOverlay
//
//  Created by Jed Lewison on 1/1/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

@import UIKit;
#import "MAFOverlayPresentationDataSource.h"
#import "MAFOverlayPresentationContext.h"

/**
 `MAFOverlayPresentationController`
 */
@interface MAFOverlayPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate, MAFOverlayPresentationContext, UIViewControllerAnimatedTransitioning>

/**
 Creates a new presentation controlle for MAFOverlay presentations. Typically created by a MAFOverlayPresentationCoordinator.

 @param dataSource              The controller's dataSource. Typically, the coordinator that created it.
 @param presentedViewController The presented view controller.

 @note For use on iOS 8 only.

 @return A new MAFOverlayPresentationController
 */
+ (instancetype)overlayPresentationControllerWithDataSource:(id<MAFOverlayPresentationDataSource>)dataSource presentedViewController:(UIViewController *)presentedViewController;

/**
 The controller's data source. You can use a custom data source to completely control the presentation layout. The presentationCoordinator typically is the data source, but if you want to only slightly tweak its default layout selections, your object can forward messages to the coordinator as a starting point.
 */
@property (nonatomic, weak) id<MAFOverlayPresentationDataSource> dataSource;

@end
