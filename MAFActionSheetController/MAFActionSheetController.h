//
//  MAFOptionActionCollectionViewController.h
//  MAFOverlay
//
//  Created by Jed Lewison on 1/4/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFAction.h"
@class MAFOverlayPresentationCoordinator;

@interface MAFActionSheetController : UITableViewController

+ (instancetype)optionActionSheetController;

@property (nonatomic) MAFOverlayPresentationCoordinator *overlayPresentationCoordinator;

- (void)addOptionAction:(MAFAction *)optionAction;

@property (nonatomic, readonly) NSArray *optionActions;

@property (nonatomic) UIColor *cellTextColor;

@property (nonatomic) BOOL disableCheckmarks;
@end
