//
//  ReviewCell.swift
//  TmdbAppTeam
//
//  Created by Durdana on 07.01.26.
//

import UIKit
import SnapKit

final class MoviewReviewCell: UITableViewCell {
    static let reuseIdentifier = "MovieReviewCell"
    
    private let avatarImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 22
        image.clipsToBounds = true
        image.backgroundColor = .blackMedium
        return image
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .primary
        return label
    }()
    
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    private let authorReviwLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 5
        label.textAlignment = .left
        label.textColor = .whiteHigh
        return label
    }()
    
    private let leftStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private let rightStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews()
        constraits()
    }
    
    private func addSubviews() {
        contentView.addSubview(mainStackView)
        [avatarImageView, ratingLabel].forEach(leftStackView.addArrangedSubview)
        [authorNameLabel, authorReviwLabel].forEach(rightStackView.addArrangedSubview)
        [leftStackView, rightStackView].forEach(mainStackView.addArrangedSubview)
    }
    
    private func constraits() {
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
    }
    
    func configure(with review: Review, viewModel: MovieDetailViewModel) {
        authorNameLabel.text = review.author
        authorReviwLabel.text = review.content
        
        if let rating = review.authorDetails?.rating {
            ratingLabel.text = String(format: "%.1f", rating)
        } else {
            ratingLabel.text = "0.0"
            ratingLabel.textColor = .whiteDisable
        }
        
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        
        if let urlString = review.avatarURL {
            viewModel.fetchAvatarImage(from: urlString) { [weak self] data in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self?.avatarImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorNameLabel.text = nil
        authorReviwLabel.text = nil
        ratingLabel.text = nil
        avatarImageView.image = nil
    }
    
}
