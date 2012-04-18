//
//  FTShareFacebook.h
//  FTShareView
//
//  Created by cescofry on 06/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//
//Use http://developers.facebook.com/docs/reference/dialogs/feed/ to see how to use those parameters

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "FT2ShareMessageController.h"

#pragma mark --
#pragma mark Data Type

typedef enum {
    FTShareFacebookPermissionNull       = 0 << 0,
    FTShareFacebookPermissionRead       = 1 << 0,
    FTShareFacebookPermissionPublish    = 1 << 1,
    FTShareFacebookPermissionOffLine    = 1 << 2
} FTShareFacebookPermission;

typedef enum {
    FTShareFacebookRequestTypePost,
    FTShareFacebookRequestTypeFriends,
    FTShareFacebookRequestTypeAlbum,
    FTShareFacebookRequestTypeOther
} FTShareFacebookRequestType;

typedef enum {
    FTShareFacebookHttpTypeGet,
    FTShareFacebookHttpTypePost,
    FTShareFacebookHttpTypeDelete,
} FTShareFacebookHttpType;

@interface FTShareFacebookPhoto : NSObject {
    UIImage *__unsafe_unretained _photo;
    NSString *__unsafe_unretained _album;
    NSString *__unsafe_unretained _message;
    NSMutableArray *__unsafe_unretained _tags;
    
}

@property (unsafe_unretained, nonatomic) UIImage *photo;
@property (unsafe_unretained, nonatomic) NSString *album;
@property (unsafe_unretained, nonatomic) NSString *message;
@property (unsafe_unretained, nonatomic) NSMutableArray *tags;

+ (id)facebookPhotoFromImage:(UIImage *)image;
- (void)addTagToUserID:(NSString *)userID atPoint:(CGPoint)point;
- (NSString *)tagsAsString;

@end

@interface FTShareFacebookData : NSObject {
    NSString *__unsafe_unretained _message;
    NSString *__unsafe_unretained _link;
    NSString *__unsafe_unretained _name;
    NSString *__unsafe_unretained _caption;
    NSString *__unsafe_unretained _picture;
    NSString *__unsafe_unretained _description;
    BOOL _hasControllerSupport;
    FTShareFacebookRequestType _type;
    FTShareFacebookHttpType _httpType;
    
    FTShareFacebookPhoto  *__unsafe_unretained _uploadPhoto;
    
}

@property (unsafe_unretained, nonatomic) NSString *message;
@property (unsafe_unretained, nonatomic) NSString *link;
@property (unsafe_unretained, nonatomic) NSString *name;
@property (unsafe_unretained, nonatomic) NSString *caption;
@property (unsafe_unretained, nonatomic) NSString *picture;
@property (unsafe_unretained, nonatomic) NSString *description;
@property (nonatomic, assign) BOOL hasControllerSupport;
@property (unsafe_unretained, nonatomic) FTShareFacebookPhoto *uploadPhoto;
@property (nonatomic, assign) FTShareFacebookRequestType type;
@property (nonatomic, assign) FTShareFacebookHttpType httpType;

- (NSMutableDictionary *)dictionaryFromParams;
- (NSString *)graphPathForType;
- (NSString *)graphHttpTypeString;
- (BOOL)isRequestValid;

@end


#pragma mark --
#pragma mark Class

@protocol FTShareFacebookDelegate;
@interface FT2ShareFacebook : NSObject <FBRequestDelegate, FBSessionDelegate, FBDialogDelegate, FTShareMessageControllerDelegate> {
    Facebook *_facebook;
    id <FTShareFacebookDelegate> __unsafe_unretained _facebookDelegate;
    id _referencedController;
    FTShareFacebookData *_params;
    NSArray *__unsafe_unretained _permissions;
}

@property (nonatomic) Facebook *facebook;
@property (nonatomic, unsafe_unretained) id<FTShareFacebookDelegate> facebookDelegate;
@property (nonatomic, readonly) FTShareFacebookData *params;
@property (unsafe_unretained, nonatomic, readonly) NSArray *permissions;

- (void)setUpFacebookWithAppID:(NSString *)appID referencedController:(id)referencedController andDelegate:(id<FTShareFacebookDelegate>)delegate;
- (void)setUpPermissions:(FTShareFacebookPermission)permission;
- (void)shareViaFacebook:(FTShareFacebookData *)data;
- (void)authorize;



#pragma mark --
#pragma mark Delegate

@end

@protocol FTShareFacebookDelegate <NSObject>

@optional

- (FTShareFacebookData *)facebookShareData;
- (NSString *)facebookPathForRequestofMethodType:(NSString **)httpMethod;
- (void)facebookLoginDialogController:(UIViewController *)controller;
- (void)facebookDidLogin:(NSError *)error;
- (void)facebookDidPost:(NSError *)error;
- (void)facebookDidReceiveResponse:(id)response;

@end


