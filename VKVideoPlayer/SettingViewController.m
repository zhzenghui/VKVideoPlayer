//
//  SettingViewController.m
//  Movie
//
//  Created by i-Bejoy on 14-1-3.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "SettingViewController.h"
//#import "DownLoadListViewController.h"
//#import "ZuiJinViewController.h"
//#import "MianZeViewController.h"
//#import "AboutViewController.h"
//#import "RecommendViewController.h"



#define Kxiazai 1000
#define KZuiJin 1001
#define KQingChu 1002 
#define KMianZe  1003
#define KAbout   1004
#define KTuiJian  1005


@interface SettingViewController ()

@end

@implementation SettingViewController


- (void)clearCache
{
    
}

- (void)openViewController:(UIButton *)button
{
    
//    BaseViewController *baseView = nil;
//    switch (button.tag) {
//        case Kxiazai:
//        {
//            baseView = [[DownLoadListViewController alloc] init];
//            break;
//        }
//        case KZuiJin:
//        {
//            
//            baseView = [[ZuiJinViewController alloc] init];
//            break;
//        }
//        case KQingChu:
//        {
//            [self clearCache];return;
//            break;
//        }
//        case KMianZe:
//        {
//            baseView = [[MianZeViewController alloc] init];
//            break;
//        }
//        case KAbout:
//        {
//            baseView = [[AboutViewController alloc] init];
//            break;
//        }
//        case KTuiJian:
//        {
//            baseView = [[RecommendViewController alloc] init];
//            break;
//        }
//        default:
//            break;
//    }
//    
//    
//    baseView.image = self.image;
//    [self addChildViewController:baseView];
//    [self.view addSubview:baseView.view];
//    baseView.view.alpha = 0;
//    
//    [UIView animateWithDuration:KLongDuration animations:^{
//        baseView.view.alpha = 1;
//    }];
    
}


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



    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cxc"]];
    view.tag = 102;
    view.frame = self.view.frame;
    [self.view addSubview:view];
    
    
    [[Button share] addToView:view addTarget:self rect:RectMake2x(0, 86, 316, 240) tag:Kxiazai action:@selector(openViewController:) imagePath:@"xianzai_list"];
    [[Button share] addToView:view addTarget:self rect:RectMake2x(324, 86, 316, 240) tag:KZuiJin action:@selector(openViewController:) imagePath:@"zuijin_list"];

    [[Button share] addToView:view addTarget:self rect:RectMake2x(0, 334, 316, 240) tag:KQingChu action:@selector(openViewController:) imagePath:@"qingchu_cache"];
    [[Button share] addToView:view addTarget:self rect:RectMake2x(324, 334, 316, 240) tag:KMianZe action:@selector(openViewController:) imagePath:@"meize"];

    [[Button share] addToView:view addTarget:self rect:RectMake2x(0, 582, 316, 240) tag:KAbout action:@selector(openViewController:) imagePath:@"about"];
    [[Button share] addToView:view addTarget:self rect:RectMake2x(324, 582, 316, 240) tag:KTuiJian action:@selector(openViewController:) imagePath:@"tuijian_app"];


    
    UIView *black = [[UIView alloc] initWithFrame:CGRectMake(0, screen_Height-50, screen_Width, 100)];
    black.backgroundColor = [UIColor blackColor];
    black.alpha = .8;
    
    [view addSubview:black];
    
    

    
    [[Button share] addToView:black addTarget:self rect:CGRectMake( 0, 0, 320, 50) tag:101 action:@selector(back:) imagePath:@"fanhui" ];

    
    [self addBackView];
}


- (void)addBackView
{
    [[Button share] addToView:self.view addTarget:self rect:RectMakeC2x(0, 0, 110, 110) tag:Action_Back action:@selector(back:) imagePath:@"按钮-返回"];
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
