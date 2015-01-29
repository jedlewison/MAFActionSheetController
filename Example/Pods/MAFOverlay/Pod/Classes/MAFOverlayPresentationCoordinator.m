//
//  MAFOverlayPresentationCoordinator.m
//  MAFOverlay
//
//  Created by Jed Lewison on 1/1/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import "MAFOverlayPresentationCoordinator.h"
#import "MAFOverlayPresentationController.h"
#import "MAFOverlayPresentationAnimator.h"

typedef NS_ENUM(NSUInteger, MAFOverlayArrowDirection) {
    MAFOverlayArrowDirectionNoArrow,
    MAFOverlayArrowDirectionUp,
    MAFOverlayArrowDirectionDown,
    MAFOverlayArrowDirectionLeft,
    MAFOverlayArrowDirectionRight
};

@interface MAFOverlayPresentationCoordinator () <UIViewControllerTransitioningDelegate>

@property (nonatomic) MAFOverlayPresentationAnimator *animator;
@property (nonatomic, weak) MAFOverlayPresentationController *presentationController;
@property (nonatomic) MAFOverlayArrowDirection arrowDirection;
@property (nonatomic) UIView *arrowView;
@property (nonatomic, weak, readwrite) UIViewController *presentedViewController;


@end

@implementation MAFOverlayPresentationCoordinator

+(instancetype)overlayPresentationCoordinatorWithPresentedViewController:(UIViewController *)presentedViewController {
    if (!presentedViewController) {
        NSLog(@"Warning: You did not provide a presented view controller to MAFOverlayPresentationCoordinator");
    }

    MAFOverlayPresentationCoordinator *overlayPresentationCoordinator = [[MAFOverlayPresentationCoordinator alloc] init];
    overlayPresentationCoordinator.presentedViewController = presentedViewController;
    presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    if ([UIPresentationController class]) {
        // The coordinator is the transitioning delegate so that we don't have to store a strong reference to the controller, creating a reference cycle, since the presentedViewController also will have a strong reference to it
        presentedViewController.transitioningDelegate = overlayPresentationCoordinator;
    } else {
        presentedViewController.transitioningDelegate = overlayPresentationCoordinator.animator;
    }
    
    CGFloat statusBarFrameHeight = MIN([[UIApplication sharedApplication] statusBarFrame].size.width, [[UIApplication sharedApplication] statusBarFrame].size.height);
    UIEdgeInsets minimumContainerEdgeInsets = UIEdgeInsetsMake(MAX(5, statusBarFrameHeight),5,5,5);
    
    overlayPresentationCoordinator.minimumContainerEdgeInsets = minimumContainerEdgeInsets;
    overlayPresentationCoordinator.anchorPoint = (CGPoint){0.5, 0.5};
    [presentedViewController.view setClipsToBounds:YES];
    return overlayPresentationCoordinator;
}


-(void)setSourceBarButtonItem:(UIBarButtonItem *)sourceBarButtonItem {
    _sourceBarButtonItem = sourceBarButtonItem;
    if ([sourceBarButtonItem respondsToSelector:@selector(view)]) {
        id obj = [(id)sourceBarButtonItem view];
        if ([obj isKindOfClass:[UIView class]]) {
            [self setSourceView:obj];
        }
    }
}

#pragma mark - UIViewControllerTransitioningDelegate (for Presentation controller)

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    MAFOverlayPresentationController *controller = [MAFOverlayPresentationController overlayPresentationControllerWithDataSource:self
                                                                                                         presentedViewController:presented];
    self.presentationController = controller;
    return controller;
}


-(MAFOverlayPresentationAnimator *)animator {
    if (!_animator && ![UIPresentationController class]) {
        _animator = [MAFOverlayPresentationAnimator overlayPresentationAnimatorWithDataSource:self
                                                                      presentedViewController:self.presentedViewController];
    }
    return _animator;
}

#pragma mark - MAFOverlayPresentationDataSource

-(MAFOverlayPresentationLayoutAttributes *)presentationLayoutAttributesForContext:(id<MAFOverlayPresentationContext>)presentationContext {
    UIInterfaceOrientation effectiveOrientation = [presentationContext presentedViewController].interfaceOrientation;
    if ([UIPresentationController class]) {
        effectiveOrientation = UIInterfaceOrientationPortrait;
    }
    MAFOverlayPresentationLayoutAttributes *atts = [self attsForPreferredContentSize:[presentationContext presentedViewController].preferredContentSize
                                        containerView:[presentationContext containerView]
                                 interfaceOrientation:effectiveOrientation];

    atts.alpha = 1.f;
    atts.transform = [presentationContext presentedViewController].view.transform;
    return atts;
}

