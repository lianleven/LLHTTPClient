//
//  ViewController.m
//  LYHttpClient
//
//  Created by lichangwen on 15/12/28.
//  Copyright © 2015年 LianLeven. All rights reserved.
//

#import "ViewController.h"
#import "GlobalTimelineViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)tezt:(UIButton *)sender {
    
    [self.navigationController pushViewController:[GlobalTimelineViewController new] animated:YES];
}



@end
