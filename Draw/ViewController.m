//
//  ViewController.m
//  Draw
//
//  Created by Chentao on 2019/3/8.
//  Copyright © 2019 Chentao. All rights reserved.
//

#import "ViewController.h"
#import "MainView.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)loadView{
    self.view = [[MainView alloc]init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


@end
