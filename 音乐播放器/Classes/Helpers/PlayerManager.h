//
//  PlayerManager.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 C. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerManagerDelegate <NSObject>


//当播放一首歌结束后，让代理去坐得事情
- (void)playerDidPlayEnd;
// 播放过程中参数是秒数
-(void)playingPlayerWithTime:(NSTimeInterval)time;
@end

@interface PlayerManager : NSObject

// 判断当前是否正在播放
@property (nonatomic,assign) BOOL isPlaying;

+ (instancetype)shareManager;
// 给一个链接，让播放器播放
- (void)playWithUrlString:(NSString *)urlStr;

//  play播放
- (void)play;

//  play暂停
- (void)pause;

// 设置代理
@property (nonatomic,assign) id<PlayerManagerDelegate> delegate;

// 改变进度
- (void)seekToTime:(NSTimeInterval)time;

-(void)seektoVolume:(float)volume;
// 获取系统时间

@property(nonatomic, assign) float sound;
@end
