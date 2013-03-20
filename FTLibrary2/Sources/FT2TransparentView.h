//
//  FT2TransparentView.h
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/* This class is meant to be used as a container for other views.
 * It doesn't intercept touches that are not for one of its subviews. */

@interface FT2TransparentView : UIView

@property (nonatomic) NSInvocation *didTouchVoid;
@property (nonatomic) NSInvocation *didTouchContent;

@end
