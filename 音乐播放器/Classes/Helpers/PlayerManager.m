//
//  PlayerManager.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 C. All rights reserved.
//

#import "PlayerManager.h"
#import "AVFoundation/AVFoundation.h"
#import "JDStatusBarNotification.h"



// 声明属性
@interface PlayerManager()
// 播放器--全局唯一,单例---如果有两个player的话，就会同时播放两个音乐
@property (nonatomic,strong) AVPlayer *player;
// 播放时间
@property (nonatomic,retain) NSTimer *timer;

@end

@implementation PlayerManager

static PlayerManager *manager=nil;
//单例方法
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[PlayerManager new];
    });
    return manager;
}

-(instancetype)init{
    if (self=[super init]) {
        // 添加通知中心，当self发出AVPlayerItemDidPlayToEndTimeNotification时触发PlayerDidPlayEnd事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlayerDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)PlayerDidPlayEnd:(NSNotification *)sender{
    // 判断代理是否走了这个方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidPlayEnd)]) {
        // 接受到item播放结束后，让代理去干一些事情，代理会怎么干，播放器不需要知道
        [self.delegate playerDidPlayEnd];
        
        [JDStatusBarNotification showWithStatus:@"下一首" dismissAfter:2 styleName:@"JDStatusBarStyleSuccess"];
    }
}

#pragma mark 对外方法
- (void)playWithUrlString:(NSString *)urlStr{
    
    if (self.player.currentItem) {
        // 如果是切换歌曲，要先把当前歌曲的观察者移除
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    // 创建一个item
    AVPlayerItem *item=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    
    // 给item添加一个观察者
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    // 替换当前正在播放的音乐
    [self.player replaceCurrentItemWithPlayerItem:item];
    
}

//  play播放
- (void)play{
    // 如果正在播放，就不播放了，直接返回。
//    if (_isPlaying) {
//        return;
//    }
    [self.player play];
    // 开始播放后标记一下
    _isPlaying=YES;
    
    // 判断定时器存在
//    if (self.timer != nil) {
//        return;
//    }

    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(playingWithSeconds) userInfo:nil repeats:YES];
}

- (void)playingWithSeconds{
    //NSLog(@"播放过程中");
    
    if (self.delegate !=nil &&[self.delegate respondsToSelector:@selector(playingPlayerWithTime:)]) {
        
        //  计算当前秒数
        NSTimeInterval time = self.player.currentTime.value/self.player.currentTime.timescale;
        //
        [self.delegate playingPlayerWithTime:time];
    }
    

    
    
    //NSLog(@"%lld",self.player.currentTime.value/self.player.currentTime.timescale);
}

//  play暂停
- (void)pause{
    
    [self.player pause];
    // 暂停播放后设为NO
    _isPlaying=NO;
    // 移除计时器
    [self.timer invalidate];
}

// 改变播放时间进度
- (void)seekToTime:(NSTimeInterval)time{
    // 先暂停
    [self pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) {
            // 拖拽成功后播放
            [self play];
        }
    }];
}
// 获取声音
-(void)seektoVolume:(float)volume{
   
    self.player.volume = volume;
  
}
#pragma mark--lazy load
-(AVPlayer *)player{
    if (!_player) {
        _player=[AVPlayer new];
    }
    return _player;
}

#pragma mark --观察响应
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"keyPath=%@--change=%@",keyPath,change);
    AVPlayerItemStatus status=[change[@"new"] integerValue];
    
    switch (status) {
        case AVPlayerItemStatusFailed:
            NSLog(@"加载失败");
            break;
        case AVPlayerItemStatusUnknown:
            NSLog(@"资源不对");
            break;
        case AVPlayerItemStatusReadyToPlay:
            NSLog(@"准备好了，可以播放");
            // 开始播放(资源正确，加载完成才开始播放)
            // 暂停时将time销毁，播放时创建
            [self pause];
            [self play];
            break;
        default:
            break;
    }
}
// 修改声音
-(void)setSound:(float)sound{
    
    self.player.volume = sound;
}
// 获取系统当前默认声音
-(float)sound{
    
    return self.player.volume;
}
@end
