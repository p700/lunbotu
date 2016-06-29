//
//  ViewController.m
//  temp
//
//  Created by 朱凯 on 16/6/13.
//  Copyright © 2016年 朱凯. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "ZKImgRunLoopView.h"


@interface ViewController ()
/** 图片数组*/
@property (nonatomic,strong) NSMutableArray *imgMarr;
@property (nonatomic,strong) ZKImgRunLoopView *imgRunView;
@end


@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubUI];
    [self setupUI];
}

- (void)addSubUI{
    ZKImgRunLoopView *imgRunView = [[ZKImgRunLoopView alloc] initWithFrame:CGRectMake(0, 0, 300, 130) placeholderImg:[UIImage imageNamed:@"load"]];
    self.imgRunView = imgRunView;
    imgRunView.imgUrlArray = self.imgMarr;
    [self.view addSubview:imgRunView];
    [imgRunView  touchImageIndexBlock:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    }];
}
- (void)setupUI{
    [self.imgRunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(130);
    }];
}
#pragma mark -- 懒加载
- (NSMutableArray *)imgMarr{
    if (!_imgMarr) {
        _imgMarr = [NSMutableArray arrayWithCapacity:8];
        for (int i=0; i<5; i++) {
            NSString *imgUrl = [NSString stringWithFormat:@"http://p700.oschina.io/b/%02d.png",i];
//            NSString *imgUrl = [NSString stringWithFormat:@"img_%02d.jpg",i];
            [_imgMarr addObject:imgUrl];
        }
    }
    return _imgMarr;
}
@end
