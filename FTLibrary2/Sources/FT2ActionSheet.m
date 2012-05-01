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

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [super initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
	if (self) {
		
	}
	return self;
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
