import Foundation

@objc protocol CreatorWithSettingsProtocol {
    var connectionDetails:SettingsProtocol! {get set}
}