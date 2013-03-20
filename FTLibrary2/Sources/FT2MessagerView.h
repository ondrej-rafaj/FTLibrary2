//
//  FT2MessagerView.h
//  FTLibrary2
//
//  Created by Baldoph on 21/08/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

/* This class always returns the recipientView in the hitTest method
 * You can use it to extend the scrollable area around some scrollView's bounds
 * for example */

@interface FT2MessagerView : UIView

@property (nonatomic, strong) UIView *recipientView;

@end
