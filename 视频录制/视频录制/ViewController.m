//
//  ViewController.m
//  视频录制
//
//  Created by doublek on 2017/5/5.
//  Copyright © 2017年 doublek. All rights reserved.
//

#import "ViewController.h"
#import "DKMovieRecorder.h"
#import <VideoToolbox/VideoToolbox.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
//管理系统多媒体资源
#import <AssetsLibrary/AssetsLibrary.h>
@interface ViewController ()

@property(nonatomic,strong)DKMovieRecorder *recorder;

@property(nonatomic,strong)NSURL *url;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}
#pragma mark - 开始录制
- (IBAction)starRecorderMovie:(UIButton *)sender {
    
    self.recorder = [DKMovieRecorder shareInstance];
    
   self.recorder.movieUrl = [[NSURL fileURLWithPath:NSHomeDirectory()] URLByAppendingPathComponent:@"Documents/123.mp4"];
    
//    //创建保存路径
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    //拼接路径
//    NSString *path1 = [path stringByAppendingPathComponent:@"123.mp4"];
//    
//    self.recorder.movieUrl = [NSURL URLWithString:path1];
    
    [self.recorder beginMovieRocerderWithPreView:self.view Completion:^(NSURL *url) {
        //给回调过来的url赋值
        self.url = url;
    }];
 
}
#pragma mark - 当点击屏幕的时候就停止拍摄
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.recorder stopRecorder];
}

#pragma mark - 播放
- (IBAction)playRecorderMovie:(UIButton *)sender {
    
    AVPlayerViewController *player = [[AVPlayerViewController alloc]init];
    
    player.player = [[AVPlayer alloc]initWithURL:self.url];
    
    //跳转界面
    [self presentViewController:player animated:YES completion:nil];
}

#pragma mark - 保存到相册
- (IBAction)saveTophoto:(UIButton *)sender {
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    
    [library writeVideoAtPathToSavedPhotosAlbum:self.url completionBlock:^(NSURL *assetURL, NSError *error) {
        
        if (error== nil) {
            
            NSLog(@"保存成功");
        }
    }];
}


@end
