//
//  FTAutoLineView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTAutoLineView.h"
#import "UIView+Layout.h"


@implementation FTAutoLineView

@synthesize enableSideSpace;


#pragma mark Initialization

- (void)doSetup {
	enableSideSpace = YES;
}

- (id)init {
    self = [super init];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
    }
    return self;
}

#pragma mark Settings

- (void)layoutElements {
	CGFloat elementsWidth = 0;
	for (UIView *v in self.subviews) {
		elementsWidth += [v width];
	}
	int add = (enableSideSpace) ? 1 : -1;
	CGFloat step = (([self width] - elementsWidth) / ([self.subviews count] + add));
	CGFloat xPos = (enableSideSpace) ? step : 0;
	for (UIView *v in self.subviews) {
		[v positionAtX:xPos];
		xPos += (step + [v width]);
	}
}


@end
