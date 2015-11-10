//
//  LyricModel.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 C. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel


// 初始化方法
-(instancetype)initWithTime:(NSTimeInterval)time
                     lyricContext:(NSString *)lyricContext{
    if (self = [super init]) {
        _time = time;
        _lyricContext = lyricContext;
    }
    return self;
}

// 便利构造器
+(instancetype)lyricWithTime:(NSTimeInterval)time
                      lyricContext:(NSString *)lyricContext{
    
    return [[LyricModel alloc]initWithTime:time lyricContext:lyricContext];
}
@end
