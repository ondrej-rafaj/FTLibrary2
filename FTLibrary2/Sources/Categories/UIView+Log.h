//
//  UIView+Log.h
//  FTLibrary2
//
//  Created by A.Papadakis on 13/09/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Log)

/* logFrameWithPrefix: will print out a log of the frame of the view
 along with a prefix. If,for instance the prefix is @"self.view" it will print out
 self.view --frame = {{0,0},{320,460}}
 */
- (void)logFrameWithPrefix:(NSString *)prefix;
- (void)logSizeWithPrefix:(NSString *)prefix;
- (void)logOriginWithPrefix:(NSString *)prefix;
- (void)logBottomWithPrefix:(NSString *)prefix;
@end
