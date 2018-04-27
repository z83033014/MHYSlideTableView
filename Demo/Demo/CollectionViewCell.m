//
//  CollectionViewCell.m
//  head
//
//  Created by 马浩原 on 2018/4/16.
//  Copyright © 2018年 WanWei. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@property (nonatomic,weak) UILabel *label;

@end

@implementation CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setUbSubViews];
        self.contentView.backgroundColor = [UIColor blueColor];
    }
    return self;
}

-(void)setUbSubViews{
    UILabel *label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    _label = label;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _label.text = title;
    
}

@end
