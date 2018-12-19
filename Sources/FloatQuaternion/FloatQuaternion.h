// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/vector_types.h>
#import <SceneKit/SceneKitTypes.h>
#import <GLKit/GLKQuaternion.h>



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct FloatQuaternion {
	float ix, iy, iz, r;
} __attribute__((aligned(__alignof__(simd_quatf))));
typedef struct FloatQuaternion FloatQuaternion;



#pragma mark SIMD Conversion

/// Converts an `FloatQuaternion` struct to `simd_quatf` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE simd_quatf FloatQuaternionToSimd(FloatQuaternion structValue) {
	return *(simd_quatf *)&structValue;
}
/// Converts an `FloatQuaternion` struct from `simd_quatf` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE FloatQuaternion FloatQuaternionFromSimd(simd_quatf simdValue) {
	return *(FloatQuaternion *)&simdValue;
}



#pragma mark SceneKit Conversion

/// Converts an `FloatQuaternion` struct to `SCNQuaternion` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
NS_INLINE SCNQuaternion FloatQuaternionToSCN(FloatQuaternion structValue) {
	return SCNVector4FromFloat4(FloatQuaternionToSimd(structValue).vector);
}
/// Converts an `FloatQuaternion` struct from `SCNQuaternion` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
NS_INLINE FloatQuaternion FloatQuaternionFromSCN(SCNQuaternion scnValue) {
	return FloatQuaternionFromSimd(simd_quaternion(SCNVector4ToFloat4(scnValue)));
}



#pragma mark GLKit Conversion

/// Converts an `FloatQuaternion` struct to `GLKQuaternion` struct using passing-individual-members initialization.
NS_INLINE GLKQuaternion FloatQuaternionToGLK(FloatQuaternion structValue) {
	return GLKQuaternionMake(structValue.ix, structValue.iy, structValue.iz, structValue.r);
}
/// Converts an `FloatQuaternion` struct from `GLKQuaternion` struct using passing-individual-members initialization.
NS_INLINE FloatQuaternion FloatQuaternionFromGLK(GLKQuaternion glkValue) {
	return (FloatQuaternion){ glkValue.q[0], glkValue.q[1], glkValue.q[2], glkValue.q[3] };
}



#pragma mark `NSValue`-Wrapping

@interface NSValue (FloatQuaternionAdditions)

+ (NSValue *)valueWithFloatQuaternion:(FloatQuaternion)floatQuaternionValue;

@property(nonatomic, readonly) FloatQuaternion floatQuaternionValue;

@end



NS_ASSUME_NONNULL_END
