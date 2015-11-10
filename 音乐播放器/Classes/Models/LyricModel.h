//
//  LyricModel.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject

// 歌词属性（指的是一句歌词的时间和内容）（ 属性的属性）
@property(nonatomic, assign) NSTimeInterval time;
@property(nonatomic, copy) NSString *lyricContext;

// 初始化方法
-(instancetype)initWithTime:(NSTimeInterval)time
                     lyricContext:(NSString *)lyricContext;

// 便利构造器
+(instancetype)lyricWithTime:(NSTimeInterval)time
                      lyricContext:(NSString *)lyricContext;


@end
