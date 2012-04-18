//
//  UBTiwtterMessageView.h
//  UBMMedia
//
//  Created by Francesco on 09/01/2012.
//  Copyright (c) 2012 Lost Bytes. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FTShareMessageControllerTypeFacebook,
    FTShareMessageControllerTypeTwitter
} FTShareMessageControllerType;

@protocol FTShareMessageControllerDelegate;
@interface FTShareMessageController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, unsafe_unretained) id<FTShareMessageControllerDelegate> delegate;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UILabel *charsLeftLabel;
@property (nonatomic, assign) FTShareMessageControllerType type;

- (id)initWithMessage:(NSString *)message type:(FTShareMessageControllerType)type andelegate:(id)delegate;

@end

@protocol FTShareMessageControllerDelegate <NSObject>

- (void)shareMessageController:(FTShareMessageController *)controller didFinishWithMessage:(NSString *)message;
- (void)shareMessageControllerDidCancel:(FTShareMessageController *)controller;
- (void)shareMessageController:(FTShareMessageController *)controller didDisappearWithMessage:(NSString *)message;

@end
