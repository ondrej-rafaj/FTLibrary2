//
//  FT2PageScrollView.h
//  FT2Library
//
//  Created by Baldoph Pourprix on 16/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 - reuse of views like UITableView
 - horizontal content
 */

@class FT2PageScrollView;
@class FT2PageView;

@protocol FT2PageScrollViewDataSource <NSObject>
@required
- (NSInteger)numberOfPagesInPageScrollView:(FT2PageScrollView *)scrollView;
@optional
//only one of the 3 following methods is required
//display an image
- (UIImage *)pageScrollView:(FT2PageScrollView *)scrollView imageForPageAtIndex:(NSInteger)index;
//simple reusing: the property reusedView contained a reused view of the same class of the one you returned before
- (UIView *)pageScrollView:(FT2PageScrollView *)scrollView viewForPageAtIndex:(NSInteger)index reusedView:(UIView *)view;
//cells queuing and reuse - table view like
- (FT2PageView *)pageScrollView:(FT2PageScrollView *)scrollView pageViewAtIndex:(NSInteger)index;
@end


@protocol FT2PageScrollViewDelegate <NSObject, UIScrollViewDelegate>
@optional
//the view at index 'index' received a touch
- (void)pageScrollView:(FT2PageScrollView *)scrollView didSelectViewAtIndex:(NSInteger)index;
- (void)pageScrollView:(FT2PageScrollView *)scrollView didSelectPageAtIndex:(NSInteger)index;

- (void)pageScrollView:(FT2PageScrollView *)scrollView didSlideToIndex:(NSInteger)index;

- (void)pageScrollView:(FT2PageScrollView *)scrollView willDiscardView:(UIView *)view;
- (void)pageScrollView:(FT2PageScrollView *)scrollView willDiscardPage:(FT2PageView *)page;

- (void)pageScrollViewCanBeRotated:(FT2PageScrollView *)scrollView;

//if you provide this method to your delegate, page scroll view will let it
//ensure the queuing of pages. Useful if several instances of page scroll views 
//are using the same pages and you want to do a general caching of those pages.
//Therefore -dequeuePageForIdentifer: will always return nil
- (void)pageScrollView:(FT2PageScrollView *)scrollView enqueuePage:(FT2PageView *)pageView;

@end


@interface FT2PageScrollView : UIScrollView {
	
	NSMutableSet *_visibleViews;
	NSMutableSet *_reusableViews;
	NSMutableDictionary *_reusablePages;
	
	NSInteger _numberOfPages;
	CGRect _varianceRect;
	
	CGFloat _visibleHorizontalPadding;
	id <FT2PageScrollViewDelegate> _pageScrollViewDelegate;
	
	BOOL _didUpdateFrame;
	
	struct {
        unsigned int dataSourceImagesOnly:1;
        unsigned int dataSourceViewsOnly:1;
		unsigned int dataSourcePagesOnly:1;
		unsigned int delegateDidSelectView:1;
		unsigned int delegateDidSelectPage:1;
		unsigned int delegateDidSlideToIndex:1;
		unsigned int delegateWillDiscardView:1;
		unsigned int delegateWillDiscardPage:1;
		unsigned int delegateCanBeRotated:1;
		unsigned int delegateEnsureQueuing:1;
    } _pageScrollViewFlags;
}

@property (nonatomic, assign) id <FT2PageScrollViewDataSource> dataSource;
@property (nonatomic, assign) id <FT2PageScrollViewDelegate> delegate;
@property (nonatomic) CGSize visibleSize;
//use page size to define width of pages when paging is disabled
@property (nonatomic, assign) CGSize pageSize; 

- (BOOL)canBeRotated;

- (void)reloadData;
- (void)reloadPageNumber; //doesn't reload content but change the contentSize accordingly

- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated;

- (id)dequeuePageForIdentifer:(NSString *)identifier;

- (NSInteger)selectedIndex;

- (UIView *)selectedView;
- (FT2PageView *)selectedPage;

- (NSInteger)indexOfView:(UIView *)view;
- (NSInteger)indexOfPage:(FT2PageView *)view;

- (UIView *)viewAtIndex:(NSUInteger)index;
- (FT2PageView *)pageAtIndex:(NSUInteger)index;

- (NSArray *)visibleViews;
- (NSArray *)visiblePages;

@end
