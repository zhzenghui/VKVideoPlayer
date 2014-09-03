//
//  RootViewController.m
//  VKVideoPlayer
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/20/14.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "DemoRootViewController.h"
#import "VKVideoPlayerViewController.h"
#import "DemoVideoPlayerViewController.h"
#import "VKVideoPlayerCaptionSRT.h"

#import "ZHm3u8.h"


#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "UIImage+ImageEffects.h"
#import "SettingViewController.h"
#import "AFNetworking.h"

#import "ZHFileCache.h"

#import "SVPullToRefresh.h"


typedef enum {
  DemoVideoPlayerIndexDefaultViewController = 0,
  DemoVideoPlayerIndexCustomViewController,
  DemoVideoPlayerIndexLength,
} DemoVideoPlayerIndex;

@interface DemoRootViewController ()
{
    int curPage;
    int maxPage;
    
    bool isInfiniteScroll;

}
@end

@implementation DemoRootViewController


- (void)insertRowAtTop {
    
    [self.dataMArray removeAllObjects];
    self.dataMArray = nil;
    [self.tableView reloadData];
    
    curPage = 1;
    
    [self loadNetWorkData];
    
}

- (void)addBottom
{
    
    if (self.dataMArray.count == KPageSize && !isInfiniteScroll) {
        
        isInfiniteScroll = true;
        __weak DemoRootViewController *weakSelf = self;
        
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtBottom];
        }];
    }
}

- (void)insertRowAtBottom {
    
    curPage = 0;
    
    [self loadNetWorkData];
    
}


#pragma mark - view


- (void)loadView
{
    [super loadView];
    isInfiniteScroll = false;
    
    self.dataMArray = [[NSMutableArray alloc] init];
    self.dataMDict = [[NSMutableDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doubelClicked)name:@"doubelClicked"object:nil];
    
    
    
    
    
    _tableView = [[UITableView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource =  self;
    
    
    //    _tableView.pagingEnabled = YES;
    _tableView.frame = CGRectMake(0, 0, 320, screen_Height);
    
    [self.view  addSubview:_tableView];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    
    
    self.dataMArray = [[NSMutableArray alloc] init];
    
    
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(openMovieTickets:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_tableView addGestureRecognizer:recognizer];
    
    
    //    [self loadNetWorkData];
    
    __weak DemoRootViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    [weakSelf.tableView triggerPullToRefresh];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)arrConverToMarr:(NSArray *)array
{
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:dict];
        [mArray addObject:d];
        
    }
    
    return mArray;
}

- (void)addArray:(NSMutableArray *)array
{
    
    for (NSMutableDictionary *dict in array) {
        [self.dataMArray addObject:dict];
    }
}

#pragma mark - network
- (void)loadNetWorkData
{
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@movie/getlist.php?dir=pull&timer=%d&num=%d", KHomeUrl,  0, KPageSize];
    
    
    if (curPage == 0) {
        NSString *timestmp = [[self.dataMArray lastObject] objectForKey:@"timer"];
        
        url = [NSString stringWithFormat:@"%@movie/getlist.php?dir=push&timer=%@&num=%d", KHomeUrl, timestmp, KPageSize];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
    }
    else {
        url = [NSString stringWithFormat:@"%@movie/getlist.php?dir=pull&timer=%d&num=%d", KHomeUrl, 0, KPageSize];
        
    }
    
    __weak DemoRootViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSMutableArray *array = [self arrConverToMarr: [responseObject objectForKey:@"rv"]];
        
        if (array .count != 0) {
            
            if (self.dataMArray.count == 0) {
                
                self.dataMArray = [NSMutableArray arrayWithArray:array];
                [self.tableView reloadData];
                [weakSelf.tableView.pullToRefreshView stopAnimating];
                
            }
            else {
                
                
                
                [self addArray:array];
                [self.tableView reloadData];
                
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                
            }
            
            
            [self addBottom];
        }
        else {
            
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        
    }];
}



- (void)openMovieTickets:(UIButton *)button
{
    //
    //    MovieTicketsViewController *vc = [[MovieTicketsViewController alloc] init ];
    //
    //    [self addChildViewController:vc];
    //    [self.view addSubview:vc.view];
    //    vc.view.frame = CGRectMake(screen_Width, 0, screen_Width, screen_Height);
    //
    //    [UIView animateWithDuration:KMiddleDuration animations:^{
    //        vc.view.frame = CGRectMake(0, 0, screen_Width, screen_Height);
    //    }];
}

