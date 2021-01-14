//
//  BodyLabel.swift

import UIKit


class BodyLabel: UILabel {

override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(textAlignment:NSTextAlignment,fontsSize:CGFloat) {
    super.init(frame: .zero)
    configure()

    self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontsSize, weight: .bold)
    }
    
    
    private func configure () {
        textColor                 = .label
        adjustsFontSizeToFitWidth = true
        font                      = UIFont.preferredFont(forTextStyle: .body)
        minimumScaleFactor        = 0.75
        lineBreakMode             = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines             = 4
    
    }
}


