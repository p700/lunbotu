//
//  ZKImgRunLoopView.h
//  temp
//
//  Created by 朱凯 on 16/6/15.
//  Copyright © 2016年 朱凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKImgRunLoopView : UIView
/** 本地图片数组*/
@property (nonatomic,strong) NSArray *imgArray;
/** 网络图片数组*/
@property (nonatomic,strong) NSArray *imgUrlArray;
/** 图片点击调用*/
- (void)touchImageIndexBlock:(void (^)(NSInteger index))block;

- (instancetype)initWithFrame:(CGRect)frame placeholderImg:(UIImage *)img;
@end
