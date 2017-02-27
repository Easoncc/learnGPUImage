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


@interface CCFilterModel : NSObject

@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) id filter;

- (instancetype)initWithName:(NSString *)name filter:(id)filter;

@end

@implementation CCFilterModel

- (instancetype)initWithName:(NSString *)name filter:(id)filter{
    self = [super init];
    if (self) {
        
        self.name = name;
        self.filter = filter;
        
    }
    return self;
}

@end


@interface CCRecorderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) GPUImageVideoCamera *videoRecorder;

@property (nonatomic ,strong) GPUImageView *videoView;
@property (nonatomic ,strong) UIButton *backButton;
@property (nonatomic ,strong) UIButton *rotateButton;
@property (nonatomic ,strong) UICollectionView *filtersCollectionView;
@property (nonatomic ,strong) NSMutableArray *filtersArray;
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
    [self initFilters];
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
    
//    GPUImageBeautifyFilter * filter = [GPUImageBeautifyFilter new];
//    [self.videoRecorder addTarget:filter];
//    [filter addTarget:self.videoView];
    
    [self.videoRecorder addTarget:self.videoView];
    
    [self.videoRecorder startCameraCapture];
    
}

- (void)initFilters{
    
    _filtersArray = [NSMutableArray new];
    
    //无
    CCFilterModel *filter = [[CCFilterModel alloc] initWithName:@"(无)" filter:nil];
    [_filtersArray addObject:filter];
    
    //美颜
    GPUImageBeautifyFilter * beautifyFilter = [GPUImageBeautifyFilter new];
    CCFilterModel *filter0 = [[CCFilterModel alloc] initWithName:@"美颜" filter:beautifyFilter];
    [_filtersArray addObject:filter0];
    
    //高亮
    GPUImageBrightnessFilter * brightnessFilter = [GPUImageBrightnessFilter new];
    brightnessFilter.brightness = 0.15;
    CCFilterModel *filter1 = [[CCFilterModel alloc] initWithName:@"高亮" filter:brightnessFilter];
    [_filtersArray addObject:filter1];
    
    //曝光
    GPUImageExposureFilter *exposureFilter = [GPUImageExposureFilter new];
    exposureFilter.exposure = 2;
    CCFilterModel *filter2 = [[CCFilterModel alloc] initWithName:@"曝光" filter:exposureFilter];
    [_filtersArray addObject:filter2];

    //对比度
    GPUImageContrastFilter *contrastFilter = [GPUImageContrastFilter new];
    contrastFilter.contrast = 2;
    CCFilterModel *filter3 = [[CCFilterModel alloc] initWithName:@"对比度" filter:contrastFilter];
    [_filtersArray addObject:filter3];
    
    //饱和度
    GPUImageSaturationFilter *SaturationFilter = [GPUImageSaturationFilter new];
    SaturationFilter.saturation = 0.6;
    CCFilterModel *filter4 = [[CCFilterModel alloc] initWithName:@"饱和度" filter:SaturationFilter];
    [_filtersArray addObject:filter4];
    
    //伽马线
    GPUImageGammaFilter *GammaFilter = [GPUImageGammaFilter new];
    GammaFilter.gamma = 2;
    CCFilterModel *filter5 = [[CCFilterModel alloc] initWithName:@"伽马线" filter:GammaFilter];
    [_filtersArray addObject:filter5];
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
        layout.itemSize = CGSizeMake(50, 50);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //创建collectionView 通过一个布局策略layout来创建
        UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 70) collectionViewLayout:layout];
        //代理设置
        collect.backgroundColor = [UIColor clearColor];
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
    
    CCFilterModel *model = _filtersArray[indexPath.row];
    
    if ([model.name isEqualToString:@"(无)"]) {
        
        cell.iconImageView.image = [UIImage imageNamed:@"2"];
    }else{
        
        GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"2"]];
        [pic addTarget:model.filter];
        [pic processImage];
        [model.filter useNextFrameForImageCapture];
        cell.iconImageView.image = [model.filter imageFromCurrentFramebuffer];
    }
    
    cell.titlesLabel.text = model.name;
    
    return cell;
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _filtersArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CCFilterModel *model = _filtersArray[indexPath.row];
    
    [self.videoRecorder removeAllTargets];
    
    if ([model.name isEqualToString:@"(无)"]) {
        
        [self.videoRecorder addTarget:self.videoView];
        
    }else{
        
        [self.videoRecorder addTarget:model.filter];
        [model.filter removeAllTargets];
        [model.filter addTarget:self.videoView];

    }
   
}








@end
