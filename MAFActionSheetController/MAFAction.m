//
//  MAFOptionAction.m
//  MAFOverlay
//
//  Created by Jed Lewison on 1/4/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import "MAFAction.h"

@interface MAFAction ()

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *detailText;
@property (nonatomic, readwrite, getter=isChecked) BOOL checked;
@property (nonatomic, readwrite) void (^actionHandler)();

@end

@implementation MAFAction

+(instancetype)optionActionWithTitle:(NSString *)title detailText:(NSString *)detailText checked:(BOOL)checked handler:(void (^)())handler
{
    MAFAction *optionAction = [[self alloc] init];
    optionAction.actionHandler = handler;
    optionAction.detailText = detailText;
    optionAction.checked = checked;
    optionAction.title = title;
    return optionAction;
}

-(instancetype)copy
{
    return [MAFAction optionActionWithTitle:self.title detailText:self.detailText checked:self.checked handler:self.actionHandler];
}

-(instancetype)copyWithZone:(NSZone *)zone
{
    return [self copy];
}

@end
