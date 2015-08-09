//  MAFActionSheetController.m
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


#import "MAFActionSheetController.h"
#import "MAFActionSheetTableViewCell.h"

@interface MAFActionSheetItem (PrivateAccess)
@property (nonatomic, copy) void (^actionHandler)();
@property (nonatomic, copy) void (^cancellationHandler)();
@property (nonatomic, copy) NSAttributedString *attributedTitle;
@property (nonatomic, copy) NSAttributedString *attributedDetailText;
@property (nonatomic, readonly) CGSize preferredSize;
@end

@interface MAFActionSheetController () <MAFOverlayPresentationContextTransitioning, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray *mutableActionSheetItems;
@property (nonatomic) CGFloat maxTitleLabelWidth;
@property (nonatomic) CGFloat maxDetailTextLabelWidth;
@property (nonatomic) UIEdgeInsets preferredMinimumTitleLabelEdgeInsets;
@property (nonatomic) NSArray *actionSheetItems;
@property (nonatomic, copy) MAFActionSheetItem *cancellationItem;
@property (nonatomic) UIView *headerView;
@property (nonatomic) UIView *footerView;
@property (nonatomic) UIView *headerContainerView;
@property (nonatomic) UIView *footerContainerView;
@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat footerHeight;
@property (nonatomic) MAFOverlayPresentationCoordinator *overlayPresentationCoordinator;
@property (nonatomic) CGSize computedPreferredContentSize;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation MAFActionSheetController

+(instancetype)actionSheetControllerWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView
{
    MAFActionSheetController *actionSheetController = [[MAFActionSheetController alloc] init];
    actionSheetController.headerView = headerView;
    actionSheetController.footerView = footerView;
    actionSheetController.headerHeight = headerView.frame.size.height;
    actionSheetController.footerHeight = footerView.frame.size.height;
    actionSheetController.overlayPresentationCoordinator = [MAFOverlayPresentationCoordinator overlayPresentationCoordinatorWithPresentedViewController:actionSheetController];
    return actionSheetController;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.overlayPresentationCoordinator = [MAFOverlayPresentationCoordinator overlayPresentationCoordinatorWithPresentedViewController:self];
}

-(UIModalTransitionStyle)modalTransitionStyle {
    return UIModalTransitionStyleCrossDissolve;
}

-(void)viewWillLayoutSubviews {

    [_tableView setScrollEnabled:(self.computedPreferredContentSize.height - self.headerHeight - self.footerHeight) > _tableView.frame.size.height+1.f];
    [_tableView setBounces:[_tableView isScrollEnabled]];
    [self.view sendSubviewToBack:_tableView];
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

    if (actionSheetItem.cancellationHandler) {
        self.cancellationItem = actionSheetItem;
        return;
    }

    [self.mutableActionSheetItems addObject:actionSheetItem];
    _actionSheetItems = [NSArray arrayWithArray:self.mutableActionSheetItems];

    if (actionSheetItem.title) {
        actionSheetItem.attributedTitle = [[NSAttributedString alloc] initWithString:actionSheetItem.title attributes:self.titleLabelAttributes];
    }

    if (actionSheetItem.detailText) {
        actionSheetItem.attributedDetailText = [[NSAttributedString alloc] initWithString:actionSheetItem.detailText attributes:self.detailTextlabelAttributes];
    }

}

-(NSDictionary *)titleLabelAttributes
{
    if (!_titleLabelAttributes) {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        _titleLabelAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:19.f],
                                   NSParagraphStyleAttributeName: paragraphStyle,
                                   NSForegroundColorAttributeName: [UIColor colorWithWhite:0.1f alpha:1.f]};
    }
    return _titleLabelAttributes;
}

