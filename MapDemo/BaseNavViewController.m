//
//  BaseNavViewController.m
//  MapDemo
//
//  Created by 熊维东 on 16/5/31.
//  Copyright © 2016年 熊维东. All rights reserved.
//

#import "BaseNavViewController.h"
 
@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

+(void)initialize
{
    UINavigationBar * navigationBar = [UINavigationBar appearance];
    
    [navigationBar setTintColor:[UIColor colorWithRed:0.601 green:0.834 blue:1.000 alpha:1.000]];
    [navigationBar setTintColor: [UIColor whiteColor]];
    
    NSShadow * shadow = [[NSShadow alloc]init];
    
    [shadow setShadowOffset:CGSizeZero];
    
    [navigationBar setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName:[UIColor whiteColor],NSShadowAttributeName:shadow
                                            
                                            }];
    
    UIBarButtonItem * barButtonItem = [UIBarButtonItem appearance];
    if ([[UIDevice currentDevice].systemVersion floatValue]> 7.0f) {
        
        [barButtonItem setTintColor:[UIColor whiteColor]];
        
    }
    else{
        NSDictionary *dict =@{NSForegroundColorAttributeName : [UIColor whiteColor],
                              NSShadowAttributeName : shadow};
        [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
        [barButtonItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];

    }
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

}

/**
 *  重写push 方法
 *
 *  @param viewController
 *  @param animated
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count >1) {
        viewController.navigationItem.leftBarButtonItem = [self  creatBackButton];
        
    }
    
}
-(UIBarButtonItem *)creatBackButton
{
//    UIBarButtonItem * barbutton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(backtoself)];
 
    UIBarButtonItem * barbutton  = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backtoself)];
    
    return barbutton;
    
}

-(void)backtoself
{
    NSLog(@" back ");
    [self popViewControllerAnimated:YES];
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
