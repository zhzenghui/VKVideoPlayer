//
//  RecommendViewController.m
//  Movie
//
//  Created by i-Bejoy on 14-1-3.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "RecommendViewController.h"

@interface RecommendViewController ()

@end

@implementation RecommendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    UIView *black = [[UIView alloc] initWithFrame:CGRectMake(0, screen_Height-50, screen_Width, 100)];
    black.backgroundColor = [UIColor blackColor];
    black.alpha = .8;
    
    [self.view addSubview:black];
    
    
    
    
    [[Button share] addToView:black addTarget:self rect:CGRectMake( 0, 0, 320, 50) tag:101 action:@selector(back:) imagePath:@"fanhui" ];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
