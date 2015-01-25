//
//  MAFOptionActionCollectionViewController.h
//  MAFOverlay
//
//  Created by Jed Lewison on 1/4/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFActionSheetItem.h"
#import <MAFOverlay/MAFOverlayPresentationCoordinator.h>

@interface MAFActionSheetController : UITableViewController

+ (instancetype)actionSheetController;

@property (nonatomic) MAFOverlayPresentationCoordinator *overlayPresentationCoordinator;

- (void)addItem:(MAFActionSheetItem *)actionSheetItem;

@property (nonatomic, readonly) NSArray *actionSheetItems;

@end