-(NSDictionary *)detailTextlabelAttributes
{
    if (!_detailTextlabelAttributes) {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        _detailTextlabelAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:16.f],
                                        NSParagraphStyleAttributeName: paragraphStyle,
                                        NSForegroundColorAttributeName: [UIColor colorWithWhite:0.2f alpha:1.f]};
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
    if (CGSizeEqualToSize(CGSizeZero, self.computedPreferredContentSize)) {

        CGSize preferredContentSize = CGSizeZero;

        for (MAFActionSheetItem *item in self.actionSheetItems) {
            preferredContentSize.width = MAX(preferredContentSize.width, item.preferredSize.width);
            preferredContentSize.height += item.preferredSize.height;
        }

        preferredContentSize.height += self.headerHeight;
        preferredContentSize.height += self.footerHeight;

        if (!self.footerView) {
            preferredContentSize.height -= 1.f/[UIScreen mainScreen].scale; // hide the bottom separator
        }
        self.computedPreferredContentSize = preferredContentSize;
    }
    return self.computedPreferredContentSize;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.actionSheetItems objectAtIndex:indexPath.row] preferredSize].height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAFActionSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optionActionCellReuseIdentifier" forIndexPath:indexPath];
    MAFActionSheetItem *actionSheetItem = [self.actionSheetItems objectAtIndex:indexPath.row];

    cell.textLabel.attributedText = actionSheetItem.attributedTitle;
    cell.detailTextLabel.attributedText = actionSheetItem.attributedDetailText;
    cell.backgroundView = actionSheetItem.customBackgroundView;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view setUserInteractionEnabled:NO];
    for (MAFActionSheetTableViewCell *cell in tableView.visibleCells) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    MAFActionSheetItem *optionAction = [self.actionSheetItems objectAtIndex:indexPath.row];
    self.actionSheetItems = nil;
    self.mutableActionSheetItems = nil;
    self.cancellationItem = nil;

    [self dismissViewControllerAnimated:YES completion:^{
        if ([self itemHandlerTiming] == MAFActionSheetItemHandlerTimingAfterCompletingDismissal) {
            if (optionAction.actionHandler) {
                optionAction.actionHandler();
            }
        }
    }];

    if ([self itemHandlerTiming] == MAFActionSheetItemHandlerTimingBeforeStartingDismissal) {
        if (optionAction.actionHandler) {
            optionAction.actionHandler();
        }
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.overlayPresentationCoordinator performLayoutForRotationToInterfaceOrientation:toInterfaceOrientation];
}

-(void)presentationContextDidDismiss:(id<MAFOverlayPresentationContext>)presentationContext {
    if ([presentationContext presentedViewController] == self) {
        // handles the cancelation scenario
        self.actionSheetItems = nil;
        self.mutableActionSheetItems = nil;
        if (self.cancellationItem.cancellationHandler) {
            MAFActionSheetItem *cancellationItem = self.cancellationItem;
            self.cancellationItem = nil;
            cancellationItem.cancellationHandler();
        }
        self.tableView.delegate = nil;
        self.tableView.dataSource = nil;
    }
}

