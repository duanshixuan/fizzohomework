//
//  UIButton+FYStyle.m
//  FangYou
//
//  Created by 陈震 on 2017/12/5.
//  Copyright © 2017年 FangYou. All rights reserved.
//

#import "UIButton+FYStyle.h"

@implementation UIButton (FYStyle)


- (void)setButtonUpIconBottomTitleWithSpace:(float)space{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.intrinsicContentSize;
    float spacing = space == 0 ? 8 : space;
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
}

- (void)setButtonRightIconLeftTitleWithSpace:(float)space{
    CGSize imageSize = self.imageView.frame.size;
    float spacing = space == 0 ? 8 : space;
 
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width-spacing, 0, imageSize.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
    
}
- (void)setButtonLeftIconRightTitleWithSpace:(float)space{
    float spacing = space == 0 ? 8 : space;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -spacing)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -spacing, 0, 0)];
}

@end
