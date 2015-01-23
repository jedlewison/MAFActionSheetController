//
//  MAFOptionActionCollectionViewController.m
//  MAFOverlay
//
//  Created by Jed Lewison on 1/4/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import "MAFActionSheetController.h"
#import "MAFActionSheetTableViewCell.h"
#import <MAFOverlay/MAFOverlayPresentationCoordinator.h>

@interface MAFActionSheetController () <MAFActionSheetTableViewCellDelegate>

@property (nonatomic) NSMutableArray *mutableOptionActions;
@property (nonatomic) CGFloat maxTitleLabelWidth;
@property (nonatomic) CGFloat maxDetailTextLabelWidth;
@property (nonatomic) NSDictionary *titleLabelAttributes;
@property (nonatomic) NSDictionary *detailTextlabelAttributes;
@property (nonatomic) UIEdgeInsets preferredMinimumTitleLabelEdgeInsets;
//@property (nonatomic) MAFOverlayPresentationCoordinator *overlayPresentationCoordinator;

@end

@implementation MAFActionSheetController

+(instancetype)optionActionSheetController
{

    MAFActionSheetController *optionActionSheetController = [[MAFActionSheetController alloc] initWithStyle:UITableViewStylePlain];
    optionActionSheetController.overlayPresentationCoordinator = [MAFOverlayPresentationCoordinator overlayPresentationCoordinatorWithPresentedViewController:optionActionSheetController];

    return optionActionSheetController;
}

-(UIModalTransitionStyle)modalTransitionStyle {
    return UIModalTransitionStyleCrossDissolve;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[MAFActionSheetTableViewCell class] forCellReuseIdentifier:@"optionActionCellReuseIdentifier"];

    self.tableView.bounces = NO;
    CGFloat sideEdgeInset = 32.f;
    self.preferredMinimumTitleLabelEdgeInsets = UIEdgeInsetsMake(0, sideEdgeInset, 0.f, sideEdgeInset);
    self.tableView.allowsMultipleSelection = NO;
    self.tableView.allowsSelection = YES;
    self.tableView.rowHeight = 44.f;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView setScrollEnabled:NO];
    
//    if ([self.tableView respondsToSelector:@selector(setSeparatorEffect:)]) {
//        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//        [self.tableView setSeparatorEffect:vibrancyEffect];
//    }
    [self.view setBackgroundColor:[UIColor clearColor]];
}

-(NSMutableArray *)mutableOptionActions
{
    if (!_mutableOptionActions) {
        _mutableOptionActions = [NSMutableArray array];
    }
    return _mutableOptionActions;
}

-(void)addOptionAction:(MAFAction *)optionAction
{
    [self.mutableOptionActions addObject:optionAction];
    _optionActions = [NSArray arrayWithArray:self.mutableOptionActions];
    CGSize labelSize = [optionAction.title sizeWithAttributes:self.titleLabelAttributes];
    self.maxTitleLabelWidth = MAX(ceil(labelSize.width), self.maxTitleLabelWidth);

    CGSize detailTextLabelSize = [optionAction.detailText sizeWithAttributes:self.detailTextlabelAttributes];
    self.maxDetailTextLabelWidth = MAX(ceil(detailTextLabelSize.width), self.maxDetailTextLabelWidth);

}

-(NSDictionary *)titleLabelAttributes
{
    if (!_titleLabelAttributes) {
        _titleLabelAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:20]};
    }
    return _titleLabelAttributes;
}

-(NSDictionary *)detailTextlabelAttributes
{
    if (!_detailTextlabelAttributes) {
        _detailTextlabelAttributes= @{ NSFontAttributeName: [UIFont systemFontOfSize:12]};
    }
    return _detailTextlabelAttributes;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.optionActions count] > 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.optionActions count];
}

-(CGSize)preferredContentSize
{
    CGSize preferredContentSize = (CGSize){
        (MAX(self.maxTitleLabelWidth, self.maxDetailTextLabelWidth)) + self.preferredMinimumTitleLabelEdgeInsets.left + self.preferredMinimumTitleLabelEdgeInsets.right,
        self.tableView.rowHeight * [self.tableView numberOfRowsInSection:0]
    };
    preferredContentSize.height -= 1.f/[UIScreen mainScreen].scale; // hide the bottom separator
    return preferredContentSize;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAFActionSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optionActionCellReuseIdentifier" forIndexPath:indexPath];
    cell.delegate = self;
    MAFAction *optionAction = [self.optionActions objectAtIndex:indexPath.row];

    if ([optionAction isChecked] && ![self disableCheckmarks]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    cell.textLabel.text = optionAction.title;
    cell.detailTextLabel.text = optionAction.detailText;
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view setUserInteractionEnabled:NO];
    MAFActionSheetTableViewCell *selectedCell = (MAFActionSheetTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    for (MAFActionSheetTableViewCell *cell in tableView.visibleCells) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (![self disableCheckmarks]) {
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UINavigationControllerHideShowBarDuration * 3.f/5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        MAFAction *optionAction = [self.optionActions objectAtIndex:indexPath.row];

        [self dismissViewControllerAnimated:YES completion:^{
            if (optionAction.actionHandler) {
                optionAction.actionHandler();
            }
        }];
    });
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.overlayPresentationCoordinator presentedOverlayViewController:self willAnimateRotationToInterfaceOrientation:toInterfaceOrientation];
}

-(CGRect)frameForCell:(MAFActionSheetTableViewCell *)cell targetFrame:(CGRect)frame {
    CGRect finalFrame = frame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        finalFrame.size.width = self.tableView.frame.size.width;
    } else {
        finalFrame.size.width = self.tableView.frame.size.height;
    }
    return finalFrame;
}

@end
