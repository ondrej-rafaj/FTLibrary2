//
//  FT2ActionSheet.m
//  FT2Library
//
//  Created by Baldoph Pourprix on 19/02/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FT2ActionSheet.h"

@implementation FT2ActionSheet

@synthesize cancelBlock = _cancelBlock;
@synthesize destructiveBlock = _destructiveBlock;
@synthesize actionBlock = _actionBlock;

- (void)setDestructiveBlock:(void (^)(void))destructiveBlock
{
	_destructiveBlock = [destructiveBlock copy];
	self.delegate = self;
}

- (void)setCancelBlock:(void (^)(void))cancelBlock
{
	_cancelBlock = [cancelBlock copy];
	self.delegate = self;
}

- (void)setActionBlock:(void (^)(NSInteger))actionBlock
{
	_actionBlock = [actionBlock copy];
	self.delegate = self;
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == self.cancelButtonIndex) {
		if (_cancelBlock) _cancelBlock(); 
	} else if (buttonIndex == self.destructiveButtonIndex) {
		if (_destructiveBlock) _destructiveBlock();
	} else {
		if (_actionBlock) _actionBlock(buttonIndex);
	}
}

@end
