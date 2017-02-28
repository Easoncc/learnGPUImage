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
    
    //反色
    GPUImageColorInvertFilter *ColorInvertFilter = [GPUImageColorInvertFilter new];
    CCFilterModel *filter6 = [[CCFilterModel alloc] initWithName:@"反色" filter:ColorInvertFilter];
    [_filtersArray addObject:filter6];
    
    //褐色（怀旧）
    GPUImageSepiaFilter *SepiaFilter = [GPUImageSepiaFilter new];
    CCFilterModel *filter7 = [[CCFilterModel alloc] initWithName:@"怀旧" filter:SepiaFilter];
    [_filtersArray addObject:filter7];
    
    //色阶
    GPUImageLevelsFilter *LevelsFilter = [GPUImageLevelsFilter new];
    [LevelsFilter setMin:0.6 gamma:0.3 max:0.7 minOut:0.2 maxOut:0.3];
    CCFilterModel *filter8 = [[CCFilterModel alloc] initWithName:@"色阶" filter:LevelsFilter];
    [_filtersArray addObject:filter8];
    
    //灰度
    GPUImageGrayscaleFilter *GrayscaleFilter = [GPUImageGrayscaleFilter new];
    CCFilterModel *filter9 = [[CCFilterModel alloc] initWithName:@"灰度" filter:GrayscaleFilter];
    [_filtersArray addObject:filter9];
    
    //RGB
    GPUImageRGBFilter *RGBFilter = [GPUImageRGBFilter new];
    RGBFilter.red = 0.6;
    RGBFilter.green = 0.4;
    RGBFilter.blue = 0.5;
    CCFilterModel *filter10 = [[CCFilterModel alloc] initWithName:@"RGB" filter:RGBFilter];
    [_filtersArray addObject:filter10];
    
    //单色
    GPUImageMonochromeFilter *MonochromeFilter = [GPUImageMonochromeFilter new];
    [MonochromeFilter setColorRed:0.6 green:0.3 blue:0.2];
    CCFilterModel *filter11 = [[CCFilterModel alloc] initWithName:@"单色" filter:MonochromeFilter];
    [_filtersArray addObject:filter11];
    
    //不透明度
    GPUImageOpacityFilter *OpacityFilter = [GPUImageOpacityFilter new];
    OpacityFilter.opacity = 0.5;
    CCFilterModel *filter12 = [[CCFilterModel alloc] initWithName:@"透明度" filter:OpacityFilter];
    [_filtersArray addObject:filter12];
    
    //提亮阴影
    GPUImageHighlightShadowFilter *HighlightShadowFilter = [GPUImageHighlightShadowFilter new];
    HighlightShadowFilter.shadows = 0.6;
    HighlightShadowFilter.highlights = 0.5;
    CCFilterModel *filter13 = [[CCFilterModel alloc] initWithName:@"提亮阴影" filter:HighlightShadowFilter];
    [_filtersArray addObject:filter13];
    
    //色彩替换（替换亮部和暗部色彩）
    GPUImageFalseColorFilter *FalseColorFilter = [GPUImageFalseColorFilter new];
    CCFilterModel *filter14 = [[CCFilterModel alloc] initWithName:@"色彩替换" filter:FalseColorFilter];
    [_filtersArray addObject:filter14];
    
    //色度
    GPUImageHueFilter *HueFilter = [GPUImageHueFilter new];
    HueFilter.hue = 200;
    CCFilterModel *filter15 = [[CCFilterModel alloc] initWithName:@"色度" filter:HueFilter];
    [_filtersArray addObject:filter15];
    
    //色度键
    GPUImageChromaKeyFilter *ChromaKeyFilter = [GPUImageChromaKeyFilter new];
    [ChromaKeyFilter setColorToReplaceRed:0.9 green:0.3 blue:0.1];
    ChromaKeyFilter.smoothing = 0.6;
    ChromaKeyFilter.thresholdSensitivity = 0.7;
    CCFilterModel *filter16 = [[CCFilterModel alloc] initWithName:@"色度键" filter:ChromaKeyFilter];
    [_filtersArray addObject:filter16];
  
    //白平横
    GPUImageWhiteBalanceFilter *WhiteBalanceFilter = [GPUImageWhiteBalanceFilter new];
    WhiteBalanceFilter.temperature = 110;
    WhiteBalanceFilter.tint = 2;
    CCFilterModel *filter17 = [[CCFilterModel alloc] initWithName:@"白平横" filter:WhiteBalanceFilter];
    [_filtersArray addObject:filter17];
    
    //形状变化
    GPUImageTransformFilter *TransformFilter = [GPUImageTransformFilter new];
    TransformFilter.affineTransform =CGAffineTransformMakeRotation(M_PI);
    CCFilterModel *filter18 = [[CCFilterModel alloc] initWithName:@"形状变化" filter:TransformFilter];
    [_filtersArray addObject:filter18];
    
    //剪裁
    GPUImageCropFilter *CropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.2, 0.2, 0.6, 0.6)];
    CCFilterModel *filter19 = [[CCFilterModel alloc] initWithName:@"剪裁" filter:CropFilter];
    [_filtersArray addObject:filter19];
    
    //锐化
    GPUImageSharpenFilter *SharpenFilter = [GPUImageSharpenFilter new];
    SharpenFilter.sharpness = 4;
    CCFilterModel *filter20 = [[CCFilterModel alloc] initWithName:@"锐化" filter:SharpenFilter];
    [_filtersArray addObject:filter20];
    
    //反遮罩锐化
    GPUImageUnsharpMaskFilter *UnsharpMaskFilter = [GPUImageUnsharpMaskFilter new];
    UnsharpMaskFilter.blurRadiusInPixels = 10;
    UnsharpMaskFilter.intensity = 0.4;
    CCFilterModel *filter21 = [[CCFilterModel alloc] initWithName:@"反遮罩锐化" filter:UnsharpMaskFilter];
    [_filtersArray addObject:filter21];
    
    //Sobel边缘检测算法
    GPUImageSobelEdgeDetectionFilter *SobelEdgeDetectionFilter = [GPUImageSobelEdgeDetectionFilter new];
    SobelEdgeDetectionFilter.texelWidth = 2;
    SobelEdgeDetectionFilter.texelHeight = 2;
    SobelEdgeDetectionFilter.edgeStrength = 2;
    CCFilterModel *filter22 = [[CCFilterModel alloc] initWithName:@"边缘检测" filter:SobelEdgeDetectionFilter];
    [_filtersArray addObject:filter22];
    
    //高斯模糊
    GPUImageGaussianBlurFilter *aussianBlurFilter = [GPUImageGaussianBlurFilter new];
    aussianBlurFilter.texelSpacingMultiplier = 2;
    aussianBlurFilter.blurRadiusInPixels = 3;
    CCFilterModel *filter23 = [[CCFilterModel alloc] initWithName:@"高斯模糊" filter:aussianBlurFilter];
    [_filtersArray addObject:filter23];

    
    //高斯模糊，选择部分清晰
    GPUImageGaussianSelectiveBlurFilter *GaussianSelectiveBlurFilter = [GPUImageGaussianSelectiveBlurFilter new];
    GaussianSelectiveBlurFilter.excludeCirclePoint = CGPointMake(100, 100);
    CCFilterModel *filter24 = [[CCFilterModel alloc] initWithName:@"高斯模糊" filter:GaussianSelectiveBlurFilter];
    [_filtersArray addObject:filter24];
    
    //双边模糊
    GPUImageBilateralFilter *BilateralFilter = [GPUImageBilateralFilter new];
    BilateralFilter.distanceNormalizationFactor = 0.2;
    CCFilterModel *filter25 = [[CCFilterModel alloc] initWithName:@"双边模糊" filter:BilateralFilter];
    [_filtersArray addObject:filter25];
    
    //彩色模糊
    GPUImageRGBOpeningFilter *RGBOpeningFilter = [[GPUImageRGBOpeningFilter alloc] initWithRadius:3];
    CCFilterModel *filter26 = [[CCFilterModel alloc] initWithName:@"彩色模糊" filter:RGBOpeningFilter];
    [_filtersArray addObject:filter26];
    
    //图像黑白化，并有大量噪点
    GPUImageLocalBinaryPatternFilter *LocalBinaryPatternFilter = [GPUImageLocalBinaryPatternFilter new];
    CCFilterModel *filter27 = [[CCFilterModel alloc] initWithName:@"黑白" filter:LocalBinaryPatternFilter];
    [_filtersArray addObject:filter27];
    
    //素描
    GPUImageSketchFilter *SketchFilter = [GPUImageSketchFilter new];
    CCFilterModel *filter28 = [[CCFilterModel alloc] initWithName:@"素描" filter:SketchFilter];
    [_filtersArray addObject:filter28];
    
    //阀值素描，形成有噪点的素描
    GPUImageThresholdSketchFilter *ThresholdSketchFilter = [GPUImageThresholdSketchFilter new];
    CCFilterModel *filter29 = [[CCFilterModel alloc] initWithName:@"阀值素描" filter:ThresholdSketchFilter];
    [_filtersArray addObject:filter29];
    
    //卡通效果（黑色粗线描边）
    GPUImageToonFilter *ToonFilter = [GPUImageToonFilter new];
    ToonFilter.threshold = 0.2;
    ToonFilter.quantizationLevels = 10;
    CCFilterModel *filter30 = [[CCFilterModel alloc] initWithName:@"卡通效果" filter:ToonFilter];
    [_filtersArray addObject:filter30];
    
    //相比上面的效果更细腻，上面是粗旷的画风
    GPUImageSmoothToonFilter *SmoothToonFilter = [GPUImageSmoothToonFilter new];
    SmoothToonFilter.threshold = 0.2;
    SmoothToonFilter.quantizationLevels = 10;
    CCFilterModel *filter31 = [[CCFilterModel alloc] initWithName:@"细腻卡通" filter:SmoothToonFilter];
    [_filtersArray addObject:filter31];
    
    //桑原(Kuwahara)滤波,水粉画的模糊效果；处理时间比较长，慎用
    GPUImageKuwaharaFilter *KuwaharaFilter = [GPUImageKuwaharaFilter new];
    KuwaharaFilter.radius = 7;
    CCFilterModel *filter32 = [[CCFilterModel alloc] initWithName:@"桑原滤波" filter:KuwaharaFilter];
    [_filtersArray addObject:filter32];
    
    //像素化
    GPUImagePixellateFilter *PixellateFilter = [GPUImagePixellateFilter new];
    PixellateFilter.fractionalWidthOfAPixel = 0.02;
    CCFilterModel *filter33 = [[CCFilterModel alloc] initWithName:@"像素化" filter:PixellateFilter];
    [_filtersArray addObject:filter33];
    
    //交叉线阴影，形成黑白网状画面
    GPUImageCrosshatchFilter *CrosshatchFilter = [GPUImageCrosshatchFilter new];
    CrosshatchFilter.crossHatchSpacing = 0.03;
    CrosshatchFilter.lineWidth = 0.003;
    CCFilterModel *filter34 = [[CCFilterModel alloc] initWithName:@"交叉线" filter:CrosshatchFilter];
    [_filtersArray addObject:filter34];
    
    //色彩丢失，模糊（类似监控摄像效果）
    GPUImageColorPackingFilter *ColorPackingFilter = [GPUImageColorPackingFilter new];
    CCFilterModel *filter35 = [[CCFilterModel alloc] initWithName:@"色彩丢失" filter:ColorPackingFilter];
    [_filtersArray addObject:filter35];
    
    //晕影，形成黑色圆形边缘，突出中间图像的效果
    GPUImageVignetteFilter *VignetteFilter = [GPUImageVignetteFilter new];
    CCFilterModel *filter36 = [[CCFilterModel alloc] initWithName:@"晕影" filter:VignetteFilter];
    [_filtersArray addObject:filter36];
    
    //凸起失真，鱼眼效果
    GPUImageBulgeDistortionFilter *BulgeDistortionFilter = [GPUImageBulgeDistortionFilter new];
    CCFilterModel *filter37 = [[CCFilterModel alloc] initWithName:@"鱼眼效果" filter:BulgeDistortionFilter];
    [_filtersArray addObject:filter37];
    
    //收缩失真，凹面镜
    GPUImagePinchDistortionFilter *PinchDistortionFilter = [GPUImagePinchDistortionFilter new];
    CCFilterModel *filter38 = [[CCFilterModel alloc] initWithName:@"凹面镜" filter:PinchDistortionFilter];
    [_filtersArray addObject:filter38];
    
    //漩涡，中间形成卷曲的画面
    GPUImageSwirlFilter *SwirlFilter = [GPUImageSwirlFilter new];
    CCFilterModel *filter39 = [[CCFilterModel alloc] initWithName:@"漩涡" filter:SwirlFilter];
    [_filtersArray addObject:filter39];
    
    //浮雕效果，带有点3d的感觉
    GPUImageEmbossFilter *EmbossFilter = [GPUImageEmbossFilter new];
    CCFilterModel *filter40 = [[CCFilterModel alloc] initWithName:@"浮雕" filter:EmbossFilter];
    [_filtersArray addObject:filter40];
    
    //像素圆点花样
    GPUImagePolkaDotFilter *PolkaDotFilter = [GPUImagePolkaDotFilter new];
    CCFilterModel *filter41 = [[CCFilterModel alloc] initWithName:@"像素圆点" filter:PolkaDotFilter];
    [_filtersArray addObject:filter41];
    
    
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
