// Vuckt
// @author: Slipp Douglas Thompson
// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.

#if _runtime(_ObjC)

fileprivate let Int4InNSValueObjCType = NSValue(int4: Int4()).objCType


extension Int4: _ObjectiveCBridgeable {
  public func _bridgeToObjectiveC() -> NSValue {
    return { NSValue(int4: $0) }(self)
  }

  public static func _forceBridgeFromObjectiveC(_ source: NSValue,
                                                result: inout Int4?) {
    precondition(strcmp(source.objCType,
                        { _ in Int4InNSValueObjCType }(Int4.self)) == 0,
                 "NSValue does not contain the right type to bridge to Int4")
    result = { $0.int4Value }(source)
  }

  public static func _conditionallyBridgeFromObjectiveC(_ source: NSValue,
                                                        result: inout Int4?)
      -> Bool {
    if strcmp(source.objCType, { _ in Int4InNSValueObjCType }(Int4.self)) != 0 {
      result = nil
      return false
    }
    result = { $0.int4Value }(source)
    return true
  }

  public static func _unconditionallyBridgeFromObjectiveC(_ source: NSValue?)
      -> Int4 {
    let unwrappedSource = source!
    precondition(strcmp(unwrappedSource.objCType,
                        { _ in Int4InNSValueObjCType }(Int4.self)) == 0,
                 "NSValue does not contain the right type to bridge to Int4")
    return { $0.int4Value }(unwrappedSource)
  }
}


#endif // _runtime(_ObjC)
