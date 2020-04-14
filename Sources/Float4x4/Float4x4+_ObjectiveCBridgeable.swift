// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#if _runtime(_ObjC)

fileprivate let Float4x4InNSValueObjCType = NSValue(float4x4: Float4x4()).objCType


extension Float4x4: _ObjectiveCBridgeable {
  public func _bridgeToObjectiveC() -> NSValue {
    return { NSValue(float4x4: $0) }(self)
  }

  public static func _forceBridgeFromObjectiveC(_ source: NSValue,
                                                result: inout Float4x4?) {
    precondition(strcmp(source.objCType,
                        { _ in Float4x4InNSValueObjCType }(Float4x4.self)) == 0,
                 "NSValue does not contain the right type to bridge to Float4x4")
    result = { $0.float4x4Value }(source)
  }

  public static func _conditionallyBridgeFromObjectiveC(_ source: NSValue,
                                                        result: inout Float4x4?)
      -> Bool {
    if strcmp(source.objCType, { _ in Float4x4InNSValueObjCType }(Float4x4.self)) != 0 {
      result = nil
      return false
    }
    result = { $0.float4x4Value }(source)
    return true
  }

  public static func _unconditionallyBridgeFromObjectiveC(_ source: NSValue?)
      -> Float4x4 {
    let unwrappedSource = source!
    precondition(strcmp(unwrappedSource.objCType,
                        { _ in Float4x4InNSValueObjCType }(Float4x4.self)) == 0,
                 "NSValue does not contain the right type to bridge to Float4x4")
    return { $0.float4x4Value }(unwrappedSource)
  }
}


#endif // _runtime(_ObjC)
