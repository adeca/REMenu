//
//  REMenuItemStyle.h
//  REMenuExample
//
//  Created by Agustín de Cabrera on 13/01/2014.
//  Copyright (c) 2014 Agustín de Cabrera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REMenuItemStyle : NSObject <NSCopying>

@property (strong, readwrite, nonatomic) UIFont *font;
@property (strong, readwrite, nonatomic) UIColor *backgroundColor;
@property (strong, readwrite, nonatomic) UIColor *separatorColor;
@property (strong, readwrite, nonatomic) UIColor *textColor;
@property (strong, readwrite, nonatomic) UIColor *textShadowColor;
@property (assign, readwrite, nonatomic) CGSize textOffset;
@property (assign, readwrite, nonatomic) CGSize textShadowOffset;
@property (assign, readwrite, nonatomic) NSTextAlignment textAlignment;

@end
