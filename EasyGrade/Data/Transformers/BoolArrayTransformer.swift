import Foundation

@objc(BoolArrayTransformer)
class BoolArrayTransformer: ValueTransformer {
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let boolArray = value as? [Bool] else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: boolArray, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let boolArray = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSNumber.self], from: data) as? [Bool]
            return boolArray
        } catch {
            return nil
        }
    }
}