-(MAFOverlayPresentationLayoutAttributes *)initialPresentationLayoutAttributesForContext:(id<MAFOverlayPresentationContext>)presentationContext {

    MAFOverlayPresentationLayoutAttributes *atts = [self presentationLayoutAttributesForContext:presentationContext];

    if ([presentationContext presentedViewController].modalTransitionStyle == UIModalTransitionStyleCoverVertical) {
        CGFloat originYOffset = [presentationContext containerView].bounds.size.height - atts.frame.origin.y;
        CGRect frame = atts.frame;
        frame.origin.y += originYOffset;

        atts.frame = frame;
        CGRect decorationViewFrame = atts.decorationViewFrame;
        decorationViewFrame.origin.y += originYOffset;
        atts.decorationViewFrame = decorationViewFrame;
    } else if ([presentationContext presentedViewController].modalTransitionStyle == UIModalTransitionStyleCrossDissolve) {
        atts.alpha = 0.f;
    }
    atts.dimmingViewAlpha = 0.f;

    return atts;
}


-(MAFOverlayPresentationLayoutAttributes *)dismissedPresentationLayoutAttributesForContext:(id<MAFOverlayPresentationContext>)presentationContext {

    MAFOverlayPresentationLayoutAttributes *atts = [self presentationLayoutAttributesForContext:presentationContext];

    if ([presentationContext presentedViewController].modalTransitionStyle == UIModalTransitionStyleCoverVertical) {
        CGFloat originYOffset = [presentationContext containerView].bounds.size.height - atts.frame.origin.y;
        CGRect frame = atts.frame;
        frame.origin.y += originYOffset;
        atts.frame = frame;
        CGRect decorationViewFrame = atts.decorationViewFrame;
        decorationViewFrame.origin.y += originYOffset;
        atts.decorationViewFrame = decorationViewFrame;

    } else if ([presentationContext presentedViewController].modalTransitionStyle == UIModalTransitionStyleCrossDissolve) {
        atts.alpha = 0.f;
    }
    atts.presentedViewTintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    atts.presentingViewTintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    atts.dimmingViewAlpha = 0.f;
    return atts;
}

-(UIView *)containerDimmingViewInOverlayPresentationContext:(id<MAFOverlayPresentationContext>)presentationContext {
    UIView *dimmingView = [[UIView alloc] init];
    dimmingView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4f];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didReceiveTap:)];
    [dimmingView addGestureRecognizer:tapGestureRecognizer];
    dimmingView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    return dimmingView;
}


