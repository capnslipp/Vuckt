// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
#pragma once

#import <Foundation/NSValue.h>
#import <simd/vector_types.h>
#import <SceneKit/SceneKitTypes.h>
#if !TARGET_OS_WATCH && !TARGET_OS_XR
	#import <GLKit/GLKQuaternion.h>
#endif
#if !TARGET_OS_WATCH
	#import <GameController/GCMotion.h>
#endif
#if !TARGET_OS_TV
	#import <CoreMotion/CMAttitude.h>
#endif



NS_ASSUME_NONNULL_BEGIN



#pragma mark Struct Definition

struct FloatQuaternion {
	float ix, iy, iz, r;
} __attribute__((aligned(__alignof__(simd_quatf))));
typedef struct FloatQuaternion FloatQuaternion;



#pragma mark SIMD Conversion

/// Converts a `FloatQuaternion` struct to `simd_quatf` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE simd_quatf FloatQuaternionToSimd(FloatQuaternion structValue) {
	return *(simd_quatf *)&structValue;
}
/// Converts a `FloatQuaternion` struct from `simd_quatf` vector using zero-op/(dangerous?) C-casts.
/// (Sanity `static_assert`s in the `.mm` file do their best to ensure out struct's layout match the simd vector's.)
NS_INLINE FloatQuaternion FloatQuaternionFromSimd(simd_quatf simdValue) {
	return *(FloatQuaternion *)&simdValue;
}



#pragma mark SceneKit Conversion

/// Converts a `FloatQuaternion` struct to `SCNQuaternion` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
NS_INLINE SCNQuaternion FloatQuaternionToSCN(FloatQuaternion structValue) {
	return SCNVector4FromFloat4(FloatQuaternionToSimd(structValue).vector);
}
/// Converts a `FloatQuaternion` struct from `SCNQuaternion` struct using SceneKit-provided SIMD↔SCNVector conversion helper function.
NS_INLINE FloatQuaternion FloatQuaternionFromSCN(SCNQuaternion scnValue) {
	return FloatQuaternionFromSimd(simd_quaternion(SCNVector4ToFloat4(scnValue)));
}



#if !TARGET_OS_WATCH && !TARGET_OS_XR
	#pragma mark GLKit Conversion

	/// Converts a `FloatQuaternion` struct to `GLKQuaternion` struct using passing-individual-members initialization.
	NS_INLINE GLKQuaternion FloatQuaternionToGLK(FloatQuaternion structValue) {
		return GLKQuaternionMake(structValue.ix, structValue.iy, structValue.iz, structValue.r);
	}
	/// Converts a `FloatQuaternion` struct from `GLKQuaternion` struct using passing-individual-members initialization.
	NS_INLINE FloatQuaternion FloatQuaternionFromGLK(GLKQuaternion glkValue) {
		return (FloatQuaternion){ glkValue.q[0], glkValue.q[1], glkValue.q[2], glkValue.q[3] };
	}
#endif // !TARGET_OS_WATCH



#if !TARGET_OS_TV
	#pragma mark CoreMotion Conversion

	/// Converts a `FloatQuaternion` struct to `CMQuaternion` struct using passing-individual-members initialization.
	NS_INLINE CMQuaternion FloatQuaternionToCM(FloatQuaternion structValue) {
		return (CMQuaternion){ structValue.ix, structValue.iy, structValue.iz, structValue.r };
	}
	/// Converts a `FloatQuaternion` struct from `CMQuaternion` struct using passing-individual-members initialization.
	NS_INLINE FloatQuaternion FloatQuaternionFromCM(CMQuaternion cmValue) {
		return (FloatQuaternion){ (float)cmValue.x, (float)cmValue.y, (float)cmValue.z, (float)cmValue.w };
	}
#endif // !TARGET_OS_TV



#if !TARGET_OS_WATCH
	#pragma mark GameController Conversion

	/// Converts a `FloatQuaternion` struct to `GCQuaternion` struct using passing-individual-members initialization.
	NS_INLINE GCQuaternion FloatQuaternionToGC(FloatQuaternion structValue) {
		return (GCQuaternion){ structValue.ix, structValue.iy, structValue.iz, structValue.r };
	}
	/// Converts a `FloatQuaternion` struct from `GCQuaternion` struct using passing-individual-members initialization.
	NS_INLINE FloatQuaternion FloatQuaternionFromGC(GCQuaternion gcValue) {
		return (FloatQuaternion){ (float)gcValue.x, (float)gcValue.y, (float)gcValue.z, (float)gcValue.w };
	}
#endif // !TARGET_OS_WATCH



#pragma mark `NSValue`-Wrapping

@interface NSValue (FloatQuaternionAdditions)

+ (NSValue *)valueWithFloatQuaternion:(FloatQuaternion)floatQuaternionValue;

@property(nonatomic, readonly) FloatQuaternion floatQuaternionValue;

@end



NS_ASSUME_NONNULL_END
