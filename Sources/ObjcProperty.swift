import Foundation

public extension objc_property_t {
    func typeInfo() -> String {
        NSString(utf8String: property_getAttributes(self)!)! as String
    }

    func propertyName() -> String {
        NSString(utf8String: property_getName(self))! as String
    }

    static func propertyList<T: NSObject>(_ t: T.Type) -> [objc_property_t] {
        var count32 = UInt32()
        guard let classPropertyList = class_copyPropertyList(t, &count32) else {
            return []
        }
        defer {
            free(classPropertyList)
        }
        return (0..<Int(count32)).map { classPropertyList[$0] }
    }
}
