//
//  TitleLabel.swift

import UIKit

class TitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(textAlignment:NSTextAlignment,fontsSize:CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontsSize, weight: .regular)
        configure()
        }
    
    
    private func configure () {
        textColor                 = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor        = 0.90
        numberOfLines             = 1
        lineBreakMode             = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}

