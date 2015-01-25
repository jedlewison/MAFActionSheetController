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

    MAFActionSheetController *actionSheetController = [MAFActionSheetController actionSheetController];

    MAFActionSheetItem *optionAction = [MAFActionSheetItem actionSheetItemWithTitle:@"Change Background To Orange" detailText:@"Detail" checked:NO handler:^{
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            self.view.backgroundColor = [UIColor orangeColor];
        }];
    }];

    MAFActionSheetItem *optionAction2 = [MAFActionSheetItem actionSheetItemWithTitle:@"Do Nothing" detailText:@"Has Custom Background View" checked:YES handler:nil];
    MAFActionSheetItem *optionAction3 = [MAFActionSheetItem actionSheetItemWithTitle:@"Change Button To Green" detailText:@"Detail" checked:NO handler:^{
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            [sender setBackgroundColor:[UIColor greenColor]];
        }];
    }];


    UIView *someView = [[UIView alloc] initWithFrame:self.view.bounds];
    [someView setBackgroundColor:[UIColor yellowColor]];
    [optionAction2 setCustomBackgroundView:someView];
    
    [actionSheetController addItem:optionAction];
    [actionSheetController addItem:optionAction2];
    [actionSheetController addItem:optionAction3];
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        [actionSheetController.overlayPresentationCoordinator setSourceBarButtonItem:sender];
    } else {
        [actionSheetController.overlayPresentationCoordinator setSourceView:sender];
    }

    [self presentViewController:actionSheetController animated:YES completion:nil];
}

@end
