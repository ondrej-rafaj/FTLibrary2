//
//  FT2Error.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FT2Error : NSError

+ (FT2Error *)errorWithError:(NSError *)error;
+ (FT2Error *)errorWithTitle:(NSString *)title andDescription:(NSString *)description;

- (void)showAsAlertViewWithDelegate:(id <UIAlertViewDelegate>)delegate;
- (void)showInConsole;
- (void)sendToFlurry;

@end
