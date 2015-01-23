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
@property (nonatomic, weak) NSLayoutConstraint *centerConstraint;

@property (nonatomic, weak) UIImageView *checkmarkImageView;
@property (nonatomic, getter=isSeparatorEnabled) BOOL separatorEnabled;


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
    self.backgroundView.backgroundColor = [UIColor clearColor];
        UIView *opaqueBackgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        opaqueBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.backgroundView = opaqueBackgroundView;
        opaqueBackgroundView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _hasCompletedInitialSetup = YES;
    }
    [super layoutSubviews];
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
                                self.backgroundView.backgroundColor = [self highlightedColor:NO];
                            } else {
                                self.backgroundView.backgroundColor = [UIColor whiteColor];
                            }

                        } completion:^(BOOL finished) {

                        }];

}

-(UIColor *)highlightedColor:(BOOL)dark
{
    if (dark) {
        return [UIColor colorWithRed:0.75f green:0.80f blue:0.875f alpha:1.f];
    } else {
        return [UIColor colorWithRed:0.875f green:0.925f blue:1.0f alpha:1.f];
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
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
            self.backgroundView.backgroundColor = [self highlightedColor:YES];
        } else {
            self.backgroundView.backgroundColor = [UIColor whiteColor];
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
