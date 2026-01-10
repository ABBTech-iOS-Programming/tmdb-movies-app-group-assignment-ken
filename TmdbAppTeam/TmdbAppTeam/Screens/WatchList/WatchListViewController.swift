//
//  WatchListViewController.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//
import UIKit
import SnapKit

final class WatchListViewController : UIViewController {
    
    private let viewModel : WatchListViewModel
    private let emptyView = EmptyStateLabel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(MovieHorizontalCell.self, forCellWithReuseIdentifier: MovieHorizontalCell.reuseIdentifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    init(viewModel: WatchListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Watch List"
        view.backgroundColor = .background
        setupUi()
        constraits()
        binding()
        viewModel.fetchGenresAndWatchlist()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchWatchList()
    }
    
    private func setupUi() {
        addSubview()
        emptyView.configure(image: UIImage(named: "emptybox"),
                            title: "There Is No Movie Yet!",
                            subtitle: "Find your movie by Type title, \ncategories, years, etc")
        
    }
    
    private func addSubview() {
        [emptyView, collectionView].forEach(view.addSubview)
    }
    private func constraits() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func binding() {
        
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                let isWatchlistEmpty = self?.viewModel.movies.isEmpty ?? true
                self?.collectionView.isHidden = isWatchlistEmpty
                self?.emptyView.isHidden = !isWatchlistEmpty
                
                self?.collectionView.reloadData()
            }
        }
    }
}

extension WatchListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieHorizontalCell.reuseIdentifier, for: indexPath) as! MovieHorizontalCell
        
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie, genreMap: viewModel.genreMap)
        return cell
    }
    
}

extension WatchListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movies[indexPath.row]
        let detailVM = MovieDetailViewModel(service: DefaultNetworkService(), movieId: selectedMovie.id)
        detailVM.checkIfFavorite(watchListMovies: viewModel.movies)
        
        let detailVC = MovieDetailViewController(viewModel: detailVM)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
