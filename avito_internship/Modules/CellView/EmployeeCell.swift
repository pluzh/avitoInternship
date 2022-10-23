//
//  EmployeeCellTableViewCell.swift
//  avito_internship
//
//  Created by Ангелина Плужникова on 21.10.2022.
//

import UIKit

class EmployeeCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var skillsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(with model: Employees, indexPath: IndexPath){
        nameLabel.text = model.name
        numberLabel.text = model.phoneNumber
        skillsLabel.text = model.skills.joined(separator: ", ")
    }
    
}
