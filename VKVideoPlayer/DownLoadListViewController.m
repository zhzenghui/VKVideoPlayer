//
//  DownLoadListViewController.m
//  Movie
//
//  Created by i-Bejoy on 14-1-3.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "DownLoadListViewController.h"
#import "DownLoadList.h"
#import "DemoVideoPlayerViewController.h"



@interface DownLoadListViewController ()
{
    UIView *view;
}
@end


@implementation DownLoadListViewController


- (void)clearList
{
    
}

#pragma mark - view

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    
    view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cxc"]];
    view.tag = 102;
    view.frame = self.view.frame;
    [self.view addSubview:view];
    

    
    UIView *black = [[UIView alloc] initWithFrame:CGRectMake(0, screen_Height-100, screen_Width, 100)];
    black.backgroundColor = [UIColor blackColor];
    black.alpha = .8;
    
    [view addSubview:black];
    
    
    
    
    [[Button share] addToView:black addTarget:self rect:CGRectMake( 0, 0, 320, 50) tag:101 action:@selector(back:) imagePath:@"fanhui" ];
    [[Button share] addToView:black addTarget:self rect:CGRectMake( 0, 50, 320, 50) tag:101 action:@selector(clearList) imagePath:@"qingkong" ];

    

    
    
    
    _tableView = [[UITableView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource =  self;
    _tableView.backgroundColor = [UIColor clearColor];
    
    //    _tableView.pagingEnabled = YES;
    _tableView.frame = CGRectMake(0, 0, 320, screen_Height-100);
    
    [view  addSubview:_tableView];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

//    NSPredicate *p = nil;
//
//    NSNumber *status = @0;
//    if (status) {
//        p = [NSPredicate predicateWithFormat:@"ANY status == %@", status];
//    }
//
//    self.dataMArray = [[DownloadList findAllWithPredicate:p] mutableCopy];


    NSPredicate* predicate1 = [NSPredicate predicateWithFormat: @" status = 1  or status = 2" ];
    [self.dataMArray addObjectsFromArray: [DownloadList findAllWithPredicate:predicate1]];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadOpen:(UIButton *)button
{
    
    
    
    UITableViewCell *cell = (UITableViewCell *)[[[button superview] superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    
    DownloadList *download = [self. dataMArray objectAtIndex:indexPath.row];
    
    
    if ([download.currentIndex intValue] == [download.files intValue]) {
        
        //        play
        DemoVideoPlayerViewController *viewController = [[DemoVideoPlayerViewController alloc] init];
        
        viewController.downloadList = download;
        
        [self presentViewController:viewController animated:YES completion:^{
            
        }];
        
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataMArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        imgView.image = [UIImage imageNamed:@"cell_bg"];
        [cell.contentView addSubview:imgView];

        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 120, 35)];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.tag = 200;
        [cell.contentView addSubview:titleLabel];
        
//        
//        
        UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(252/2, 25, 120, 35)];
//        sizeLabel.textAlignment = NSTextAlignmentCenter;
        sizeLabel.textColor = [UIColor whiteColor];
        sizeLabel.tag = 201;
        [cell.contentView addSubview:sizeLabel];
//
//        
//        
//        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(540/2, 25, 120, 35)];
////        tipLabel.textAlignment = NSTextAlignmentCenter;
//        tipLabel.textColor = [UIColor whiteColor];
//        tipLabel.tag = 202;
//        [cell.contentView addSubview:tipLabel];
//
        [[Button share] addToView:cell.contentView  addTarget:self rect:CGRectMake(440/2, 25, 120, 35) tag:2000 action:@selector(downloadOpen:)];

    }
    
    
    DownloadList *download = self.dataMArray[indexPath.row];
    
    
    UILabel *titleLabel1 = (UILabel *)[cell.contentView viewWithTag:200];
    UILabel *titleLabel2 = (UILabel *)[cell.contentView viewWithTag:201];
//    UILabel *titleLabel3 = (UILabel *)[cell.contentView viewWithTag:202];

    UIButton *b = (UIButton *)[cell.contentView viewWithTag:2000];
    
    

    titleLabel1.text = download.title;

    titleLabel2.text = [NSString stringWithFormat:@"%@/%@", download.currentIndex, download.files];
    
    
    if ([download.currentIndex intValue] == [download.files intValue]) {
        [b setTitle:@"播放" forState:UIControlStateNormal];
    }
    else {
        [b setTitle:@"下载中" forState:UIControlStateNormal];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        NSDictionary *dict = [self.dataMArray objectAtIndex:indexPath.row];
        
        
        
        [self.dataMArray removeObject:dict];
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        
    }
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



#pragma - ToInterfaceOrientation


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return (UIInterfaceOrientationMaskLandscape);
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}




@end
