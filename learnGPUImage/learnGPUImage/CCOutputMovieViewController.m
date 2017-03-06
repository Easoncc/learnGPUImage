//
//  CCOutputMovieViewController.m
//  learnGPUImage
//
//  Created by chenchao on 2017/3/1.
//  Copyright © 2017年 chenchao. All rights reserved.
//

#import "CCOutputMovieViewController.h"
#import <GPUImage.h>
#import <AssetsLibrary/ALAssetsLibrary.h>


@interface CCOutputMovieViewController ()

@property (nonatomic ,strong) GPUImageVideoCamera *videoRecorder;
@property (nonatomic ,strong) GPUImageView *videoView;

@property (nonatomic ,strong) UIButton *backButton;

@property (nonatomic ,strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic ,strong) UIButton *recorderButton;
@property (nonatomic ,assign) BOOL isRecordering;

@end

@implementation CCOutputMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.recorderButton];
    
    [self initRecorder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - common

- (void)initRecorder{
    
    self.videoRecorder = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.videoRecorder.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoRecorder.horizontallyMirrorFrontFacingCamera = YES;
    
    long time = [[NSDate date] timeIntervalSince1970];
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Movie_%ld.m4v",time]];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720, 1280)];
    self.movieWriter.shouldPassthroughAudio = YES;
    self.movieWriter.encodingLiveVideo = YES;
    self.videoRecorder.audioEncodingTarget = self.movieWriter;

    [self.videoRecorder addTarget:self.videoView];
    
    [self.videoRecorder startCameraCapture];

}

#pragma mark - view

- (GPUImageView *)videoView{
    
    if (!_videoView) {
        
        GPUImageView *view = [[GPUImageView alloc] initWithFrame:self.view.frame];
        
        _videoView = view;
        
    }
    return _videoView;
}


- (UIButton *)backButton{
    
    if (!_backButton) {
        
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(10, 20, 50, 50);
        [button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _backButton = button;
        
    }
    
    return _backButton;
}

- (UIButton *)recorderButton{
    
    if (!_recorderButton) {
        
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(20, 300, 50, 50);
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        button.layer.cornerRadius = 25;
        button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [button addTarget:self action:@selector(recorderButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _recorderButton = button;
        
    }
    
    return _recorderButton;
}

#pragma mark - action

- (void)backButtonClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)recorderButtonClick{
    
    if (_isRecordering) {
        
        [self.videoRecorder removeTarget:self.movieWriter];
        [self.movieWriter finishRecording];
        _isRecordering = NO;
        [self.recorderButton setTitle:@"停止" forState:UIControlStateNormal];
        
        long time = [[NSDate date] timeIntervalSince1970];
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Movie_%ld.m4v",time]];
        unlink([pathToMovie UTF8String]);
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        
        self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720, 1280)];
        self.movieWriter.shouldPassthroughAudio = YES;
        self.movieWriter.encodingLiveVideo = YES;
        self.videoRecorder.audioEncodingTarget = self.movieWriter;
        
//
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
//        {
//            [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
//             {
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     
//                     if (error) {
//                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil
//                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                         [alert show];
//                     } else {
//                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功" message:nil
//                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                         [alert show];
//                     }
//                 });
//             }];
//        }
//        else {
//            NSLog(@"error mssg)");
//        }
        
    }else{
        
        [self.videoRecorder addTarget:self.movieWriter];
        
        [self.movieWriter startRecording];
        _isRecordering = YES;
        
        [self.recorderButton setTitle:@"录制中" forState:UIControlStateNormal];
    }
    
}

@end
