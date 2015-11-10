//
//  MusicCell.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"


@interface MusicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *songerName;
// model属性传值
@property (nonatomic,strong) MusicModel *allMusic;

@end
