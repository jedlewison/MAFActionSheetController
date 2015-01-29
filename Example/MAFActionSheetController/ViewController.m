//  ViewController.m
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

#import "ViewController.h"
#import "MAFActionSheetController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)didPressButton:(id)sender {
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    headerLabel.text = @"Custom Header View";
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.text = @"Custom Footer View";
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

    footerLabel.backgroundColor = [UIColor whiteColor];
    [headerLabel sizeToFit];
    headerLabel.frame = (CGRect){headerLabel.frame.origin, headerLabel.frame.size.width, 52.f};
    [footerLabel sizeToFit];
    footerLabel.frame = (CGRect){footerLabel.frame.origin, headerLabel.frame.size.width, 36.f};
    
    if ([self.toolbarItems containsObject:sender]) {
        headerLabel = nil;
        footerLabel = nil;
    } else if (self.navigationItem.rightBarButtonItem == sender) {
        footerLabel = nil;
    }
    
    MAFActionSheetController *actionSheetController = [MAFActionSheetController actionSheetControllerWithHeaderView:headerLabel footerView:footerLabel];

    NSString *title = @"Change Background Color";
    NSString *detailText = @"Color will be orange";
    UIColor *targetColor = [UIColor orangeColor];
    if (self.view.backgroundColor == targetColor) {
        detailText = @"Color will be white";
        targetColor = [UIColor whiteColor];
    }
    MAFActionSheetItem *optionAction = [MAFActionSheetItem actionSheetItemWithTitle:title detailText:detailText handler:^{
        [actionSheetController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.view.backgroundColor = targetColor;

        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            
        }];
    }];

    MAFActionSheetItem *optionAction2 = [MAFActionSheetItem actionSheetItemWithTitle:@"Do Nothing" detailText:@"Has Custom Background View" handler:nil];
    MAFActionSheetItem *optionAction3 = [MAFActionSheetItem actionSheetItemWithTitle:@"Change Button To Green" detailText:@"Detail" handler:^{
        [actionSheetController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if ([sender isKindOfClass:[UIButton class]]) {
                [sender setBackgroundColor:[UIColor greenColor]];
            }
        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            
        }];
    }];

    MAFActionSheetItem *cancellationActionItem = [MAFActionSheetItem actionSheetItemWithCancellationHandler:^{
        NSLog(@"I got cancelled");
    }];
    
    [actionSheetController addItem:optionAction];

    if (sender == [self.toolbarItems lastObject]) {

        UIView *someView = [[UIView alloc] initWithFrame:(CGRect){0,0,40,80}];
        [someView setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.5f]];
        [optionAction2 setCustomBackgroundView:someView];
        [actionSheetController addItem:optionAction];
        [actionSheetController addItem:optionAction];
        [actionSheetController addItem:optionAction];
        [actionSheetController addItem:optionAction];
        [actionSheetController addItem:optionAction];
        [actionSheetController addItem:optionAction];
        [actionSheetController addItem:optionAction];
        [actionSheetController addItem:optionAction];
        [actionSheetController addItem:optionAction];
        [actionSheetController addItem:optionAction];
        [actionSheetController addItem:optionAction];
        [actionSheetController addItem:optionAction3];

    }
    
    
    [actionSheetController addItem:optionAction2];
    
    [actionSheetController addItem:optionAction3];
    [actionSheetController addItem:cancellationActionItem];
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        [actionSheetController.overlayPresentationCoordinator setSourceBarButtonItem:sender];
    } else {
        [actionSheetController.overlayPresentationCoordinator setSourceView:sender];
    }
    [actionSheetController setItemHandlerTiming:MAFActionSheetItemHandlerTimingBeforeStartingDismissal];
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

@end
