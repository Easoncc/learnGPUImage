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
#import "GPUImageBeautifyFilter.h"

@interface CCOutputMovieViewController ()

@property (nonatomic ,strong) GPUImageVideoCamera *videoRecorder;
@property (nonatomic ,strong) GPUImageView *videoView;

@property (nonatomic ,strong) UIButton *backButton;

@property (nonatomic ,strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic ,strong) UIButton *recorderButton;
@property (nonatomic ,assign) BOOL isRecordering;
@property (nonatomic ,strong) GPUImageBeautifyFilter *beautifyFilter;
@property (nonatomic ,strong) NSMutableArray *urlArray;
@property (nonatomic ,strong) NSString *url;

@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) float allTime;
@property (nonatomic ,strong) UILabel *timeLabel;

@end

@implementation CCOutputMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.urlArray = [NSMutableArray new];
    
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.recorderButton];
    [self.view addSubview:self.timeLabel];
    
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
    self.url = pathToMovie;
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720, 1280)];
    self.movieWriter.shouldPassthroughAudio = YES;
    self.movieWriter.encodingLiveVideo = YES;
    self.videoRecorder.audioEncodingTarget = self.movieWriter;
    //美颜
    _beautifyFilter = [GPUImageBeautifyFilter new];

    
    [self.videoRecorder addTarget:_beautifyFilter];
    [_beautifyFilter addTarget:self.videoView];
    
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
        
        button.frame = CGRectMake(self.view.frame.size.width/2-80/2, self.view.frame.size.height*0.8, 80, 80);
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 40;
        button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [button setTitle:@"开始" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(recorderButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _recorderButton = button;
        
    }
    
    return _recorderButton;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, self.recorderButton.frame.origin.y-40, self.view.frame.size.width, 20);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        _timeLabel = label;
        
    }
    return  _timeLabel;
}

#pragma mark - action

- (void)backButtonClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)recorderButtonClick{
    
    if (_isRecordering) {
        
        [self.urlArray addObject:self.url];
        [self stopTimer];
        [_beautifyFilter removeTarget:self.movieWriter];
        [self.movieWriter finishRecording];
        _isRecordering = NO;
        [self.recorderButton setTitle:@"开始" forState:UIControlStateNormal];
        
        long time = [[NSDate date] timeIntervalSince1970];
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Movie_%ld.m4v",time]];
        unlink([pathToMovie UTF8String]);
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        self.url = pathToMovie;
        
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
        
        [_beautifyFilter addTarget:self.movieWriter];
        [self startTimer];
        [self.movieWriter startRecording];
        _isRecordering = YES;
        
        [self.recorderButton setTitle:@"停止" forState:UIControlStateNormal];
    }
    
}

- (void)startTimer{
    _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
   
}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)timeAction{
    self.allTime += 0.1;
    self.timeLabel.text = [NSString stringWithFormat:@"%.1f",self.allTime];
}

@end
