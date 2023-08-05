//
//  JellyPresentationManager.swift
//  Chibha
//
//  Created by Sachin Khosla on 15/09/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import Foundation
import Jelly

class JellyPresentationManager {
    class func getSlideInPopupAnimation(targetSize: CGSize) -> JellyPresentation {
        
        let presentation = JellySlideInPresentation(
            dismissCurve: .easeInEaseOut,
            presentationCurve: .easeInEaseOut,
            backgroundStyle: .dimmed(alpha: 0.0),
            directionShow: .bottom,
            directionDismiss: .bottom,
            widthForViewController: .custom(value: targetSize.width),
            heightForViewController: .custom(value: targetSize.height)
        )
        return presentation
    }
}
