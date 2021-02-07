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
        contentView.addSubview(image)
        return image
    }()
    
    lazy var criticNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        contentView.addSubview(label)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    
    private func setupConstraints() {
        criticImage.translatesAutoresizingMaskIntoConstraints = false
        criticNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            criticImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            criticImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            criticImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            criticImage.bottomAnchor.constraint(equalTo: criticNameLabel.topAnchor, constant: -8),
            criticNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            criticNameLabel.centerXAnchor.constraint(equalTo: criticImage.centerXAnchor)
        ])
        criticImage.setContentHuggingPriority(UILayoutPriority(rawValue: 248), for: .horizontal)
        criticImage.setContentHuggingPriority(UILayoutPriority(rawValue: 248), for: .vertical)
        criticImage.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        criticImage.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        criticNameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        criticNameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        criticNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        criticNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
    }
}
