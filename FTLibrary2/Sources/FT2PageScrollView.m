//
//  FT2PageScrollView.m
//  FT2Library
//
//  Created by Baldoph Pourprix on 16/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FT2PageScrollView.h"
#import "UIView+Layout.h"
#import "FT2PageView.h"
#import "FT2ReusableView.h"

#define scrollViewBoundsWidth self.bounds.size.width
#define scrollViewBoundsHeight self.bounds.size.height

#define scrollViewRelevantDimension horizontalWorflow(scrollViewBoundsWidth, scrollViewBoundsHeight)

#define horizontalWorflow(x, y) ((_flow == FT2PageSCrollViewFlowHorizontal) ? x : y)

NSString * const FT2PageContainerIdentifier = @"PageContainerIdentifier";

@interface FT2PageView ()
@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL usedAsContainer;
@property (nonatomic, strong) UIView *containedView;
@end

@interface FT2PageScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) CGSize internalPageSize;
@property (nonatomic) FT2PageSCrollViewFlow flow;

- (void)_updateUIForCurrentOffset;
- (FT2PageView *)_viewForIndex:(NSInteger)index;
- (void)_disposeOfVisibleViewsAndTellDelegate:(BOOL)tellDelegate;
- (NSInteger)_numberOfViewsPerPage;
@end

@implementation FT2PageScrollView

@synthesize delegate;
@synthesize dataSource = _dataSource;
@synthesize visibleSize = _visibleSize;
@synthesize pageSize = _pageSize;
@synthesize internalPageSize = _internalPageSize;

#pragma mark - Private Methods

- (void)_updateUIForCurrentOffset
{
	CGFloat offset = horizontalWorflow(self.contentOffset.x, self.contentOffset.y);
	
	CGFloat minVisibleOffset = offset - _visiblePadding;
	CGFloat maxVisibleOffset = minVisibleOffset + _visiblePadding * 2 + scrollViewRelevantDimension - 1;
	
	CGFloat pageDimension = horizontalWorflow(_internalPageSize.width, _internalPageSize.height);
	NSInteger minVisibleIndex = minVisibleOffset / pageDimension;
	NSInteger maxVisibleIndex = maxVisibleOffset / pageDimension;
	
	if (minVisibleIndex < 0) minVisibleIndex = 0;
	if (maxVisibleIndex >= _numberOfPages) maxVisibleIndex = _numberOfPages - 1;
	
	NSMutableSet *newVisibleViews = [NSMutableSet new];
	for (int i = minVisibleIndex; i <= maxVisibleIndex; i++) {
		FT2PageView *existingView = nil;
		for (FT2PageView *pageView in _visibleViews) {
			if (pageView.index == i) {
				existingView = pageView;
				break;
			}
		}
		if (existingView) {
			[newVisibleViews addObject:existingView];
			[_visibleViews removeObject:existingView];
		}
		else {
			FT2PageView *newView = [self _viewForIndex:i];
			[self addSubview:newView];
			[newVisibleViews addObject:newView];
		}
	}
	
	[self _disposeOfVisibleViewsAndTellDelegate:YES];
	_visibleViews = newVisibleViews;
}

