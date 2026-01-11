//
//  EmptyStateLabel.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//

import UIKit
import SnapKit

final class EmptyStateLabel: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteHigh
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteDisable
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(stackView)
        [imageView, titleLabel, subtitleLabel].forEach(stackView.addArrangedSubview)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
        }
    }
    
    func configure(image: UIImage?, title: String, subtitle: String) {
        imageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
