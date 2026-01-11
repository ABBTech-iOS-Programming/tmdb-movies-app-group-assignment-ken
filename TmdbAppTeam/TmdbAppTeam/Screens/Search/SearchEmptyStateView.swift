//
//  SearchEmptyStateView.swift
//  TmdbAppTeam
//
//  Created by Macbook on 09.01.26.
//


import UIKit
import SnapKit

final class SearchEmptyStateView: UIView {
 
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "emptyStateImage")
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "We Are Sorry, We Can Not\nFind the Movie :("
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Find your movie by Type title, categories,\nyears, etc"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .center
        return sv
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

        [imageView, titleLabel, subtitleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }

        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(120)
        }
    }
}
