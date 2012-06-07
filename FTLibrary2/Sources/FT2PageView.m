//
//  FT2PageView.m
//  FT2Library
//
//  Created by Baldoph Pourprix on 13/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FT2PageView.h"
#import "FT2ReusableView.h"
#import "UIView+Layout.h"

@interface FT2PageView ()
@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL usedAsContainer;
@property (nonatomic, strong) UIView *containedView;
@end

@implementation FT2PageView
@synthesize index = _index;
@synthesize usedAsContainer = _usedAsContainer;
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize containedView = _containedView;
@synthesize contentView = _contentView;

#pragma mark - Object lifecycle

- (id)initWithReuseIdentifier:(NSString *)identifier
{
	self = [super initWithFrame:CGRectMake(0, 0, 320, 320)];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		_reuseIdentifier = identifier;
		
		_contentView = [[UIView alloc] initWithFrame:self.bounds];
		_contentView.backgroundColor = [UIColor clearColor];
		_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:_contentView];
	}
	return self;
}

#pragma mark - Setters

- (void)setContainedView:(UIView *)containedView
{
	[_containedView removeFromSuperview];
	_containedView = containedView;
	_containedView.frame = self.bounds;
	[self addSubview:containedView];
	[containedView centerInSuperview];
}

#pragma mark - ReusableView Protocol

- (void)prepareForReuse
{
	
}

- (void)willBeDiscarded
{
	
}

@end
