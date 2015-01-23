//
//  ViewController.m
//  MAFActionSheetControllerExample
//
//  Created by Jed Lewison on 1/22/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import "ViewController.h"
#import "MAFActionSheetController.h"
#import "MAFOverlay.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)didPressButton:(id)sender {

    MAFActionSheetController *actionSheetController = [self.storyboard instantiateViewControllerWithIdentifier:@"Action Sheet Controller"];

    MAFAction *optionAction = [MAFAction optionActionWithTitle:@"Option Action One" detailText:@"Detail" checked:NO handler:nil];

    MAFAction *optionAction2 = [MAFAction optionActionWithTitle:@"Option Action Two" detailText:@"Detail" checked:NO handler:nil];

    MAFAction *optionAction3 = [MAFAction optionActionWithTitle:@"Option Action Three" detailText:@"Detail" checked:NO handler:nil];

    [actionSheetController addOptionAction:optionAction];
    [actionSheetController addOptionAction:optionAction2];
    [actionSheetController addOptionAction:optionAction3];
    [self presentViewController:actionSheetController animated:YES completion:nil];
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        [actionSheetController.overlayPresentationCoordinator setSourceBarButtonItem:sender];
    } else {
        [actionSheetController.overlayPresentationCoordinator setSourceView:sender];
    }
    [self presentViewController:actionSheetController animated:YES completion:NULL];
}

@end
