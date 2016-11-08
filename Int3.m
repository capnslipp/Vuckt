// SlidingPuzzleCity
// @copyright: Slipp Douglas Thompson
// @copyright date: The date(s) of version control check-ins corresponding to this file and this project as a whole; or in lieu of, no earlier than November 2016.

#import "Int3.h"


@implementation Int3_ObjC

@synthesize x=_x, y=_y, z=_z;


- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y z:(NSInteger)z
{
	self = [super init];
	if (!self)
		return nil;
	
	_x = x;
	_y = y;
	_z = z;
	
	return self;
}


@end