- (FT2PageView *)_viewForIndex:(NSInteger)index
{
	FT2PageView *finalPage = nil;
	
	if (_pageScrollViewFlags.dataSourcePagesOnly) {
		finalPage = [_dataSource pageScrollView:self pageViewAtIndex:index];
	} else {
		FT2PageView *pageViewContainer = [self dequeuePageForIdentifer:FT2PageContainerIdentifier];
		if (pageViewContainer == nil) {
			pageViewContainer = [[FT2PageView alloc] initWithReuseIdentifier:FT2PageContainerIdentifier];
			pageViewContainer.usedAsContainer = YES;
		}
		
		UIView *reusedView = [_reusableViews anyObject];
		if (reusedView) {
			[_reusableViews removeObject:reusedView];
		}
		if ([reusedView respondsToSelector:@selector(prepareForReuse)]) {
			[(id <FT2ReusableView>)reusedView prepareForReuse];
		}
		
		if (_pageScrollViewFlags.dataSourceImagesOnly) {
			UIImageView *reusedImageView = (UIImageView *)reusedView;
			if (reusedImageView == nil) {
				reusedImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
				reusedImageView.userInteractionEnabled = YES;
				reusedImageView.contentMode = UIViewContentModeScaleAspectFit;
			}
			UIImage *buttonImage = [_dataSource pageScrollView:self imageForPageAtIndex:index];
			[reusedImageView setImage:buttonImage];
			[reusedImageView sizeToFit];
			reusedView = reusedImageView;
		}
		else if (_pageScrollViewFlags.dataSourceViewsOnly) {
			reusedView = [_dataSource pageScrollView:self viewForPageAtIndex:index reusedView:reusedView];	
		}
		
		reusedView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		pageViewContainer.containedView = reusedView;
		finalPage = pageViewContainer;
	}
	
	if (_flow == FT2PageSCrollViewFlowHorizontal) {
		finalPage.xOrigin = index * _internalPageSize.width - ((self.clipsToBounds) ? _visiblePadding : 0);
	} else {
		finalPage.yOrigin = index * _internalPageSize.height - ((self.clipsToBounds) ? _visiblePadding : 0);
	}
	finalPage.index = index;
	
	if (self.pagingEnabled) {
			finalPage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	} else {
		if (_flow == FT2PageSCrollViewFlowHorizontal) {
			finalPage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		} else {
			finalPage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		}
	}
	finalPage.width = horizontalWorflow(_internalPageSize.width + ((self.clipsToBounds) ? 2 * _visiblePadding : 0), _internalPageSize.width);
	finalPage.height = horizontalWorflow(_internalPageSize.height, _internalPageSize.height + ((self.clipsToBounds) ? 2 * _visiblePadding : 0));
	
	return finalPage;
}

- (void)_disposeOfVisibleViewsAndTellDelegate:(BOOL)tellDelegate
{	
	for (FT2PageView *pageView in _visibleViews) {
		
		if (pageView.usedAsContainer) {
			UIView *contentView = pageView.containedView;
			if ([contentView respondsToSelector:@selector(willBeDiscarded)]) {
				[(id <FT2ReusableView>)contentView willBeDiscarded];
			}
			if (tellDelegate && _pageScrollViewFlags.delegateWillDiscardView) {
				[_pageScrollViewDelegate pageScrollView:self willDiscardView:contentView];
			}
			if (_reusableViews.count < [self _numberOfViewsPerPage]) {
				[_reusableViews addObject:contentView];
				pageView.containedView = nil;
			}
		}
		
		[pageView willBeDiscarded];
		if (tellDelegate && _pageScrollViewFlags.delegateWillDiscardPage) {
			[_pageScrollViewDelegate pageScrollView:self willDiscardPage:pageView];
		}
		if (_pageScrollViewFlags.delegateEnsureQueuing) {
			[self.delegate pageScrollView:self enqueuePage:pageView];
		} else  if (pageView.reuseIdentifier) {
			NSMutableSet *setForIdentifier = [_reusablePages objectForKey:pageView.reuseIdentifier];
			if (setForIdentifier == nil) {
				setForIdentifier = [NSMutableSet new];
				[_reusablePages setObject:setForIdentifier forKey:pageView.reuseIdentifier];
			}
			if (setForIdentifier.count < [self _numberOfViewsPerPage]) {
				[setForIdentifier addObject:pageView];
			}
		}
		[pageView removeFromSuperview];		
	}
	[_visibleViews removeAllObjects];
}

- (NSInteger)_numberOfViewsPerPage
{
	CGFloat dimension = scrollViewRelevantDimension;
	CGFloat pageDimension = horizontalWorflow(_internalPageSize.width, _internalPageSize.height);
	NSInteger number = dimension / pageDimension;
	return number + 1;
}

#pragma mark - Others

