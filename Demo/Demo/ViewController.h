//
//  ViewController.h
//  Demo
//
//  Created by 马浩原 on 2018/4/17.
//  Copyright © 2018年 GSWW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
//cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;


@end

