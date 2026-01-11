//
//  MovieSegmentCell.swift
//  TmdbAppTeam
//
//  Created by Durdana on 05.01.26.
//

import UIKit
import SnapKit

final class MovieSegmentCell: UICollectionViewCell {

    static let reuseIdentifier = "MovieSegmentCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.isHidden = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(underlineView)

        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        underlineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.textColor = isSelected ? .whiteHigh : .whiteDisable
        underlineView.isHidden = !isSelected
    }
}
