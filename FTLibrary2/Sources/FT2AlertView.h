//
//  FT2AlertView.h
//  FT2Library
//
//  Created by Baldoph Pourprix on 19/02/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FT2AlertView : UIAlertView <UIAlertViewDelegate>

- (id)initWithTitle:(NSString *)title message:(NSString *)message actionBlock:(void (^)(NSInteger clikedButtonIndex))actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

+ (id)showAlertViewWithTitle:(NSString *)title message:(NSString *)message actionBlock:(void (^)(NSInteger clikedButtonIndex))actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, copy) void (^actionBlock)(NSInteger clikedButtonIndex);

@end
