//
//  ViewController.m
//  XHMoviePlayerExample
//
//  Created by wangxiangheng on 2017/5/15.
//  Copyright © 2017年 CoderXH. All rights reserved.
//

#import "ViewController.h"
#import "MoviePlayerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * ceshi = [UIButton buttonWithType:UIButtonTypeCustom];
    ceshi.frame = CGRectMake(150, 250, 100, 30);
    [ceshi setTitle:@"播放器测试" forState:UIControlStateNormal];
    [ceshi addTarget:self action:@selector(playTest) forControlEvents:UIControlEventTouchUpInside];
    [ceshi setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:ceshi];
    
    
}


- (void)playTest
{
    
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"Google Search App Spot 02" withExtension:@"mp4"];
    MoviePlayerView * mPlayer = [[MoviePlayerView alloc]initWithUrl:url];
    [mPlayer play];
    
    
    
}



@end
