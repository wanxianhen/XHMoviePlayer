//
//  UIView+FrameExpand.h
//  PublicModule
//
//  Created by zhoupengli on 15/4/16.
//  Copyright (c) 2015年 Longtu Game. All rights reserved.
//

#import <UIKit/UIKit.h>
//字体宏定义
#define FONT(size)      [UIFont systemFontOfSize:(size)]

#define MLOG(...)       printf("%s 第%d行: %s\n\n",[LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])


@interface UIView (FrameExpand)

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

@property CGFloat centerX;
@property CGFloat centerY;

/**
 *  设置圆角样式
 *
 *  @param cornerRadius 圆角弧度半斤
 *  @param width        边框宽度
 *  @param color        边框颜色
 */
- (void)loadRoundBorderStyle:(float)cornerRadius
                       width:(float)width
                       color:(UIColor*)color;

@end
