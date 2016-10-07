import Quartz
import PlaygroundSupport
import SwiftyHaru

public extension SwiftyHaru.PDFDocument {
    
    public func display() {
        
        let view = PDFView(frame: NSRect(x: 0, y: 0, width: 480, height: 640))
        
        view.document = PDFDocument(data: getData())
        
        view.scaleFactor = 0.75
        
        PlaygroundPage.current.liveView = view
    }
}

