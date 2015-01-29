//  MAFActionSheetItem.h
//  MAFActionSheetController
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

@import UIKit;

/**
You add `MAFActionSheetItem` objects to an `MAFActionSheetController` to represent the options that should be displayed to the user and to define the action that should take place upon selection.
 
You can also create an item with a cancellationHandler.
 
 Only one item per controller will have its handler fired. The rest will be discarded.
 */
@interface MAFActionSheetItem : NSObject

/**
 Creates action items for display.
 
 @param title      The large text to show to the user. Can be nil.
 @param detailText The detail text. Can be nil.
 @param handler    The block to fire when the item is selected.
 
 @return A newly-created action sheet item for use in an action sheet controller.
 */

+ (instancetype)actionSheetItemWithTitle:(NSString *)title
                           detailText:(NSString *)detailText
                              handler:(void (^)())handler;

/**
 Creates action items with a cancellation handler. This item has no visible representation, but is fired when a user taps outside of an action sheet controller.
 
 @param cancellationHandler The block to fire when an action sheet controller is dismissed by the user tapping outside of the controller's view.
 
 @return A newly-created action sheet item with a cancellationHandler.
 */

+ (instancetype)actionSheetItemWithCancellationHandler:(void (^)())cancellationHandler;

/**
 The item's title. Can be nil.
 */
@property (nonatomic, copy, readonly) NSString *title;
/**
 The item's detail text. Can be nil.
 */
@property (nonatomic, copy, readonly) NSString *detailText;
/**
 A custom background view to be displayed underneath the title and detailText but above the normal background.
 
 If the backgroundView is smaller than the item's default size, it will be expanded to fit, otherwise the item's size will attempt to expand to fit the backgroundView. 
 
 @warning If this background view intercepts touch events, it will prevent the actionSheetController's item from being selected.
 */
@property (nonatomic) UIView *customBackgroundView;


@end
