//
//  ZuiJinViewController.h
//  Movie
//
//  Created by i-Bejoy on 14-1-3.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "AllBaseViewController.h"

@interface ZuiJinViewController : AllBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *dataMArray;






@end
