//
//  FT2CustomAnimationView.m
//  FT2Library
//
//  Created by Baldoph Pourprix on 06/12/2011.
//  Copyright (c) 2011 Coronal Sky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FT2CustomAnimationView.h"

/*********************************** FT2CustomAnimation ***********************************/

@interface FT2CustomAnimation ()
@property (nonatomic, assign) NSTimeInterval startTimestamp;
@property (nonatomic, assign) float progress;
@end

@implementation FT2CustomAnimation

@synthesize key = _key;
@synthesize customProgressForTime = _customProgressForTime;
@synthesize disableUserInteraction = _disableUserInteraction;
@synthesize animationCurve = _animationCurve;
@synthesize duration = _duration;
@synthesize startTimestamp = _startTimestamp;
@synthesize progress = _progress;

- (id)init
{
	self = [super init];
	if (self) {
		_key = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
		_disableUserInteraction = NO;
		_animationCurve = FT2CustomAnimationCurveEaseInOut;
		_duration = 0.3;
		_progress = 1;
	}
	return self;
}

@end

/*********************************** FT2CustomAnimationView ***********************************/

@interface FT2CustomAnimationView ()
- (float)_progressForTime:(float)time andAnimationCurve:(FT2CustomAnimationCurve)animationCurve;
- (void)_removeAnimations:(NSArray *)animations;
- (void)_animationWillBegin:(FT2CustomAnimation *)animation;
- (void)_animationDidFinish:(FT2CustomAnimation *)animation;

- (void)_increaseDisableToken;
- (void)_decreaseDisableToken;
@end

@implementation FT2CustomAnimationView

@synthesize isAnimating = _isAnimating;

#pragma mark - private

- (float)_progressForTime:(float)time andAnimationCurve:(FT2CustomAnimationCurve)animationCurve
{
	float value = 0.f;
	switch (animationCurve) {
		case FT2CustomAnimationCurveEaseInOut:
			value = 0.5f + atanf(3.009569674f * (2 * time - 1)) / 2.5f;
			break;
		case FT2CustomAnimationCurveEaseOut:
			value = atanf(3.009569674f * time) / 1.25f;
			break;
		case FT2CustomAnimationCurveLinear:
			value = time;
			break;
	}
	if (value < 0.f) value = 0.f;
	else if (value > 1.f) value = 1.f;
	return value;
}

- (void)_displayLinkDidFire
{
	for (FT2CustomAnimation *anim in _animations) {
		float progress = 0.f;
		NSTimeInterval durationSinceBeginning = [[NSDate date] timeIntervalSince1970] - anim.startTimestamp;
		NSTimeInterval time = durationSinceBeginning / anim.duration;
		if (anim.customProgressForTime) {
			progress = anim.customProgressForTime(time);
		}
		else {
			progress = [self _progressForTime:time andAnimationCurve:anim.animationCurve];
		}
		anim.progress = progress;
		for (id <FT2CustomAnimationObserver> obj in _animationObservers) {
			[obj animationView:self didChangeProgress:anim.progress forAnimation:anim];
		}
	}
	[self setNeedsDisplay];
}

- (void)_removeAnimations:(NSArray *)animations
{
	for (FT2CustomAnimation *anim in animations) {
		[_animations removeObject:anim];
		[self _animationDidFinish:anim];
		for (id <FT2CustomAnimationObserver> obj in _animationObservers) {
			[obj animationView:self didEndAnimation:anim];
		}
	}
	if (_animations.count == 0) { 
		_displayLink.paused = YES;
		_isAnimating = NO;
	}
}