- (id)dequeuePageForIdentifer:(NSString *)identifier
{
	NSMutableSet *set = [_reusablePages objectForKey:identifier];
	if (set) {
		FT2PageView *page = [set anyObject];
		if (page) {
			[set removeObject:page];
			[page prepareForReuse];
			return page;
		}
	}
	return nil;
}

#pragma mark - Others

- (NSInteger)indexOfView:(UIView *)view
{
	for (FT2PageView *page in _visibleViews) {
		if (page.containedView == view) {
			return page.index;
		}
	}
	return NSNotFound;
}

- (NSInteger)indexOfPage:(FT2PageView *)view
{
	for (FT2PageView *page in _visibleViews) {
		if (page == view) {
			return page.index;
		}
	}
	return NSNotFound;
}

- (UIView *)viewAtIndex:(NSUInteger)index
{
	for (FT2PageView *page in _visibleViews) {
		if (page.index == index) {
			return page.containedView;
		}
	}
	return nil;
}

- (FT2PageView *)pageAtIndex:(NSUInteger)index
{
	for (FT2PageView *page in _visibleViews) {
		if (page.index == index) {
			return page;
		}
	}
	return nil;	
}

- (NSArray *)visibleViews
{
	NSMutableArray *returnedViews = [NSMutableArray new];
	NSArray *sortedPageViews = [self visiblePages];
	for (FT2PageView *pageView in sortedPageViews) {
		[returnedViews addObject:pageView.subviews.lastObject];
	}
	return returnedViews;
}

- (NSArray *)visiblePages
{
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
	NSArray *sortedPageViews = [_visibleViews sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
	return sortedPageViews;	
}

- (BOOL)canBeRotated
{
	return !self.dragging && !self.decelerating;
}

#pragma mark - UI Handling

- (void)reloadData
{
	_numberOfPages = [_dataSource numberOfPagesInPageScrollView:self];
	if (_flow == FT2PageSCrollViewFlowHorizontal) {
		self.contentSize = CGSizeMake(_numberOfPages * _internalPageSize.width, _internalPageSize.height);
	} else {
		self.contentSize = CGSizeMake(_internalPageSize.width, _numberOfPages * _internalPageSize.height);
	}
	[self _disposeOfVisibleViewsAndTellDelegate:NO];
	if (_numberOfPages > 0) {
		[self _updateUIForCurrentOffset];
	}
}

- (void)reloadPageNumber
{
	NSInteger numberOfPages = [_dataSource numberOfPagesInPageScrollView:self];
	if (numberOfPages != _numberOfPages) {
		_numberOfPages = numberOfPages;
		if (_flow == FT2PageSCrollViewFlowHorizontal) {
			self.contentSize = CGSizeMake(_numberOfPages * _internalPageSize.width, _internalPageSize.height);
		} else {
			self.contentSize = CGSizeMake(_internalPageSize.width, _numberOfPages * _internalPageSize.height);
		}
	}
}

- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
	if (animated && index != self.selectedIndex) [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	if (_flow == FT2PageSCrollViewFlowHorizontal) {
		CGFloat xOffset = index * _internalPageSize.width;
		
		if (index != 0 && self.contentSize.width - xOffset < self.bounds.size.width) {
			xOffset = self.contentSize.width - self.bounds.size.width;
		}
		[self setContentOffset:CGPointMake(xOffset, 0) animated:animated];
	} else {
		CGFloat yOffset = index * _internalPageSize.height;
		
		if (index != 0 && self.contentSize.height - yOffset < self.bounds.size.height) {
			yOffset = self.contentSize.height - self.bounds.size.height;
		}
		[self setContentOffset:CGPointMake(0, yOffset) animated:animated];
	}
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint startPoint = [[touches anyObject] locationInView:self];
	_varianceRect = CGRectMake(startPoint.x, startPoint.y, 0, 0);
	
	[super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:self];
	CGRect newRect = CGRectMake(point.x, point.y, 0, 0);
	_varianceRect = CGRectUnion(_varianceRect, newRect);
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:self];
	CGRect newRect = CGRectMake(point.x, point.y, 0, 0);
	_varianceRect = CGRectUnion(_varianceRect, newRect);
	
	if (_varianceRect.size.height < 20 && _varianceRect.size.width < 20) {
		
		for (FT2PageView *page in _visibleViews) {
			if (CGRectContainsPoint(page.frame, point)) {
				if (_pageScrollViewFlags.delegateDidSelectView) {
					[_pageScrollViewDelegate pageScrollView:self didSelectViewAtIndex:page.index];
				}
				else if (_pageScrollViewFlags.delegateDidSelectPage) {
					[_pageScrollViewDelegate pageScrollView:self didSelectPageAtIndex:page.index];
				}
				break;
			}
		}
	}
	[super touchesEnded:touches withEvent:event];
}

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
	self = [self initWithFrame:frame contentFlow:FT2PageSCrollViewFlowHorizontal];
	return self;
}

