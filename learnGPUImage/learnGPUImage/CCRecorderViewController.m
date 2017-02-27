//
//  CCRecorderViewController.m
//  learnGPUImage
//
//  Created by chenchao on 2017/2/27.
//  Copyright © 2017年 chenchao. All rights reserved.
//

#import "CCRecorderViewController.h"
#import "GPUImageBeautifyFilter.h"
#import <GPUImage.h>
#import "CCFiltersCollectionViewCell.h"

@interface CCRecorderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) GPUImageVideoCamera *videoRecorder;

@property (nonatomic ,strong) GPUImageView *videoView;
@property (nonatomic ,strong) UIButton *backButton;
@property (nonatomic ,strong) UIButton *rotateButton;
@property (nonatomic ,strong) UICollectionView *filtersCollectionView;

@end

@implementation CCRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.rotateButton];
    [self.view addSubview:self.filtersCollectionView];
    
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
    
    GPUImageBeautifyFilter * filter = [GPUImageBeautifyFilter new];
    [self.videoRecorder addTarget:filter];
    [filter addTarget:self.videoView];
    
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

- (UIButton *)rotateButton{
    
    if (!_rotateButton) {
        
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(self.view.frame.size.width - 50 - 10, 20, 50, 50);
        [button setImage:[UIImage imageNamed:@"rotate"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rotateButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _rotateButton = button;
        
    }
    return _rotateButton;
}

- (UICollectionView *)filtersCollectionView{
    
    if (!_filtersCollectionView) {
        
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        layout.itemSize = CGSizeMake(50, 50);
//        layout.minimumLineSpacing = 10;
//        layout.minimumInteritemSpacing = 10;
        
        //创建collectionView 通过一个布局策略layout来创建
        UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 70) collectionViewLayout:layout];
        collect.backgroundColor = [UIColor redColor];
        //代理设置
//        collect.backgroundColor = [UIColor clearColor];
        collect.delegate = self;
        collect.dataSource = self;
        collect.showsHorizontalScrollIndicator = NO;
        //注册item类型 这里使用系统的类型
        [collect registerClass:[CCFiltersCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        _filtersCollectionView = collect;

        
    }
    return _filtersCollectionView;
}

#pragma mark - action

- (void)backButtonClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rotateButtonClick{
    [self.videoRecorder rotateCamera];
}

#pragma mark - uicollectionDelegate

//这是正确的方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CCFiltersCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"1"];
    
    return cell;
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
}








@end
