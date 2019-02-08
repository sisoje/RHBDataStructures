import Foundation

public class SortDescriptor<T>: NSSortDescriptor {}

public extension KeyPath where Value: Comparable {
    func sortDescriptor(ascending: Bool) -> SortDescriptor<Root> {
        return SortDescriptor(keyPath: self, ascending: ascending)
    }
}
