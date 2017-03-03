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
@property (nonatomic ,strong) GPUImageDissolveBlendFilter *dissolveFilter;
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
    
    _dissolveFilter = [[GPUImageDissolveBlendFilter alloc] init];
    [_dissolveFilter setMix:0.5];
    
    UIImage *image = [UIImage imageNamed:@"3"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UIView *subView = [[UIView alloc] initWithFrame:self.view.frame];
    subView.backgroundColor = [UIColor clearColor];
    imageView.center = CGPointMake(subView.bounds.size.width / 2, 30);
    [subView addSubview:imageView];
    
    GPUImageUIElement *uielement = [[GPUImageUIElement alloc] initWithView:subView];
    
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720, 1280)];
    self.movieWriter.shouldPassthroughAudio = YES;
    self.movieWriter.encodingLiveVideo = YES;
    self.videoRecorder.audioEncodingTarget = self.movieWriter;
    
    GPUImageFilter* progressFilter = [[GPUImageFilter alloc] init];
    
    [self.videoRecorder addTarget:progressFilter];
    [progressFilter addTarget:_dissolveFilter];
    [uielement addTarget:_dissolveFilter];
    [_dissolveFilter addTarget:self.videoView];
//    [_dissolveFilter addTarget:self.movieWriter];
    
    [self.videoRecorder startCameraCapture];
    
    
    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        CGRect frame = imageView.frame;
//        frame.origin.x += 1;
        frame.origin.y += 1;
        imageView.frame = frame;
        [uielement updateWithTimestamp:time];
    }];
    
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
        
        [_dissolveFilter removeAllTargets];
        [self.movieWriter finishRecording];
        _isRecordering = NO;
        [self.recorderButton setTitle:@"停止" forState:UIControlStateNormal];
        
//        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
//        unlink([pathToMovie UTF8String]);
//        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
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
        
        
        [_dissolveFilter addTarget:self.movieWriter];
        
        [self.movieWriter startRecording];
        _isRecordering = YES;
        
        [self.recorderButton setTitle:@"录制中" forState:UIControlStateNormal];
    }
    
}

@end
