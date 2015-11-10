//
//  PlayingViewController.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 C. All rights reserved.
//

// 将ViewController写成单例使用，因为它一直在后台运行。

#import <UIKit/UIKit.h>

@interface PlayingViewController : UIViewController

//当前播放第几首
@property (nonatomic,assign) NSInteger index;

+ (instancetype)sharedPlayingPVC;

@end
