//
//  EQOperation.h
//  Equili
//
//  Created by Baldoph on 29/03/2013.
//  Copyright (c) 2013 Coronal Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FT2Operation : NSOperation

@property (nonatomic, copy) void (^block)(FT2Operation *);

- (id)initWithBlock:(void (^)(FT2Operation *operation))block;

@end