- (id)initWithFrame:(CGRect)frame contentFlow:(FT2PageSCrollViewFlow)flow
{
	self = [super initWithFrame:frame];
	if (self) {
		self.pagingEnabled = YES;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.delaysContentTouches = YES;
		self.canCancelContentTouches = YES;
		[super setDelegate:self];
		self.scrollsToTop = NO;
		self.visibleSize = frame.size;
		_numberOfPages = -1;
		_reusableViews = [NSMutableSet new];
		_reusablePages = [NSMutableDictionary new];
		_flow = flow;
	}
	return self;
}

- (void)setFrame:(CGRect)frame
{
	_didUpdateFrame = YES;
	NSInteger selectedIndex = [self selectedIndex];
	[super setFrame:frame];
	if (self.pagingEnabled) {
		_internalPageSize = self.bounds.size;
	}
	if (_flow == FT2PageSCrollViewFlowHorizontal) {
		self.contentSize = CGSizeMake(_numberOfPages * _internalPageSize.width, scrollViewBoundsHeight);
	} else {
		self.contentSize = CGSizeMake(scrollViewBoundsWidth, _numberOfPages * _internalPageSize.height);
	}
	[self scrollToPageAtIndex:(selectedIndex < 0) ? 0 : selectedIndex animated:NO];
	[self _updateUIForCurrentOffset];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
	if (_numberOfPages == -1 && newSuperview) {
		[self reloadData];
	}
}

- (void)setPagingEnabled:(BOOL)pagingEnabled
{
	[super setPagingEnabled:pagingEnabled];
	if (pagingEnabled) {
		_internalPageSize = self.bounds.size;
	} else {
		_internalPageSize = _pageSize;
	}
}

#pragma mark - Getters

- (NSInteger)selectedIndex
{
    NSInteger index = horizontalWorflow(self.contentOffset.x / _internalPageSize.width, self.contentOffset.y / _internalPageSize.height);
    if (index < 0) index = 0;
    if (index > _numberOfPages - 1) index = _numberOfPages - 1;
	
    return index;
}

- (UIView *)selectedView
{
	NSInteger index = [self selectedIndex];
	for (FT2PageView *v in _visibleViews) {
		if (v.index == index) return v.subviews.lastObject;
	}
	return nil;
}

- (FT2PageView *)selectedPage
{
	NSInteger index = [self selectedIndex];
	for (FT2PageView *v in _visibleViews) {
		if (v.index == index) return v;
	}
	return nil;
}

- (id <FT2PageScrollViewDelegate>)delegate
{
	return _pageScrollViewDelegate;
}

#pragma mark - Setters

- (void)setVisibleSize:(CGSize)size
{	
	if (horizontalWorflow(size.width > self.frame.size.width, size.height > self.frame.size.height)) {
		self.clipsToBounds = NO;
	} else {
		self.clipsToBounds = YES;
	}

	_visibleSize = size;
	_visiblePadding = horizontalWorflow((size.width - self.frame.size.width) / 2, (size.height - self.frame.size.height) / 2);
}

