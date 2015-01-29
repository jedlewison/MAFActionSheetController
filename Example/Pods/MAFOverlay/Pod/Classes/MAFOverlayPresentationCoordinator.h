//
//  MAFOverlayPresentationCoordinator.h
//  MAFOverlay
//
//  Created by Jed Lewison on 1/1/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

@import UIKit;
#import "MAFOverlayPresentationDataSource.h"

/**
 `MAFOverlayPresentationCoordinator` objects coordinate popover-style overlay presentations on iPhone and iPad on iOS 7+.
 
 Behind the scenes, the coordinator uses MAFOverlayPresentationController on iOS 8 and MAFOverlayPresentationAnimator on iOS 7 to actually perform manage presentations. (Different classes are used because of differences in how iOS 7 and 8 handle rotation and iOS 8's introduction of UIPresentation Controller.
 */
@interface MAFOverlayPresentationCoordinator : NSObject <MAFOverlayPresentationDataSource>

/**
 Creates a new presentation coordinator for the presented view controller.

It also creates an MAFOverlayPresentationContext (an `MAFOverlayPresentationController` on iOS 8 and a `MAFOverlayPresentationAnimator` on iOS 7) and assigns itself as the context's data source. It also sets the presented view controller's modal presentation style to UIModalPresentationCustom On iOS 8 it assigns itself as the presentedViewController's `transitioningDelegate;` on iOS 7, it sets the animator as the `transitioningDelegate`.
 
 You need to to keep a strong reference to the coordinator until the presented view controller is dimissed, for example as a property on the presented view controller. See examples for sample code.
 
 @warning: To properly handle rotations on iOS 7, you must implement willAnimateRotationToInterfaceOrientation: in the presented view controller and send the performLayoutForRotationToInterfaceOrientation to the coordinator.
 
 @param presentedViewController The presented view controller for the presentation.

 @return A new presentation coordinator.
 */
+(instancetype)overlayPresentationCoordinatorWithPresentedViewController:(UIViewController *)presentedViewController;

/** The presentation's source view.
 
 If you specify a source view, the presentation will present from the center of the source view.  */
@property (nonatomic, weak) UIView *sourceView;

/** The presentation's source bar button item.
 
 If you specify a source bar button, the presentation will present from the center of the source view. Setting a source bar button item takes precedence over the source view. */
@property (nonatomic, weak) UIBarButtonItem *sourceBarButtonItem;

/** The anchor point for presentations without a source.
 
 For presentations that do not have a source view or bar button item, the anchor point controls the presentations relative position in the available screen (constrained by minimimumContainerEdgeInsets. The default of CGPoint(0.5, 0.5) represents the center of the available area. A position of 0,0 is upper left and 1,1 is lower right. 0.5,1 would be flush bottom. */
@property (nonatomic) CGPoint anchorPoint;

/** The screen edge insets for the presentation */
@property (nonatomic) UIEdgeInsets minimumContainerEdgeInsets;

/** To properly handle rotation on iOS 7 devices, call this method in willAnimateRotationToInterfaceOrientation
 @param toInterfaceOrientation The animation's target interface orientation
 */

-(void)performLayoutForRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

/**  The coordinator's presentation context.
 
 The presentation context is responsible for managing the presentaiton layout. The presentation coordinator is responsible for creating this object. By default, the presentation coordinator assigns itself as the context's dataSource, but you can assign any object that implements the `MAFOverlayPresentationDataSource` protocal to be the datasource. It is a separate object from the coordinator to handle differences between iOS 7 and iOS 8. */
@property (nonatomic, weak, readonly) id<MAFOverlayPresentationContext> presentationContext;

@end
