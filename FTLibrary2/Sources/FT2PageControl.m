//
//  FTPageControl.m
//  FTLibrary
//
//  Created by Baldoph Pourprix on 04/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FT2PageControl.h"

@interface FT2PageControl ()

@property (nonatomic) UIImage *internUnselectedDotImage;
@property (nonatomic) UIImage *internSelectedDotImage;

- (UIImage *)_defaultImageDotWithRadius:(CGFloat)radius andColor:(UIColor *)color;
- (UIImage *)_customImageDotWithMaskImage:(UIImage *)maskImage andColor:(UIColor *)color;
- (void)_updateCurrentPageDisplay;
- (void)_updateIndicatorsIfNeeded;

@end

@implementation FT2PageControl

@synthesize numberOfPages = _numberOfPages;
@synthesize currentPage = _currentPage;
@synthesize hidesForSinglePage;
@synthesize defersCurrentPageDisplay;

@synthesize selectedDotColor = _selectedDotColor;
@synthesize unselectedDotColor = _unselectedDotColor;
@synthesize dotRadius = _dotRadius;
@synthesize dotsSpacing = _dotsSpacing;
@synthesize internUnselectedDotImage = _internUnselectedDotImage;
@synthesize internSelectedDotImage = _internSelectedDotImage;
@synthesize dotMask = _dotMask;
@synthesize unselectedDotImage = _unselectedDotImage;
@synthesize selectedDotImage = _selectedDotImage;

#pragma mark - User Interaction

- (void)indicatorAction:(UIButton *)indicator
{
	self.currentPage = [_indicators indexOfObject:indicator];
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Dot image generation

- (UIImage *)_defaultImageDotWithRadius:(CGFloat)radius andColor:(UIColor *)color
{
	CGFloat screenScale = [UIScreen mainScreen].scale;
	CGFloat imageWidth = radius * 2;
	CGRect dotRect = CGRectMake(0, 0, imageWidth, imageWidth);
	UIGraphicsBeginImageContextWithOptions(dotRect.size, NO, screenScale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[color setFill];
	CGContextFillEllipseInRect(context, dotRect);
	UIImage *dotImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return dotImage;
}

- (UIImage *)_customImageDotWithMaskImage:(UIImage *)maskImage andColor:(UIColor *)color
{
	CGFloat screenScale = [UIScreen mainScreen].scale;

	CGRect dotRect = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
	UIGraphicsBeginImageContextWithOptions(dotRect.size, NO, screenScale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[color setFill];
	CGContextClipToMask(context, dotRect, maskImage.CGImage);
	CGContextFillRect(context, dotRect);
	UIImage *dotImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return dotImage;
}

#pragma mark - View lifecycle

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.clipsToBounds = NO;
		self.backgroundColor = [UIColor clearColor];
		
		_unselectedDotColor = [UIColor colorWithWhite:1.f alpha:0.5f];
		_selectedDotColor = [UIColor whiteColor];
		_dotRadius = 3.f;
		_dotsSpacing = 10.f;
		_numberOfPages = 0;
		_currentPage = 0;
		_displayedPage = 0;
		_indicators = [NSMutableArray new];
		_pageControlFlags.hideForSinglePage = NO;
		_pageControlFlags.defersCurrentPageDisplay = NO;
		_pageControlFlags.changeInSelectedColor = YES;
		_pageControlFlags.changeInUnselectedColor = YES;
	}
	return self;
}

- (void)layoutSubviews
{
	[self _updateIndicatorsIfNeeded];
	
	if (_pageControlFlags.changeInLayout) {
		
		CGSize sizeThatFit = [self sizeThatFits:CGSizeZero];
		
		CGFloat xOffset = (CGRectGetWidth(self.bounds) - sizeThatFit.width) / 2;
		CGFloat dotWidth = (_unselectedDotImage) ? _unselectedDotImage.size.width : 2 * _dotRadius;
		
		for (int i = 0; i < _numberOfPages; i++) {
			UIButton *button = [_indicators objectAtIndex:i];
			CGRect buttonFrame = button.frame;
			
			buttonFrame.origin.x = xOffset + i * (dotWidth + _dotsSpacing);
			buttonFrame.origin.y = 0;
			buttonFrame.size.width = _dotsSpacing + dotWidth;
			
			button.frame = buttonFrame;			
		}
		
		_pageControlFlags.changeInLayout = NO;
	}
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	_pageControlFlags.changeInLayout = YES;
	[self setNeedsLayout];
}

#pragma mark - Custom Setters

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
	if (_numberOfPages != numberOfPages) {
		_numberOfPages = numberOfPages;
		
		_pageControlFlags.changeInLayout = YES;
		
		self.hidden = (_pageControlFlags.hideForSinglePage && _numberOfPages <= 1);
		
		if (_currentPage >= numberOfPages) self.currentPage = numberOfPages - 1;
		
		[self setNeedsLayout];
	}
}

