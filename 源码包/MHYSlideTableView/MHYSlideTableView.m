//
//  MHYSlideTableView.m
//  head
//
//  Created by 马浩原 on 2018/4/16.
//  Copyright © 2018年 WanWei. All rights reserved.
//

#import "MHYSlideTableView.h"

@interface MHYSlideTableView()<UIScrollViewDelegate>

@property (nonatomic,weak) UIView *headView;

@property (nonatomic,strong) NSArray *tableViews;

@property (nonatomic,assign) CGFloat headViewHeight;

@property (nonatomic,assign) CGFloat headHiddenHeight;

@property (nonatomic,weak) UIScrollView *backScrollView;

@end

@implementation MHYSlideTableView

-(instancetype)initWithFrame:(CGRect)frame andHeadView :(UIView *)headView andSubTableViews:(NSArray *)tableViews andHeadHiddenHeight:(CGFloat)headHiddenHeight{
    if (self = [super initWithFrame:frame]) {
        _headView = headView;
        _tableViews = tableViews;
        _headViewHeight = CGRectGetHeight(headView.frame);
        _headHiddenHeight = headHiddenHeight;
        _selectedTabNum = 0;
        [self createSub];
    }
    return self;
}

-(void)createSub{
    
    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backScrollView.delegate = self;
    backScrollView.backgroundColor = [UIColor yellowColor];
    backScrollView.contentSize = CGSizeMake(self.frame.size.width*_tableViews.count, 0);
    backScrollView.bounces = NO;
    backScrollView.pagingEnabled = YES;
    [self addSubview:backScrollView];
    _backScrollView = backScrollView;
    
    [self createHeadView];
    [self createTableView];
}

- (void)createHeadView{
    _headView.frame = _headView.bounds;
    [self addSubview:_headView];
}
- (void)createTableView {
    for(int i =0;i<_tableViews.count;i++){
        UIScrollView *tabView = _tableViews[i];
        tabView.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        tabView.delegate = self;
        tabView.contentInset = UIEdgeInsetsMake(_headViewHeight, 0, 0, 0);
        tabView.contentOffset = CGPointMake(0, 0-_headViewHeight);
        [_backScrollView addSubview:tabView];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView ==_backScrollView) {
        return;
    }
    if (scrollView.contentOffset.y>_headHiddenHeight-_headViewHeight) {
        _headView.frame = CGRectMake(0, 0-_headHiddenHeight, self.frame.size.width, _headViewHeight);
        for (int i = 0; i<_tableViews.count; i++) {
            UIScrollView *otherTab = _tableViews[i];
            if (otherTab != scrollView) {
                if(otherTab.contentOffset.y<_headHiddenHeight-_headViewHeight){
                    otherTab.contentOffset = CGPointMake(0, _headHiddenHeight-_headViewHeight);
                }
            }
        }
    }else if (scrollView.contentOffset.y<=_headHiddenHeight-_headViewHeight&&scrollView.contentOffset.y>=0-_headViewHeight) {
        for (int i = 0; i<_tableViews.count; i++) {
            UIScrollView *otherTab = _tableViews[i];
            if (otherTab != scrollView) {
                otherTab.contentOffset = scrollView.contentOffset;
            }
        }
        _headView.frame = CGRectMake(0, -scrollView.contentOffset.y-_headViewHeight, self.frame.size.width, _headViewHeight);
    }else{
        for (int i = 0; i<_tableViews.count; i++) {
            UIScrollView *otherTab = _tableViews[i];
            if (otherTab != scrollView) {
                otherTab.contentOffset = CGPointMake(0, 0-_headViewHeight);
            }
        }
        _headView.frame = CGRectMake(0,0, self.frame.size.width, _headViewHeight);
    }
}


-(void)setSelectedTabNum:(NSInteger)selectedTabNum{
    _selectedTabNum = selectedTabNum;
    [UIView animateWithDuration:0.5 animations:^{
        _backScrollView.contentOffset = CGPointMake(self.frame.size.width*selectedTabNum, 0);
    }];
    
}


@end
