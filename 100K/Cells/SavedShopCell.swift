//
//  SavedShopCell.swift
//  100K
//
//  Created by TXB4 on 10/01/2021.
//


import UIKit

class SavedShopCell: UITableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    static let reuseID  = "SavedShopCell"
    let editImageView   = ImageView(frame:.zero)
    let titleLabel      = TitleLabel(textAlignment:.left , fontsSize: 16)
    let nickNameLabel   = BodyLabel(textAlignment: .left, fontsSize: 13)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    private func configure () {
        
        addSubview(editImageView)
        addSubview(titleLabel)
        addSubview(nickNameLabel)
        accessoryType = .disclosureIndicator
        
        backgroundColor           = .systemGray5
        editImageView.image       = SFSymbols.icon
        editImageView.image       = editImageView.image!.withRenderingMode(.alwaysTemplate)
        editImageView.tintColor   = UIColor.systemGray
        editImageView.layer.cornerRadius = 10
        
        titleLabel.anchor(top:self.topAnchor,leading: editImageView.leadingAnchor,paddingTop: 20, paddingLeft: 60,height: 40)
        nickNameLabel.anchor(top: titleLabel.bottomAnchor,leading:editImageView.leadingAnchor, paddingTop: 0,paddingLeft: 60,height: 20)
        editImageView.anchor(top:self.topAnchor ,leading: self.leadingAnchor, paddingTop: 20, paddingLeft: 20, width: 40, height: 40)
    }
    
    
}
