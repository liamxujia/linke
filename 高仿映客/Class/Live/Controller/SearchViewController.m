//
//  SearchViewController.m
//  高仿映客
//
//  Created by JIAAIR on 16/6/30.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import "SearchViewController.h"
#define XJScreenW [UIScreen mainScreen].bounds.size.width
@interface SearchViewController () <UISearchBarDelegate, UINavigationBarDelegate>

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置左侧搜索框
    [self setupLeftsearchBar];
   
    //设置右侧Item
    [self setupRightItem];
    
    
}

#pragma mark ---- <设置右侧Item>
- (void)setupRightItem {
    //Right
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    //字体颜色
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [rightBtn setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
#pragma mark ---- <设置左侧搜索框>
- (void)setupLeftsearchBar {
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat w = XJScreenW - 65;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, w, 28)];

    searchBar.placeholder = @"输入映客号或昵称";
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor grayColor];
    [searchBar becomeFirstResponder];
    
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:searchBar];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:searchButton];
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

//在这个方法中写搜索方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   
}

@end
