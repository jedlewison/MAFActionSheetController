//
//  MAFOptionActionCollectionViewController.h
//  MAFOverlay
//
//  Created by Jed Lewison on 1/4/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

@import UIKit;
#import "MAFActionSheetItem.h"
#import <MAFOverlay/MAFOverlayPresentationCoordinator.h>

@interface MAFActionSheetController : UITableViewController

+ (instancetype)actionSheetControllerWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView;

@property (nonatomic) MAFOverlayPresentationCoordinator *overlayPresentationCoordinator;

- (void)addItem:(MAFActionSheetItem *)actionSheetItem;

@property (nonatomic, readonly) NSArray *actionSheetItems;

@property (nonatomic) BOOL shouldPerformSelectedActionBeforeDismissal;

@property (nonatomic, readonly) UIView *headerView;
@property (nonatomic, readonly) UIView *footerView;

@end
