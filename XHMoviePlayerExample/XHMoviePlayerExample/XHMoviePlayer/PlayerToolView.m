//
//  PlayerToolView.m
//  KLine
//
//  Created by wangxiangheng on 2017/3/28.
//  Copyright © 2017年 wangxiangheng. All rights reserved.
//

#import "PlayerToolView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+FrameExpand.h"


#define kToolViewHeight 55
#define kToolBtnWith  60

@interface PlayerToolView()

//顶部工具条
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *settingsBtn;

//底部工具条
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UILabel *TimePlayedLabel;
@property (nonatomic,strong)UILabel *TimeLeftLabel;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic,strong)UISlider *movieProgressSlider;//进度条
@property (nonatomic,assign)CGFloat ProgressBeginToMove;
@property (nonatomic,assign)CGFloat totalMovieDuration;//视频总时间

//右边文件管理
@property (nonatomic,strong)UIView *settingsView;
@property (nonatomic,strong)UIView *rightView;
@property (nonatomic,strong)UIButton *setTestBtn;

//touch evens
@property (nonatomic,assign)BOOL isShowView;
@property (nonatomic,assign)BOOL isSettingsViewShow;
@property (nonatomic,assign)BOOL isSlideOrClick;

@property (nonatomic,strong)UISlider *volumeViewSlider;
@property (nonatomic,assign)float systemVolume;//系统音量值
@property (nonatomic,assign)float systemBrightness;//系统亮度
@property (nonatomic,assign)CGPoint startPoint;//起始位置坐标

@property (nonatomic,assign)BOOL isTouchBeganLeft;//起始位置方向
@property (nonatomic,copy)NSString *isSlideDirection;//滑动方向
@property (nonatomic,assign)float startProgress;//起始进度条
@property (nonatomic,assign)float NowProgress;//进度条当前位置

//监控进度
@property (nonatomic,strong)NSTimer *avTimer;

@end

@implementation PlayerToolView

- (void)didMoveToSuperview
{
    self.backgroundColor = [UIColor clearColor];

    //获取系统音量
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    //获取系统亮度
    _systemBrightness = [UIScreen mainScreen].brightness;
    
    [self setupMainView];
}

- (void)setupMainView {
    NSLog(@"5.setupMainView方法，初始化界面");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.bounds = window.bounds;
    self.center = window.center;
    
    _totalMovieDuration = CMTimeGetSeconds(self.player.currentItem.asset.duration);
    
    //我来组成头部
    [self createTopView];
    //我来组成底部
    [self createBottomView];
    //右边文件管理
    [self createRightSettingsView];
    

}
#pragma mark - 头部工具条view
- (void)createTopView
{
    CGFloat titleLableWidth = 150;
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, kToolViewHeight)];
    _topView.backgroundColor = [UIColor clearColor];
    
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, kToolBtnWith, kToolViewHeight)];
    [_backBtn setImage:[self getIcon:@"mediaPreviewClose"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_backBtn];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, titleLableWidth, kToolViewHeight)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"我是标题";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.userInteractionEnabled = NO;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.centerX = _topView.centerX;
    [_topView addSubview:_titleLabel];
    
    _settingsBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width - 70, 0, 70, kToolViewHeight)];
    [_settingsBtn setImage:[self getIcon:@"mediaPreviewAlbum"] forState:UIControlStateNormal];
    [_settingsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_settingsBtn addTarget:self action:@selector(settingsClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_settingsBtn];
    
    [self addSubview:_topView];
}
//返回关闭点击
- (void)backClick
{
    [self.avTimer invalidate];
    self.avTimer = nil;
    
    if (self.closeBlock) {
        self.closeBlock();
    }
}
//设置按钮点击
- (void)settingsClick:(UIButton*)btn
{
    NSLog(@"点击了设置按钮");
    
}

#pragma mark - 底部工具条View
- (void)createBottomView
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - kToolViewHeight, self.width, kToolViewHeight)];
    _bottomView.backgroundColor = [UIColor clearColor];
    
    _playBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kToolBtnWith, kToolViewHeight)];
    [_playBtn setImage:[self getIcon:@"mediaPreviewPlay"] forState:UIControlStateNormal];
    [_playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_playBtn];
    
    CGFloat timeLableWidth = 40;
    _TimePlayedLabel = [[UILabel alloc]initWithFrame:CGRectMake(_playBtn.right, 0, timeLableWidth, kToolViewHeight)];
    _TimePlayedLabel.font = FONT(12);
    _TimePlayedLabel.backgroundColor = [UIColor clearColor];
    _TimePlayedLabel.textColor = [UIColor whiteColor];
    _TimePlayedLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_TimePlayedLabel];
    
    _movieProgressSlider = [[UISlider alloc] initWithFrame:CGRectMake(_TimePlayedLabel.right + 5, 0, _bottomView.width - 105 - 70, kToolViewHeight)];
    [_movieProgressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_movieProgressSlider setMaximumTrackTintColor:[UIColor colorWithRed:0.49f green:0.48f blue:0.49f alpha:1.00f]];
    [_movieProgressSlider setThumbImage:[UIImage imageNamed:@"progressThumb.png"] forState:UIControlStateNormal];
    [_movieProgressSlider addTarget:self action:@selector(scrubbingDidBegin) forControlEvents:UIControlEventTouchDown];
    [_movieProgressSlider addTarget:self action:@selector(scrubbingDidEnd) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel)];
    
    [_bottomView addSubview:_movieProgressSlider];
    
    
    _TimeLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(_movieProgressSlider.right + 5, 0, timeLableWidth, kToolViewHeight)];
      _TimeLeftLabel.font = FONT(12);
    _TimeLeftLabel.backgroundColor = [UIColor clearColor];
    _TimeLeftLabel.textColor = [UIColor whiteColor];
    _TimeLeftLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_TimeLeftLabel];
    
    _TimePlayedLabel.text = [self convertMovieTimeToText:0];
     _TimeLeftLabel.text = [self convertMovieTimeToText:_totalMovieDuration];
    
    [self addSubview:_bottomView];
    
}
//float（秒）时间转string类型时间
- (NSString*)convertMovieTimeToText:(Float64)time
{
    if (time < 60) {
        return [NSString stringWithFormat:@"00:%02ld",(long)time];
    }else{
        NSInteger minite = time/60;
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)minite,(long)(time - minite*60)];
    }
}


