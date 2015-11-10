//
//  MusicListController.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 C. All rights reserved.
//

#import "MusicListController.h"
#import "MusicCell.h"
#import "DataManager.h"
#import "MusicModel.h"
#import "PlayerManager.h"
#import "PlayingViewController.h"

@interface MusicListController ()

@end

@implementation MusicListController

// 代码规范，每一个模块间要空一行
//static NSString * identifier = @"cell";

static NSString * customCell = @"customCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    // 注册(使用xib的时候注册需要使用registerNib)
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicCell" bundle:nil] forCellReuseIdentifier:customCell];
    
    // 刷新数据
    [DataManager shareDataManager].updataUI=^(){
        [self.tableView reloadData];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DataManager shareDataManager].musicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:customCell forIndexPath:indexPath];
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:customCell forIndexPath:indexPath];
    
//    cell.textLabel.text=@"音乐";
    
    // 对model赋值
//    MusicModel *model= [DataManager shareDataManager].musicArray[indexPath.row];
    MusicModel *model=[[DataManager shareDataManager] musicModelWithIndex:indexPath.row];
    
    cell.allMusic = model;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
// cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //找到cell位置
//    MusicCell *cell=[tableView cellForRowAtIndexPath:indexPath];
//    [[PlayerManager shareManager] playWithUrlString:cell.allMusic.mp3Url];
    
    // 拿到模态出来的控制器
    PlayingViewController *playingVC=[PlayingViewController sharedPlayingPVC];
    // 第几首
    playingVC.index=indexPath.row;
    
#pragma mark---跳转界面两种方法
    // 跳转界面两种方法----presentViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#> completion:<#^(void)completion#>等同于showDetailViewController:<#(nonnull UIViewController *)#> sender:<#(nullable id)#>
    
    [self showDetailViewController:playingVC sender:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
