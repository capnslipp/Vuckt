// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>



struct Int2 {
	NSInteger x, y;
};
typedef struct Int2 Int2;



@interface NSValue (Int2Additions)

+ (NSValue *)valueWithInt2:(Int2)int2Value;

@property(nonatomic, readonly) Int2 int2Value;

@end