- (void)backCell:(UIButton *)button
{
    
    
    self.tableView.scrollEnabled = YES;
    
    
    
    UITableViewCell *cell = (UITableViewCell *)[[[[button superview] superview] superview] superview];
    
    
    UIView *view = [cell viewWithTag:102];
    view.alpha = 0;
    
    
}

- (VKVideoPlayerCaption*)testCaption:(NSString*)captionName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:captionName ofType:@"srt"];
    NSData *testData = [NSData dataWithContentsOfFile:filePath];
    NSString *rawString = [[NSString alloc] initWithData:testData encoding:NSUTF8StringEncoding];
    
    VKVideoPlayerCaption *caption = [[VKVideoPlayerCaptionSRT alloc] initWithRawString:rawString];
    return caption;
}

- (void)playMovie:(UIButton *)button
{
    
    //    NSDictionary *dict = @{@"name": @"Chuang-King" ,@"url": @"http://screencasts.b0.upaiyun.com/assets/episodes/video/006-tags.mp4"};
    
    UITableViewCell *cell = (UITableViewCell *)[[[[button superview] superview] superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = [self. dataMArray objectAtIndex:indexPath.row];
    

    DLog(@"%@", dict[@"url"]);
    DemoVideoPlayerViewController *viewController = [[DemoVideoPlayerViewController alloc] init];

    viewController.url = [NSURL URLWithString:dict[@"url"]];

    [self presentViewController:viewController animated:YES completion:^{
        
    }];


}


- (void)openSetting:(UIButton *)button
{
    
    
    UITableViewCell *cell = (UITableViewCell *)[[[[button superview] superview] superview] superview];
    
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    
    
    
    SettingViewController *vc = [[SettingViewController alloc] init];
    //    vc.image = imageView.image;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    vc.view.alpha = 0;
    [UIView animateWithDuration:KMiddleDuration animations:^{
        vc.view.alpha = 1;
    }];
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
    return screen_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"daliy_cell_bg"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 100;
        
        imageView.frame = CGRectMake(0, 0, 320, screen_Height);
        [cell.contentView addSubview:imageView];
        
        
        
        
        
        
        UIView *view = [[UIView alloc] init];
        view.userInteractionEnabled = YES;
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cxc"]];
        view.tag = 102;
        view.alpha = 0;
        view.frame = self.view.frame;
        [cell.contentView addSubview:view];
        
        
        UIImageView *imageView1 = [[UIImageView alloc] init];
        imageView1.tag = 101;
        imageView1.frame = CGRectMake(0, 0, 320, screen_Height);
        [view addSubview:imageView1];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"movie_title"]];
        titleLabel.tag = 200;
        [view addSubview:titleLabel];
        
        
        
        
        UIView *black = [[UIView alloc] initWithFrame:CGRectMake(0, screen_Height-150, screen_Width, 150)];
        black.backgroundColor = [UIColor blackColor];
        black.alpha = .8;
        
        [view addSubview:black];
        
        
        
        
        [[Button share] addToView:view addTarget:self rect:RectMake2x(228, 358, 177,    176)  tag:101 action:@selector(playMovie:) imagePath:@"play" ];
        
        [[Button share] addToView:black addTarget:self rect:CGRectMake( 0, 0, 320, 50) tag:101 action:@selector(backCell:) imagePath:@"fanhui" ];
        
        [[Button share] addToView:black addTarget:self rect:CGRectMake(0, 50, 320, 50) tag:101 action:@selector(openMovieTickets:) imagePath:@"dianyingpiao" ];
        
        [[Button share] addToView:black addTarget:self rect:CGRectMake(0, 100, 320, 50) tag:101 action:@selector(openSetting:) imagePath:@"shezhi"];
        
        
    }
    
    
    __block UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:100];
    __block UIImageView *imageView1 = (UIImageView *)[cell.contentView viewWithTag:101];
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:200];
    
    
    
    
    
    NSMutableDictionary *dict = [self.dataMArray objectAtIndex:indexPath.row];
    
    titleLabel.text = [dict objectForKey:@"title"];
    
    NSString *urlString = nil;
    if (is40) {
        urlString =   [dict objectForKey:@"pic4"]  ;
        
    }
    else {
        urlString =  [dict objectForKey:@"pic35"]  ;
        
    }
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    
    //    if ( ! [dict objectForKey:@"effect"]  ) {
    //
    //
    [imageView setImageWithURL:[NSURL URLWithString:urlString]
              placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                         
                         if (image)
                         {
                             
                             const char *charLabel = [urlString UTF8String];
                             
                             dispatch_queue_t queue = dispatch_queue_create(charLabel, NULL);
                             
                             dispatch_async(queue, ^(void) {
                                 //                                     NSLog(@"current %@",  [dict objectForKey:@"title"]);
                                 NSData *data =  [[ZHFileCache share] file: [dict objectForKey:@"title"]];
                                 //
                                 if ( data ) {
                                     
                                     if (indexPath.row == 0) {
                                         
                                         UIImage *i = [UIImage imageWithData:data];
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             imageView1.image = i;
                                             
                                         });
                                     }
                                 }
                                 else {
                                     
                                     UIImage *i =  [image applyLightEffect];
                                     NSData *imageData = UIImageJPEGRepresentation(i, .8);
                                     
                                     [[ZHFileCache share] saveFile:imageData fileName: titleLabel.text];
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         
                                         imageView1.image = i;
                                     });
                                 }
                                 //
                                 
                                 
                                 
                             });
                         }
                     }];
    //
    //
    //    }
    //    else {
    //        imageView.image = [dict objectForKey:@"image"];
    //        imageView1.image = [dict objectForKey:@"effect"];
    //    }
    
    
    
    
    
    
    
    
    
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *view = (UIView *) [cell viewWithTag:102];
    tableView.scrollEnabled = NO;
    
    
    
    [UIView animateWithDuration:KMiddleDuration animations:^{
        view.alpha = 1;
    }];
    
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    
    [imageView.image applyLightEffect];
    
}

