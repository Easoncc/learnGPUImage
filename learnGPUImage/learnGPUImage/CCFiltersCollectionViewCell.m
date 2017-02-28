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
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titlesLabel];
        
    }
    return self;
}

- (UIImageView *)iconImageView{
    
    if (!_iconImageView) {
        
        UIImageView *imageview = [UIImageView new];
        imageview.frame = CGRectMake(0, 0, 50, 50);
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.layer.masksToBounds = YES;
        
        _iconImageView = imageview;
        
    }
    
    return _iconImageView;
}


- (UILabel *)titlesLabel{
    
    if (!_titlesLabel) {
        
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 30, 50, 20);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12.0];
        
        _titlesLabel = label;
        
        
    }
    return _titlesLabel;
}

@end
