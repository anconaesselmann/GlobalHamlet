@objc public protocol DICProtocol {
    func build(idString: String) -> AnyObject!
    func decorate(obj:InitArgsInterface, idString: String)
    func decorate(obj:InitArgsInterface)
}