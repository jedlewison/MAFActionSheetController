//  MAFActionSheetItem.m
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

#import "MAFActionSheetItem.h"

@interface MAFActionSheetItem ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *detailText;

@property (nonatomic, copy) NSAttributedString *attributedTitle;
@property (nonatomic, copy) NSAttributedString *attributedDetailText;

@property (nonatomic) CGSize preferredSize;

@property (nonatomic, copy) void (^actionHandler)();

@property (nonatomic, copy) void (^cancellationHandler)();

@end

@implementation MAFActionSheetItem

+(instancetype)actionSheetItemWithTitle:(NSString *)title detailText:(NSString *)detailText handler:(void (^)())handler
{
    MAFActionSheetItem *actionSheetItem = [[self alloc] init];
    actionSheetItem.actionHandler = handler;
    actionSheetItem.detailText = detailText;
    actionSheetItem.title = title;
    return actionSheetItem;
}

+(instancetype)actionSheetItemWithCancellationHandler:(void (^)())cancellationHandler {
    MAFActionSheetItem *actionSheetItem = [[self alloc] init];
    actionSheetItem.cancellationHandler = cancellationHandler;
    return actionSheetItem;
}

-(instancetype)copy
{
    MAFActionSheetItem *actionSheetItem = [MAFActionSheetItem actionSheetItemWithTitle:self.title
                                             detailText:self.detailText
                                                handler:self.actionHandler];
    actionSheetItem.customBackgroundView = self.customBackgroundView;
    actionSheetItem.cancellationHandler = self.cancellationHandler;
    actionSheetItem.attributedTitle = self.attributedTitle;
    actionSheetItem.attributedDetailText = self.attributedDetailText;
    return actionSheetItem;
}

-(instancetype)copyWithZone:(NSZone *)zone
{
    return [self copy];
}

-(CGSize)preferredSize {
    if (_preferredSize.width == 0) {
        CGFloat paddingAmount = 16.f;
        _preferredSize.height = MAX(44, MAX(self.customBackgroundView.frame.size.height, self.attributedTitle.size.height + self.attributedDetailText.size.height + paddingAmount));
        _preferredSize.width = MAX(self.customBackgroundView.frame.size.width, MAX(self.attributedTitle.size.width + paddingAmount, self.attributedDetailText.size.width + paddingAmount));
        _preferredSize.height = ceil(_preferredSize.height);
        _preferredSize.width = ceil(_preferredSize.width);
    }
    return _preferredSize;
}

@end
