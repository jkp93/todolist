//
//  TaskTableViewCell.swift
//  ToDo
//
//  Created by 박중권 on 3/25/24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneSwitch: UISwitch!

    var switchValueChanged: ((Bool) -> Void)?

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        switchValueChanged?(sender.isOn)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doneSwitch.isOn = false // 스위치 값 초기화
        titleLabel.numberOfLines = 0 // 여러 줄 형성하는 코드
        titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width // preferredMaxLayoutWidth 을 label의 길이 만큼 조정
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

