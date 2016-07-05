//
//  MineViewController.m
//  高仿映客
//
//  Created by JIAAIR on 16/6/29.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import "MineViewController.h"
#import "UIBarButtonItem+Item.h"
#import "MineHeadView.h"
#import "MiddleView.h"
#import "MyView.h"

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface MineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) MyView *introView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //将自定义的View放在tabView 的上面，而不是作为tableView.tableHeaderView
    [self setupTableView];
    
    
//   self.edgesForExtendedLayout = UIRectEdgeNone;
    //隐藏navigationbar和tableHeaderView
    self.navigationController.navigationBarHidden = YES;
    _tableView.tableHeaderView.hidden = YES;
 
    
    

    
}

- (void)setupTableView {
    
    //创建tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.contentInset = UIEdgeInsetsMake(240 + 200, 0, 0, 0);
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
    //给middleView和mineView创建一个容器，让两个视图放在一起
    MyView *introView = [[MyView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240 + 200)];
    
    //创建个人简介
    MineHeadView *headView = [MineHeadView mineHeadView];
    
    [introView addSubview:headView];
    
    //个人等级财富详情
    MiddleView *middleView = [MiddleView middleView];
    
    [introView addSubview:middleView];
    
    [middleView makeConstraints:^(MASConstraintMaker *make) {
        //middleView约束
        make.left.bottom.right.equalTo(introView);
        make.height.equalTo(200);
    }];
    [headView makeConstraints:^(MASConstraintMaker *make) {
        //headView约束
        make.top.left.right.equalTo(introView);
        make.bottom.equalTo(middleView.top);
    }];
    
    [self.view addSubview:introView];
    
    _introView = introView;
    _tableView = tableView;
    
    //添加监听，动态观察tableview的contentOffset的改变
    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark ---- <KVO 回调>
//设置的最大高度为200，最小为64
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        if (offset.y <= 0 && -offset.y >= 20) {
            
            CGRect newFrame = CGRectMake(0, 0, self.view.frame.size.width, -offset.y);
            
            _introView.frame = newFrame;
            
            if (-offset.y <= 200)
            {
                _tableView.contentInset = UIEdgeInsetsMake(-offset.y, 0, 0, 0);
            }
        } else {
            
            CGRect newFrame = CGRectMake(0, 0, self.view.frame.size.width, 64);
            _introView.frame = newFrame;
            _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
    }
}



#pragma mark ---- <tableView数据源方法>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"映客";
    
    return cell;
}









@end
