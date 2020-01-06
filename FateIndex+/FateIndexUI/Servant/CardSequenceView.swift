//
//  CardSequenceView.swift
//  FateIndex+
//
//  Created by PeterGuan on 2019/10/4.
//  Copyright © 2019 管君. All rights reserved.
//

import UIKit

class CardSequenceView: UIView {

    private struct Constants {
        static let margin: CGFloat = 5.0
    }

    let cardViews = [UIImageView(), UIImageView(), UIImageView(), UIImageView(), UIImageView()]

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        cardViews.forEach { addSubview($0) }
    }

    func configure(servant: Servant) {
//        let arts = servant.card.arts.count
//        let quick = servant.card.quick.count
//        let buster = servant.card.buster.count
//
//        for (index, element) in cardSequence.enumerated() {
//            cardViews[index].image = UIImage(named: element.rawValue)
//        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let size = bounds.size
        let width = size.height

        for (index, element) in cardViews.enumerated() {
            let mul = CGFloat(index)
            let subtract: CGFloat

            if index == cardViews.count - 1 {
                subtract = width
            }
            else {
                subtract = width + Constants.margin
            }

            element.frame = CGRect(x: size.width - subtract * (CGFloat(cardViews.count) - mul), y: 0, width: width, height: size.height)
        }
    }
}
