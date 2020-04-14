// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#if _runtime(_ObjC)

fileprivate let FloatQuaternionInNSValueObjCType = NSValue(floatQuaternion: FloatQuaternion()).objCType


extension FloatQuaternion: _ObjectiveCBridgeable {
  public func _bridgeToObjectiveC() -> NSValue {
    return { NSValue(floatQuaternion: $0) }(self)
  }

  public static func _forceBridgeFromObjectiveC(_ source: NSValue,
                                                result: inout FloatQuaternion?) {
    precondition(strcmp(source.objCType,
                        { _ in FloatQuaternionInNSValueObjCType }(FloatQuaternion.self)) == 0,
                 "NSValue does not contain the right type to bridge to FloatQuaternion")
    result = { $0.floatQuaternionValue }(source)
  }

  public static func _conditionallyBridgeFromObjectiveC(_ source: NSValue,
                                                        result: inout FloatQuaternion?)
      -> Bool {
    if strcmp(source.objCType, { _ in FloatQuaternionInNSValueObjCType }(FloatQuaternion.self)) != 0 {
      result = nil
      return false
    }
    result = { $0.floatQuaternionValue }(source)
    return true
  }

  public static func _unconditionallyBridgeFromObjectiveC(_ source: NSValue?)
      -> FloatQuaternion {
    let unwrappedSource = source!
    precondition(strcmp(unwrappedSource.objCType,
                        { _ in FloatQuaternionInNSValueObjCType }(FloatQuaternion.self)) == 0,
                 "NSValue does not contain the right type to bridge to FloatQuaternion")
    return { $0.floatQuaternionValue }(unwrappedSource)
  }
}


#endif // _runtime(_ObjC)
