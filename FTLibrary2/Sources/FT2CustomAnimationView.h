//
//  FT2CustomAnimationView.h
//  FT2Library
//
//  Created by Baldoph Pourprix on 06/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	FT2CustomAnimationCurveEaseInOut,
	FT2CustomAnimationCurveEaseOut,
	FT2CustomAnimationCurveLinear
} FT2CustomAnimationCurve;

typedef NSUInteger FT2CustomAnimationOptions;

@class CADisplayLink;
@class FT2CustomAnimation;
@protocol FT2CustomAnimationObserver;
@protocol FT2CustomAnimationViewDelegate;

@interface FT2CustomAnimationView : UIView {
	
	CADisplayLink *_displayLink;
	NSMutableArray *_animations;
	int _disableToken;
	NSMutableArray *_animationObservers;
	BOOL _delegateImplementsDrawRect;
}

@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, unsafe_unretained) id <FT2CustomAnimationViewDelegate> delegate;

//handy method to start an animation
- (void)startAnimationWithDuration:(NSTimeInterval)duration;
- (void)startAnimationWithDuration:(NSTimeInterval)duration andKey:(NSString *)key;

/* When you add an animation, the method -drawRect:forAnimation:withAnimationProgress: start being called for the
 * time of the animation's 'duration' property. The position you add your animation at will be the 
 * position you draw your content for this animation. That is if you insert an animation at the index 0, the
 * -drawRectMethod for this animation will be called first and the other animations' contents will be drawn over this
 * one. */

- (void)addAnimation:(FT2CustomAnimation *)animation;
- (void)insertAnimation:(FT2CustomAnimation *)animation atIndex:(NSInteger)index;
- (void)insertAnimation:(FT2CustomAnimation *)animation belowAnimation:(FT2CustomAnimation *)otherAnimation;
- (void)insertAnimation:(FT2CustomAnimation *)animation aboveAnimation:(FT2CustomAnimation *)otherAnimation;

- (void)drawRect:(CGRect)rect forAnimation:(FT2CustomAnimation *)animation withAnimationProgress:(float)progress;

- (void)animationWillBegin:(FT2CustomAnimation *)animation;
- (void)animationDidFinish:(FT2CustomAnimation *)animation;

- (void)addAnimationObserver:(id <FT2CustomAnimationObserver>)observer;
- (void)removeAnimationObserver:(id <FT2CustomAnimationObserver>)observer;

@end

@interface FT2CustomAnimation : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic) NSTimeInterval duration;

/* customProgressForTime must be a block that returns a value between 0 and 1, given the relative time of the animation.
 * relativeTime is 0 when the animation starts, and 1 when it finishes. */
@property (nonatomic, copy) float (^customProgressForTime)(float relativeTime); //used if non nil, instead of animationCurve
@property (nonatomic) BOOL disableUserInteraction; //default: NO
@property (nonatomic) FT2CustomAnimationCurve animationCurve; //default: FT2CustomAnimationCurveEaseInOut

@end

@protocol FT2CustomAnimationObserver <NSObject>

- (void)animationView:(FT2CustomAnimationView *)animationView didChangeProgress:(float)progress forAnimation:(FT2CustomAnimation *)animation;
- (void)animationView:(FT2CustomAnimationView *)animationView willStartAnimation:(FT2CustomAnimation *)animation;
- (void)animationView:(FT2CustomAnimationView *)animationView didEndAnimation:(FT2CustomAnimation *)animation;

@end

@protocol FT2CustomAnimationViewDelegate <NSObject>

- (void)drawCustomAnimationView:(FT2CustomAnimationView *)view inRect:(CGRect)rect forAnimation:(FT2CustomAnimation *)animation withAnimationProgress:(float)progress;

@end
