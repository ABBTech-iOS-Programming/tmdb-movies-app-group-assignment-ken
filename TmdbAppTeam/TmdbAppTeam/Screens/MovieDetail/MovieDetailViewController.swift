
//
//  MovieDetailViewController.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//
import UIKit
import SnapKit

final class MovieDetailViewController:UIViewController {
    private let viewModel: MovieDetailViewModel
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var selectedSegmentIndex = 0
    let segments = ["About movie", "Reviews"]
    
    private let headerContainerView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .blackHigh
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let detailsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .blackHigh
        return label
    }()
    
    private let ratingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteHigh
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let starImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star")
        iv.tintColor = .primary
        return iv
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .primary
        return label
    }()
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .blackHigh
        return button
    }()
    
    private let backGroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .blackHigh
        label.numberOfLines = 2
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    private let segmentView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .blackHigh
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        binding()
        viewModel.fetchMovieDetails()
    }
    
    private func setupUI() {
        addSubViews()
        constraits()
    }
    
    private func addSubViews() {
        
        view.addSubview(headerContainerView)
        [backButton, detailsTitleLabel, bookmarkButton].forEach(headerContainerView.addSubview)
        
        backGroundImage.addSubview(ratingView)
        [starImageView, ratingLabel].forEach(ratingView.addSubview)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [backGroundImage, posterImageView, movieTitleLabel, infoStackView,
         descriptionLabel, segmentCollectionView].forEach(contentView.addSubview)
    }
    
    private func binding() {
        
        viewModel.onDataFetched = { [weak self] in
            guard let self = self, let detail = self.viewModel.movieDetail else { return }
            
            DispatchQueue.main.async {
                self.movieTitleLabel.text = detail.title
                self.descriptionLabel.text = detail.overview
                self.ratingLabel.text = String(format: "%.1f", detail.voteAverage ?? 0.0)
                self.setupInfoStack()
                
                self.viewModel.downloadImage { [weak self] imageData in
                    if let data = imageData {
                        self?.backGroundImage.image = UIImage(data: data)
                    }
                }
                
                if let posterURL = self.viewModel.posterURL {
                    URLSession.shared.dataTask(with: URL(string: posterURL)!) { [weak self] data, response, error in
                        if let data = data {
                            DispatchQueue.main.async {
                                self?.posterImageView.image = UIImage(data: data)
                            }
                        }
                    }.resume()
                }
            }
        }
    }
    
    private func infoItem(icon: String, text: String) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .whiteMedium
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .whiteMedium
        
        stack.addArrangedSubview(iconView)
        stack.addArrangedSubview(label)
        
        return stack
    }
    
    private lazy var segmentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.isScrollEnabled = false
        cv.register(MovieSegmentCell.self, forCellWithReuseIdentifier: MovieSegmentCell.reuseIdentifier)
        return cv
    }()
    
    private func setupInfoStack() {
        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let yearItem = infoItem(icon: "calendar", text: viewModel.releaseYear)
        let timeItem = infoItem(icon: "clock", text: viewModel.runtimeText)
        let genreItem = infoItem(icon: "ticket", text: viewModel.genreText)
        
        [yearItem, timeItem, genreItem].forEach { infoStackView.addArrangedSubview($0) }
    }
    
    private func constraits() {
        
        headerContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        detailsTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerContainerView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        ratingView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(8)
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(45)
        }
        
        starImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.centerY.equalToSuperview()
            make.size.equalTo(14)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        backGroundImage.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.height.equalTo(210)
            make.horizontalEdges.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints { make in
            make.height.equalTo(136)
            make.width.equalTo(110)
            make.leading.equalToSuperview().offset(30)
            //make.top.equalTo(backGroundImage.snp.top).inset(134)
            make.centerY.equalTo(backGroundImage.snp.bottom)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
            make.bottom.equalTo(backGroundImage.snp.bottom).offset(40)
            make.trailing.equalToSuperview().inset(16)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(24)
        }
        
        segmentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentCollectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieSegmentCell.reuseIdentifier, for: indexPath) as! MovieSegmentCell
        let isSelected = indexPath.item == selectedSegmentIndex
        cell.configure(title: segments[indexPath.item], isSelected: isSelected)
        return cell
    }
}

extension MovieDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSegmentIndex = indexPath.item
        collectionView.reloadData()
        
        if selectedSegmentIndex == 0 {
            descriptionLabel.text = viewModel.movieDetail?.overview
        } else {
            descriptionLabel.text = "There are no reviews yet for this movie."
        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView === segmentCollectionView {
            let width = collectionView.frame.width / CGFloat(segments.count + 2)
            return CGSize(width: width, height: collectionView.frame.height)
        }
        
        return (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
    }
}
