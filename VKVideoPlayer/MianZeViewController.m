//
//  MianZeViewController.m
//  Movie
//
//  Created by i-Bejoy on 14-1-3.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "MianZeViewController.h"

@interface MianZeViewController ()

@end

@implementation MianZeViewController

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
	// Do any additional setup after loading the view.
    

    
    
    
    
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cxc"]];
    view.tag = 102;
    view.frame = self.view.frame;
    [self.view addSubview:view];
    
    
    
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.view.frame];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 2500/2)];
    iv.image = [UIImage imageNamed:@"版权声明"];
    sv.contentSize = CGSizeMake(320,  2500/2);
    [sv addSubview:iv];
    
    
    
    [view addSubview:sv];
    
    
    UIView *black = [[UIView alloc] initWithFrame:CGRectMake(0, screen_Height-50, screen_Width, 100)];
    black.backgroundColor = [UIColor blackColor];
    black.alpha = .8;
    
    [view addSubview:black];
    
    
    
    
    [[Button share] addToView:black addTarget:self rect:CGRectMake( 0, 0, 320, 50) tag:101 action:@selector(back:) imagePath:@"fanhui" ];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
