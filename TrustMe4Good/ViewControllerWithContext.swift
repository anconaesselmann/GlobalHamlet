import CoreData
@objc protocol ViewControllerWithContext {
    var context: NSManagedObjectContext! { get set }
}