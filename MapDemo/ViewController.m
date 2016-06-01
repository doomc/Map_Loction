//
//  ViewController.m
//  MapDemo
//
//  Created by 熊维东 on 16/5/31.
//  Copyright © 2016年 熊维东. All rights reserved.
//

#import "ViewController.h"
#import "MapDemoViewController.h"
@interface ViewController ()
- (IBAction)openMapLocation:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor cyanColor];
 

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openMapLocation:(id)sender {
    NSLog(@"打开地图图");
    MapDemoViewController * mapvc =[[MapDemoViewController alloc]init];
    [self.navigationController pushViewController:mapvc animated:YES];
    
    
}
@end
