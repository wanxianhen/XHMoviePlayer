//
//  UIView+FrameExpand.m
//  PublicModule
//
//  Created by zhoupengli on 15/4/16.
//  Copyright (c) 2015年 Longtu Game. All rights reserved.
//

#import "UIView+FrameExpand.h"

@implementation UIView (FrameExpand)

- (CGFloat) height
{
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (CGFloat) centerX
{
    return self.center.x;
}

- (void) setCenterX: (CGFloat) newCx
{
    self.center = CGPointMake(newCx, self.center.y);
}

- (CGFloat) centerY
{
    return self.center.y;
}

- (void) setCenterY: (CGFloat) newCy
{
    self.center = CGPointMake(self.center.x , newCy);
}

- (void)loadRoundBorderStyle:(float)cornerRadius
                       width:(float)width
                       color:(UIColor*)color
{
    self.layer.cornerRadius = cornerRadius?:MIN(self.width/2, self.height/2);
    self.layer.borderWidth = width;
    
    if (color) {
        self.layer.borderColor = color.CGColor;
    }
    
    self.layer.masksToBounds = YES;
}

@end
