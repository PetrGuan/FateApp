//
//  SelectCountCell.swift
//  FateIndex
//
//  Created by Peter-Guan on 2020/6/1.
//  Copyright © 2020 管君. All rights reserved.
//

import UIKit

class SelectCountCell: UITableViewCell {

    private struct Contants {
        static let padding: CGFloat = 16.0
        static let imageSize: CGFloat = 25.0
        static let labelWidth: CGFloat = 40.0
    }

    static let identifier = "SelectCountCell"

    private let plusButton = UIButton(frame: .zero)
    private let minusButton = UIButton(frame: .zero)
    private let levelLabel = UILabel(frame: .zero)

    var plusAction: (() -> Void)?
    var minusAction: (() -> Void)?

    var countValue: Int {
        didSet {
            levelLabel.text = "\(countValue)"
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        countValue = 1
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        selectionStyle = .none

        plusButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        minusButton.setImage(UIImage(systemName: "minus.circle"), for: .normal)

        contentView.addSubview(plusButton)
        contentView.addSubview(minusButton)
        contentView.addSubview(levelLabel)

        plusButton.addTarget(self, action: #selector(handlePlusButtonTapped(_:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(handleMinusButtonTapped(_:)), for: .touchUpInside)

        levelLabel.textAlignment = .center
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let padding = (height - Contants.imageSize) / 2.0
        plusButton.frame = CGRect(x: width - Contants.imageSize - Contants.padding, y: padding, width: Contants.imageSize, height: Contants.imageSize)
        levelLabel.frame = CGRect(x: plusButton.left - Contants.labelWidth - Contants.padding, y: padding, width: Contants.labelWidth, height: Contants.imageSize)
        minusButton.frame = CGRect(x: levelLabel.left - Contants.imageSize - Contants.padding, y: padding, width: Contants.imageSize, height: Contants.imageSize)
    }

    @objc private func handlePlusButtonTapped(_ sender: UIButton) {
        plusAction?()
    }

    @objc private func handleMinusButtonTapped(_ sender: UIButton) {
        minusAction?()
    }
}
