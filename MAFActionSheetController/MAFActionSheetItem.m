//
//  MAFOptionAction.m
//  MAFOverlay
//
//  Created by Jed Lewison on 1/4/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import "MAFActionSheetItem.h"

@interface MAFActionSheetItem ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *detailText;

@property (nonatomic, copy) NSAttributedString *attributedTitle;
@property (nonatomic, copy) NSAttributedString *attributedDetailText;

@property (nonatomic, readwrite, getter=isChecked) BOOL checked;
@property (nonatomic, copy) void (^actionHandler)();

@property (nonatomic, copy) void (^cancellationHandler)();

@end

@implementation MAFActionSheetItem

+(instancetype)actionSheetItemWithTitle:(NSString *)title detailText:(NSString *)detailText checked:(BOOL)checked handler:(void (^)())handler
{
    MAFActionSheetItem *actionSheetItem = [[self alloc] init];
    actionSheetItem.actionHandler = handler;
    actionSheetItem.detailText = detailText;
    actionSheetItem.checked = checked;
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
                                                checked:self.checked
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

@end
