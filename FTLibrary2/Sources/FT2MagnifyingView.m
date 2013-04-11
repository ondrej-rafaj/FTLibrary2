//
//  FT2MagnifyingView.m
//  FT2Library2
//
//  Created by Baldoph Pourprix on 12/02/2012.
//  Copyright (c) 2012 Fuerte International All rights reserved.
//

#import "FT2MagnifyingView.h"

@interface FT2MagnifyingView ()
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@property (nonatomic) CGFloat lastZoomValue;
@property (nonatomic) BOOL didSendZoomDelegate;
@property (nonatomic) CGFloat zoomThreshold;

@end

@implementation FT2MagnifyingView

@synthesize magnifiedView = _magnifiedView;
@synthesize doubleTapRecognizer = _doubleTapRecognizer;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;  		
		
		_doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
		_doubleTapRecognizer.numberOfTapsRequired = 2;		
    }
    return self;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    float newScale = (self.zoomScale > self.minimumZoomScale) ?  self.minimumZoomScale : self.maximumZoomScale;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [self zoomToRect:zoomRect animated:YES];
}

- (void)zoomOutAnimated:(BOOL)animated animationsOptions:(UIViewAnimationOptions)options completionBlock:(void (^)(void))didZoomOut
{
	if (self.zoomScale == self.minimumZoomScale) {
		if (didZoomOut) didZoomOut();
	} else {
		[UIView animateWithDuration:(animated) ? 0.2 : 0 delay:0 options:options animations:^{
			self.zoomScale = self.minimumZoomScale;
		} completion:^(BOOL finished) {
		if (didZoomOut) didZoomOut();			
		}];
	}
}

#pragma mark -
#pragma mark Override layoutSubviews to center content

- (void)layoutSubviews 
{
	[super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _magnifiedView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    _magnifiedView.frame = frameToCenter;
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _magnifiedView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
	if (_magnifiedView && scrollView.zoomScale > _zoomThreshold && _didSendZoomDelegate == NO) {
		_didSendZoomDelegate = YES;
		if ([_magnifyingViewDelegate respondsToSelector:@selector(magnifyingViewDidZoomIn:)])
			[_magnifyingViewDelegate magnifyingViewDidZoomIn:self];
	} else if (scrollView.zoomScale <= _zoomThreshold && _didSendZoomDelegate) {
		_didSendZoomDelegate = NO;
	}
	_lastZoomValue = scrollView.zoomScale;
}

#pragma mark -
#pragma mark Configure scrollView to display new image (tiled or not)

- (void)setMagnifiedView:(UIView *)magnifiedView
{	
    // clear the previous imageView
    [_magnifiedView removeFromSuperview];
    
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    _magnifiedView = magnifiedView;
	
	if (magnifiedView) {
		[self addSubview:_magnifiedView];
		
		[_magnifiedView addGestureRecognizer:_doubleTapRecognizer];
		_magnifiedView.userInteractionEnabled = YES;
		
		self.contentSize = _magnifiedView.bounds.size;
		[self setMaxMinZoomScalesForCurrentBounds];
		self.zoomScale = self.minimumZoomScale;
	}
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _magnifiedView.bounds.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    CGFloat maxScale = 1.0;
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
	
	_zoomThreshold = minScale +  (maxScale - minScale) / 2;
}

- (void)setFrame:(CGRect)frame
{
	CGPoint restorePoint;
	CGFloat restoreScale;
	if (self.magnifiedView.superview) {
		restorePoint = [self pointToCenterAfterRotation];
		restoreScale = [self scaleToRestoreAfterRotation];
	}
	
	[super setFrame:frame];
	
	if (self.magnifiedView.superview) {
		[self setMaxMinZoomScalesForCurrentBounds];
		[self restoreCenterPoint:restorePoint scale:restoreScale];
	}
}

#pragma mark -
#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image

// returns the center point, in image coordinate space, to try to restore after rotation. 
- (CGPoint)pointToCenterAfterRotation
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return [self convertPoint:boundsCenter toView:_magnifiedView];
}

// returns the zoom scale to attempt to restore after rotation. 
- (CGFloat)scaleToRestoreAfterRotation
{
    CGFloat contentScale = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (contentScale <= self.minimumZoomScale + FLT_EPSILON)
        contentScale = 0;
    
    return contentScale;
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}

// Adjusts content offset and scale to try to preserve the old zoomscale and center.
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale
{    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
    
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:_magnifiedView];
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0, 
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
    self.contentOffset = offset;
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

@end

