//
//  ReviewCellTableViewCell.swift
//  LMCTest
//
//  Created by сергей on 03.02.2021.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    func configureCellWith(_ label: String, _ summary: String, _ byline: String, _ date: String) {
        reviewTitleLabel.text = label
        summaryTextLabel.text = summary
        reviewerBylineLabel.text = byline.capitalized
        updatedDateLabel.text = date.customizeDate()
    }
    
    lazy var reviewTitleLabel: UILabel = {
        let label =  UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var summaryTextLabel: UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 3
        return label
    }()
    
    lazy var reviewerBylineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    lazy var updatedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var textStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [reviewTitleLabel, summaryTextLabel,
                               reviewerBylineLabel, updatedDateLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 8
        return stack
    }()
    
    lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mainImage, textStackView])
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 16
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        reviewTitleLabel.text = nil
        summaryTextLabel.text = nil
        reviewerBylineLabel.text = nil
        updatedDateLabel.text = nil
        mainImage.image = nil
    }
    
    private func setupCell() {
        contentView.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainImage.widthAnchor.constraint(
                equalToConstant: (contentView.frame.width / 2) - (contentView.frame.width * 0.15)),
            textStackView.bottomAnchor.constraint(equalTo: mainImage.bottomAnchor)
        ])
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
    }
}
