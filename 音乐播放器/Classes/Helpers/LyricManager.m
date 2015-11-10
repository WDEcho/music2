//
//  LyricManager.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 C. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"
#import "PlayerManager.h"
@interface LyricManager ()
{
    NSInteger _index;
}


@property (nonatomic, strong) NSMutableArray *allDataArray;

@end


@implementation LyricManager


//
static LyricManager *lyricManager = nil;
+(LyricManager *)sharedLyricManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        lyricManager = [[LyricManager alloc]init];
    });
    return lyricManager;
}

//  解析歌词
-(void)loadLyricWithString:(NSString *)lyricStr{
    
    // 清空数组
    
    [self.allDataArray removeAllObjects];
    
    if ([lyricStr isEqualToString:@""]) {
        
        LyricModel *model = [[LyricModel alloc]initWithTime:0 lyricContext:@"没有找到换个词"];
        [self.allDataArray addObject:model];
    }else{
    
   
    // 1.分行
    NSArray *lyricStringArray = [lyricStr componentsSeparatedByString:@"\n"];
    
    for (NSString *itemStr in lyricStringArray) {
        NSLog(@"%@",itemStr);
        
        NSArray *timeAndLyricStr = [itemStr componentsSeparatedByString:@"]"];
        
        // 判断长度（有的歌词为空要结束本次循环）
        if ([timeAndLyricStr.firstObject length]==0) {
            
            continue;
        }
        
        if (timeAndLyricStr.count !=2) {
            continue;
        }
        //去掉时间左边的 "]"
        // 获取时间
        NSString *time = [timeAndLyricStr [0] substringFromIndex:1];
       // NSString *timeStr = [timeAndLyricStr.firstObject substringFromIndex:1];
        
      //截取时间
        
        NSArray *timeArray  =[time componentsSeparatedByString:@":"];

        // 获取分钟数
        NSInteger minute = [timeArray [0]integerValue];
        //NSString *minutes = timeArray.firstObject;
        //  获取秒数
        double second = [timeArray [1] doubleValue];
        //NSString *second =timeArray.lastObject;
        
    
        // 封装成model类型
        LyricModel *lyricmodel = [[LyricModel alloc]initWithTime:(minute *60 +second) lyricContext:timeAndLyricStr[1]];
        
        //添加到数组
        [self.allDataArray addObject:lyricmodel];
        
        
    }
        
    }
    
}

// 数组长度

-(NSInteger)count{

    return self.allDataArray.count;
    
    
}
-(NSArray *)allData{
    
    // return self.allDataArray;
     return [self.allDataArray copy];
}
    
    


// 懒加载
-(NSMutableArray *)allDataArray{
    
    if (!_allDataArray) {
        self.allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}


-(NSString *)lyricStringWithIndexPath:(NSIndexPath *)indexPath{
    
    LyricModel *lyric = self.allDataArray[indexPath.row];
    return lyric.lyricContext;
}


// 根据时间获取下标的歌词

-(NSInteger)lyricIndexPathWithTime:(NSTimeInterval)time{
    
    // 遍历数组找到还没有播放的那一句歌词
    for (int i = 0; i < self.allDataArray.count; i ++) {
        
        LyricModel*lyric =self.allDataArray[i];
        
        if (time < lyric.time) {
            // 注意如果是零个元素，而且元素的时间比要播放的时间大，i-1，就会小雨0.这样tableview就会crash
            _index =  (i -1 >0)?(i - 1) :0;
             // 找到符合条件的，结束循环
            break;
        }
    }
    return _index;
    
}

@end
