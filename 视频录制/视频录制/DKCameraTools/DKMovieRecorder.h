//
//  DKMovieRecorder.h
//  视频录制
//
//  Created by doublek on 2017/5/5.
//  Copyright © 2017年 doublek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DKMovieRecorder : NSObject

//保存图片的路径
@property(nonatomic,strong)NSURL *movieUrl;

+(instancetype)shareInstance;

-(void)beginMovieRocerderWithPreView:(UIView *)preView Completion:(void(^)(NSURL *))block;

-(void)stopRecorder ;


@end
