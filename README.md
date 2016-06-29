><h2>基于UIScrollView封装的轮播图</h2>

创建
``` objc
ZKImgRunLoopView *imgRunView = 
  [[ZKImgRunLoopView alloc] initWithFrame:CGRectMake(0, 0, 300, 130) placeholderImg:nil];
```
属性赋值
``` objc
imgRunView.imgUrlArray = self.imgMarr;    //网络图片
imgRunView.imgArray = self.imgMarr;   //本地图片
```
点击当前图片block回调
``` objc
[imgRunView  touchImageIndexBlock:^(NSInteger index) {
  NSLog(@"%ld",(long)index);
}];
```
