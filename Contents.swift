import Foundation

let rawSample = NSData(contentsOf: Bundle.main.url(forResource: "ocr", withExtension:"json")!)!

var sampleData: AnyObject!

do {
    try sampleData = JSONSerialization.jsonObject(with: rawSample as Data, options: .allowFragments) as AnyObject!
} catch let error as NSError {
    print(error)
}

struct Box {
    var minX: Int
    var minY: Int
    var maxX: Int
    var maxY: Int
    var words = [Word]()
    init(minX: Int, minY: Int, maxX: Int, maxY: Int) {
        self.minX = minX
        self.minY = minY
        self.maxX = maxX
        self.maxY = maxY
    }
    
    public func checkY(yVal: Int) -> Bool{
        return (yVal <= self.maxY && yVal >= self.minY)
        //MARK: can also check against distance between top of lower bounding box and bottom of upper bounding box to see if it fits in upper box +- a few units
    }
    
}

struct Word {
    var x: Int
    var y: Int
    var text: String
}

var boxesArray = [Box]()

func convertToBoxes(data: [String: AnyObject]) {
    (data["regions"] as! [[String: AnyObject]]).forEach({(region) in
        let lines = region["lines"] as! [[String: AnyObject]]
        lines.forEach({line in
            let boundingBox = (line["boundingBox"]) as! String
            let coords = boundingBox.components(separatedBy: ",")
            print(coords)
            boxesArray.append(Box(minX: Int(coords[0])!, minY: Int(coords[1])!, maxX: Int(coords[2])!, maxY: Int(coords[3])!))
            
        })
        
    })
}


convertToBoxes(data: sampleData as! [String : AnyObject])