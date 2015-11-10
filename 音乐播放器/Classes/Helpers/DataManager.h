//
//  DataManager.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

// 定义block
typedef void (^UpdataUI)();

@interface DataManager : NSObject
@property (nonatomic,strong) NSMutableArray *musicArray;
/**
 *  单例方法
 *
 *  @return 单例
 */
+ (DataManager *)shareDataManager;
// command+control+⬆️/⬇️切换.h，.m

// 声明block
@property (nonatomic,copy) UpdataUI updataUI;

// 根据cell的索引返回一个model
- (MusicModel *)musicModelWithIndex:(NSInteger)index;

@end
