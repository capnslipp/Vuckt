// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>



struct Int3 {
	NSInteger x, y, z;
};
typedef struct Int3 Int3;



@interface NSValue (Int3Additions)

+ (NSValue *)valueWithInt3:(Int3)int3Value;

@property(nonatomic, readonly) Int3 int3Value;

@end
