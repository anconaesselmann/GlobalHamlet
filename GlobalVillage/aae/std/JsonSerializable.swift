import Foundation

protocol JsonSerializable {
    func JsonSerialize() -> String?;
}