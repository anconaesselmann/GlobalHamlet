import Foundation

protocol SwitchCellModelProtocol {
    var count:Int {get}
    func getDataAtIndex(index:Int) -> AnyObject
}