//
//  Message.h
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//


#import <Foundation/Foundation.h>



@interface Message : NSObject
{
}

@property(nonatomic,assign) id <UIAlertViewDelegate> delegate;


+ (id)share;


- (void)messageAlert:(NSString *)message delegate:(id)delegate;

- (void)messageAlert:(NSString *)message;


- (void)messagePrompt:(NSString *)message;


@end




@protocol MessageDelegate <NSObject>
@optional

@end

