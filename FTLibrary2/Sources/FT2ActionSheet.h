//
//  FT2ActionSheet.h
//  FT2Library
//
//  Created by Baldoph Pourprix on 19/02/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FT2ActionSheet : UIActionSheet <UIActionSheetDelegate>

@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, copy) void (^destructiveBlock)(void);
@property (nonatomic, copy) void (^actionBlock)(NSInteger clikedButtonIndex);


@end
