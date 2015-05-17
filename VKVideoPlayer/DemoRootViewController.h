//
//  RootViewController.h
//  VKVideoPlayer
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/20/14.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

enum {
	State_Stopped = 0,
    State_Triggered,
    State_Loading,
    State_All = 10
};
typedef NSUInteger State;


#import "AllBaseViewController.h"
#import <UIKit/UIKit.h>

@interface DemoRootViewController :  AllBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSTimer *timer;
}

@property(nonatomic,retain) UITableView *tableView;
@property (nonatomic, assign) State state;





@property(nonatomic, strong) NSMutableArray *dataMArray;
@property(nonatomic, strong) NSMutableDictionary *dataMDict;


@end
