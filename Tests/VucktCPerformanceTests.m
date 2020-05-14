//
//  VucktCTests.m
//  Vuckt
//
//  Created by Cap'n Slipp on 5/13/20.
//

#import <XCTest/XCTest.h>
#import <simd/simd.h>



float randomFloatFromNegOneToPosOne() {
	float randomFloat = (float)(arc4random() % ((uint32_t)RAND_MAX + 1)) / RAND_MAX;
	return randomFloat * 2.0 - 1.0;
}

static const int kIterationCount = 1000000;



@interface VucktCTests : XCTestCase
@end


@implementation VucktCTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testSimdFloat3Performance
{
	simd_float3 *testSetA = calloc(kIterationCount, sizeof(simd_float3));
	simd_float3 *testSetB = calloc(kIterationCount, sizeof(simd_float3));
	for (int i = 0; i < 1000000; ++i) {
		float value = (float)i;
		testSetA[i] = (simd_float3){
			value + (0 + randomFloatFromNegOneToPosOne()),
			value - (500 + randomFloatFromNegOneToPosOne()),
			value * (2.5 + randomFloatFromNegOneToPosOne())
		};
		testSetB[i] = (simd_float3){
			value + (500 + randomFloatFromNegOneToPosOne()),
			-value * (10.0 + randomFloatFromNegOneToPosOne()),
			value / (2.0 + randomFloatFromNegOneToPosOne())
		};
	}
	
	[self measureBlock:^{
		for (int i = 0; i < kIterationCount; ++i) {
			simd_float3 result;
			result = testSetA[i] + testSetB[i];
			result = testSetA[i] - testSetB[i];
			result = testSetA[i] * testSetB[i];
			result = testSetA[i] / testSetB[i];
			(void)result;
			bool resultB;
			resultB = simd_all(testSetA[i] < testSetB[i]);
			resultB = simd_all(testSetA[i] <= testSetB[i]);
			resultB = simd_all(testSetA[i] == testSetB[i]);
			(void)resultB;
		}
	}];
	
	free(testSetA);
	free(testSetB);
}

@end
