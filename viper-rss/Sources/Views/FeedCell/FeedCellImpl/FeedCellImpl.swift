//
//  FeedCellImpl.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

private struct Metrics {
    struct Fonts {
        static let newTitleFont = Constants.Fonts.newTitleFont
        static let newDescriptionFont = Constants.Fonts.newDescriptionFont
        static let dateFont = Constants.Fonts.dateFont
        static let sourceFont = Constants.Fonts.sourceFont
    }
    
    struct Colors {
        static let newsTitleColor = Constants.Colors.newsTitleColor
        static let newsDescriptionColor = Constants.Colors.newsDescriptionColor
        static let backgroundColor = Constants.Colors.backgroundColor
        static let dateColor = Constants.Colors.dateColor
        static let sourceColor = Constants.Colors.sourceColor
    }
    
    struct Sizes {
        static let topAndBottomMargin = Constants.Sizes.topAndBottomMargin
        static let leadingToImage = Constants.Sizes.leadingToImage
        static let spaceForCheckIndicator = Constants.Sizes.spaceForCheckIndicator
        static let fromImageToText = Constants.Sizes.fromImageToText
        static let imageSize = Constants.Sizes.imageSize
        static let spaceBetweenText = Constants.Sizes.spaceBetweenText
        static let eyeSize: CGFloat = 20
    }
}

class FeedCellImpl: UITableViewCell, FeedCellProtocol {
    
    private var viewModel: FeedViewModelProtocol?

    private let newsTitle = UILabel().then {
        $0.font = Metrics.Fonts.newTitleFont
        $0.textColor = Metrics.Colors.newsTitleColor
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.sizeToFit()
    }
    
    private let newsDescription = UILabel().then {
        $0.font = Metrics.Fonts.newDescriptionFont
        $0.textColor = Metrics.Colors.newsDescriptionColor
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.sizeToFit()
    }
    
    private let newsImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = AssetsHelper.placeholders.placeholder.image
    }
    
    private let sourceLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = Metrics.Fonts.sourceFont
        $0.textColor = Metrics.Colors.sourceColor
    }
    
    private let dateLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = Metrics.Fonts.dateFont
        $0.textColor = Metrics.Colors.dateColor
    }
    
    private let eyeImage = UIImageView().then {
        $0.image = AssetsHelper.icons.eye.image
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Metrics.Colors.backgroundColor
        [newsTitle,
         newsDescription,
         newsImage,
         sourceLabel,
         dateLabel,
         eyeImage].forEach { contentView.addSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel
        newsTitle.text = viewModel.newsTitleText
        self.viewModel?.onImageUpdate = { [weak self] img in
            self?.newsImage.image = img
        }
        self.newsImage.image = viewModel.img
        newsDescription.text = viewModel.newsShortDescription
        sourceLabel.text = viewModel.source
        dateLabel.text = viewModel.date
        newsDescription.isHidden = viewModel.isFullMode ? false : true
        self.eyeImage.isHidden = viewModel.isReaded ? false : true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsImage.frame = CGRect(
            x: Metrics.Sizes.leadingToImage,
            y: Metrics.Sizes.topAndBottomMargin,
            width: Metrics.Sizes.imageSize,
            height: Metrics.Sizes.imageSize)
        newsImage.layer.masksToBounds = false
        newsImage.layer.cornerRadius = newsImage.frame.size.width / 2
        newsImage.clipsToBounds = true
        
        newsTitle.frame = CGRect(
            x: newsImage.frame.maxX + Metrics.Sizes.fromImageToText,
            y: newsImage.frame.minY,
            width: contentView.frame.width - Metrics.Sizes.leadingToImage - Metrics.Sizes.imageSize - Metrics.Sizes.fromImageToText - Metrics.Sizes.spaceForCheckIndicator,
            height: viewModel?.titleHeight ?? 0)
        
        newsDescription.frame = CGRect(
            x: newsTitle.frame.minX,
            y: newsTitle.frame.maxY + Metrics.Sizes.spaceBetweenText,
            width: newsTitle.frame.width,
            height: viewModel?.descriptionHeight ?? 0)
        
        sourceLabel.frame = CGRect(
            x: newsImage.frame.minX,
            y: contentView.frame.height - Metrics.Sizes.topAndBottomMargin,
            width: sourceLabel.intrinsicContentSize.width,
            height: sourceLabel.intrinsicContentSize.height)
        
        dateLabel.frame = CGRect(
            x: contentView.frame.width - Metrics.Sizes.leadingToImage - dateLabel.intrinsicContentSize.width,
            y: contentView.frame.height - Metrics.Sizes.topAndBottomMargin,
            width: dateLabel.intrinsicContentSize.width,
            height: dateLabel.intrinsicContentSize.height)
        
        eyeImage.frame = CGRect(
            x: contentView.frame.width - 10 - Metrics.Sizes.eyeSize,
            y: 10,
            width: Metrics.Sizes.eyeSize,
            height: Metrics.Sizes.eyeSize)
    }
}
