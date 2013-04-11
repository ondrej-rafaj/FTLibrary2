//
//  EQOperation.m
//  Equili
//
//  Created by Baldoph on 29/03/2013.
//  Copyright (c) 2013 Coronal Sky. All rights reserved.
//

#import "FT2Operation.h"

@implementation FT2Operation

- (id)initWithBlock:(void (^)(FT2Operation *operation))block
{
	self = [super init];
	if (self) {
		if (block) _block = [block copy];
	}
	return self;
}

- (void)main
{
	if (!self.isCancelled) {
		__weak FT2Operation *wself = self;
		if (_block) _block(wself);
		else NSLog(@"EQOperation %@ was started without a block", self);
	}
}

@end
