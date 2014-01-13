//
//  REMenuItemStyle.m
//  REMenuExample
//
//  Created by Agustín de Cabrera on 13/01/2014.
//  Copyright (c) 2014 Agustín de Cabrera. All rights reserved.
//

#import "REMenuItemStyle.h"

@implementation REMenuItemStyle

- (id)copyWithZone:(NSZone *)zone
{
    REMenuItemStyle *copy = [[REMenuItemStyle alloc] init];
    
    copy->_font = self.font;
    copy->_backgroundColor = self.backgroundColor;
    copy->_separatorColor = self.separatorColor;
    copy->_textColor = self.textColor;
    copy->_textShadowColor = self.textShadowColor;
    copy->_textOffset = self.textOffset;
    copy->_textShadowOffset = self.textShadowOffset;
    copy->_textAlignment = self.textAlignment;
    
    return copy;
}

@end