#pragma mark - scrollview

- (void)scrollTableview
{
    if (self.dataMArray.count == 0) {
        return;
    }
    
    
    
    int i = round(self.tableView.contentOffset.y / screen_Height);
    
    
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    __block UIImageView *imageView1 = (UIImageView *)[cell.contentView viewWithTag:101];
    NSMutableDictionary *dict = [self.dataMArray objectAtIndex: i  ];
    
    
    NSLog(@"load  %@", [dict objectForKey:@"title"]);
    NSData *data =  [[ZHFileCache share] file: [dict objectForKey:@"title"]];
    
    if ( data ) {
        UIImage *i = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView1.image = i;
        });
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    
    NSLog(@"%hhd", decelerate);
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(scrollTableview) userInfo:nil repeats:NO];
    
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    //    int i = round(scrollView.contentOffset.y / screen_Height);
    //    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self scrollTableview ];
}


//// called on start of dragging (may require some time and or distance to move)
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewWillBeginDragging");
//}
//// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
//{
//    NSLog(@"scrollViewWillEndDragging");
//
//}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndScrollingAnimation");
    
    [self scrollTableview];
    
    
}// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating


//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2){
//    NSLog(@"scrollViewWillBeginZooming");
//
//}// called before the scroll view begins zooming its content
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    NSLog(@"scrollViewDidEndZooming");
//
//}// scale between minimum and maximum. called after any 'bounce' animations

//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
//
//}
// return a yes if you want to scroll to the top. if not defined, assumes YES
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
//    NSLog(@"scrollViewDidScrollToTop");
//
//}// called when scr

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat scrollViewContentHeight =  scrollView.contentSize.height;
//    CGFloat scrollOffsetThreshold = scrollViewContentHeight- scrollView.bounds.size.height;
//
//
//    if (scrollView.contentOffset.y < 0) {
//        scrollView.contentOffset = CGPointMake(0, -5);
//    }
//
//}


#pragma mark - UIInterfaceOrientation

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait ;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}


- (BOOL)shouldAutorotate {
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationMaskPortrait);
}
#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//  Class vcClass = NSClassFromString(cell.textLabel.text);
//  UIViewController *viewController = [[vcClass alloc] init];
//  
//  [self presentModalViewController:viewController animated:YES];
//  
//  if ([viewController isKindOfClass:[VKVideoPlayerViewController class]]) {
//    VKVideoPlayerViewController *videoController = (VKVideoPlayerViewController*)viewController;
//    [videoController playVideoWithStreamURL:[NSURL URLWithString:@"http://localhost:12345/ios_240.m3u8"]];
//    [videoController setSubtitle:[self testCaption:@"testCaptionBottom"]];
//    
//    [videoController.player setCaptionToTop:[self testCaption:@"testCaptionTop"]];
//  }
//}

@end
