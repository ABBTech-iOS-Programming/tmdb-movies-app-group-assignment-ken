import UIKit
import SnapKit

final class MovieHorizontalCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: MovieHorizontalCell.self)
    
    private let cellStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .center
        return sv
    }()

    private let rightStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 13
        sv.alignment = .leading
        return sv
    }()

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.backgroundColor = .darkGray
        return iv
    }()

    private let starImageView = MovieHorizontalCell.makeIcon("star.fill", .systemOrange)
    private let genreImageView = MovieHorizontalCell.makeIcon("ticket", .white)
    private let dateImageView = MovieHorizontalCell.makeIcon("calendar", .white)
    private let durationImageView = MovieHorizontalCell.makeIcon("clock", .white)

    private let movieTitle: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.textColor = .white
        l.numberOfLines = 2
        return l
    }()

    private let movieAvg = MovieHorizontalCell.makeLabel(color: .systemOrange)
    private let movieGenre = MovieHorizontalCell.makeLabel()
    private let movieYear = MovieHorizontalCell.makeLabel()
    private let movieDuration = MovieHorizontalCell.makeLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(cellStackView)

        [posterImageView,rightStackView].forEach(cellStackView.addArrangedSubview)
        

        rightStackView.addArrangedSubview(movieTitle)
         
        [
            (starImageView, movieAvg),
            (genreImageView, movieGenre),
            (dateImageView, movieYear),
            (durationImageView, movieDuration)
        ].forEach { icon, label in
            rightStackView.addArrangedSubview(
                makeRow(icon: icon, label: label)
            )
        }
    }

    private func setupConstraints() {
        cellStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalTo(160)
        }
    }

    func configure(with movie: Movie, genreMap: [Int: String]) {
        movieTitle.text = movie.title
        movieAvg.text = String(format: "%.1f", movie.voteAverage)
        if let releaseDate = movie.releaseDate {
            movieYear.text = String(releaseDate.prefix(4))
        } else {
            movieYear.text = nil
        }
        movieGenre.text = movie.genreIds
                .compactMap { genreMap[$0] }
                .first ?? "Unknown"
        movieDuration.text = "-"
        
        Task {
            let service = DefaultNetworkService()
            
            let detail: MovieDetail = try await service.request(MovieEndpoints.details(id: movie.id))
            
            await MainActor.run {
                self.movieDuration.text = "\(detail.runtime ?? 0) min"
            }
            

        }
        

        if let path = movie.posterPath,
           let url = URL(string: APIConstants.imageBaseURL + path) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                }
            }.resume()
        } else {
            posterImageView.image = UIImage(systemName: "photo")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }

    private func makeRow(icon: UIImageView, label: UILabel) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: [icon, label])
        sv.axis = .horizontal
        sv.spacing = 6
        sv.alignment = .center
        return sv
    }

    private static func makeIcon(_ name: String, _ color: UIColor) -> UIImageView {
        let iv = UIImageView(image: UIImage(systemName: name))
        iv.tintColor = color
        iv.contentMode = .scaleAspectFit
        return iv
    }

    private static func makeLabel(color: UIColor = .white) -> UILabel {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = color
        return l
    }
}