-(void)didReceiveTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [sender setEnabled:NO];
        [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

-(UIView *)decorationView:(id<MAFOverlayPresentationContext>)presentationContext {
    return [self createArrowViewIfNeeded:[presentationContext presentedViewController].view.backgroundColor];
}

-(UIMotionEffectGroup *)motionEffectGroup:(id<MAFOverlayPresentationContext>)presentationContext {

    NSString *xAxisKeyPath = @"center.x";
    NSString *yAxisKeyPath = @"center.y";
    CGFloat minXValue = -12.f;
    CGFloat maxXValue = 12.f;
    CGFloat minYValue = -12.f;
    CGFloat maxYValue = 12.f;

    UIInterfaceOrientation effectiveOrientation = [presentationContext presentedViewController].interfaceOrientation;
    if ([UIPresentationController class]) {
        // On iOS 8, you don't need to do anything special based on interface orientation to make the motion effects look right
        effectiveOrientation = UIInterfaceOrientationPortrait;
    }
    if (![UIPresentationController class] && presentationContext.presentedViewController.interfaceOrientation != UIInterfaceOrientationPortrait) {

        switch (effectiveOrientation) {
            case UIInterfaceOrientationPortraitUpsideDown:
                 minYValue = 12.f;
                 maxYValue = -12.f;

                break;
            case UIInterfaceOrientationLandscapeLeft:
                xAxisKeyPath = @"center.y";
                yAxisKeyPath = @"center.x";
                minXValue = 12.f;
                maxXValue = -12.f;

                break;
            case UIInterfaceOrientationLandscapeRight:
                xAxisKeyPath = @"center.y";
                yAxisKeyPath = @"center.x";
                 minYValue = 12.f;
                 maxYValue = -12.f;

                break;

            default:
                break;
        }
    }
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:xAxisKeyPath type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xAxis.minimumRelativeValue = @(minXValue);
    xAxis.maximumRelativeValue = @(maxXValue);

    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:yAxisKeyPath type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yAxis.minimumRelativeValue = @(minYValue);
    yAxis.maximumRelativeValue = @(maxYValue);

    UIMotionEffectGroup *motionEffect = [[UIMotionEffectGroup alloc] init];
    motionEffect.motionEffects = @[xAxis, yAxis];
    return motionEffect;
}

#pragma mark - MAFOverlayPresentationContext

- (id<MAFOverlayPresentationContext>)presentationContext {
        if (self.animator) {
            return self.animator;
        } else {
            return self.presentationController;
        }
}

#pragma mark - legacy implementation

-(MAFOverlayPresentationLayoutAttributes *)attsForPreferredContentSize:(CGSize)preferredContentSize
                        containerView:(UIView *)containerView
                 interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    MAFOverlayPresentationLayoutAttributes *atts = [[MAFOverlayPresentationLayoutAttributes alloc] init];

    CGRect layoutContainerRect = containerView.frame;
    layoutContainerRect.origin = CGPointZero;
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        layoutContainerRect.size = (CGSize) {
            MAX(layoutContainerRect.size.width, layoutContainerRect.size.height),
            MIN(layoutContainerRect.size.width, layoutContainerRect.size.height)
        };
    }
    atts.minimumMargin = self.minimumContainerEdgeInsets;
    UIEdgeInsets minimumMargin = atts.minimumMargin;
    CGSize layoutTargetSize = preferredContentSize;

    if (CGSizeEqualToSize(CGSizeZero, layoutTargetSize)) {
        if (layoutTargetSize.height == UIViewNoIntrinsicMetric) {
            NSLog(@"No preferred content size.width or intrinsic content size.width");
        }
        if (layoutTargetSize.width == UIViewNoIntrinsicMetric) {
            NSLog(@"No preferred content size.height or intrinsic content size.height");
        }

        atts.frame = CGRectZero;
        return atts;
    }

    CGPoint originForPresentation = [self originForPresentationInContainerView:containerView
                                                          interfaceOrientation:interfaceOrientation
                                                           layoutContainerRect:layoutContainerRect];

    CGRect layoutFrame;

    if (self.sourceView) {

        CGFloat marginFromOrigin = 20.f;

        layoutFrame.origin.x = originForPresentation.x-layoutTargetSize.width/2.f;
        layoutFrame.size = layoutTargetSize;

        originForPresentation.y = MAX(originForPresentation.y, MIN(MAX(originForPresentation.y, minimumMargin.top), layoutContainerRect.size.height-(layoutFrame.size.height+minimumMargin.bottom)));

        CGFloat spaceAboveOrigin = originForPresentation.y - minimumMargin.top;
        CGFloat spaceBelowOrigin = (layoutContainerRect.size.height - minimumMargin.bottom) - originForPresentation.y;

        if (self.arrowDirection == MAFOverlayArrowDirectionNoArrow) {
            if (spaceAboveOrigin >= (layoutTargetSize.height+20) || spaceAboveOrigin > spaceBelowOrigin) {
                self.arrowDirection = MAFOverlayArrowDirectionDown;
            } else {
                self.arrowDirection = MAFOverlayArrowDirectionUp;
            }
        }
        
        if (self.arrowDirection == MAFOverlayArrowDirectionDown) {
            layoutFrame.origin.y = MAX(minimumMargin.top,
                                       originForPresentation.y-(layoutTargetSize.height + marginFromOrigin));
            layoutFrame.size.height = MIN(layoutFrame.size.height,
                                          originForPresentation.y - marginFromOrigin - layoutFrame.origin.y);
            self.arrowDirection = MAFOverlayArrowDirectionDown;

        } else {

            layoutFrame.origin.y = originForPresentation.y + marginFromOrigin;
            layoutFrame.size.height = MIN(layoutFrame.size.height, CGRectGetMaxY(layoutContainerRect)-minimumMargin.bottom-layoutFrame.origin.y);
            self.arrowDirection = MAFOverlayArrowDirectionUp;

        }

        if (CGRectGetMaxX(layoutFrame) > (CGRectGetMaxX(layoutContainerRect)-minimumMargin.right)) {
            layoutFrame.origin.x -= CGRectGetMaxX(layoutFrame)-CGRectGetMaxX(layoutContainerRect);
            layoutFrame.origin.x -= minimumMargin.right;
            if (layoutFrame.origin.x < minimumMargin.left) {
                layoutFrame.size.width += layoutFrame.origin.x - minimumMargin.left; // (don't let the + confuse you, this will shrink the frame)
                layoutFrame.origin.x = minimumMargin.left;
            }
        }

    } else {

        layoutFrame.origin.x = MAX(MAX(minimumMargin.left, minimumMargin.right), CGRectGetMidX(layoutContainerRect)-layoutTargetSize.width/2.f);
        layoutFrame.origin.y = MAX(MAX(minimumMargin.top, minimumMargin.bottom), CGRectGetMidY(layoutContainerRect)-layoutTargetSize.height/2.f);
        layoutFrame.size.width = layoutContainerRect.size.width - 2.f*layoutFrame.origin.x;
        layoutFrame.size.height = layoutContainerRect.size.height - 2.f*layoutFrame.origin.y;

        CGSize leadingPadding = (CGSize) {
            layoutFrame.origin.x - self.minimumContainerEdgeInsets.left,
            layoutFrame.origin.y - self.minimumContainerEdgeInsets.top
        };

        CGSize trailingPadding = (CGSize) {
            layoutFrame.origin.x - self.minimumContainerEdgeInsets.right,
            layoutFrame.origin.y - self.minimumContainerEdgeInsets.bottom
        };

        if (self.anchorPoint.x < 0.5f) {
            layoutFrame.origin.x -= leadingPadding.width * (0.5f - self.anchorPoint.x) * 2.f;
        } else if (self.anchorPoint.x > 0.5f ) {
            layoutFrame.origin.x += trailingPadding.width * (self.anchorPoint.x-0.5f) * 2.f;
        }
        if (self.anchorPoint.y < 0.5f) {
            layoutFrame.origin.y -= leadingPadding.height * (0.5f - self.anchorPoint.y) * 2.f;
        } else if (self.anchorPoint.y > 0.5f ) {
            layoutFrame.origin.y += trailingPadding.height * (self.anchorPoint.y-0.5f) * 2.f;

        }

        layoutFrame.origin.x = round(layoutFrame.origin.x * [UIScreen mainScreen].scale)/[UIScreen mainScreen].scale;
        layoutFrame.origin.y = round(layoutFrame.origin.y * [UIScreen mainScreen].scale)/[UIScreen mainScreen].scale;

    }
    
    //Adjust for minimum margins horizontally
    
    layoutFrame.origin.x = MAX(layoutFrame.origin.x, minimumMargin.left);
    
    CGFloat rightOverhang = CGRectGetMaxX(layoutFrame) - (layoutContainerRect.size.width - minimumMargin.right);
    
    if (rightOverhang > 0) {
        
        CGFloat canExpandWidthBy = MAX(0, layoutFrame.origin.x - minimumMargin.left);
        layoutFrame.origin.x -= MIN(canExpandWidthBy, rightOverhang);
        rightOverhang -= MIN(canExpandWidthBy, rightOverhang);
        if (rightOverhang > 0) {
            layoutFrame.size.width -= rightOverhang;
        }
    }

    atts.frame = layoutFrame;

    if (self.sourceView == nil) {
        atts.decorationViewFrame = CGRectZero;
    } else {

        CGFloat minX = CGRectGetMinX(atts.frame)+[self sizeForArrowView].width/2.f;
        CGFloat maxX = CGRectGetMaxX(atts.frame)-[self sizeForArrowView].width/2.f;
        
        CGRect decorationViewFrame = (CGRect){
            MAX(minX, (MIN(originForPresentation.x - [self sizeForArrowView].width/2.f, maxX))),
            0,
            [self sizeForArrowView]
        };
        
        if (minX > maxX) {
            decorationViewFrame.origin.x = originForPresentation.x;
        }
        decorationViewFrame.origin.x = MAX(atts.frame.origin.x + atts.cornerRadius - (1.f+1.f/[UIScreen mainScreen].scale), originForPresentation.x - [self sizeForArrowView].width/2.f);

        if (self.arrowDirection == MAFOverlayArrowDirectionUp) {
            decorationViewFrame.origin.y = atts.frame.origin.y - [self sizeForArrowView].height;
        } else if (self.arrowDirection == MAFOverlayArrowDirectionDown) {
            decorationViewFrame.origin.y = atts.frame.origin.y + atts.frame.size.height;
        }

        atts.decorationViewFrame = decorationViewFrame;

    }

    return atts;
}

