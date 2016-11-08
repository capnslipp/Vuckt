// SlidingPuzzleCity
// @copyright: Slipp Douglas Thompson
// @copyright date: The date(s) of version control check-ins corresponding to this file and this project as a whole; or in lieu of, no earlier than November 2016.
#pragma once

#import <Foundation/NSObject.h>



NS_ASSUME_NONNULL_BEGIN

@interface Int3_ObjC : NSObject

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y z:(NSInteger)z;

@property(nonatomic, assign) NSInteger x;
@property(nonatomic, assign) NSInteger y;
@property(nonatomic, assign) NSInteger z;

@end

NS_ASSUME_NONNULL_END
