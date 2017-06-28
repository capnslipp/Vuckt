// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>



struct Int3_CStruct {
	NSInteger x, y, z;
};
typedef struct Int3_CStruct Int3_C;

static const char *Int3_CStruct_objCTypeEncoding = @encode(struct Int3_CStruct);



@interface NSValue (Int3Additions)

+ (NSValue *)valueWithInt3:(Int3_C)int3Value;

@property(nonatomic, readonly) Int3_C int3Value;

@end