- (void)setDataSource:(id <FT2PageScrollViewDataSource>)d
{
	_dataSource = d;
	_pageScrollViewFlags.dataSourceImagesOnly = [d respondsToSelector:@selector(pageScrollView:imageForPageAtIndex:)];
	_pageScrollViewFlags.dataSourcePagesOnly = [d respondsToSelector:@selector(pageScrollView:pageViewAtIndex:)];
	_pageScrollViewFlags.dataSourceViewsOnly = [d respondsToSelector:@selector(pageScrollView:viewForPageAtIndex:reusedView:)];
	
	if (!_pageScrollViewFlags.dataSourceViewsOnly && !_pageScrollViewFlags.dataSourceImagesOnly && !_pageScrollViewFlags.dataSourcePagesOnly) {
		[NSException raise:NSInternalInconsistencyException format:@"You need to implement one of the 3 data source methods that return an object."];
	}
}

- (void)setDelegate:(id<FT2PageScrollViewDelegate>)d
{
	_pageScrollViewDelegate = d;
	_pageScrollViewFlags.delegateDidSelectPage = [d respondsToSelector:@selector(pageScrollView:didSelectPageAtIndex:)];
	_pageScrollViewFlags.delegateDidSelectView = [d respondsToSelector:@selector(pageScrollView:didSelectViewAtIndex:)];
	_pageScrollViewFlags.delegateDidSlideToIndex = [d respondsToSelector:@selector(pageScrollView:didSlideToIndex:)];
	_pageScrollViewFlags.delegateWillDiscardPage = [d respondsToSelector:@selector(pageScrollView:willDiscardPage:)];
	_pageScrollViewFlags.delegateWillDiscardView = [d respondsToSelector:@selector(pageScrollView:willDiscardView:)];
	_pageScrollViewFlags.delegateCanBeRotated = [d respondsToSelector:@selector(pageScrollViewCanBeRotated:)];
	_pageScrollViewFlags.delegateEnsureQueuing = [d respondsToSelector:@selector(pageScrollView:enqueuePage:)];
}

- (void)setPageSize:(CGSize)pageSize
{
	_pageSize = pageSize;
	if (!self.pagingEnabled) _internalPageSize = pageSize;
}

#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_didUpdateFrame) {
		_didUpdateFrame = NO;
		for (FT2PageView *page in _visibleViews) {
			if (_flow == FT2PageSCrollViewFlowHorizontal) {
				page.xOrigin = page.index * _internalPageSize.width - ((self.clipsToBounds) ? _visiblePadding : 0);
			} else {
				page.yOrigin = page.index * _internalPageSize.height - ((self.clipsToBounds) ? _visiblePadding : 0);
			}
		}
	} else {
		[self _updateUIForCurrentOffset];	
	}

	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
		[_pageScrollViewDelegate scrollViewDidScroll:self];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if (_pageScrollViewFlags.delegateDidSlideToIndex) {
		[_pageScrollViewDelegate pageScrollView:self didSlideToIndex:[self selectedIndex]];
	}
	if (_pageScrollViewFlags.delegateCanBeRotated && self.canBeRotated) {
		[_pageScrollViewDelegate pageScrollViewCanBeRotated:self];
	}
	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
		[_pageScrollViewDelegate scrollViewDidEndDecelerating:self];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
		[_pageScrollViewDelegate scrollViewWillBeginDragging:scrollView];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate) {
		if (_pageScrollViewFlags.delegateDidSlideToIndex) 
        {
			[_pageScrollViewDelegate pageScrollView:self didSlideToIndex:[self selectedIndex]];
		}
	} else if (_pageScrollViewFlags.delegateCanBeRotated && self.canBeRotated) {
		[_pageScrollViewDelegate pageScrollViewCanBeRotated:self];
	}
	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
		[_pageScrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	}
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
		[_pageScrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	if (_pageScrollViewFlags.delegateDidSlideToIndex) {
		[_pageScrollViewDelegate pageScrollView:self didSlideToIndex:[self selectedIndex]];
	}

	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
		[_pageScrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
	}
}

@end