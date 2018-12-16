// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#if _runtime(_ObjC)

fileprivate let Float2InNSValueObjCType = NSValue(float2: Float2()).objCType


extension Float2: _ObjectiveCBridgeable {
  public func _bridgeToObjectiveC() -> NSValue {
    return { NSValue(float2: $0) }(self)
  }

  public static func _forceBridgeFromObjectiveC(_ source: NSValue,
                                                result: inout Float2?) {
    precondition(strcmp(source.objCType,
                        { _ in Float2InNSValueObjCType }(Float2.self)) == 0,
                 "NSValue does not contain the right type to bridge to Float2")
    result = { $0.float2Value }(source)
  }

  public static func _conditionallyBridgeFromObjectiveC(_ source: NSValue,
                                                        result: inout Float2?)
      -> Bool {
    if strcmp(source.objCType, { _ in Float2InNSValueObjCType }(Float2.self)) != 0 {
      result = nil
      return false
    }
    result = { $0.float2Value }(source)
    return true
  }

  public static func _unconditionallyBridgeFromObjectiveC(_ source: NSValue?)
      -> Float2 {
    let unwrappedSource = source!
    precondition(strcmp(unwrappedSource.objCType,
                        { _ in Float2InNSValueObjCType }(Float2.self)) == 0,
                 "NSValue does not contain the right type to bridge to Float2")
    return { $0.float2Value }(unwrappedSource)
  }
}


#endif // _runtime(_ObjC)
