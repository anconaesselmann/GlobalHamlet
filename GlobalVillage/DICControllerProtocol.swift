import CoreData
@objc protocol DICControllerProtocol: InitArgsInterface {
    var dic: DICProtocol! { get set }
}