//
//  MAFOverlayPresentationCoordinator.m
//  MAFOverlay
//
//  Created by Jed Lewison on 1/1/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import "MAFOverlayPresentationController.h"

@interface MAFOverlayPresentationController ()

@property (nonatomic, weak) UIView *decorationView;
@property (nonatomic, weak) UIView *dimmingView;

@end

@implementation MAFOverlayPresentationController

+(instancetype)overlayPresentationControllerWithDataSource:(id<MAFOverlayPresentationDataSource>)dataSource
                                   presentedViewController:(UIViewController *)presentedViewController{

    MAFOverlayPresentationController *controller = [[self alloc] initWithPresentedViewController:presentedViewController presentingViewController:nil];
    presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    controller.dataSource = dataSource;
    presentedViewController.transitioningDelegate = controller;
    return controller;
}

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return self;
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        MAFOverlayPresentationLayoutAttributes *presentedAtts = [self.dataSource presentationLayoutAttributesForContext:self];
        [presentedAtts applyToPresentationContext:self];
        self.dimmingView.frame = self.containerView.bounds;

    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}


-(void)presentationTransitionWillBegin
{
    if ([self.presentedViewController respondsToSelector:@selector(presentationContextWillPresent:)]) {
        [self.presentedViewController performSelector:@selector(presentationContextWillPresent:) withObject:self];
    }
    
    if ([self.presentingViewController respondsToSelector:@selector(presentationContextWillPresent:)]) {
        [self.presentingViewController performSelector:@selector(presentationContextWillPresent:) withObject:self];
    }

    
    self.presentedView.autoresizingMask = UIViewAutoresizingNone;

    self.containerView.backgroundColor = [UIColor clearColor];

    [self.presentedView addMotionEffect:[self.dataSource motionEffectGroup:self]];

    [UIView performWithoutAnimation:^{
        [[self.dataSource initialPresentationLayoutAttributesForContext:self] applyToPresentationContext:self];
    }];

    id <UIViewControllerTransitionCoordinator> transitionCoordinator =
    [[self presentingViewController] transitionCoordinator];

    [transitionCoordinator animateAlongsideTransition:
     ^(id<UIViewControllerTransitionCoordinatorContext> context) {
         MAFOverlayPresentationLayoutAttributes *presentedAtts = [self.dataSource presentationLayoutAttributesForContext:self];
         [presentedAtts applyToPresentationContext:self];
     } completion:nil];
}

-(void)presentationTransitionDidEnd:(BOOL)completed {
    if ([self.presentedViewController respondsToSelector:@selector(presentationContextDidPresent:)]) {
        [self.presentedViewController performSelector:@selector(presentationContextDidPresent:) withObject:self];
    }
    
    if ([self.presentingViewController respondsToSelector:@selector(presentationContextDidPresent:)]) {
        [self.presentingViewController performSelector:@selector(presentationContextDidPresent:) withObject:self];
    }
}

-(UIModalPresentationStyle)presentationStyle
{
    return UIModalPresentationCustom;
}

-(CGRect)frameOfPresentedViewInContainerView {
    return [self.dataSource presentationLayoutAttributesForContext:self].frame;
}

-(void)dismissalTransitionWillBegin {
    if ([self.presentedViewController respondsToSelector:@selector(presentationContextWillDismiss:)]) {
        [self.presentedViewController performSelector:@selector(presentationContextWillDismiss:) withObject:self];
    }
    
    if ([self.presentingViewController respondsToSelector:@selector(presentationContextWillDismiss:)]) {
        [self.presentingViewController performSelector:@selector(presentationContextWillDismiss:) withObject:self];
    }
    
    id <UIViewControllerTransitionCoordinator> transitionCoordinator =
    [[self presentingViewController] transitionCoordinator];
    
    // Fade in the dimming view during the transition.
    MAFOverlayPresentationLayoutAttributes *dismissedAtts = [self.dataSource dismissedPresentationLayoutAttributesForContext:self];
    [transitionCoordinator animateAlongsideTransition:
     ^(id<UIViewControllerTransitionCoordinatorContext> context) {
         [dismissedAtts applyToPresentationContext:self];
     } completion:nil];
}

-(void)dismissalTransitionDidEnd:(BOOL)completed {
    if ([self.presentedViewController respondsToSelector:@selector(presentationContextDidDismiss:)]) {
        [self.presentedViewController performSelector:@selector(presentationContextDidDismiss:) withObject:self];
    }
    
    if ([self.presentingViewController respondsToSelector:@selector(presentationContextDidDismiss:)]) {
        [self.presentingViewController performSelector:@selector(presentationContextDidDismiss:) withObject:self];
    }

}

-(UIView *)dimmingView {
    if (!_dimmingView && self.containerView) {
        UIView *dimmingView = [self.dataSource containerDimmingViewInOverlayPresentationContext:self];
        dimmingView.frame = self.containerView.bounds;
        [self.containerView addSubview:dimmingView];
        _dimmingView = dimmingView;
    }
    return _dimmingView;
}

-(UIView *)decorationView {
    if (!_decorationView && self.containerView) {
        UIView *decorationView = [self.dataSource decorationView:self];
        [self.containerView addSubview:decorationView];
        _decorationView = decorationView;
        [_decorationView addMotionEffect:[self.dataSource motionEffectGroup:self]];

    }
    return _decorationView;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return UINavigationControllerHideShowBarDuration;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    [self.containerView addSubview:self.presentedViewController.view];

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{


                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}
@end
