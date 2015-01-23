//
//  MAFOptionAction.h
//  MAFOverlay
//
//  Created by Jed Lewison on 1/4/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAFAction : NSObject

@property (nonatomic, getter=isSelected) BOOL selected;

+ (instancetype)optionActionWithTitle:(NSString *)title
                           detailText:(NSString *)detailText
                              checked:(BOOL)checked
                              handler:(void (^)())handler;

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *detailText;
@property (nonatomic, readonly, getter=isChecked) BOOL checked;
@property (nonatomic, copy, readonly) void (^actionHandler)();


@end
