//
//  DetailCell.swift
//  LMCTest
//
//  Created by сергей on 05.02.2021.
//

import UIKit

class DetailCell: UITableViewCell {
    
    func configureCellWith(_ name: String, _ status: String, _ bio: String?, image: String) {
        criticNameLabel.text = name
        criticStatusLabel.text = status
        criticBioLabel.text = bio
        criticImage.loadImageUsingCache(withUrl: image)
    }


    lazy var criticImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "person.circle"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var criticNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mark Cubanbbkjhj"
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textAlignment = .left
        return label
    }()
    
    lazy var criticStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "part-time"
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.backgroundColor = .blue
        return label
    }()
    
    lazy var criticBioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [criticNameLabel, criticStatusLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()
    
    lazy var bioStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [criticImage, textStack])
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [bioStack, criticBioLabel])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createCell()
        setupConstraints()
        contentView.backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func createCell() {
        contentView.addSubview(mainStack)
    }
    
    private func setupConstraints() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textStack.heightAnchor.constraint(equalTo: criticImage.heightAnchor, multiplier: 0.7),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
        ])
    }

}
