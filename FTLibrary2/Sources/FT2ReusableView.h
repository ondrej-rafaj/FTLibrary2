//
//  FT2ReusableView.h
//  FT2Library
//
//  Created by Baldoph Pourprix on 14/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Protocol notably used by FT2PageScrollView for views returned by the data source that are not 
 * FT2PageView objects  */

@protocol FT2ReusableView <NSObject>
@optional
- (void)prepareForReuse;
- (void)willBeDiscarded;
@end
