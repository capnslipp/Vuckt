// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#if _runtime(_ObjC)

fileprivate let Int2InNSValueObjCType = NSValue(int2: Int2()).objCType


extension Int2: _ObjectiveCBridgeable {
  public func _bridgeToObjectiveC() -> NSValue {
    return { NSValue(int2: $0) }(self)
  }

  public static func _forceBridgeFromObjectiveC(_ source: NSValue,
                                                result: inout Int2?) {
    precondition(strcmp(source.objCType,
                        { _ in Int2InNSValueObjCType }(Int2.self)) == 0,
                 "NSValue does not contain the right type to bridge to Int2")
    result = { $0.int2Value }(source)
  }

  public static func _conditionallyBridgeFromObjectiveC(_ source: NSValue,
                                                        result: inout Int2?)
      -> Bool {
    if strcmp(source.objCType, { _ in Int2InNSValueObjCType }(Int2.self)) != 0 {
      result = nil
      return false
    }
    result = { $0.int2Value }(source)
    return true
  }

  public static func _unconditionallyBridgeFromObjectiveC(_ source: NSValue?)
      -> Int2 {
    let unwrappedSource = source!
    precondition(strcmp(unwrappedSource.objCType,
                        { _ in Int2InNSValueObjCType }(Int2.self)) == 0,
                 "NSValue does not contain the right type to bridge to Int2")
    return { $0.int2Value }(unwrappedSource)
  }
}


#endif // _runtime(_ObjC)