-(CGSize)sizeForArrowView {
    return (CGSize) {19, 9};
}

-(void)performLayoutForRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [self.animator performLayoutForRotationToInterfaceOrientation:toInterfaceOrientation];
}


-(CGPoint)originForPresentationInContainerView:(UIView *)containerView
                          interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                           layoutContainerRect:(CGRect)layoutContainerRect
{

    if ([self.sourceBarButtonItem respondsToSelector:@selector(view)]) {
        UIView *view = [(id)self.sourceBarButtonItem view];
        if ([view isKindOfClass:[UIView class]]) {
            self.sourceView = view;
        }
    }

    if (!self.sourceView) {
        self.arrowDirection = MAFOverlayArrowDirectionNoArrow;
        return CGPointZero;
    }

    CGPoint originForPresentation = [containerView convertPoint:(CGPoint){CGRectGetMidX(self.sourceView.bounds),
        CGRectGetMidY(self.sourceView.bounds)}
                                                       fromView:self.sourceView];

    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            originForPresentation = (CGPoint){
                layoutContainerRect.size.width - originForPresentation.x,
                layoutContainerRect.size.height - originForPresentation.y
            };
            break;

        case UIInterfaceOrientationLandscapeLeft:
            originForPresentation = (CGPoint){
                layoutContainerRect.size.width - originForPresentation.y,
                originForPresentation.x
            };
            break;

        case UIInterfaceOrientationLandscapeRight:
            originForPresentation = (CGPoint){
                originForPresentation.y,
                layoutContainerRect.size.height - originForPresentation.x
            };

            break;

        default:
            break;
    }

    return originForPresentation;

}

