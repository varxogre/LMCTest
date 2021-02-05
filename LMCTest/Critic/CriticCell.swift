//
//  CriticViewCell.swift
//  LMCTest
//
//  Created by сергей on 05.02.2021.
//

import UIKit

class CriticCell: UICollectionViewCell {
    
    lazy var criticImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var criticNameLabel: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCell() {
        mainStack.addArrangedSubview(criticImage)
        mainStack.addArrangedSubview(criticNameLabel)
        contentView.addSubview(mainStack)
    }
    
    private func setupConstraints() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        ])
    }
}
