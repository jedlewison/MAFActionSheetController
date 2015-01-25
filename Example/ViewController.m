//
//  ViewController.m
//  MAFActionSheetControllerExample
//
//  Created by Jed Lewison on 1/22/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import "ViewController.h"
#import "MAFActionSheetController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)didPressButton:(id)sender {
    
    UILabel *headerLable = [[UILabel alloc] init];
    headerLable.text = @"header?";
    headerLable.backgroundColor = [UIColor greenColor];
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.text = @"footerLabel?";
    footerLabel.backgroundColor = [UIColor lightGrayColor];
    [headerLable sizeToFit];
    [footerLabel sizeToFit];
    MAFActionSheetController *actionSheetController = [MAFActionSheetController actionSheetControllerWithHeaderView:headerLable footerView:footerLabel];

    MAFActionSheetItem *optionAction = [MAFActionSheetItem actionSheetItemWithTitle:@"Change Background To Orange" detailText:@"Detail" checked:NO handler:^{
        [actionSheetController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.view.backgroundColor = [UIColor orangeColor];

        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            
        }];
    }];

    MAFActionSheetItem *optionAction2 = [MAFActionSheetItem actionSheetItemWithTitle:@"Do Nothing" detailText:@"Has Custom Background View" checked:YES handler:nil];
    MAFActionSheetItem *optionAction3 = [MAFActionSheetItem actionSheetItemWithTitle:@"Change Button To Green" detailText:@"Detail" checked:NO handler:^{
        [actionSheetController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [sender setBackgroundColor:[UIColor greenColor]];
        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            
        }];
    }];

    MAFActionSheetItem *cancellationActionItem = [MAFActionSheetItem actionSheetItemWithCancellationHandler:^{
        NSLog(@"I got cancelled");
    }];
    
    UIView *someView = [[UIView alloc] initWithFrame:self.view.bounds];
    [someView setBackgroundColor:[UIColor yellowColor]];
    [optionAction2 setCustomBackgroundView:someView];
    
    [actionSheetController addItem:optionAction];
    [actionSheetController addItem:optionAction2];
    [actionSheetController addItem:optionAction3];
    [actionSheetController addItem:cancellationActionItem];
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        [actionSheetController.overlayPresentationCoordinator setSourceBarButtonItem:sender];
    } else {
        [actionSheetController.overlayPresentationCoordinator setSourceView:sender];
    }
    [actionSheetController setShouldPerformSelectedActionBeforeDismissal:YES];
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

@end
