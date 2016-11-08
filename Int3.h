// SlidingPuzzleCity
// @copyright: Slipp Douglas Thompson
// @copyright date: The date(s) of version control check-ins corresponding to this file and this project as a whole; or in lieu of, no earlier than November 2016.
#pragma once

#import <Foundation/NSValue.h>



struct Int3_CStruct {
	NSInteger x, y, z;
};
typedef struct Int3_CStruct Int3;

static const char *Int3_CStruct_objCTypeEncoding = @encode(struct Int3_CStruct);



@interface NSValue (Int3Additions)

+ (NSValue *)valueWithInt3:(Int3)int3Value;

@property(nonatomic, readonly) Int3 int3Value;

@end
