//
//  MAFOptionActionCollectionViewCell.m
//  MAFOverlay
//
//  Created by Jed Lewison on 1/4/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import "MAFActionSheetTableViewCell.h"

@interface MAFActionSheetTableViewCell () {
    BOOL _hasCompletedInitialSetup;
}
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *optionDetailTextLabel;
@property (nonatomic, weak) UIView *highlightedView;

@end

@implementation MAFActionSheetTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] ) {
        
    }
    return self;
}

-(void)layoutSubviews {
    if (!_hasCompletedInitialSetup) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _hasCompletedInitialSetup = YES;
        if (!self.backgroundView) {
            self.backgroundView = [self createBackgroundView];
        }
        self.backgroundView.frame = self.contentView.bounds;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.highlightedView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

    }
    
    [super layoutSubviews];
    CGPoint textLabelCenter = self.textLabel.center;
    CGPoint detailTextLabelCenter = self.detailTextLabel.center;
    self.textLabel.frame = (CGRect){CGPointZero,self.contentView.bounds.size.width,self.textLabel.frame.size.height};
    self.textLabel.center = (CGPoint){self.center.x, textLabelCenter.y};
    self.detailTextLabel.frame = (CGRect){CGPointZero,self.contentView.bounds.size.width,self.detailTextLabel.frame.size.height};
    self.detailTextLabel.center = (CGPoint){self.center.x, detailTextLabelCenter.y};
}

-(UIView *)createBackgroundView {
    if ([UIVisualEffectView class]) {
        UIVisualEffect *visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
        return visualEffectView;
        
        
    } else {
        UIView *opaqueBackgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        opaqueBackgroundView.backgroundColor = [UIColor whiteColor];
        return opaqueBackgroundView;
    }
}

-(void)setFrame:(CGRect)frame {
    CGRect finalFrame = frame;
    if (![UIPresentationController class]) {
        finalFrame = [self.delegate frameForCell:self targetFrame:frame];;
    }
    [super setFrame:finalFrame];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    NSTimeInterval duration = 0.f;
    
    if (animated) {
        duration = UINavigationControllerHideShowBarDuration;
    }

    [UIView animateWithDuration:duration
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            
                            if (highlighted) {
                                self.highlightedView.alpha = 1.f;
                            } else {
                                self.highlightedView.alpha = 0.f;
                            }
                            
                        } completion:^(BOOL finished) {
                            
                        }];
    
}

-(UIView *)highlightedView {
    if (!_highlightedView) {
        UIView *highlightedView = [[UIView alloc] initWithFrame:self.backgroundView.bounds];
        _highlightedView = highlightedView;
        highlightedView.alpha = 0.f;
        [self.backgroundView addSubview:highlightedView];
        [self.backgroundView setClipsToBounds:YES];
        [_highlightedView setBackgroundColor:[UIColor colorWithRed:0.875f green:0.925f blue:1.0f alpha:0.75f]];
    }
    return _highlightedView;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (!selected) {
        return;
    }
    [super setSelected:selected animated:animated];
    
    animated = YES;
    NSTimeInterval duration = 0.f;
    CGFloat damping = 1.f;
    CGFloat velocity = 1.f;
    if (animated) {
        duration = UINavigationControllerHideShowBarDuration*1.f/3.f;
        damping = 0.0f;
        velocity = 0.0965f;
    }
    
    
    [self.backgroundView.layer removeAllAnimations];
    
    [UIView animateWithDuration:duration delay:0.f usingSpringWithDamping:damping initialSpringVelocity:velocity options:0 animations:^{
        
        if (selected) {
            self.highlightedView.alpha = 1.f;
        } else {
            self.highlightedView.alpha = 0.f;
        }

     
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}

-(void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:selected];
}

-(void)setHighlighted:(BOOL)highlighted {
    [self setHighlighted:highlighted animated:highlighted];
}

@end
