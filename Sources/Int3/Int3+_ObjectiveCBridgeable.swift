// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#if _runtime(_ObjC)

fileprivate let Int3InNSValueObjCType = NSValue(int3: Int3()).objCType


extension Int3: _ObjectiveCBridgeable {
  public func _bridgeToObjectiveC() -> NSValue {
    return { NSValue(int3: $0) }(self)
  }

  public static func _forceBridgeFromObjectiveC(_ source: NSValue,
                                                result: inout Int3?) {
    precondition(strcmp(source.objCType,
                        { _ in Int3InNSValueObjCType }(Int3.self)) == 0,
                 "NSValue does not contain the right type to bridge to Int3")
    result = { $0.int3Value }(source)
  }

  public static func _conditionallyBridgeFromObjectiveC(_ source: NSValue,
                                                        result: inout Int3?)
      -> Bool {
    if strcmp(source.objCType, { _ in Int3InNSValueObjCType }(Int3.self)) != 0 {
      result = nil
      return false
    }
    result = { $0.int3Value }(source)
    return true
  }

  public static func _unconditionallyBridgeFromObjectiveC(_ source: NSValue?)
      -> Int3 {
    let unwrappedSource = source!
    precondition(strcmp(unwrappedSource.objCType,
                        { _ in Int3InNSValueObjCType }(Int3.self)) == 0,
                 "NSValue does not contain the right type to bridge to Int3")
    return { $0.int3Value }(unwrappedSource)
  }
}


#endif // _runtime(_ObjC)
