//
//  Emitterable.swift
//  AYPageView
//
//  Created by Andy on 2022/9/21.
//

import UIKit

protocol Emitterable {}

extension Emitterable where Self : UIViewController {
    
    func startEmittering(_ position: CGPoint) {
        
        let emitter = CAEmitterLayer()
        
        emitter.emitterPosition = position
        
        emitter.preservesDepth = true
        
        let cell = CAEmitterCell()
        
        cell.velocity = 100
        
        cell.velocityRange = 50
        
        cell.scale = 0.7
        
        cell.scaleRange = 0.3
        
        // 纬度(水平方向)
        cell.emissionLatitude = -CGFloat(M_PI_2)
        
        cell.emissionRange = CGFloat(M_PI_2/6)
        
        cell.lifetime = 3
        cell.lifetimeRange = 1.5
        
        cell.birthRate = 10
        
        cell.contents = UIImage(named: "")
        
        emitter.emitterCells = [cell]
        
        view.layer.addSublayer(emitter)
    }
    
    
    func stopEmittering() {
        view.layer.sublayers?.filter({ $0.isKind(of: CAEmitterLayer.self) }).first?.removeFromSuperlayer()
    }
    
}
