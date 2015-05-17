//
//  DownLoadListViewController.h
//  Movie
//
//  Created by i-Bejoy on 14-1-3.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "AllBaseViewController.h"
#import "ZHm3u8.h"


@interface DownLoadListViewController : AllBaseViewController<UITableViewDataSource, UITableViewDelegate, ZHm3u8Delegate>
{
    
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *dataMArray;


@end
