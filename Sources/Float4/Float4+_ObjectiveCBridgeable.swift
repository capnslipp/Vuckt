// IntN
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#if _runtime(_ObjC)

fileprivate let Float4InNSValueObjCType = NSValue(float4: Float4()).objCType


extension Float4: _ObjectiveCBridgeable {
  public func _bridgeToObjectiveC() -> NSValue {
    return { NSValue(float4: $0) }(self)
  }

  public static func _forceBridgeFromObjectiveC(_ source: NSValue,
                                                result: inout Float4?) {
    precondition(strcmp(source.objCType,
                        { _ in Float4InNSValueObjCType }(Float4.self)) == 0,
                 "NSValue does not contain the right type to bridge to Float4")
    result = { $0.float4Value }(source)
  }

  public static func _conditionallyBridgeFromObjectiveC(_ source: NSValue,
                                                        result: inout Float4?)
      -> Bool {
    if strcmp(source.objCType, { _ in Float4InNSValueObjCType }(Float4.self)) != 0 {
      result = nil
      return false
    }
    result = { $0.float4Value }(source)
    return true
  }

  public static func _unconditionallyBridgeFromObjectiveC(_ source: NSValue?)
      -> Float4 {
    let unwrappedSource = source!
    precondition(strcmp(unwrappedSource.objCType,
                        { _ in Float4InNSValueObjCType }(Float4.self)) == 0,
                 "NSValue does not contain the right type to bridge to Float4")
    return { $0.float4Value }(unwrappedSource)
  }
}


#endif // _runtime(_ObjC)
