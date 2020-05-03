// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#if _runtime(_ObjC)

fileprivate let FloatRotorInNSValueObjCType = NSValue(floatRotor: FloatRotor()).objCType


extension FloatRotor: _ObjectiveCBridgeable {
  public func _bridgeToObjectiveC() -> NSValue {
    return { NSValue(floatRotor: $0) }(self)
  }

  public static func _forceBridgeFromObjectiveC(_ source: NSValue,
                                                result: inout FloatRotor?) {
    precondition(strcmp(source.objCType,
                        { _ in FloatRotorInNSValueObjCType }(FloatRotor.self)) == 0,
                 "NSValue does not contain the right type to bridge to FloatRotor")
    result = { $0.floatRotorValue }(source)
  }

  public static func _conditionallyBridgeFromObjectiveC(_ source: NSValue,
                                                        result: inout FloatRotor?)
      -> Bool {
    if strcmp(source.objCType, { _ in FloatRotorInNSValueObjCType }(FloatRotor.self)) != 0 {
      result = nil
      return false
    }
    result = { $0.floatRotorValue }(source)
    return true
  }

  public static func _unconditionallyBridgeFromObjectiveC(_ source: NSValue?)
      -> FloatRotor {
    let unwrappedSource = source!
    precondition(strcmp(unwrappedSource.objCType,
                        { _ in FloatRotorInNSValueObjCType }(FloatRotor.self)) == 0,
                 "NSValue does not contain the right type to bridge to FloatRotor")
    return { $0.floatRotorValue }(unwrappedSource)
  }
}


#endif // _runtime(_ObjC)
