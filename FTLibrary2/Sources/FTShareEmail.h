//
//  FTShareEmail.h
//  FTShareView
//
//  Created by cescofry on 06/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

#pragma mark --
#pragma mark Data Type

@interface FTShareEmailData : NSObject {
    NSString *__unsafe_unretained _subject;
    NSString *__unsafe_unretained _plainBody;
    NSString *__unsafe_unretained _htmlBody;
@private
    NSMutableArray *_attachments;
}

@property (unsafe_unretained, nonatomic) NSString *subject;
@property (unsafe_unretained, nonatomic) NSString *plainBody;
@property (unsafe_unretained, nonatomic) NSString *htmlBody;
@property (nonatomic, readonly) NSMutableArray *attachments;

- (void)addAttachmentWithObject:(id)obj type:(NSString *)type andName:(NSString *)name;
- (BOOL)isRequestValid;

@end


#pragma mark --
#pragma mark Class

@protocol FTShareEmailDelegate;
@interface FTShareEmail : NSObject <MFMailComposeViewControllerDelegate, MFMailComposeViewControllerDelegate> {

    id _referencedController;
}

@property (nonatomic, unsafe_unretained) id <FTShareEmailDelegate> mailDelegate;

- (void)setUpEmailWithRefencedController:(id)controller andDlelegate:(id<FTShareEmailDelegate>)delegate;
- (void)shareViaMail:(FTShareEmailData *)data;

@end


#pragma mark --
#pragma mark Delegate

@protocol FTShareEmailDelegate <NSObject>

@optional

- (FTShareEmailData *)mailShareData;
- (void)mailSent:(MFMailComposeResult)result;

@end
