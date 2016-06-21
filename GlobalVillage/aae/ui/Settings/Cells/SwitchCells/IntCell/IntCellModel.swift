import Foundation

class IntCellModel:SettingModel, SwitchCellModelProtocol {
    var minValue = 0
    var maxValue = 1000
    var count:Int {
        get {
            return pickerData.count
        }
    }
    var rawValues = [1, 2, 3, 4, 5, 6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,30,35,40,45,50,60,70,80,90,100,125,150,175,200,250,500,750,1000]
    
    var pickerData:[Int] {
        var values = [Int]()
        for index in 0 ..< rawValues.count {
            let rawValue = rawValues[index]
            if rawValue >= minValue && rawValue <= maxValue {
                values.append(rawValue)
            }
        }
        return values
    }
    func getDataAtIndex(index:Int) -> AnyObject {
        return pickerData[index]
    }
}