//
//  MoviesViewController.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//
import UIKit
import SnapKit

final class MoviesViewController : UIViewController {
    
    private let viewModel : MoviesViewModel
    
    init(viewModel: MoviesViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Element
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "What do you want to watch?"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.searchBarStyle = .minimal
        sb.searchTextField.textColor = .white
        sb.searchTextField.backgroundColor = .darkGray
        return sb
    }()
    
    private let trendingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var trendingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let spacing: CGFloat = 16
        let totalspacing = spacing * 3
        let itemWidth = (UIScreen.main.bounds.width - (spacing * 3)) / 2.5
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.layer.cornerRadius = 20
        cv.clipsToBounds = true
        cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifire)
        cv.dataSource = self
        cv.delegate = self
        cv.tag = 0
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        binding()
        viewModel.fetchTrendingMovies()
        setupUI()
    }
    
    private func binding() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.trendingCollectionView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        addSubview()
        constraits()
    }
    
    private func addSubview() {
        view.addSubview(headerLabel)
        view.addSubview(searchBar)
        view.addSubview(trendingTitleLabel)
        view.addSubview(trendingCollectionView)
    }
    
    private func constraits() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        
        trendingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
        }
        
        trendingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(trendingTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(240)
        }
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifire, for: indexPath) as! MovieCell
        let movie = viewModel.movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
 
}

extension MoviesViewController: UICollectionViewDelegate {
    
}
