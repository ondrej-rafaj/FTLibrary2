//
//  FT2PageView.h
//  FT2Library
//
//  Created by Baldoph Pourprix on 13/12/2011.
//  Copyright (c) 2011 Coronal Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FT2ReusableView.h"


@interface FT2PageView : UIView <FT2ReusableView> {
	
	NSInteger _index;
	BOOL _usedAsContainer;
}

- (id)initWithReuseIdentifier:(NSString *)identifier;

@property (nonatomic, strong, readonly) NSString *reuseIdentifier;
@property (nonatomic, strong) UIView *contentView;

@end
