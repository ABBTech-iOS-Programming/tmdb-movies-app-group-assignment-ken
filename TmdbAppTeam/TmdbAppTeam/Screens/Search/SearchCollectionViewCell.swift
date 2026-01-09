//
//  SearchCollectionViewCell.swift
//  TmdbAppTeam
//
//  Created by Macbook on 08.01.26.
//
import UIKit
import SnapKit
class SearchCollectionViewCell : UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: SearchCollectionViewCell.self)
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    private let movieTitle : UILabel = {
       let l = UILabel()
        l.font = .systemFont(ofSize: 18,weight: .bold)
        l.textColor = .label
        return l
    }()
    
    private let movieYear : UILabel = {
       let l = UILabel()
        l.font = .systemFont(ofSize: 16,weight: .regular)
        l.textColor = .label
        return l
    }()
    
    private let movieAvg : UILabel = {
       let l = UILabel()
        l.font = .systemFont(ofSize: 14,weight: .bold)
        l.textColor = .systemOrange
        return l
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    private func setupUI() {
        addSubview()
        constraits()
    }
    
    private func addSubview() {
        contentView.addSubview(posterImageView)
    }
    
    private func constraits() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with movie: Movie) {
        if let path = movie.posterPath {
            let urlString = APIConstants.imageBaseURL + path
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data, let downloadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.posterImageView.image = downloadedImage
                    }
                }
            }.resume()
            
        } else {
            posterImageView.image = UIImage(systemName: "no-image")
        }
    }
    
    
}
