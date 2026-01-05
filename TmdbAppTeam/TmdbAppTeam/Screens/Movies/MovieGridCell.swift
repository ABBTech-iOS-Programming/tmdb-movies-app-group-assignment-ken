//
//  MovieGridCell.swift
//  TmdbAppTeam
//
//  Created by Macbook on 05.01.26.
//

import UIKit
import SnapKit
final class MovieGridCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: MovieGridCell.self)

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.backgroundColor = .darkGray
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)

        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.height).multipliedBy(0.8)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title

        if let path = movie.posterPath {
            let urlString = APIConstants.imageBaseURL + path
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    guard let data else { return }
                    DispatchQueue.main.async {
                        self?.posterImageView.image = UIImage(data: data)
                    }
                }.resume()
            }
        }
    }
}
