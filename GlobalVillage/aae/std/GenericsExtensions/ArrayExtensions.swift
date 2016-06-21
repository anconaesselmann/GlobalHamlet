import Foundation

extension Array {
    func getArrayWith(itemAtPosition indexA:Int, atPosition indexB:Int) -> [Element]? {
        return getArrayWith(itemsInRangeFrom: indexA, to: indexA, movedToPosition: indexB)
    }
    func getArrayWith(itemsInRangeFrom indexA:Int, to endRangeItem:Int, movedToPosition indexB:Int) -> [Element]? {
        guard indexA < self.count && indexA >= 0 else {return nil}
        guard indexB < self.count && indexB >= 0 else {return nil}
        guard endRangeItem < self.count && endRangeItem >= 0 else {return nil}
        guard indexB < self.count - (endRangeItem - indexA) else {return nil}
        var headEnd:Int!
        var midBegin:Int!
        var midEnd:Int!
        var tailBegin:Int!
        
        let rangeLength = endRangeItem - indexA
        
        let removeBefore:((Int,Int)->Bool) = {$0 < $1}
        
        if indexA < indexB {
            headEnd   = indexA
            midBegin  = indexA + rangeLength + 1
            midEnd    = indexB + rangeLength + 1
            tailBegin = indexB + rangeLength + 1
        } else if indexA > indexB {
            headEnd   = indexB
            midBegin  = indexB
            midEnd    = indexA
            tailBegin = indexA + rangeLength + 1
        } else {
            return self
        }
        var new = [Element]()
        for i in 0.stride(to: headEnd, by: 1) {
            new.append(self[i])
        }
        if !removeBefore(indexA, indexB) {
            for i in indexA.stride(to: endRangeItem + 1, by: 1) {
                new.append(self[i])
            }
        }
        for i in midBegin.stride(to: midEnd, by: 1) {
            new.append(self[i])
        }
        if removeBefore(indexA, indexB) {
            for i in indexA.stride(to: endRangeItem + 1, by: 1) {
                new.append(self[i])
            }
        }
        for i in tailBegin.stride(to: self.count, by: 1) {
            new.append(self[i])
        }
        return new
    }
}