- (void)setCurrentPage:(NSInteger)currentPage
{
	if (currentPage != _currentPage) {
		if (currentPage < 0) {
			_currentPage = 0;
		}
		else if (currentPage >= _numberOfPages) {
			_currentPage = _numberOfPages - 1;
			if (_currentPage < 0) _currentPage = 0;
		}
		else {
			_currentPage = currentPage;
		}
		
		if (!_pageControlFlags.defersCurrentPageDisplay) {
			[self _updateCurrentPageDisplay];
		}
	}
}

- (void)setDefersCurrentPageDisplay:(BOOL)d
{
	_pageControlFlags.defersCurrentPageDisplay = d;
}

- (void)setHidesForSinglePage:(BOOL)h
{
	_pageControlFlags.hideForSinglePage = h;
	self.hidden = (h && _numberOfPages <= 1);
}

- (void)setDotRadius:(CGFloat)dotRadius
{
	if (_dotRadius != dotRadius) {
		_dotRadius = dotRadius;
		
		_pageControlFlags.changeInLayout = YES;
		_pageControlFlags.changeInSelectedColor = YES;
		_pageControlFlags.changeInUnselectedColor = YES;
		[self setNeedsLayout];
	}
}

- (void)setDotsSpacing:(CGFloat)dotsSpacing
{
	if (_dotsSpacing != dotsSpacing) {
		_dotsSpacing = dotsSpacing;
		
		_pageControlFlags.changeInLayout = YES;
		[self setNeedsLayout];
	}
}

- (void)setSelectedDotColor:(UIColor *)selectedDotColor
{
	_selectedDotColor = selectedDotColor;
	_pageControlFlags.changeInSelectedColor = YES;
	[self setNeedsLayout];
}

- (void)setUnselectedDotColor:(UIColor *)unselectedDotColor
{
	_unselectedDotColor = unselectedDotColor;
	_pageControlFlags.changeInUnselectedColor = YES;
	[self setNeedsLayout];
}

- (void)setSelectedDotImage:(UIImage *)selectedDotImage
{
	_selectedDotImage = selectedDotImage;
	if (selectedDotImage) _pageControlFlags.changeInSelectedImage = YES;
	else _pageControlFlags.changeInSelectedImage = YES;
	[self setNeedsLayout];
}

- (void)setUnselectedDotImage:(UIImage *)unselectedDotImage
{
	_unselectedDotImage = unselectedDotImage;	
	if (unselectedDotImage) _pageControlFlags.changeInUnselectedImage = YES;
	else _pageControlFlags.changeInUnselectedColor = YES;
	[self setNeedsLayout];
}

#pragma mark - UI methods

