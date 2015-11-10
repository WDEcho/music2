//
//  PlayingViewController.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 C. All rights reserved.
//

#import "PlayingViewController.h"
#import "PlayerManager.h"
#import "DataManager.h"
#import "LyricManager.h"
#import "LyricModel.h"
@interface PlayingViewController ()<PlayerManagerDelegate,UITableViewDelegate,UITableViewDataSource>

// 记录一下当前的音乐的索引
@property (nonatomic,assign) NSInteger currentIndex;
// 记住当前正在播放的音乐
@property (nonatomic,retain) MusicModel *currentModel;

#pragma mark 控件
@property (weak, nonatomic) IBOutlet UILabel *songName;

@property (weak, nonatomic) IBOutlet UILabel *singerName;

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;

@property (weak, nonatomic) IBOutlet UILabel *playedTime;

@property (weak, nonatomic) IBOutlet UILabel *lastTime;

@property (weak, nonatomic) IBOutlet UISlider *timeSlider;

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;

@property (strong, nonatomic) IBOutlet UITableView *lyricTableView;

@property (strong, nonatomic) IBOutlet UIImageView *muImageView;
@end


@implementation PlayingViewController

static PlayingViewController *playingVC=nil;
// 重用标示符
static NSString *cellindentfier = @"cell";
#pragma mark 控件事件
- (IBAction)prevAction:(UIButton *)sender {
    [sender setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    _currentIndex--;
    // 判断是否是第一首
    if (_currentIndex==-1) {
        // 如果是第一首，就播放最后一首
        _currentIndex=[DataManager shareDataManager].musicArray.count-1;
    }
    [self startPlay];
}

// 暂停或者播放时间
- (IBAction)playOrPauseAction:(UIButton *)sender {
    // 判断是否正在播放
    if ([PlayerManager shareManager].isPlaying) {
        // 如果正在播放，就让播放器暂停，同时改变button的text
        [[PlayerManager shareManager] pause];
        [sender setImage:[UIImage imageNamed:@"playing"] forState:(UIControlStateNormal)];
        //[sender setTitle:@"播放" forState:UIControlStateNormal];
    }else{
        // 暂停状态：开始播放，并改变btn为暂停
        [[PlayerManager shareManager] play];
        [sender setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
       // [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }

    
}

// 下一首
- (IBAction)nextAction:(UIButton *)sender {
    
    [sender setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    
    _currentIndex++;
    // 判断是否是最后一首
    if (_currentIndex==[DataManager shareDataManager].musicArray.count) {
        //如果是最后一首，就播放第一首
        _currentIndex=0;
    }
    [self startPlay];
}

// 改变播放的进度
- (IBAction)changeTime:(UISlider *)sender {
    // 调用接口
    [[PlayerManager shareManager] seekToTime:sender.value];
}
// 音量大小
- (IBAction)changeVolume:(UISlider *)sender {
    
    [[PlayerManager shareManager] seektoVolume:sender.value];
    //[PlayerManager shareManager].sound = sender.value;

}
- (IBAction)low:(UIButton *)sender {
    
     [PlayerManager shareManager].sound = self.volumeSlider.value ++;
}

- (IBAction)up:(UIButton *)sender {
    
   
    [PlayerManager shareManager].sound =self.volumeSlider.value --;
}


+ (instancetype)sharedPlayingPVC{
    // 多线程
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 创建Storyboard
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // 取出需求的ViewController--在main中拿到我们需求的视图控制器
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
        
    });
    return playingVC;
}

- (void)startPlay{
    // 播放音乐
    [[PlayerManager shareManager] playWithUrlString:self.currentModel.mp3Url];
    
    [self buildUI];
}

// 加载UI
- (void)buildUI{
    // self.才会走get方法(才会显示在label上)
    self.singerName.text=self.currentModel.singer;
    self.songName.text=self.currentModel.name;
    
    // 显示图片
    [self.imgPic sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];
    
    //模态视图
    [self.muImageView sd_setImageWithURL:[NSURL URLWithString:self.currentModel.blurPicUrl]];
    
    // 更改button
    [self.playOrPauseBtn setImage:[UIImage imageNamed:@"stop"] forState:(UIControlStateNormal)];
    //[self.playOrPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    
    // 改变进度条的最大值
    self.timeSlider.maximumValue=[self.currentModel.duration intValue]/1000;
    self.timeSlider.value=0;
    
    //更改旋转的角度,图片归位
    self.imgPic.transform = CGAffineTransformMakeRotation(0);
    
  // 赋值歌词
    
    
        [[LyricManager sharedLyricManager] loadLyricWithString:self.currentModel.lyric];
        
        [self.lyricTableView reloadData];
  
   
   

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
 
    // 如果要播放的音乐当前播放的音乐一样，就什么都不干了
    if (_index==_currentIndex) {
        return;
    }
    // 如果不等于,给当前播放的音乐索引赋值
    _currentIndex=_index;
    // 开始播放
    [self startPlay];
}

// 只运行一次
- (void)viewDidLoad {
    [super viewDidLoad];
    // 给定一个初始值
    _currentIndex=-1;
    
    // 获取当前音量
    self.volumeSlider.value = [PlayerManager shareManager].sound;
    // 切圆角
    self.imgPic.layer.masksToBounds=YES;
    self.imgPic.layer.cornerRadius=120;
    
    // 设置自己为播放器的代理，帮播放器干一些事情
    [PlayerManager shareManager].delegate=self;
    //   注册TableView
    [self.lyricTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellindentfier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(UIButton *)sender {
    // 返回界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 代理方法



// 播放器播放结束了，开始播放下一首
-(void)playerDidPlayEnd{
    
    [self nextAction:nil];
}

// 播放过程中参数是秒数
-(void)playingPlayerWithTime:(NSTimeInterval)time{
    // 播放过程中滑竿的自己滚动
    _timeSlider.value = time;
    // 播放时间
    self.playedTime.text = [self stringWithTime:time];
    // 剩余时间
    NSTimeInterval time1 =[self.currentModel.duration integerValue]/1000 -time;
    self.lastTime.text =[self stringWithTime:time1];

    // 每0.1秒转一度
    self.imgPic.transform = CGAffineTransformRotate(self.imgPic.transform, M_PI/180);
    
    // 歌词位置
    
    NSInteger index = [[LyricManager sharedLyricManager]lyricIndexPathWithTime:time];
    
    //  歌词
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

    // 歌词滚动 让tableview选中我们要找的歌词
    
    [self.lyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    
    
}

// 根据时间获取到字符串
-(NSString *)stringWithTime :(NSTimeInterval )time{
    
    NSInteger minutes = time / 60;
    
    NSInteger second = (int)time % 60;
    
    return [NSString stringWithFormat:@"%ld:%ld",minutes,second];
}
#pragma mark getter
// 确保当前播放的音乐是最新的
-(MusicModel *)currentModel{
    // 取到要播放的model(因为要做上一首，下一首，所以要用currentIndex)
    MusicModel *model = [[DataManager shareDataManager] musicModelWithIndex:self.currentIndex];
    return model;
}

#pragma mark UITableViewDataSouse代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  [LyricManager sharedLyricManager].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindentfier forIndexPath:indexPath];

    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.textLabel.highlightedTextColor =[UIColor greenColor];
    
    //遮挡背景颜色的view
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;

    
    //
    
    LyricModel *lyric=[LyricManager sharedLyricManager].allData[indexPath.row];
//    // 设置歌词
    cell.textLabel.text=lyric.lyricContext;
    
  //  cell.textLabel.text =  [[LyricManager sharedLyricManager] lyricStringWithIndexPath:indexPath];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