- (void)_increaseDisableToken
{
	if (_disableToken == 0) {
		[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	}
	_disableToken++;
}

- (void)_decreaseDisableToken
{
	_disableToken--;
	if (_disableToken == 0) {
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}	
}

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_animations = [NSMutableArray new];
		_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_displayLinkDidFire)];
		_displayLink.paused = YES;
		_displayLink.frameInterval = 2;
		[_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
		_isAnimating = NO;
		_disableToken = 0;
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
	NSMutableArray *animsToDelete = [NSMutableArray new];
	for (FT2CustomAnimation *anim in _animations) {
		float progress = 1.f;
		if (_isAnimating) {
			progress = anim.progress;
		}
		[self drawRect:rect forAnimation:anim withAnimationProgress:progress];
		if (anim.progress >= 1.f) [animsToDelete addObject:anim];
	}
	if (_animations.count == 0) {
		[self drawRect:rect forAnimation:nil withAnimationProgress:1];
	}
	if (animsToDelete.count > 0) [self _removeAnimations:animsToDelete];
}

- (void)drawRect:(CGRect)rect forAnimation:(FT2CustomAnimation *)animation withAnimationProgress:(float)progress
{
	
}

- (void)dealloc
{
	[_displayLink invalidate];
}

#pragma mark - Animation Observers Handling

- (void)addAnimationObserver:(id <FT2CustomAnimationObserver>)observer
{
	if (_animationObservers == nil) _animationObservers = [NSMutableArray new];
	[_animationObservers addObject:observer];
}

- (void)removeAnimationObserver:(id <FT2CustomAnimationObserver>)observer
{
	[_animationObservers removeObject:observer];
}

#pragma mark - Animations

- (void)startAnimationWithDuration:(NSTimeInterval)duration
{
	FT2CustomAnimation *animation = [FT2CustomAnimation new];
	animation.duration = duration;
	[self addAnimation:animation];
}

- (void)startAnimationWithDuration:(NSTimeInterval)duration andKey:(NSString *)key
{
	FT2CustomAnimation *animation = [FT2CustomAnimation new];
	animation.key = key;
	animation.duration = duration;
	[self addAnimation:animation];
}

- (void)addAnimation:(FT2CustomAnimation *)animation
{
	[self insertAnimation:animation atIndex:_animations.count];
}

- (void)insertAnimation:(FT2CustomAnimation *)animation belowAnimation:(FT2CustomAnimation *)otherAnimation
{
	NSInteger otherAnimIndex = [_animations indexOfObject:otherAnimation];
	if (otherAnimIndex == NSNotFound) {
		[self addAnimation:animation];
	} else {
		[self insertAnimation:animation atIndex:otherAnimIndex];
	}
}

- (void)insertAnimation:(FT2CustomAnimation *)animation aboveAnimation:(FT2CustomAnimation *)otherAnimation
{
	NSInteger otherAnimIndex = [_animations indexOfObject:otherAnimation];
	if (otherAnimIndex == NSNotFound) {
		[self addAnimation:animation];
	} else {
		[self insertAnimation:animation atIndex:otherAnimIndex + 1];
	}
}

- (void)insertAnimation:(FT2CustomAnimation *)animation atIndex:(NSInteger)index
{
	animation.startTimestamp = [[NSDate date] timeIntervalSince1970];
	[_animations insertObject:animation atIndex:index];
	[self _animationWillBegin:animation];
	for (id <FT2CustomAnimationObserver> obj in _animationObservers) {
		[obj animationView:self willStartAnimation:animation];
	}
	if (_displayLink.paused) {
		_isAnimating = YES;
		_displayLink.paused = NO;
	}
}

#pragma mark - Animations 'callbacks'

- (void)_animationWillBegin:(FT2CustomAnimation *)animation
{
	if (animation.disableUserInteraction) [self _increaseDisableToken];
	[self animationWillBegin:animation];
}

- (void)_animationDidFinish:(FT2CustomAnimation *)animation
{
	if (animation.disableUserInteraction) [self _decreaseDisableToken];
	[self animationDidFinish:animation];
}

- (void)animationWillBegin:(FT2CustomAnimation *)animation
{
	
}

- (void)animationDidFinish:(FT2CustomAnimation *)animation
{
	
}

@end