- (void)_updateIndicatorsIfNeeded
{
	if ([_indicators count] != _numberOfPages) {
		
		if (_pageControlFlags.changeInLayout) {
			for (UIView *v in _indicators) {
				[v removeFromSuperview];
			}
			[_indicators removeAllObjects];
			
			for (int i = 0; i < _numberOfPages; i++) {
				UIButton *indicatorButton = [[UIButton alloc] initWithFrame:CGRectZero];
				indicatorButton.backgroundColor = [UIColor clearColor];
				indicatorButton.multipleTouchEnabled = NO;
				indicatorButton.exclusiveTouch = YES;
				indicatorButton.adjustsImageWhenHighlighted = NO;
				indicatorButton.selected = (i == _currentPage);
				indicatorButton.userInteractionEnabled = !indicatorButton.selected;
				[indicatorButton setImage:_internSelectedDotImage forState:UIControlStateSelected];
				[indicatorButton setImage:_internUnselectedDotImage forState:UIControlStateNormal];
				if (indicatorButton.selected) [indicatorButton setImage:_internSelectedDotImage forState:UIControlStateHighlighted];
				else [indicatorButton setImage:_internUnselectedDotImage forState:UIControlStateHighlighted];
				[indicatorButton sizeToFit];
				[indicatorButton addTarget:self action:@selector(indicatorAction:) forControlEvents:UIControlEventTouchUpInside];
				[_indicators addObject:indicatorButton];
				[self addSubview:indicatorButton];
			}
		}
	}
	
	BOOL changes = NO;
	
	if (_pageControlFlags.changeInSelectedImage) {
		self.internSelectedDotImage = _selectedDotImage;
		changes = YES;
	}
	else if (_pageControlFlags.changeInSelectedColor) {
		if (_dotMask) self.internSelectedDotImage = [self _customImageDotWithMaskImage:_dotMask andColor:_selectedDotColor];
		else self.internSelectedDotImage = [self _defaultImageDotWithRadius:_dotRadius andColor:_selectedDotColor];
		changes = YES;
	}
	
	if (_pageControlFlags.changeInUnselectedImage) {
		self.internUnselectedDotImage = _unselectedDotImage;
		changes = YES;
	}
	else if (_pageControlFlags.changeInUnselectedColor) {
		if (_dotMask) self.internUnselectedDotImage = [self _customImageDotWithMaskImage:_dotMask andColor:_unselectedDotColor];
		else self.internUnselectedDotImage = [self _defaultImageDotWithRadius:_dotRadius andColor:_unselectedDotColor];
		changes = YES;
	}
	
	if (changes) {
		for (UIButton *button in _indicators) {
			[button setImage:_internSelectedDotImage forState:UIControlStateSelected];
			[button setImage:_internUnselectedDotImage forState:UIControlStateNormal];
			if (button.selected) [button setImage:_internSelectedDotImage forState:UIControlStateHighlighted];
			else [button setImage:_internUnselectedDotImage forState:UIControlStateHighlighted];
			[button sizeToFit];
		}
	}
	
	_pageControlFlags.changeInSelectedColor = NO;
	_pageControlFlags.changeInUnselectedColor = NO;
	_pageControlFlags.changeInSelectedImage = NO;
	_pageControlFlags.changeInUnselectedImage = NO;
}

- (void)updateCurrentPageDisplay
{
	if (_pageControlFlags.defersCurrentPageDisplay) {
		[self _updateCurrentPageDisplay];
	}
}

- (void)_updateCurrentPageDisplay
{
	[self layoutIfNeeded];
	UIButton *selectedIndicator = [_indicators objectAtIndex:_displayedPage];
	UIButton *newSelectedIndicator = [_indicators objectAtIndex:_currentPage];
	
	selectedIndicator.selected = NO;
	selectedIndicator.userInteractionEnabled = YES;
	newSelectedIndicator.selected = YES;
	newSelectedIndicator.userInteractionEnabled = NO;

	[newSelectedIndicator setImage:_internSelectedDotImage forState:UIControlStateHighlighted];
	[selectedIndicator setImage:_internUnselectedDotImage forState:UIControlStateHighlighted];

	_displayedPage = _currentPage;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
	if (pageCount == 0) return CGSizeZero;
	
	CGSize dotSize;
	if (_selectedDotImage) dotSize = _selectedDotImage.size;
	else dotSize = CGSizeMake(2 * _dotRadius, 2 * _dotRadius);

	CGSize returnedSize;
	returnedSize.height = dotSize.height;
	returnedSize.width = pageCount * (dotSize.width + _dotsSpacing);
	
	return returnedSize;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	return [self sizeForNumberOfPages:_numberOfPages];
}

@end

