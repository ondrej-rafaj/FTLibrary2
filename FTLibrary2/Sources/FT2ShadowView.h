//
//  FTShadowView.h
//  FTLibrary2
//
//  Created by Baldoph on 22/08/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

/* A view that contains a rectangular shadow */

@interface FT2ShadowView : UIView

@property (nonatomic) UIColor *shadowColor;
@property (nonatomic) CGFloat shadowRadius;
/* basically, the number of time the shadow will be drawn, making it darker
 * and darker */
@property (nonatomic) NSInteger shadowStrength;

@end
