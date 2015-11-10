//
//  LyricManager.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricManager : NSObject

// 对外接口
@property (nonatomic, strong)  NSArray *allData;

//数组长度
@property(nonatomic, assign) NSInteger count;
//单例
+(LyricManager *)sharedLyricManager;


// 解析歌词

// 拆分加载歌词，根据字符串

-(void)loadLyricWithString:(NSString *)lyricStr;

// 下标

-(NSString *)lyricStringWithIndexPath:(NSIndexPath *)indexPath;

// 根据时间获取下标

-(NSInteger)lyricIndexPathWithTime:(NSTimeInterval)time;

@end
