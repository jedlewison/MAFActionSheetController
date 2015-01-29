//  MAFActionSheetTableViewCell.m
//  MAFActionSheetController
//
// Copyright (c) 2015 Magic App Factory, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "MAFActionSheetTableViewCell.h"

@interface MAFActionSheetTableViewCell () {
    BOOL _hasCompletedInitialSetup;
}
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *optionDetailTextLabel;


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
        self.contentView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.5f];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        _hasCompletedInitialSetup = YES;

    }
    if (!self.backgroundView) {
        self.backgroundView = [self createBackgroundView];
    }
    self.backgroundView.frame = self.contentView.bounds;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

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
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        return visualEffectView;
    } else {
        UIView *opaqueBackgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        opaqueBackgroundView.backgroundColor = [UIColor whiteColor];
        return opaqueBackgroundView;
    }
}

-(void)prepareForReuse {
    [self.backgroundView removeFromSuperview];
    self.backgroundView = [self createBackgroundView];
}

@end