-(void)presentationContextWillPresent:(id<MAFOverlayPresentationContext>)presentationContext {
    [self.view setBackgroundColor:[UIColor clearColor]];

    self.headerContainerView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, self.view.bounds.size.width, self.headerHeight}];
    self.footerContainerView = [[UIView alloc] initWithFrame:(CGRect){0, self.view.bounds.size.height - self.footerHeight, self.view.bounds.size.width, self.footerHeight}];
    CGRect footerContainerFrame = self.footerContainerView.frame;
    if (self.footerView) {
        if ([UIPresentationController class]) {
            footerContainerFrame.origin.y -= 1.f/[UIScreen mainScreen].scale;
            footerContainerFrame.size.height += 1.f/[UIScreen mainScreen].scale;
        } else {
            // fix for iOS 7 layout bug
            footerContainerFrame.origin.y -= 1.f;
            footerContainerFrame.size.height += 1.f;

        }
    }
    self.footerContainerView.frame = footerContainerFrame;
    self.headerContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    self.footerContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;

    if (self.headerView) {
        [self.headerContainerView setBackgroundColor:[UIColor clearColor]];
        [self.headerContainerView addSubview:self.headerView];
        self.headerView.frame = self.headerContainerView.bounds;
        self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    } else {
        [self.headerContainerView setBackgroundColor:[UIColor whiteColor]];
    }
    if (self.footerView) {
        [self.footerContainerView setBackgroundColor:[UIColor clearColor]];
        [self.footerContainerView addSubview:self.footerView];
        self.footerView.frame = self.footerContainerView.bounds;
        self.footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    } else {
        [self.footerContainerView setBackgroundColor:[UIColor whiteColor]];
    }

    CGRect headerSeparatorFrame = self.headerContainerView.frame;
    headerSeparatorFrame.size.height = 1.f/[UIScreen mainScreen].scale;
    if (![UIPresentationController class]) {
        // fix for iOS 7 layout bug
        headerSeparatorFrame.size.height = 1.f;
    }
    headerSeparatorFrame.origin.y = CGRectGetMaxY(self.headerContainerView.frame)-headerSeparatorFrame.size.height;
    UIView *headerSeparatorView = [[UIView alloc] initWithFrame:headerSeparatorFrame];
    [headerSeparatorView setBackgroundColor:self.footerHeaderSeparatorColor];
    [headerSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
    [self.headerContainerView addSubview:headerSeparatorView];
    [self.footerContainerView setClipsToBounds:YES];
    [self.headerContainerView setClipsToBounds:YES];

    CGRect footerSeparatorFrame = self.footerContainerView.frame;
    footerSeparatorFrame.origin = CGPointZero;
    footerSeparatorFrame.size.height = 1.f/[UIScreen mainScreen].scale;
    if (![UIPresentationController class]) {
        // fix for iOS 7 layout bug
        footerSeparatorFrame.size.height = 1.f;
    }

    UIView *footerSeparatorView = [[UIView alloc] initWithFrame:footerSeparatorFrame];
    [footerSeparatorView setBackgroundColor:self.footerHeaderSeparatorColor];
    [footerSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    [self.footerContainerView addSubview:footerSeparatorView];

    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame.origin.y = self.headerHeight;
    tableViewFrame.size.height -= (self.footerHeight + self.headerHeight);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [tableView registerClass:[MAFActionSheetTableViewCell class] forCellReuseIdentifier:@"optionActionCellReuseIdentifier"];
    tableView.bounces = NO;
    tableView.allowsMultipleSelection = NO;
    tableView.allowsSelection = YES;
    [tableView setScrollEnabled:NO];
    [tableView setClipsToBounds:YES];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor clearColor];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tableView];
    self.tableView = tableView;

    [self.tableView reloadData];
    [self.view addSubview:self.headerContainerView];
    [self.view addSubview:self.footerContainerView];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderFooterPositionWithScrollView:scrollView];
}

- (void)updateHeaderFooterPositionWithScrollView:(UIScrollView *)scrollView {

    UIEdgeInsets scrollIndicatorInsets = scrollView.scrollIndicatorInsets;

    if (scrollView.contentOffset.y <= 0) {
        self.headerContainerView.frame = (CGRect){CGPointZero,self.tableView.frame.size.width,self.headerHeight + (scrollView.contentOffset.y * -1.f)};
        scrollIndicatorInsets.top = CGRectGetMaxY(self.headerContainerView.frame)-self.headerHeight;
    } else if (scrollView.contentOffset.y >= ([scrollView contentSize].height - self.tableView.frame.size.height)) {
        CGFloat distance = scrollView.contentOffset.y - ([scrollView contentSize].height - self.tableView.frame.size.height);
        CGRect footerContainerFrame = self.footerContainerView.frame;
        footerContainerFrame = (CGRect){0,CGRectGetMaxY(self.tableView.frame)-distance-1.f/[UIScreen mainScreen].scale,self.tableView.frame.size.width,self.footerHeight + distance};
        footerContainerFrame.origin.y -= 1.f/[UIScreen mainScreen].scale;
        footerContainerFrame.size.height += 1.f;
        self.footerContainerView.frame = footerContainerFrame;
        scrollIndicatorInsets.bottom = CGRectGetMaxY(self.tableView.frame)-self.footerContainerView.frame.origin.y;

    }
    scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
}

-(UIColor *)footerHeaderSeparatorColor {
    if (!_footerHeaderSeparatorColor) {
        _footerHeaderSeparatorColor = [UIColor colorWithWhite:0.f alpha:0.35f];
    }
    return _footerHeaderSeparatorColor;
}

- (BOOL)prefersStatusBarHidden {
    return self.actionSheetControllerPrefersStatusBarHidden;
}

- (BOOL)modalPresentationCapturesStatusBarAppearance {
    return self.actionSheetControllerModalPresentationCapturesStatusBarAppearance;
}
@end
