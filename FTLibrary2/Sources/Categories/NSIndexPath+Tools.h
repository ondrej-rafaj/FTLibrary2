//
//  NSIndexPath+Tools.h
//  FT2Library
//
//  Created by Baldoph Pourprix on 27/02/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (Tools)

- (BOOL)isParentOfIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathByRemovingFirstIndex;

- (NSInteger)lastIndex;

- (NSIndexPath *)indexPathByPrefixingWithIndex:(NSInteger)prefixIndex;

@end
