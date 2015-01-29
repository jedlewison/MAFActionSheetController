//
//  MAFOverlayPresentationLayoutAttributes.m
//  MAFOverlay
//
//  Created by Jed Lewison on 1/14/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import "MAFOverlayPresentationLayoutAttributes.h"

@implementation MAFOverlayPresentationLayoutAttributes

-(instancetype)init {
    if (self = [super init]) {
        _cornerRadius = 10.f;
        _dimmingViewAlpha = 1.f;
        _transform = CGAffineTransformIdentity;
        _alpha = 1.f;
        _presentedViewTintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        _presentingViewTintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        _minimumMargin = UIEdgeInsetsMake(8, 8, 8, 8);
    }
    return self;
}

-(id)copy {
    MAFOverlayPresentationLayoutAttributes *copiedAtts = [[MAFOverlayPresentationLayoutAttributes alloc] init];
    copiedAtts.frame = self.frame;
    copiedAtts.alpha = self.alpha;
    copiedAtts.transform = self.transform;
    copiedAtts.dimmingViewAlpha = self.dimmingViewAlpha;
    copiedAtts.decorationViewFrame = self.decorationViewFrame;
    copiedAtts.cornerRadius = self.cornerRadius;
    copiedAtts.presentedViewTintAdjustmentMode = self.presentedViewTintAdjustmentMode;
    copiedAtts.presentingViewTintAdjustmentMode = self.presentingViewTintAdjustmentMode;
    copiedAtts.minimumMargin = self.minimumMargin;
    return copiedAtts;
}

-(id)copyWithZone:(NSZone *)zone {
    return [self copy];
}

-(void)applyToPresentationContext:(id<MAFOverlayPresentationContext>)presentationContext {

    MAFOverlayPresentationLayoutAttributes *attributes = [self layoutAttributesForPresentationContext:presentationContext];

    presentationContext.presentedViewController.view.frame = attributes.frame;
    presentationContext.presentedViewController.view.transform = attributes.transform;
    presentationContext.decorationView.transform = attributes.transform;
    presentationContext.presentedViewController.view.alpha = attributes.alpha;
    presentationContext.decorationView.alpha = attributes.alpha;
    presentationContext.dimmingView.alpha = attributes.dimmingViewAlpha;

    presentationContext.decorationView.frame = attributes.decorationViewFrame;
    presentationContext.presentedViewController.view.layer.cornerRadius = attributes.cornerRadius;
    presentationContext.presentedViewController.view.tintAdjustmentMode = attributes.presentedViewTintAdjustmentMode;
    presentationContext.presentingViewController.view.tintAdjustmentMode = attributes.presentingViewTintAdjustmentMode;

    [presentationContext.containerView bringSubviewToFront:presentationContext.dimmingView];
    [presentationContext.containerView bringSubviewToFront:presentationContext.decorationView];
    [presentationContext.containerView bringSubviewToFront:presentationContext.presentedViewController.view];

}

- (instancetype)layoutAttributesForPresentationContext:(id<MAFOverlayPresentationContext>)presentationContext {

    UIInterfaceOrientation interfaceOrientation = [presentationContext presentedViewController].interfaceOrientation;

    if ([UIPresentationController class] || interfaceOrientation == UIInterfaceOrientationPortrait) {
        return self;
    }

    CGRect newPresentedFrame = [self adjustRect:self.frame forOrientation:interfaceOrientation containingFrame:[presentationContext containerView].bounds];
    CGRect newDecorationFrame = [self adjustRect:self.decorationViewFrame forOrientation:interfaceOrientation containingFrame:[presentationContext containerView].bounds];

    MAFOverlayPresentationLayoutAttributes *newAttributes = [self copy];
    newAttributes.frame = newPresentedFrame;
    newAttributes.decorationViewFrame = newDecorationFrame;

    return newAttributes;
}

- (CGRect)adjustRect:(CGRect)inputRect forOrientation:(UIInterfaceOrientation)interfaceOrientation containingFrame:(CGRect)containingFrame {

    CGRect adjustedRect = inputRect;

    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            break;

        case UIInterfaceOrientationPortraitUpsideDown:
            adjustedRect.origin.x = containingFrame.size.width - (inputRect.size.width + inputRect.origin.x);
            adjustedRect.origin.y = containingFrame.size.height - (inputRect.size.height + inputRect.origin.y);

            break;

        case UIInterfaceOrientationLandscapeLeft:
            adjustedRect.origin.x = inputRect.origin.y;
            adjustedRect.origin.y = containingFrame.size.height - (inputRect.size.width + inputRect.origin.x);
            adjustedRect.size.width = inputRect.size.height;
            adjustedRect.size.height = inputRect.size.width;

            break;

        case UIInterfaceOrientationLandscapeRight:
            adjustedRect.origin.x = containingFrame.size.width - (inputRect.size.height + inputRect.origin.y);
            adjustedRect.origin.y = inputRect.origin.x;
            adjustedRect.size.width = inputRect.size.height;
            adjustedRect.size.height = inputRect.size.width;
            break;
            
        default:
            break;
    }
    
    return adjustedRect;
    
}

@end
