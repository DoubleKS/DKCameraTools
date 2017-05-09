//
//  DKMovieRecorder.m
//  视频录制
//
//  Created by doublek on 2017/5/5.
//  Copyright © 2017年 doublek. All rights reserved.
//

#import "DKMovieRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface DKMovieRecorder ()<AVCaptureFileOutputRecordingDelegate>
//输入设备 摄像头
@property(nonatomic,strong)AVCaptureDeviceInput *captureDeviceInputMovie;
//输入设备 麦克风
@property(nonatomic,strong)AVCaptureDeviceInput *captureDeviceInputMicro;
//输出设备,输出视频数据
@property(nonatomic,strong)AVCaptureMovieFileOutput *captureMovieFileOutput;

//拍摄会话
@property(nonatomic,strong)AVCaptureSession *captureSession;

//预览图层
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

//录制完成回调
@property(nonatomic,copy)void(^block)(NSURL *);

@end


@implementation DKMovieRecorder

//创建单例类
+(instancetype)shareInstance {
    
    static DKMovieRecorder *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[DKMovieRecorder alloc]init];
    });
    
    return manager;
}

-(void)beginMovieRocerderWithPreView:(UIView *)preView Completion:(void(^)(NSURL *))block {
    
    //创建设备 有两个摄像头 前置和后置摄像头
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //创建输入设备 视频
    self.captureDeviceInputMovie = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
    
    // 创建麦克风
     AVCaptureDevice *deviceMicro = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    //麦克风
    self.captureDeviceInputMicro = [[AVCaptureDeviceInput alloc]initWithDevice:deviceMicro error:nil];
    
    //创建输出设备
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc]init];
    
    //创建会话设备
    self.captureSession = [[AVCaptureSession alloc]init];
    
    //将输入设备添加到拍摄会话
    if ([self.captureSession canAddInput: self.captureDeviceInputMovie]) {
        [self.captureSession addInput: self.captureDeviceInputMovie];
    }
    
    if ([self.captureSession canAddInput: self.captureDeviceInputMicro]) {
        [self.captureSession addInput: self.captureDeviceInputMicro];
    }
    
    if ([self.captureSession canAddOutput: self.captureMovieFileOutput]) {
        [self.captureSession addOutput: self.captureMovieFileOutput];
    }
    
    //设置预览图层
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    //layer本身不能直接显示
    [preView.layer addSublayer:self.captureVideoPreviewLayer];
    //设置图层的锚点
    self.captureVideoPreviewLayer.bounds = preView.bounds;
    self.captureVideoPreviewLayer.anchorPoint = CGPointMake(0, 0);
    //开始录制
    [self.captureSession startRunning];
    
    //开始录制  url:视频保存的路径  Delegate：代理
    [self.captureMovieFileOutput startRecordingToOutputFileURL:self.movieUrl recordingDelegate:self];
    //保存路径
    self.block = block;
    
    
}

-(void)stopRecorder {
    //开启拍摄会话
    [self.captureSession stopRunning];
    
    //移除预览图层
    [self.captureVideoPreviewLayer removeFromSuperlayer];
    
    //结束录制视频
    [self.captureMovieFileOutput stopRecording];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate代理方法

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    
    NSLog(@"开始录制");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput willFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    NSLog(@"将要结束录制");
    self.block(fileURL);
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    
    NSLog(@"已经结束录制");
    self.block(outputFileURL);
}

@end
