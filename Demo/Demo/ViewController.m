//
//  ViewController.m
//  head
//
//  Created by 马浩原 on 2018/2/9.
//  Copyright © 2018年 WanWei. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

#import "MHYSlideTableView.h"
#import "MJRefresh.h"

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define NavBarHeight ( kDevice_Is_iPhoneX ? 64+24.f : 64.f )

#define TabBarHeight ( kDevice_Is_iPhoneX ? 49+34.f : 49.f )

//屏幕宽度
#define ScreenSizeWidth     ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define ScreenSizeHeight    ([UIScreen mainScreen].bounds.size.height)

#define BTN_TAG  300000


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *tableArr;

@property (nonatomic,strong) NSMutableArray *cellCount;

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,weak) MHYSlideTableView *slideTableView;

@end

@implementation ViewController

static NSString * UICollectionCellID = @"UICollectionCellID";

-(NSMutableArray *)tableArr{
    if (!_tableArr) {
        _tableArr = [NSMutableArray array];
    }
    return _tableArr;
}

-(NSMutableArray *)cellCount{
    if (!_cellCount) {
        _cellCount = [NSMutableArray array];
    }
    return _cellCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (!(@available(iOS 11.0, *))) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    for (int i = 0; i<4; i++) {
        NSNumber *count = [NSNumber numberWithInteger:10+i*10];
        [self.cellCount addObject:count];
    }
    
    [self createUI];
    for (int i = 0; i<self.tableArr.count; i++) {
        [self loadData:YES andCount:i];
    }
}


-(void)createSlideView{
    MHYSlideTableView *slideTableView = [[MHYSlideTableView alloc] initWithFrame:CGRectMake(0, NavBarHeight, ScreenSizeWidth, ScreenSizeHeight-NavBarHeight) andHeadView:self.headView andSubTableViews:self.tableArr andHeadHiddenHeight:200];
    [self.view addSubview:slideTableView];
    _slideTableView = slideTableView;
}

- (void)createUI{
    self.title = @"Demo";
    self.navigationController.navigationBar.translucent = NO;
    [self createHead];
    [self createTab];
    [self createCollection];
    [self createSlideView];
    
}

-(void)createHead{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200+44)];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    headImage.image = [UIImage imageNamed:@"3333.png"];
    [headView addSubview:headImage];
    
    CGFloat btnW = ScreenSizeWidth/4.0f;
    
    for (int i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(i*btnW, 200, btnW, 43);
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [btn setTitle:[NSString stringWithFormat:@"第%d个",i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = BTN_TAG +i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn];
    }
    self.headView = headView;
    
}

-(void)btnClicked:(UIButton *)btn{
    
    self.slideTableView.selectedTabNum = btn.tag-BTN_TAG;
    
}


-(void)createTab{
    for(int i =0;i<3;i++){
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenSizeWidth, ScreenSizeHeight-NavBarHeight) style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.tableArr addObject:tableView];
    
        typeof(self) __weak weakSelf = self;
        
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadData:YES andCount:i];
        }];
        tableView.mj_header.ignoredScrollViewContentInsetTop = 244;

        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadData:NO andCount:i];
        }];
    }
}


-(void)loadData:(BOOL)isrefresh andCount:(NSInteger) i{
    if(isrefresh){
        NSNumber *count = self.cellCount[i];
        count = [NSNumber numberWithInteger:10+i*10];
        [self.cellCount replaceObjectAtIndex:i withObject:count];
    }else{
        NSNumber *count = self.cellCount[i];
        count = [NSNumber numberWithInteger:[count intValue]+i+1];
        [self.cellCount replaceObjectAtIndex:i withObject:count];
    }
    
    
    UIView *view = self.tableArr[i];
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)view;
        [tableView reloadData];
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
    }else if ([view isKindOfClass:[UICollectionView class]]){
        UICollectionView *collectionView = (UICollectionView *)view;
        [collectionView reloadData];
        [collectionView.mj_header endRefreshing];
        [collectionView.mj_footer endRefreshing];
    }
}

-(void)createCollection{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//    CGFloat W = (self.view.frame.size.width-50)/2.0f;
//    CGFloat H = W*0.5;
//    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
//    layout.itemSize = CGSizeMake(W,H);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavBarHeight, ScreenSizeWidth, ScreenSizeHeight-NavBarHeight) collectionViewLayout:layout];
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    typeof(self) __weak weakSelf = self;
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData:YES andCount:3];
    }];
    collectionView.mj_header.ignoredScrollViewContentInsetTop = 244;
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData:NO andCount:3];
    }];

    [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:UICollectionCellID];
//    [self.view addSubview:collectionView];
    [self.tableArr addObject:collectionView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    for (UIView *tab in self.tableArr) {
        if (tableView == tab) {
            NSInteger count = [self.cellCount[[self.tableArr indexOfObject:tab]] intValue];
            return count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"123"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个tableView,第%ld行",[self.tableArr indexOfObject:tableView],indexPath.row];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    for (UIView *coll in self.tableArr) {
//        if (collectionView == coll) {
//            NSInteger count = [self.cellCount[[self.tableArr indexOfObject:coll]] intValue];
//            return count;
//        }
//    }
    return 100;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //走了
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UICollectionCellID forIndexPath:indexPath];
    cell.title = [NSString stringWithFormat:@"第%ld个collectionView,第%ld个cell",[self.tableArr indexOfObject:collectionView],indexPath.row];
    return cell;
}

//cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat W = (self.view.frame.size.width-60)/3.0f;
    int value = (arc4random() % 150)+50;
    if(value>100){
        value-=100;
    }
    CGFloat H = W*value*0.01;
    
    return CGSizeMake(W,H);
    
}



-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}


@end

