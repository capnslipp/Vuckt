// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#if _runtime(_ObjC)

fileprivate let Float3x3InNSValueObjCType = NSValue(float3x3: Float3x3()).objCType


extension Float3x3: _ObjectiveCBridgeable {
  public func _bridgeToObjectiveC() -> NSValue {
    return { NSValue(float3x3: $0) }(self)
  }

  public static func _forceBridgeFromObjectiveC(_ source: NSValue,
                                                result: inout Float3x3?) {
    precondition(strcmp(source.objCType,
                        { _ in Float3x3InNSValueObjCType }(Float3x3.self)) == 0,
                 "NSValue does not contain the right type to bridge to Float3x3")
    result = { $0.float3x3Value }(source)
  }

  public static func _conditionallyBridgeFromObjectiveC(_ source: NSValue,
                                                        result: inout Float3x3?)
      -> Bool {
    if strcmp(source.objCType, { _ in Float3x3InNSValueObjCType }(Float3x3.self)) != 0 {
      result = nil
      return false
    }
    result = { $0.float3x3Value }(source)
    return true
  }

  public static func _unconditionallyBridgeFromObjectiveC(_ source: NSValue?)
      -> Float3x3 {
    let unwrappedSource = source!
    precondition(strcmp(unwrappedSource.objCType,
                        { _ in Float3x3InNSValueObjCType }(Float3x3.self)) == 0,
                 "NSValue does not contain the right type to bridge to Float3x3")
    return { $0.float3x3Value }(unwrappedSource)
  }
}


#endif // _runtime(_ObjC)
