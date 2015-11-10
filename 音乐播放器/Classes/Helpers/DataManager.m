//
//  DataManager.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 C. All rights reserved.
//

#import "DataManager.h"


@implementation DataManager

static DataManager *manager=nil;

+ (DataManager *)shareDataManager{
    //gcd 提供的一种单例方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[DataManager new];
        [manager requestData];
    });
    return manager;
}

// 数据解析
- (void)requestData{
    // 在子线程中请求数据，防止假死
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 构造url-- 数据连接
        NSURL *url= [NSURL URLWithString:kMusicListURL];
        //请求数据
        NSArray *dataArray=[NSArray arrayWithContentsOfURL:url];
        for (int i=0; i<dataArray.count; i++) {
//            NSLog(@"%@",dataArray[i]);
            MusicModel *model=[MusicModel new];
            [model setValuesForKeysWithDictionary:dataArray[i]];
            [_musicArray addObject:model];
//            NSLog(@"-----%@-----",_musicArray);
        }
        // 返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // 判断block是否为空
            if (!self.updataUI) {
                NSLog(@"block没有数据");
            }else{
                // block实现
                self.updataUI();
            }
        });
    });
}
  
#pragma mark--lazy load
// 懒加载
-(NSMutableArray *)musicArray{
    if (!_musicArray) {
        // 使用之前，需要初始化
        _musicArray=[NSMutableArray arrayWithCapacity:5];
    }
    return _musicArray;
}

- (MusicModel *)musicModelWithIndex:(NSInteger)index{
    // 返回数组
    return self.musicArray[index];
}

@end
