//
//  CCFiltersCollectionViewCell.m
//  learnGPUImage
//
//  Created by chenchao on 2017/2/27.
//  Copyright © 2017年 chenchao. All rights reserved.
//

#import "CCFiltersCollectionViewCell.h"

@interface CCFiltersCollectionViewCell()


@end

@implementation CCFiltersCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}

- (UIImageView *)imageView{
    
    if (!_imageView) {
        
        UIImageView *imageview = [UIImageView new];
        imageview.frame = self.frame;
        _imageView = imageview;
        
    }
    
    return _imageView;
}

@end
