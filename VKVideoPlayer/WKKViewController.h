//
//  WKKViewController.h
//  CameraWithAVFoudation
//
//  Created by 可可 王 on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"


@class Customer;
@class Note;
@interface WKKViewController : UIViewController
{
    UIView *RealView;
    
    UIButton *submitButton;
    UIButton *redoButton;
    UIButton *backButton;
}
@property (retain, nonatomic) UIView *RealView;
@property (retain, nonatomic) IBOutlet UIView *liveView;
@property (retain, nonatomic) IBOutlet UIImageView *Preview;


@property (weak, nonatomic) IBOutlet UIView *showView;




@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) Customer *customer;


- (IBAction)back:(id)sender;
- (IBAction)redoPhoto:(id)sender;
- (IBAction)updateImage:(id)sender;
- (IBAction)saveImage:(id)sender;

@end
