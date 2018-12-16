// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#if _runtime(_ObjC)

fileprivate let Float3InNSValueObjCType = NSValue(float3: Float3()).objCType


extension Float3: _ObjectiveCBridgeable {
  public func _bridgeToObjectiveC() -> NSValue {
    return { NSValue(float3: $0) }(self)
  }

  public static func _forceBridgeFromObjectiveC(_ source: NSValue,
                                                result: inout Float3?) {
    precondition(strcmp(source.objCType,
                        { _ in Float3InNSValueObjCType }(Float3.self)) == 0,
                 "NSValue does not contain the right type to bridge to Float3")
    result = { $0.float3Value }(source)
  }

  public static func _conditionallyBridgeFromObjectiveC(_ source: NSValue,
                                                        result: inout Float3?)
      -> Bool {
    if strcmp(source.objCType, { _ in Float3InNSValueObjCType }(Float3.self)) != 0 {
      result = nil
      return false
    }
    result = { $0.float3Value }(source)
    return true
  }

  public static func _unconditionallyBridgeFromObjectiveC(_ source: NSValue?)
      -> Float3 {
    let unwrappedSource = source!
    precondition(strcmp(unwrappedSource.objCType,
                        { _ in Float3InNSValueObjCType }(Float3.self)) == 0,
                 "NSValue does not contain the right type to bridge to Float3")
    return { $0.float3Value }(unwrappedSource)
  }
}


#endif // _runtime(_ObjC)
