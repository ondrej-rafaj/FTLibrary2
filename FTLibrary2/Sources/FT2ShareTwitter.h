//
//  FTShareTwitter.h
//  FTShareView
//
//  Created by cescofry on 06/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "FT2ShareMessageController.h"

#pragma mark --
#pragma mark Data Type

@interface FTShareTwitterData : NSObject {
    NSString *__unsafe_unretained _message;
    BOOL _hasControllerSupport;
}

@property (unsafe_unretained, nonatomic) NSString *message;
@property (nonatomic, assign) BOOL hasControllerSupport;

- (BOOL)isRequestValid;

@end



#pragma mark --
#pragma mark Class


@protocol FTShareTwitterDelegate;
@interface FT2ShareTwitter : NSObject <SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterEngineDelegate, FTShareMessageControllerDelegate> {
    SA_OAuthTwitterEngine *_twitter;
    id <FTShareTwitterDelegate> __unsafe_unretained _twitterDelegate;
    FTShareTwitterData *__unsafe_unretained _twitterParams;
    id _referencedController;
}

@property (nonatomic, unsafe_unretained) id<FTShareTwitterDelegate> twitterDelegate;
@property (unsafe_unretained, nonatomic, readonly) FTShareTwitterData *twitterParams;

- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret referencedController:(id)referencedController andDelegate:(id<FTShareTwitterDelegate>)delegate;
- (void)shareViaTwitter:(FTShareTwitterData *)data;
@end



#pragma mark --
#pragma mark Delegate

@protocol FTShareTwitterDelegate <NSObject>

@optional

- (FTShareTwitterData *)twitterData;
- (void)twitterLoginDialogController:(UIViewController *)controller;
- (void)twitterDidLogin:(NSError *)error;
- (void)twitterDidPost:(NSError *)error;

@end
