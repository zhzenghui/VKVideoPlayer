//
//  RecommendViewController.h
//  Movie
//
//  Created by i-Bejoy on 14-1-3.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "AllBaseViewController.h"

@interface RecommendViewController : AllBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic,retain) UITableView *tableView;


@end