//播放/暂停 click
- (void)playClick:(UIButton*)btn
{

    [self PlayOrStop:!_isPlay];

}
#pragma mark - play
- (void)PlayOrStop:(BOOL)isPlay
{
    if (isPlay) {
        //1.通过实际百分比获取秒数。
        float dragedSeconds = floorf(_totalMovieDuration*_NowProgress);
        CMTime newCMTime = CMTimeMake(dragedSeconds, 1);
        //2.更新电影到实际秒数
        [_player seekToTime:newCMTime];
        //3.play 并且重启timer
        [_player play];
        _isPlay = YES;
        [_playBtn setImage:[self getIcon:@"mediaPreviewPause"] forState:UIControlStateNormal];
        
        self.avTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                        target:self
                                                      selector:@selector(updateUI)
                                                      userInfo:nil
                                                       repeats:YES];
    }else{
        [_player pause];
        [self.avTimer invalidate];
        [_playBtn setImage:[self getIcon:@"mediaPreviewPlay"] forState:UIControlStateNormal];
        _isPlay = NO;
    }
}
- (void)updateUI
{
    CGFloat now = CMTimeGetSeconds(_player.currentItem.currentTime);
    CGFloat duration = CMTimeGetSeconds(_player.currentItem.duration);
    
    //1.根据播放进度与总进度 ，计算出当前百分比
    CGFloat new = now/duration;
    //2.计算当前百分比 与 实际百分比的差值
    CGFloat DValue = new - _NowProgress;
    //3.实际百分比更新到当前百分比
    _NowProgress = new;
    //4.当前百分比加上差值更新实际进度条
    self.movieProgressSlider.value = self.movieProgressSlider.value + DValue;
    
    _TimePlayedLabel.text = [self convertMovieTimeToText:now];
    _TimeLeftLabel.text = [self convertMovieTimeToText:duration ];
    
    if (now >= duration) {

        [self PlayOrStop:NO];
   
        _NowProgress = 0.0;
        _movieProgressSlider.value = 0.0;
        _TimePlayedLabel.text = [self convertMovieTimeToText:0];
 
        
    }
}
//按住滑块
- (void)scrubbingDidBegin
{
    _ProgressBeginToMove = _movieProgressSlider.value;
}
//释放滑块
- (void)scrubbingDidEnd
{
    [self UpdatePlayer];
}
//拖动停止后更新avPlayer
- (void)UpdatePlayer
{
    //1.暂停播放
    [self PlayOrStop:NO];
    //2.存储实际百分比
    _NowProgress = _movieProgressSlider.value;
    //3.重新开始播放
    [self PlayOrStop:YES];
    
}

#pragma mark - 右侧设置View
- (void)createRightSettingsView
{
    
}

- (void)layoutSubviews
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setFrame:(CGRect){0, 0, screenSize} ];
    
    _topView.frame = CGRectMake(0, 0, self.width, kToolViewHeight);
    _backBtn.frame = CGRectMake(0, 0, kToolBtnWith, kToolViewHeight);
    _titleLabel.frame = CGRectMake(0, 0, 150, kToolViewHeight);
    _titleLabel.centerX = _topView.centerX;
    _settingsBtn.frame = CGRectMake(self.width - 70, 0, 70, kToolViewHeight);
    
    _bottomView.frame = CGRectMake(0, self.height - kToolViewHeight, self.width, kToolViewHeight);
    _playBtn.frame = CGRectMake(0, 0, kToolBtnWith, kToolViewHeight);
    CGFloat timeLableWidth = 40;
    _TimePlayedLabel.frame = CGRectMake(_playBtn.right, 0, timeLableWidth, kToolViewHeight);
    _movieProgressSlider.frame =CGRectMake(_TimePlayedLabel.right + 5, 0, _bottomView.width - 175, kToolViewHeight);
    _TimeLeftLabel.frame = CGRectMake(_movieProgressSlider.right + 5, 0, timeLableWidth, kToolViewHeight);
  
}

- (UIImage *)getIcon:(NSString *)name
{
    //拿到图片资源
    NSBundle * imgBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"XHMoviePlayer" ofType:@"bundle"]];
    NSString * imgPath =[[imgBundle resourcePath] stringByAppendingPathComponent:name];
    
    UIImage * image = [UIImage imageNamed:imgPath];
    
    return  image;
}

@end
