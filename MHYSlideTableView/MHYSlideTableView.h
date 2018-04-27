//
//  MHYSlideTableView.h
//  head
//
//  Created by 马浩原 on 2018/4/16.
//  Copyright © 2018年 WanWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHYSlideTableView : UIView

//滑动至第几个table
@property (nonatomic,assign) NSInteger selectedTabNum;

/**
 @param headView      头部的view
 @param tableViews    盛放头部下面需要左右滑动的tablview或collection数组(可以混搭)
 @param headHiddenHeight    在tableView(或collection)向上滑动时,头部视图需要跟着向上滑动的最大高度;
 */

-(instancetype)initWithFrame:(CGRect)frame andHeadView :(UIView *)headView andSubTableViews:(NSArray *)tableViews andHeadHiddenHeight:(CGFloat)headHiddenHeight;




@end
