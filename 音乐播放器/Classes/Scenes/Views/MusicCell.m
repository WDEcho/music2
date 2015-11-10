//
//  MusicCell.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 C. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell

// model赋值--set方法
-(void)setAllMusic:(MusicModel *)allMusic{
    // 选中cell进行操作时，需要对allMusic（model层）赋值
    _allMusic=allMusic;
    
    _songName.text=allMusic.name;
    _songerName.text=allMusic.singer;
    
    // 在pch里面导入了SDWebImage头文件
    [_imgView sd_setImageWithURL:[NSURL URLWithString:allMusic.picUrl] placeholderImage:[UIImage imageNamed:@"6"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
