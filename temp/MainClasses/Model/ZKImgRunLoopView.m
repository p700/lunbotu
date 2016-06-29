//
//  ZKImgRunLoopView.m
//  temp
//
//  Created by 朱凯 on 16/6/15.
//  Copyright © 2016年 朱凯. All rights reserved.
//

#import "ZKImgRunLoopView.h"
#import <UIImageView+WebCache.h>

@interface ZKImgRunLoopView () <UIScrollViewDelegate>
/** 外面加层UIView*/
@property (nonatomic,strong) UIView *divView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
/** 当前图片索引*/
@property (nonatomic,assign) NSInteger imgIndexOf;
/** 定时器*/
@property (nonatomic,strong) NSTimer *timer;
/** 回调block*/
@property (nonatomic,copy) void (^block)();
@property (nonatomic,strong) UIImage *placeholderImg;
@property (nonatomic,assign) float oldContentOffsetX;
@property (nonatomic,assign) NSInteger imgCount;
@end

@implementation ZKImgRunLoopView
#pragma mark -- 初始化
- (instancetype)initWithFrame:(CGRect)frame placeholderImg:(UIImage *)img{
    if (self = [super init]) {
        self.frame = frame;
        if (img) {
            self.placeholderImg = img;
        }
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}
#pragma mark -- 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    BOOL isRight = self.oldContentOffsetX < point.x;
    self.oldContentOffsetX = point.x;
    // 开始显示最后一张图片的时候切换到第二个图
    if (point.x > self.width*(self.imgCount-2)+self.width*0.5 && !self.timer) {
        self.pageControl.currentPage = 0;
    }else if (point.x > self.width*(self.imgCount-2) && self.timer && isRight){
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage = (point.x + self.width*0.5) / self.width;
    }
    // 开始显示第一张图片的时候切换到倒数第二个图
    if (point.x >= self.width*(self.imgCount-1)) {
        [_scrollView setContentOffset:CGPointMake(self.width+point.x-self.width*self.imgCount, 0) animated:NO];
    }else if (point.x < 0) {
        [scrollView setContentOffset:CGPointMake(point.x+self.width*(self.imgCount-1), 0) animated:NO];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}
#pragma mark -- 定时器
- (void)startTimer
{
    self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)nextPage
{
    [self.scrollView setContentOffset:CGPointMake((self.pageControl.currentPage+1)*self.width, 0) animated:YES];
}
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark -- 模型初始化
- (void)setImgArray:(NSArray *)imgArray{
    [(NSMutableArray *)imgArray addObject:imgArray[0]];
    _imgArray = imgArray;
    self.imgCount = imgArray.count;
    for (int i=0; i<imgArray.count; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.image = [UIImage imageNamed:imgArray[i]];
        imgView.frame = CGRectMake(i*self.width, 0, self.width, self.height);
        [self.scrollView addSubview:imgView];
    }
    self.scrollView.contentSize = CGSizeMake(self.width*imgArray.count, 0);
    self.pageControl.numberOfPages = imgArray.count-1;
    [self addImgClick];
    [self startTimer];
}
- (void)setImgUrlArray:(NSArray *)imgUrlArray{
    [(NSMutableArray *)imgUrlArray addObject:imgUrlArray[0]];
    _imgUrlArray = imgUrlArray;
    self.imgCount = imgUrlArray.count;
    for (int i=0; i<imgUrlArray.count; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        NSURL *imgUrl = [NSURL URLWithString:imgUrlArray[i]];
        [imgView sd_setImageWithURL:imgUrl placeholderImage:self.placeholderImg];
        imgView.frame = CGRectMake(i*self.width, 0, self.width, self.height);
        [self.scrollView addSubview:imgView];
    }
    self.scrollView.contentSize = CGSizeMake(self.width*imgUrlArray.count, 0);
    self.pageControl.numberOfPages = imgUrlArray.count-1;
    [self addImgClick];
    [self startTimer];
}
#pragma mark -- 点击图片
-(void)touchImageIndexBlock:(void (^)(NSInteger))block{
    __block ZKImgRunLoopView *men = self;
    self.block = ^(){
        if (block) {
            block((men.pageControl.currentPage));
        }
    };
}
- (void)addImgClick{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick)];
    [self.scrollView addGestureRecognizer:tap];
}
- (void)imgClick{
    if (self.block) {
        self.block();
    }
}
#pragma mark -- 懒加载
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        self.imgIndexOf = 1;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        CGRect rect = CGRectMake(0, self.height-13, self.width, 4);
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        self.pageControl.currentPage = 0;
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        self.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    }
    return _pageControl;
}
@end
