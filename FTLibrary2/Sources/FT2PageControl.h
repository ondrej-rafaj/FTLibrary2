//
//  FTPageControl.h
//  FTLibrary
//
//  Created by Baldoph Pourprix on 04/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FT2PageControl : UIControl {
@private
    NSMutableArray* _indicators;
    NSInteger       _currentPage;
	NSInteger       _displayedPage;
    struct {
        unsigned int hideForSinglePage:1;
        unsigned int defersCurrentPageDisplay:1;
		unsigned int changeInSelectedColor:1;
		unsigned int changeInUnselectedColor:1;
		unsigned int changeInLayout:1;
		unsigned int changeInSelectedImage:1;
		unsigned int changeInUnselectedImage:1;
    } _pageControlFlags;
}

@property (nonatomic) NSInteger numberOfPages;          // default is 0
@property (nonatomic) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1

@property (nonatomic,retain) UIColor *selectedDotColor;
@property (nonatomic,retain) UIColor *unselectedDotColor;
@property (nonatomic,retain) UIImage *unselectedDotImage;
@property (nonatomic,retain) UIImage *selectedDotImage;

@property (nonatomic) CGFloat dotRadius;
@property (nonatomic) CGFloat dotsSpacing;
@property (nonatomic,retain) UIImage *dotMask;

@property (nonatomic) BOOL hidesForSinglePage;          // hide the the indicator if there is only one page. default is NO

@property (nonatomic) BOOL defersCurrentPageDisplay;    // if set, clicking to a new page won't update the currently displayed page until -updateCurrentPageDisplay is called. default is NO

- (void)updateCurrentPageDisplay;                      // update page display to match the currentPage. ignored if defersCurrentPageDisplay is NO. setting the page value directly will update immediately

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;   // returns minimum size required to display dots for given page count. can be used to size control if page count could change

@end