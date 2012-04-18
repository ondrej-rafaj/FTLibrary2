//
//  FTError.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FTError : NSError

+ (FTError *)errorWithError:(NSError *)error;
+ (FTError *)errorWithTitle:(NSString *)title andDescription:(NSString *)description;

- (void)showAsAlertViewWithDelegate:(id <UIAlertViewDelegate>)delegate;
- (void)showInConsole;

@end
