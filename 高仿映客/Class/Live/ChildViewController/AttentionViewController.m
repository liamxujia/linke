//
//  AttentionViewController.m
//  高仿映客
//
//  Created by JIAAIR on 16/7/2.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import "AttentionViewController.h"

@interface AttentionViewController ()

@end

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome_1"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
