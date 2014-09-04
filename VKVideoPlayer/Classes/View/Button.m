//
//  Button.m
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "Button.h"

static Button *button;

@implementation Button

+ (id)share
{
    if (button) {
        return button;
    }
    button = [[Button alloc] init];
    return button;
}

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}




- (UIButton *)addToView:(UIView *)view
              addTarget:(id)target
                     rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action
                imagePath:(NSString *)imagePath
     highlightedImagePath:(NSString *)highlightedImagePath
        SelectedImagePath:(NSString *)SelectedImagePath

{
    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //    button.backgroundColor = [UIColor clearColor];
    //    [button.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5].CGColor];
    
//    CALayer *layer = button.layer;
//    layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    
    [button setAdjustsImageWhenHighlighted:YES];
    
    [button setImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
    if (highlightedImagePath) {
        [button setImage:[UIImage imageNamed:highlightedImagePath] forState:UIControlStateHighlighted];
    }
    if (SelectedImagePath) {
        [button setImage:[UIImage imageNamed:SelectedImagePath] forState:UIControlStateSelected];
    }


    
    button.frame = rect;
    button.tag = tag;
    
    [view addSubview:button];
    
    return button;
}


- (UIButton *)addToView:(UIView *)view
              addTarget:(id)target
                   rect:(CGRect)rect
                    tag:(int)tag
                 action:(SEL)action
              imagePath:(NSString *)imagePath
   highlightedImagePath:(NSString *)highlightedImagePath
{
    
    return [self addToView:view addTarget:target rect:rect tag:tag action:action imagePath:imagePath highlightedImagePath:highlightedImagePath SelectedImagePath:nil];
    
}


- (UIButton *)addToView:(UIView *)view
              addTarget:(id)target
                     rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action
                imagePath:(NSString *)imagePath
{
    
    
    return [self addToView:view addTarget:target rect:rect tag:tag action:action imagePath:imagePath highlightedImagePath:nil];
}




- (UIButton *)addToView:(UIView *)view
              addTarget:(id)target
                     rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action

{
    return [self addToView:view addTarget:target rect:rect tag:tag action:action imagePath:nil highlightedImagePath:nil];
}

@end
