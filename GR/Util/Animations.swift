//
//  Animations.swift
//  GR
//
//  Created by 中森えみり on 2021/07/19.
//

import Foundation
import Lottie

class Util{
    
    static func startAnimation(name:String,view:UIView){
        let animationView = AnimationView()
        let animation = Animation.named(name)
        animationView.frame = view.bounds
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        view.addSubview(animationView)
        animationView.play { finish in
            
            if finish{
                animationView.removeFromSuperview()
            }
        }
        
        
    }
    
}
