//
//  PlayerViewController.m
//  高仿映客
//
//  Created by JIAAIR on 16/7/2.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import "PlayerViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "DMHeartFlyView.h"
#import <Accelerate/Accelerate.h>

#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define XJScreenW [UIScreen mainScreen].bounds.size.width
@interface PlayerViewController ()

@property (atomic, retain) id <IJKMediaPlayback> player;

@property (weak, nonatomic) UIView *PlayerView;

@property (atomic, strong) NSURL *url;

@property (nonatomic, assign)int number;

@property (nonatomic, assign)CGFloat heartSize;

@property (nonatomic, strong)UIImageView *dimIamge;

@property (nonatomic, strong) NSArray *fireworksArray;

@property (nonatomic, weak) CALayer *fireworksL;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 播放视频
    [self goPlaying];
    
    // 开启通知
    [self installMovieNotificationObservers];
    
    // 设置加载视图
    [self setupLoadingView];
    
    // 创建按钮
    [self setupBtn];

}

- (void)viewWillAppear:(BOOL)animated {
    if (![self.player isPlaying]) {
        //准备播放
        [self.player prepareToPlay];
    }
}

#pragma mark ---- <设置加载视图>
- (void)setupLoadingView
{
    self.dimIamge = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [_dimIamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@", _imageUrl]] placeholderImage:[UIImage imageNamed:@"default_room"]];
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = _dimIamge.bounds;
    [_dimIamge addSubview:visualEffectView];
    [self.view addSubview:_dimIamge];
    
}

#pragma mark ---- <创建按钮>
- (void)setupBtn {
    
    // 返回
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 64 / 2 - 8, 33, 33);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    backBtn.layer.shadowOffset = CGSizeMake(0, 0);
    backBtn.layer.shadowOpacity = 0.5;
    backBtn.layer.shadowRadius = 1;
    [self.view addSubview:backBtn];
    
    // 暂停
    UIButton * playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(XJScreenW - 33 - 10, 64 / 2 - 8, 33, 33);
    
    if (self.number == 0) {
        [playBtn setImage:[UIImage imageNamed:@"暂停"] forState:(UIControlStateNormal)];
        [playBtn setImage:[UIImage imageNamed:@"开始"] forState:(UIControlStateSelected)];
    }else{
        [playBtn setImage:[UIImage imageNamed:@"开始"] forState:(UIControlStateNormal)];
        [playBtn setImage:[UIImage imageNamed:@"暂停"] forState:(UIControlStateSelected)];
    }
    
    [playBtn addTarget:self action:@selector(play_btn:) forControlEvents:(UIControlEventTouchUpInside)];
    playBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    playBtn.layer.shadowOffset = CGSizeMake(0, 0);
    playBtn.layer.shadowOpacity = 0.5;
    playBtn.layer.shadowRadius = 1;
    [self.view addSubview:playBtn];
    
    // 点赞
    UIButton * heartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    heartBtn.frame = CGRectMake(36, XJScreenH - 36 - 10, 36, 36);
    [heartBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    [heartBtn addTarget:self action:@selector(showTheLove:) forControlEvents:UIControlEventTouchUpInside];
    heartBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    heartBtn.layer.shadowOffset = CGSizeMake(0, 0);
    heartBtn.layer.shadowOpacity = 0.5;
    heartBtn.layer.shadowRadius = 1;
    heartBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:heartBtn];
    
    //礼物
    UIButton *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    giftBtn.frame = CGRectMake(XJScreenW - 50, XJScreenH - 36 - 10, 36, 36);
    [giftBtn setImage:[UIImage imageNamed:@"gift"] forState:UIControlStateNormal];
    [giftBtn addTarget:self action:@selector(showMyPorsche918) forControlEvents:UIControlEventTouchUpInside];
    giftBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    giftBtn.layer.shadowOffset = CGSizeMake(0, 0);
    giftBtn.layer.shadowOpacity = 0.5;
    giftBtn.layer.shadowRadius = 1;
    [self.view addSubview:giftBtn];
    
    
}

- (void)goPlaying {
    
    //获取url
    self.url = [NSURL URLWithString:_liveUrl];
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:nil];
    
    UIView *playerview = [self.player view];
    UIView *displayView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    self.PlayerView = displayView;
    [self.view addSubview:self.PlayerView];
    
    // 自动调整自己的宽度和高度
    playerview.frame = self.PlayerView.bounds;
    playerview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.PlayerView insertSubview:playerview atIndex:1];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];

}

// 返回
- (void)goBack
{
    // 停播
    [self.player shutdown];
    
    [self.navigationController popViewControllerAnimated:true];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

// 暂停开始
- (void)play_btn:(UIButton *)sender {
    
    sender.selected =! sender.selected;
    if (![self.player isPlaying]) {
        // 播放
        [self.player play];
    }else{
        // 暂停
        [self.player pause];
    }
}

// 点赞
-(void)showTheLove:(UIButton *)sender{
    
    _heartSize = 36;
    
    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(_heartSize + _heartSize/2.0, self.view.bounds.size.height - _heartSize/2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self.view];
    
    // button点击动画
    CAKeyframeAnimation *btnAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    btnAnimation.values = @[@(1.0),@(0.7),@(0.5),@(0.3),@(0.5),@(0.7),@(1.0), @(1.2), @(1.4), @(1.2), @(1.0)];
    btnAnimation.keyTimes = @[@(0.0),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    btnAnimation.calculationMode = kCAAnimationLinear;
    btnAnimation.duration = 0.3;
    [sender.layer addAnimation:btnAnimation forKey:@"SHOW"];
    
}
//送礼物
- (void)showMyPorsche918 {
    CGFloat durTime = 3.0;
    
    UIImageView *porsche918 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"porsche"]];
    
    //设置汽车初始位置
    porsche918.frame = CGRectMake(0, 0, 0, 0);
    [self.view addSubview:porsche918];
    
    //给汽车添加动画
    [UIView animateWithDuration:durTime animations:^{
        
        porsche918.frame = CGRectMake(XJScreenW * 0.5 - 100, XJScreenH * 0.5 - 100 * 0.5, 240, 120);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //
        [UIView animateWithDuration:0.5 animations:^{
            porsche918.alpha = 0;
        } completion:^(BOOL finished) {
            [porsche918 removeFromSuperview];
        }];
    });
 
    
    
    //烟花
    
    CALayer *fireworksL = [CALayer layer];
    fireworksL.frame = CGRectMake((XJScreenW - 250) * 0.5, 100, 250, 50);
    fireworksL.contents = (id)[UIImage imageNamed:@"gift_fireworks_0"].CGImage;
    [self.view.layer addSublayer:fireworksL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            //没找到设置透明度的方法，有创意可以自己写
//            fireworksL.alpha = 0;
        } completion:^(BOOL finished) {
            [fireworksL removeFromSuperlayer];
        }];
    });
    _fireworksL = fireworksL;
    
    

    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (int i = 1; i < 3; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gift_fireworks_%d",i]];
        [tempArray addObject:image];
    }
    _fireworksArray = tempArray;
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

static int _fishIndex = 0;

- (void)update {
    
    _fishIndex++;
    
    if (_fishIndex > 1) {
        _fishIndex = 0;
    }
    UIImage *image = self.fireworksArray[_fishIndex];
    _fireworksL.contents = (id)image.CGImage;
}



#pragma Install Notifiacation
- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
}

- (void)removeMovieNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}

#pragma Selector func

- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    
    _dimIamge.hidden = YES;
    
    switch (_player.playbackState) {
            
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}




@end
