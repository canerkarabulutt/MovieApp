//
//  Extension.swift
//  MovieApp
//
//  Created by Caner Karabulut on 22.11.2023.
//

import UIKit

extension UIView {
        func backgroundGradientColor() {
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor.alpha]
            gradient.locations = [0,1]
            gradient.frame = bounds
            layer.addSublayer(gradient)
    }
}
extension String {
    func capitalizeLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
