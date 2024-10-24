//
//  VMPickerViewCell.swift
//  VMPickerViewDemo
//
//  Created by Vasi Margariti on 18/10/2024.
//

import UIKit

class VMPickerViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    // label
    var titleLabel: UILabel!
    
    // color
    var highlightedColor: UIColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    
    // bool
    var isPicked: Bool = false {
        didSet {
            if self.isPicked {
                self.highlightedAppearance()
            } else {
                self.unhighlightedAppearance()
            }
        }
    }
    
    
    
    
    
    
    // MARK: - Overrides
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    
    
    
    
    // MARK: - Methods
    func highlightedAppearance() {
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.titleLabel.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        
    }
    func unhighlightedAppearance() {
        self.titleLabel.textColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.6)
        self.titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        self.titleLabel.backgroundColor = .clear
    }



    
    
}
extension VMPickerViewCell {
    func setup() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = 8
        titleLabel.clipsToBounds = true
        self.unhighlightedAppearance()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        //-
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
}

