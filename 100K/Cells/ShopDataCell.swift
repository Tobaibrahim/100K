//
//  ShopDataCell.swift
//  100K
//
//  Created by TXB4 on 14/01/2021.
//

import UIKit


class ShopDataCell: UITableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    static let reuseID  = "ShopDataCell"
    let editImageView   = ImageView(frame:.zero)
    let titleLabel      = TitleLabel(textAlignment:.left , fontsSize: 17)
    let shopItemValueLabel   = BodyLabel(textAlignment: .center, fontsSize: 25)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    private func configure () {
        
//        addSubview(editImageView)
        addSubview(titleLabel)
        addSubview(shopItemValueLabel)
        accessoryType = .disclosureIndicator
        
        backgroundColor           = .systemGray5
        editImageView.image       = SFSymbols.icon
        editImageView.image       = editImageView.image!.withRenderingMode(.alwaysTemplate)
        editImageView.tintColor   = UIColor.systemGray
        editImageView.layer.cornerRadius = 10
        
        titleLabel.anchor(top:self.topAnchor,leading: self.leadingAnchor,trailing: self.trailingAnchor,paddingTop: 20, paddingLeft: 20,paddingRight: 160,height: 40)

        shopItemValueLabel.anchor(top:self.topAnchor,leading:titleLabel.leadingAnchor,trailing: self.trailingAnchor,paddingTop: 20,paddingLeft: 320,paddingRight: 20,height: 40)
        
//        editImageView.anchor(top:self.topAnchor ,leading: self.leadingAnchor, paddingTop: 20, paddingLeft: 20, width: 40, height: 40)
    }
    
}
