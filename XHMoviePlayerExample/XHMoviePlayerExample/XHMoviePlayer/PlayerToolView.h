//
//  PlayerToolView.h
//  KLine
//
//  Created by wangxiangheng on 2017/3/28.
//  Copyright © 2017年 wangxiangheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerToolView : UIView

@property (nonatomic,strong)AVPlayer *player;


@property (nonatomic, copy) void (^closeBlock)();

//播放球动起来
- (void)PlayOrStop:(BOOL)isPlay;

@end
