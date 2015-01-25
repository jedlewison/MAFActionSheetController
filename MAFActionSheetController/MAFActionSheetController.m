//
//  MAFOptionActionCollectionViewController.m
//  MAFOverlay
//
//  Created by Jed Lewison on 1/4/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import "MAFActionSheetController.h"
#import "MAFActionSheetTableViewCell.h"

@interface MAFActionSheetItem (PrivateAccess)
@property (nonatomic, copy) void (^actionHandler)();
@property (nonatomic, copy) NSAttributedString *attributedTitle;
@property (nonatomic, copy) NSAttributedString *attributedDetailText;
@end


@interface MAFActionSheetController () <MAFActionSheetTableViewCellDelegate>

@property (nonatomic) NSMutableArray *mutableActionSheetItems;
@property (nonatomic) CGFloat maxTitleLabelWidth;
@property (nonatomic) CGFloat maxDetailTextLabelWidth;
@property (nonatomic) NSDictionary *titleLabelAttributes;
@property (nonatomic) NSDictionary *detailTextlabelAttributes;
@property (nonatomic) UIEdgeInsets preferredMinimumTitleLabelEdgeInsets;
@property (nonatomic) NSArray *actionSheetItems;
@end

@implementation MAFActionSheetController

+(instancetype)actionSheetController
{
    
    MAFActionSheetController *optionActionSheetController = [[MAFActionSheetController alloc] initWithStyle:UITableViewStylePlain];
    optionActionSheetController.overlayPresentationCoordinator = [MAFOverlayPresentationCoordinator overlayPresentationCoordinatorWithPresentedViewController:optionActionSheetController];

    return optionActionSheetController;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.overlayPresentationCoordinator = [MAFOverlayPresentationCoordinator overlayPresentationCoordinatorWithPresentedViewController:self];
    
}

-(UIModalTransitionStyle)modalTransitionStyle {
    return UIModalTransitionStyleCrossDissolve;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[MAFActionSheetTableViewCell class] forCellReuseIdentifier:@"optionActionCellReuseIdentifier"];

    self.tableView.bounces = NO;
    CGFloat sideEdgeInset = 8.f;
    self.preferredMinimumTitleLabelEdgeInsets = UIEdgeInsetsMake(0, sideEdgeInset, 0.f, sideEdgeInset);
    self.tableView.allowsMultipleSelection = NO;
    self.tableView.allowsSelection = YES;
    self.tableView.rowHeight = 44.f;
    [self.tableView setScrollEnabled:NO];

//    if ([self.tableView respondsToSelector:@selector(setSeparatorEffect:)]) {
//        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//        [self.tableView setSeparatorEffect:vibrancyEffect];
//    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor clearColor];


    [self.view setBackgroundColor:[UIColor clearColor]];
}

-(NSMutableArray *)mutableActionSheetItems
{
    if (!_mutableActionSheetItems) {
        _mutableActionSheetItems = [NSMutableArray array];
    }
    return _mutableActionSheetItems;
}


-(void)addItem:(MAFActionSheetItem *)actionSheetItem
{
    if (self.presentingViewController) {
        NSLog(@"cannot add item to presented controller");
        return;
    }
    [self.mutableActionSheetItems addObject:actionSheetItem];
    _actionSheetItems = [NSArray arrayWithArray:self.mutableActionSheetItems];
    
    if (actionSheetItem.title) {
        actionSheetItem.attributedTitle = [[NSAttributedString alloc] initWithString:actionSheetItem.title attributes:self.titleLabelAttributes];
        self.maxTitleLabelWidth = MAX(ceil(actionSheetItem.attributedTitle.size.width), self.maxTitleLabelWidth);
    }
    
    if (actionSheetItem.detailText) {
        actionSheetItem.attributedDetailText = [[NSAttributedString alloc] initWithString:actionSheetItem.detailText attributes:self.detailTextlabelAttributes];
        self.maxDetailTextLabelWidth = MAX(ceil(actionSheetItem.attributedDetailText.size.width), self.maxDetailTextLabelWidth);
    }

}

-(NSDictionary *)titleLabelAttributes
{
    if (!_titleLabelAttributes) {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        _titleLabelAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:18],
                                   NSParagraphStyleAttributeName: paragraphStyle};
    }
    return _titleLabelAttributes;
}

-(NSDictionary *)detailTextlabelAttributes
{
    if (!_detailTextlabelAttributes) {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        _detailTextlabelAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:12],
                                   NSParagraphStyleAttributeName: paragraphStyle,
                                   NSForegroundColorAttributeName: [UIColor colorWithWhite:0.3f alpha:1.f]};
    }
    return _detailTextlabelAttributes;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.actionSheetItems count] > 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.actionSheetItems count];
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
    MAFActionSheetItem *actionSheetItem = [self.actionSheetItems objectAtIndex:indexPath.row];

    
    cell.textLabel.attributedText = actionSheetItem.attributedTitle;
    cell.detailTextLabel.attributedText = actionSheetItem.attributedDetailText;
    cell.backgroundView = actionSheetItem.customBackgroundView;
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

    MAFActionSheetItem *optionAction = [self.actionSheetItems objectAtIndex:indexPath.row];
    self.actionSheetItems = nil;
    self.mutableActionSheetItems = nil;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UINavigationControllerHideShowBarDuration * 3.f/5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

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
