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
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var criticNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCell()
        setupConstraints()
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        criticImage.image = nil
        criticNameLabel.text = nil
    }
    
    override func layoutMarginsDidChange() {
        setupConstraints()
    }
    
    private func createCell() {
        mainStack.addArrangedSubview(criticImage)
        mainStack.addArrangedSubview(criticNameLabel)
        contentView.addSubview(mainStack)
    }
    
    private func setupConstraints() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
        ])
    }
}
