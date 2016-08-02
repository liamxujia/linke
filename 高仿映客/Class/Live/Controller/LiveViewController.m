//
//  LiveViewController.m
//  高仿映客
//
//  Created by JIAAIR on 16/6/29.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import "LiveViewController.h"
#import "UIBarButtonItem+Item.h"
#import "UIView+XJExtension.h"
#import "AttentionViewController.h"
#import "HotViewController.h"
#import "NewViewController.h"
#import "SearchViewController.h"

static NSString * const ID = @"CELL";
#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define XJScreenW [UIScreen mainScreen].bounds.size.width
@interface LiveViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

/** 顶部navigationItem控件*/
@property (nonatomic, weak) UIScrollView *topView;
/** 下划线 */
@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, weak) UIButton *selectButton;

@property (nonatomic, strong) NSMutableArray *titleButtons;

@property (nonatomic,assign) BOOL isInitial;
@end

@implementation LiveViewController

- (NSMutableArray *)titleButtons {
    
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航条内容
    [self setupNavgationBar];

    // 添加底部内容view
    [self setupBottomContentView];
    
    // 添加所有子控制器
    [self setupAllChildViewController];
    
    // 不添加额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置状态栏为白色(还要在info,plist文件中设置View controller-based status bar appearance = NO)
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

}

#pragma mark - 添加所有的子控制器
- (void)setupAllChildViewController {
   
    //关注
    AttentionViewController *attenVc = [[AttentionViewController alloc] init];
    attenVc.title = @"关注";
    [self addChildViewController:attenVc];
    
    //热门
    HotViewController *hotVc = [[HotViewController alloc] init];
    hotVc.title = @"热门";
    [self addChildViewController:hotVc];
    
    //最新
    NewViewController *newVc = [[NewViewController alloc] init];
    newVc.title = @"最新";
    [self addChildViewController:newVc];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isInitial == NO) {
        // 添加标题
        [self setupAllTitle];
        _isInitial = YES;
    }

}

#pragma mark - 选中标题按钮
- (void)selButton:(UIButton *)titleButton
{
    _selectButton.selected = NO;
    titleButton.selected = YES;
    _selectButton = titleButton;
    
    // 移动下划线的位置
    [UIView animateWithDuration:0.25 animations:^{
        
        _lineView.xj_centerX = titleButton.xj_centerX;
    }];
    
}

#pragma mark - 点击标题

- (void)titleClick:(UIButton *)titleButton
{
    
    
    NSInteger i = titleButton.tag;
    
    // 重复点击标题按钮的时候,刷新当前界面
    if (titleButton == _selectButton) {
//        NSLog(@"重复点击标题按钮");
    }

    [self selButton:titleButton];
    
    //滚动collectionView 修改偏移量
    CGFloat offsetX = i * XJScreenW;
    _collectionView.contentOffset = CGPointMake(offsetX, 0);
    
}

#pragma mark - UICollectionViewDelegate
// 滚动完成的时候就会调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获取角标
    NSInteger i = scrollView.contentOffset.x / XJScreenW;
    
    // 获取选中标题
    UIButton *selButton = self.titleButtons[i];
    
    // 选中标题
    [self selButton:selButton];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childViewControllers.count;
}

// 只要有新的cell出现的时候才会调用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 只要有新的cell出现,就把对应的子控制器的view添加到新的cell上
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    // 移除之前子控制器view
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    // 取出对应的子控制器添加到对应cell上
    UIViewController *vc = self.childViewControllers[indexPath.row];
    vc.view.frame = CGRectMake(0, 0, XJScreenW, XJScreenH);
    [cell.contentView addSubview:vc.view];
    
    return cell;
}

#pragma mark - 添加标题
- (void)setupAllTitle
{
    NSUInteger count = self.childViewControllers.count;
    CGFloat btnW = 50;
    CGFloat btnX = 40;
    CGFloat btnH = _topView.xj_height;
    for (int i = 0; i < count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        
        UIViewController *vc = self.childViewControllers[i];
        [titleButton setTitle:vc.title forState:UIControlStateNormal];
        // 设置标题颜色
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        // 设置标题字体
        titleButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        btnX = i * btnW;
        
        titleButton.frame = CGRectMake(btnX, 0, btnW, btnH);
        
        // 监听按钮点击
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_topView addSubview:titleButton];
        
        if (i == 0) {
            // 添加下划线
            // 下划线宽度 = 按钮文字宽度
            // 下划线中心点x = 按钮中心点x
            
            CGFloat h = 2;
            CGFloat y = 38 ;
            UIView *lineView =[[UIView alloc] init];
            // 位置和尺寸
            lineView.xj_height = h;
            // 先计算文字尺寸,在给label去赋值
            [titleButton.titleLabel sizeToFit];
            lineView.xj_width = titleButton.titleLabel.xj_width;
            lineView.xj_centerX = titleButton.xj_centerX;
            lineView.xj_y = y;
            lineView.backgroundColor = [UIColor whiteColor];
            _lineView = lineView;
            
            [_topView addSubview:lineView];
            
            [self titleClick:titleButton];
        }
        
        [self.titleButtons addObject:titleButton];
    }
    
}

#pragma mark - 添加底部内容view
- (void)setupBottomContentView
{
    // 创建一个流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(XJScreenW, XJScreenH);
    
    // 设置水平滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    // 创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    collectionView.scrollsToTop = NO;
    
    // 开启分页
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.bounces = NO;
    
    // 展示cell
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    // 注册cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
}

#pragma mark - 设置导航条内容
- (void)setupNavgationBar {
    
    //middleView
    UIScrollView *topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    topView.scrollsToTop = NO;
    _topView = topView;
    
    /**
     *  把UIScrollView添加到导航控制器
     */
    [self.navigationItem setTitleView:topView];
    
    // left
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"card_search"] highImage:[UIImage imageNamed:@"card_search"] target:self action:@selector(search)];
    
    // right
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"card_message"] highImage:[UIImage imageNamed:@"card_message"] target:nil action:nil];
}

#pragma mark ---- <push搜索栏>
- (void)search {
    SearchViewController *searchVc = [[SearchViewController alloc] init];

    [self.navigationController pushViewController:searchVc animated:YES];
}
@end
