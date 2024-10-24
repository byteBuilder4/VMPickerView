//
//  UIColorExtension.swift
//  VMPickerViewDemo
//
//  Created by Vasi Margariti on 23/10/2024.
//

import UIKit

extension UIColor {
    
    /// Interpolates between two colors (from and to) based on a progress value.
    ///
    /// - Parameters:
    ///   - from: The starting color.
    ///   - to: The ending color.
    ///   - progress: The progress value between 0 and 1, where 0 returns the `from` color, and 1 returns the `to` color.
    /// - Returns: The interpolated `UIColor`.
    func interpolateColor(from: UIColor, to: UIColor, progress: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        
        from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let red = fromRed + (toRed - fromRed) * progress
        let green = fromGreen + (toGreen - fromGreen) * progress
        let blue = fromBlue + (toBlue - fromBlue) * progress
        let alpha = fromAlpha + (toAlpha - fromAlpha) * progress
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
