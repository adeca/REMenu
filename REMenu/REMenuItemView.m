//
// REMenuItemView.m
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

#import "REMenuItemView.h"
#import "REMenuItem.h"

@interface REMenuItemView ()

@property (strong, readwrite, nonatomic) UIView *backgroundView;

@property (readonly, nonatomic) REMenuItemStyle *itemStyle;
@property (readonly, nonatomic) REMenuItemStyle *highlightedItemStyle;
@property (readonly, nonatomic) REMenuItemStyle *subtitleItemStyle;
@property (readonly, nonatomic) REMenuItemStyle *subtitleHighlightedItemStyle;

@end

@implementation REMenuItemView

- (id)initWithFrame:(CGRect)frame menu:(REMenu *)menu hasSubtitle:(BOOL)hasSubtitle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menu = menu;
        self.isAccessibilityElement = YES;
        self.accessibilityTraits = UIAccessibilityTraitButton;
        self.accessibilityHint = NSLocalizedString(@"Double tap to choose", @"Double tap to choose");
        
        _backgroundView = ({
            UIView *view = [[UIView alloc] initWithFrame:self.bounds];
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            if (menu.liveBlur && REUIKitIsFlatMode())
                view.alpha = 0.5f;
            view;
        });
        [self addSubview:_backgroundView];
        
        CGRect titleFrame;
        if (hasSubtitle) {
            // Dividing lines at 1/1.725 (vs 1/2.000) results in labels about 28-top 20-bottom or 60/40 title/subtitle (for a 48 frame height)
            //
            titleFrame = CGRectMake(self.itemStyle.textOffset.width,
                                    self.itemStyle.textOffset.height,
                                    0, floorf(frame.size.height / 1.725));

            CGRect subtitleFrame = CGRectMake(self.subtitleItemStyle.textOffset.width,
                                              self.subtitleItemStyle.textOffset.height + titleFrame.size.height,
                                              0, floorf(frame.size.height * (1.0 - 1.0 / 1.725)));
            self.subtitleLabel = ({
                UILabel *label =[[UILabel alloc] initWithFrame:subtitleFrame];
                label.contentMode = UIViewContentModeCenter;
                label.textAlignment = self.subtitleItemStyle.textAlignment;
                label.backgroundColor = [UIColor clearColor];
                label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                label.isAccessibilityElement = NO;
                label;
            });
            [self addSubview:_subtitleLabel];
        } else {
            titleFrame = CGRectMake(self.itemStyle.textOffset.width,
                                    self.itemStyle.textOffset.height,
                                    0, frame.size.height);
        }

        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:titleFrame];
            label.isAccessibilityElement = NO;
            label.contentMode = UIViewContentModeCenter;
            label.textAlignment = self.itemStyle.textAlignment;
            label.backgroundColor = [UIColor clearColor];
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            label;
        });

        _imageView = [[UIImageView alloc] initWithFrame:CGRectNull];
        
        _badgeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor colorWithWhite:0.559 alpha:1.000];
            label.font = [UIFont systemFontOfSize:11];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.hidden = YES;
            label.layer.cornerRadius = 4.0;
            label.layer.borderColor =  [UIColor colorWithWhite:0.630 alpha:1.000].CGColor;
            label.layer.borderWidth = 1.0;
            label;
        });
        
        [self addSubview:_titleLabel];
        [self addSubview:_imageView];
        [self addSubview:_badgeLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.image = self.item.image;
    
    // Adjust frames
    //
    CGFloat verticalOffset = floor((self.frame.size.height - self.item.image.size.height) / 2.0);
    CGFloat horizontalOffset = floor((self.menu.itemHeight - self.item.image.size.height) / 2.0);
    CGFloat x = (self.menu.imageAlignment == REMenuImageAlignmentLeft) ? horizontalOffset + self.menu.imageOffset.width :
                                                                         self.titleLabel.frame.size.width - (horizontalOffset + self.menu.imageOffset.width + self.item.image.size.width);
    self.imageView.frame = CGRectMake(x, verticalOffset + self.menu.imageOffset.height, self.item.image.size.width, self.item.image.size.height);
    
    // Set up badge
    //
    self.badgeLabel.hidden = !self.item.badge;
    if (self.item.badge) {
        self.badgeLabel.text = self.item.badge;
        NSAttributedString *badgeAttributedString = [[NSAttributedString alloc] initWithString:self.item.badge
                                                                                    attributes:@{NSFontAttributeName:self.badgeLabel.font}];
        CGRect rect = [badgeAttributedString boundingRectWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                          context:nil];
        CGFloat x = self.menu.imageAlignment == REMenuImageAlignmentLeft ? CGRectGetMaxX(self.imageView.frame) - 2.0 :
        CGRectGetMinX(self.imageView.frame) - rect.size.height - 4.0;
        self.badgeLabel.frame = CGRectMake(x, self.imageView.frame.origin.y - 2.0, rect.size.width + 6.0, rect.size.height + 2.0);
       
        if (self.menu.badgeLabelConfigurationBlock)
            self.menu.badgeLabelConfigurationBlock(self.badgeLabel, self.item);
    }
    
    // Accessibility
    //
    self.accessibilityLabel = self.item.title;
    if (self.subtitleLabel.text)
        self.accessibilityLabel = [NSString stringWithFormat:@"%@, %@", self.item.title, self.item.subtitle];
    
    // Adjust styles
    //
    self.titleLabel.font = self.itemStyle.font;
    self.titleLabel.text = self.item.title;
    self.titleLabel.textColor = self.itemStyle.textColor;
    self.titleLabel.shadowColor = self.itemStyle.textShadowColor;
    self.titleLabel.shadowOffset = self.itemStyle.textShadowOffset;
    self.titleLabel.textAlignment = self.itemStyle.textAlignment;
    
    self.subtitleLabel.font = self.subtitleItemStyle.font;
    self.subtitleLabel.text = self.item.subtitle;
    self.subtitleLabel.textColor = self.subtitleItemStyle.textColor;
    self.subtitleLabel.shadowColor = self.subtitleItemStyle.textShadowColor;
    self.subtitleLabel.shadowOffset = self.subtitleItemStyle.textShadowOffset;
    self.subtitleLabel.textAlignment = self.subtitleItemStyle.textAlignment;
    
    self.item.customView.frame = CGRectMake(0, 0, self.titleLabel.frame.size.width, self.frame.size.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.backgroundColor = self.highlightedItemStyle.backgroundColor;
    self.separatorView.backgroundColor = self.highlightedItemStyle.separatorColor;
    self.imageView.image = self.item.higlightedImage ? self.item.higlightedImage : self.item.image;
    
    self.titleLabel.textColor = self.highlightedItemStyle.textColor;
    self.titleLabel.shadowColor = self.highlightedItemStyle.textShadowColor;
    self.titleLabel.shadowOffset = self.highlightedItemStyle.textShadowOffset;
    
    self.subtitleLabel.textColor = self.subtitleHighlightedItemStyle.textColor;
    self.subtitleLabel.shadowColor = self.subtitleHighlightedItemStyle.textShadowColor;
    self.subtitleLabel.shadowOffset = self.subtitleHighlightedItemStyle.textShadowOffset;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.separatorView.backgroundColor = self.itemStyle.separatorColor;
    self.imageView.image = self.item.image;
    
    self.titleLabel.textColor = self.itemStyle.textColor;
    self.titleLabel.shadowColor = self.itemStyle.textShadowColor;
    self.titleLabel.shadowOffset = self.itemStyle.textShadowOffset;
    
    self.subtitleLabel.textColor = self.subtitleItemStyle.textColor;
    self.subtitleLabel.shadowColor = self.subtitleItemStyle.textShadowColor;
    self.subtitleLabel.shadowOffset = self.subtitleItemStyle.textShadowOffset;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.separatorView.backgroundColor = self.itemStyle.separatorColor;
    self.imageView.image = self.item.image;
    
    self.titleLabel.textColor = self.itemStyle.textColor;
    self.titleLabel.shadowColor = self.itemStyle.textShadowColor;
    self.titleLabel.shadowOffset = self.itemStyle.textShadowOffset;
    
    self.subtitleLabel.textColor = self.subtitleItemStyle.textColor;
    self.subtitleLabel.shadowColor = self.subtitleItemStyle.textShadowColor;
    self.subtitleLabel.shadowOffset = self.subtitleItemStyle.textShadowOffset;

    CGPoint endedPoint = [touches.anyObject locationInView:self];
    if (endedPoint.y < 0 || endedPoint.y > CGRectGetHeight(self.bounds))
        return;
    
    if (!self.menu.closeOnSelection) {
        if (self.item.action)
            self.item.action(self.item);
    } else {
        if (self.item.action) {
            if (self.menu.waitUntilAnimationIsComplete) {
                __typeof (&*self) __weak weakSelf = self;
                [self.menu closeWithCompletion:^{
                    weakSelf.item.action(weakSelf.item);
                }];
            } else {
                [self.menu close];
                self.item.action(self.item);
            }
        }
    }
}

- (REMenuItemStyle *)itemStyle
{
    return self.item.itemStyle ?: self.menu.itemStyle;
}
- (REMenuItemStyle *)highlightedItemStyle
{
    return self.item.highlightedItemStyle ?: self.menu.highlightedItemStyle;
}
- (REMenuItemStyle *)subtitleItemStyle
{
    return self.item.subtitleItemStyle ?: self.menu.subtitleItemStyle;
}
- (REMenuItemStyle *)subtitleHighlightedItemStyle
{
    return self.item.subtitleHighlightedItemStyle ?: self.menu.subtitleHighlightedItemStyle;
}

@end
