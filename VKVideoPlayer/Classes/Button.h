//
//  Button.h
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Button : NSObject



+ (id)share;


- (UIButton *)addToView:(UIView *)view
               addTarget:(id)target
                     rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action
                imagePath:(NSString *)imagePath
     highlightedImagePath:(NSString *)highlightedImagePath
        SelectedImagePath:(NSString *)SelectedImagePath
;

- (UIButton *)addToView:(UIView *)view
              addTarget:(id)target
                     rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action
                imagePath:(NSString *)imagePath
     highlightedImagePath:(NSString *)highlightedImagePath;

- (UIButton *)addToView:(UIView *)view
              addTarget:(id)target
                     rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action
                imagePath:(NSString *)imagePath;

- (UIButton *)addToView:(UIView *)view
              addTarget:(id)target
                     rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action;



@end
