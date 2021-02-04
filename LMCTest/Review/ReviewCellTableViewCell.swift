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
        reviewerBylineLabel.text = byline
        updatedDateLabel.text = date.customizeDate()
    }
    
    let reviewTitleLabel = UILabel()
    let summaryTextLabel = UILabel()
    let reviewerBylineLabel = UILabel()
    let updatedDateLabel = UILabel()
    let mainImage = UIImageView()
    private var textStackView = UIStackView()
    private var mainStackView = UIStackView()
    
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            mainImage.layer.cornerRadius = 5
            mainImage.clipsToBounds = true
            mainImage.contentMode = .scaleAspectFill
            setupCell()
            setupConstraints()
        }
    
    required init?(coder: NSCoder) {
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
        
        // fonts configuration
        reviewTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        reviewTitleLabel.adjustsFontSizeToFitWidth = true
        summaryTextLabel.font = UIFont.systemFont(ofSize: 14)
        summaryTextLabel.minimumScaleFactor = 0.5
        summaryTextLabel.numberOfLines = 3
        reviewerBylineLabel.font = UIFont.systemFont(ofSize: 17)
        updatedDateLabel.font = UIFont.systemFont(ofSize: 10)
        
        // fonts color configuration
        updatedDateLabel.textColor = .lightGray
        
        // create stackViews
        textStackView = UIStackView(arrangedSubviews: [reviewTitleLabel, summaryTextLabel, reviewerBylineLabel, updatedDateLabel])
        mainStackView = UIStackView(arrangedSubviews: [mainImage, textStackView])
        
        // configure stacks
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.distribution = .fill
        textStackView.spacing = 8
        
        mainStackView.axis = .horizontal
        mainStackView.alignment = .top
        mainStackView.distribution = .fill
        mainStackView.spacing = 16
        
        // add subviews
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
