//
//  MoviePlayerView.m
//  KLine
//
//  Created by wangxiangheng on 2017/3/28.
//  Copyright © 2017年 wangxiangheng. All rights reserved.
//

#import "MoviePlayerView.h"
#import "PlayerToolView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+FrameExpand.h"


@interface MoviePlayerView()

@property (nonatomic, strong) AVPlayer *player ;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) PlayerToolView *toolView;

@end

@implementation MoviePlayerView

- (instancetype)initWithUrl:(NSURL *)url
{
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [super initWithFrame:(CGRect){0, 0,screenSize }];
    
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        //传入地址
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        // 播放器
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        
        // 播放器layer
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        
        
        _playerLayer.frame = self.bounds;
        // 视频填充模式
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        // 添加到imageview的layer上
        [self.layer addSublayer:_playerLayer];
        // 隐藏提示框 开始播放
        
        //静音模式也能播放
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)]];
        
        //监听程序状态栏方向改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutSubviews) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    
    return self;
}


- (void)setupMainView {
    NSLog(@"5.setupMainView方法，初始化界面");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.bounds = window.bounds;
    self.center = window.center;
    //1. toolView
    
    [self addSubview:self.toolView];

}
- (PlayerToolView *)toolView
{
    if (_toolView == nil) {
        _toolView = [[PlayerToolView alloc]initWithFrame:self.bounds];
        _toolView.player = _player;
        __weak typeof (self)  weakSelf = self;
        _toolView.closeBlock = ^(){
            [weakSelf close];
        };
    }
    
    return _toolView;
}
- (void)tapView
{
    self.toolView.hidden = !self.toolView.hidden;
  
}
- (void)play
{
    [self setupMainView];
    // 播放
    [self.player play];
    [self.toolView PlayOrStop:YES];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
    
    
    
}

- (void)close
{
    [self.player pause];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}

- (void)layoutSubviews
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.frame = (CGRect){0, 0,screenSize };
    [self.playerLayer setFrame:(CGRect){0, 0, screenSize} ];
    
    self.toolView.frame = self.frame;
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
