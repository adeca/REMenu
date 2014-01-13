//
// REMenu.h
// REMenu
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RECommonFunctions.h"
#import "REMenuItem.h"
#import "REMenuContainerView.h"
#import "REMenuItemStyle.h"

@class REMenuItem;

typedef NS_ENUM(NSInteger, REMenuImageAlignment) {
    REMenuImageAlignmentLeft,
    REMenuImageAlignmentRight
};

typedef NS_ENUM(NSInteger, REMenuLiveBackgroundStyle) {
    REMenuLiveBackgroundStyleLight,
    REMenuLiveBackgroundStyleDark
};

@interface REMenu : NSObject 

// Data
//
@property (strong, readwrite, nonatomic) NSArray *items;
@property (strong, readwrite, nonatomic) UIView *backgroundView;
@property (assign, readonly, nonatomic) BOOL isOpen;
@property (assign, readonly, nonatomic) BOOL isAnimating;
@property (assign, readwrite, nonatomic) BOOL waitUntilAnimationIsComplete;
@property (copy, readwrite, nonatomic) void (^closeCompletionHandler)(void);
@property (assign, readwrite, nonatomic) BOOL closeOnSelection;

// Style
//
@property (strong, readwrite, nonatomic) REMenuItemStyle *itemStyle;
@property (strong, readwrite, nonatomic) REMenuItemStyle *highlightedItemStyle;
@property (strong, readwrite, nonatomic) REMenuItemStyle *subtitleItemStyle;
@property (strong, readwrite, nonatomic) REMenuItemStyle *subtitleHighlightedItemStyle;

@property (assign, readwrite, nonatomic) CGFloat cornerRadius;
@property (strong, readwrite, nonatomic) UIColor *shadowColor;
@property (assign, readwrite, nonatomic) CGSize shadowOffset;
@property (assign, readwrite, nonatomic) CGFloat shadowOpacity;
@property (assign, readwrite, nonatomic) CGFloat shadowRadius;
@property (assign, readwrite, nonatomic) CGFloat itemHeight;
@property (assign, readwrite, nonatomic) CGFloat separatorHeight;
@property (assign, readwrite, nonatomic) CGSize imageOffset;
@property (assign, readwrite, nonatomic) CGFloat borderWidth;
@property (strong, readwrite, nonatomic) UIColor *borderColor;
@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
@property (assign, readwrite, nonatomic) NSTimeInterval bounceAnimationDuration;
@property (assign, readwrite, nonatomic) REMenuImageAlignment imageAlignment;
@property (assign, readwrite, nonatomic) BOOL appearsBehindNavigationBar;
@property (assign, readwrite, nonatomic) BOOL bounce;
@property (assign, readwrite, nonatomic) BOOL liveBlur; // Available only in iOS 7
@property (strong, readwrite, nonatomic) UIColor *liveBlurTintColor; // Available only in iOS 7
@property (assign, readwrite, nonatomic) REMenuLiveBackgroundStyle liveBlurBackgroundStyle; // Available only in iOS 7
@property (copy, readwrite, nonatomic) void (^badgeLabelConfigurationBlock)(UILabel *badgeLabel, REMenuItem *item);

- (id)initWithItems:(NSArray *)items;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view;
- (void)showInView:(UIView *)view;
- (void)showFromNavigationController:(UINavigationController *)navigationController;
- (void)setNeedsLayout;
- (void)closeWithCompletion:(void (^)(void))completion;
- (void)close;

@end
