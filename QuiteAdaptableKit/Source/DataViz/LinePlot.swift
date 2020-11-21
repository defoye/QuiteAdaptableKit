//
//  LinePlot.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 11/21/20.
//

import UIKit

private struct Constants {
    
    static let drawBuffer: CGFloat = 30
    
    static let strokeColor: UIColor = .black
    static let fillColor: UIColor = .clear
}

public class LinePlot: UIView {
    
    private var points = [CGPoint]()
    private var fillColor: UIColor?
    private var graphLineWidth: CGFloat = 1.0
//    private var suffixPercent: Double = 0.0
    
    public func configure(points: [CGPoint], fillColor: UIColor?, graphLineWidth: CGFloat?) {
        self.points = points
        backgroundColor = .red
        self.fillColor = fillColor
        if let lineWidth = graphLineWidth { self.graphLineWidth = lineWidth }
    }
    
//    public func configure(withViewData viewData: [CGPoint], fillColor: UIColor?, graphLineWidth: CGFloat?, suffixPercentCutOff: Double?) {
//        self.points = viewData
//        backgroundColor = .red
//        self.fillColor = fillColor
//        if let lineWidth = graphLineWidth { self.graphLineWidth = lineWidth }
//        if let suffixPercent = suffixPercentCutOff { self.suffixPercent = suffixPercent }
//    }
    
    override public func draw(_ rect: CGRect) {
        if self.points.count <= 0 {return }
        
        //create the path
        let graphPath = UIBezierPath()
        let frameWidth: CGFloat = self.bounds.width
        let frameHeight: CGFloat = self.bounds.height
        var max_x: CGFloat = 0.0
        var max_y: CGFloat = 0.0
        var min_y: CGFloat = CGFloat.greatestFiniteMagnitude
        
        // Cutoff from front.  Accounts for user input percentage
//        points = points.suffix(Int(Double(points.count) * (suffixPercent > 1 ? suffixPercent / 100 : suffixPercent)))
        
        for point in points {
            max_x = CGFloat.maximum(max_x, point.x)
            max_y = CGFloat.maximum(max_y, point.y)
            min_y = CGFloat.minimum(min_y, point.y)
        }
        
        // Draw a plot that fully extends to borders of view
        // Assuming all points are equally spaced
        let horizontalIntervalLength = frameWidth / max_x
        let maxYOffsetted = (max_y - min_y)
        let verticalIntervalLength = frameHeight / maxYOffsetted
        
        //set the path's line width to the height of the stroke
        graphPath.lineWidth = graphLineWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        graphPath.move(to: CGPoint(
            x: self.bounds.minX,
            y: self.bounds.maxY))
        
        points = points.map { (point) -> CGPoint in
            CGPoint(x: point.x * horizontalIntervalLength, y: (frameHeight - (verticalIntervalLength * (point.y - min_y))))
        }
        
        for point in points {
            graphPath.addLine(to: CGPoint(x: point.x, y: point.y))
        }
        
        if let fillColor = fillColor {
            // Wrap line around lower axis to fill with color
            graphPath.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
            graphPath.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY))
            
            //set the stroke color
            fillColor.setStroke()
            graphPath.fill()
        }
        
        //draw the stroke
        UIView.animate(withDuration: 10.0) {
            graphPath.stroke()
        }
    }
}
