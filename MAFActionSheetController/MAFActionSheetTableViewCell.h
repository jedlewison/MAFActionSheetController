//
//  MAFOptionActionCollectionViewCell.h
//  MAFOverlay
//
//  Created by Jed Lewison on 1/4/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MAFActionSheetTableViewCell;

@protocol MAFActionSheetTableViewCellDelegate <NSObject>

-(CGRect)frameForCell:(MAFActionSheetTableViewCell *)cell targetFrame:(CGRect)frame;

@end

@interface MAFActionSheetTableViewCell : UITableViewCell

@property (nonatomic, weak) id <MAFActionSheetTableViewCellDelegate> delegate; // for iOS 7 landscape iPhone

@end
