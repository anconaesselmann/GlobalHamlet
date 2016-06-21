import Foundation

class Error: NSObject {
    var errorCode = 0
    var errorMessage = ""
    override init() {}
    init(errorCode:Int, errorMessage:String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}