-(UIView *)createArrowViewIfNeeded:(UIColor *)backgroundColor
{
    if (self.arrowDirection == MAFOverlayArrowDirectionNoArrow) {
        return nil;
    }

    if (!self.arrowView) {

    CGRect frame = CGRectZero;
    frame.size = [self sizeForArrowView];

    UIImageView *arrowPointerView = [[UIImageView alloc] initWithFrame:frame];

    UIGraphicsBeginImageContextWithOptions(arrowPointerView.frame.size, NO, [[UIScreen mainScreen] scale]);
    [backgroundColor setFill];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];


    CGPoint startingPoint = CGPointMake(0, arrowPointerView.frame.size.height);
    CGPoint arrowTipPoint = CGPointMake(arrowPointerView.frame.size.width/2.f, 0.f);
        CGFloat pixelPoint = 1.f/[UIScreen mainScreen].scale;

    CGPoint secondPoint = CGPointMake(arrowTipPoint.x-(1.f), arrowTipPoint.y+pixelPoint);
    CGPoint controlPointForSecondPoint = CGPointMake(arrowPointerView.frame.size.width * 1.f/6.f,arrowPointerView.frame.size.height);
    CGPoint thirdPoint = CGPointMake(arrowTipPoint.x+(1.f), arrowTipPoint.y+pixelPoint);
    CGPoint fourthPoint = CGPointMake(arrowPointerView.frame.size.width, arrowPointerView.frame.size.height);
    CGPoint controlPointForFourthPoint = CGPointMake(arrowPointerView.frame.size.width * 5.f/6.f,arrowPointerView.frame.size.height);

    if (self.arrowDirection == MAFOverlayArrowDirectionDown) {
        startingPoint.y = 0;
        arrowTipPoint.y = arrowPointerView.frame.size.height;
        secondPoint.y = arrowTipPoint.y - 1.f;
        controlPointForSecondPoint.y = 0.f;
        thirdPoint.y = secondPoint.y;
        fourthPoint.y = 0.f;
        controlPointForFourthPoint.y = 0.f;
    }
    [bezierPath moveToPoint:startingPoint];

    [bezierPath addQuadCurveToPoint:secondPoint
                       controlPoint:controlPointForSecondPoint];

    [bezierPath addQuadCurveToPoint:thirdPoint
                       controlPoint:arrowTipPoint];

        [bezierPath addQuadCurveToPoint:fourthPoint
                       controlPoint:controlPointForFourthPoint];


    [bezierPath closePath];

    if (backgroundColor == [UIColor clearColor]) {
        backgroundColor = [UIColor whiteColor];
    }

    [backgroundColor setFill];

    [bezierPath fill];
    arrowPointerView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    arrowPointerView.autoresizingMask = UIViewAutoresizingNone;
        self.arrowView = arrowPointerView;
    }

    return self.arrowView;

}

@end
