//
//  MoviesViewController.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//

import UIKit
import SnapKit

final class MoviesViewController: UIViewController {
    
    private let viewModel: MoviesViewModel
    var watchlistMovies: [Movie] = []
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var categoryHeightConstraint: Constraint?

    


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
        layout.itemSize = CGSize(width: 140, height: 210)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifire)
        cv.dataSource = self
        cv.delegate = self
        cv.tag = 0
        return cv
    }()
    
    private let segmentTitles = ["Now playing", "Upcoming", "Top rated","Popular"]
    private var selectedSegmentIndex = 0
    
    private lazy var segmentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(SegmentCell.self, forCellWithReuseIdentifier: SegmentCell.reuseIdentifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let spacing: CGFloat = 16
        let columns = CGFloat(3.0)
        let totalSpacing = spacing * (columns + 1)
        let itemWidth = floor((UIScreen.main.bounds.width - totalSpacing) / columns)

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: spacing,
            bottom: 0,
            right: spacing
        )

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
//        cv.isScrollEnabled = false
        cv.register(MovieGridCell.self, forCellWithReuseIdentifier: MovieGridCell.reuseIdentifier)
        cv.dataSource = self
        cv.delegate = self
        cv.tag = 1
        cv.isScrollEnabled = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        searchBar.delegate = self
        setupUI()
        bindViewModel()
        viewModel.fetchTrendingMovies()
        viewModel.fetchCategoryMovies(.nowPlaying)
        let backImage = UIImage(named: "chevron-icon")
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backButtonTitle = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchListMovies { [weak self] movies in
            self?.watchlistMovies = movies
        }
    }
    
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.segmentCollectionView.reloadData()
                self.categoryCollectionView.reloadData()
                self.categoryCollectionView.layoutIfNeeded()

                self.categoryHeightConstraint?.update(offset: self.categoryCollectionView.contentSize.height)
                self.view.layoutIfNeeded()
            }
        }
        
        viewModel.onTrendingUpdated = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.trendingCollectionView.reloadData()
               
            }
        }
    }
    
    private func setupUI() {
        addSubViews()
        constraints()
    }
    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [headerLabel,searchBar,trendingTitleLabel,trendingCollectionView,segmentCollectionView,categoryCollectionView].forEach(contentView.addSubview)
    } 
    
    private func constraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
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
            make.height.equalTo(220)
        }

        segmentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(trendingCollectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentCollectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()

           // make.height.equalTo(1000)
            categoryHeightConstraint = make.height.equalTo(1).constraint
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func goToDetail(with movieId: Int) {
        let detailViewModel = MovieDetailViewModel( service: DefaultNetworkService(), movieId: movieId )
        detailViewModel.checkIfFavorite(watchListMovies: self.watchlistMovies)
        let detailViewController = MovieDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func openSearchScreen() {
        let viewModel = SearchViewModel(service: DefaultNetworkService())
        let vc = SearchViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MoviesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === segmentCollectionView {
            return segmentTitles.count
        }
        return collectionView.tag == 0
            ? viewModel.trendingMovies.count
            : viewModel.categoryMovies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView === segmentCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SegmentCell.reuseIdentifier,
                for: indexPath
            ) as? SegmentCell else {
                return SegmentCell()
            }

            cell.configure(
                title: segmentTitles[indexPath.item],
                isSelected: indexPath.item == selectedSegmentIndex
            )
            return cell
        }

        if collectionView.tag == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCell.reuseIdentifire,
                for: indexPath
            ) as? MovieCell else {
                return MovieCell()
            }

            cell.configure(with: viewModel.trendingMovies[indexPath.item])
            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieGridCell.reuseIdentifier,
            for: indexPath
        ) as? MovieGridCell else {
            return MovieGridCell()
        }

        cell.configure(with: viewModel.categoryMovies[indexPath.item])
        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView === segmentCollectionView {
            selectedSegmentIndex = indexPath.item
            segmentCollectionView.reloadData()

            switch indexPath.item {
            case 0:
                viewModel.fetchCategoryMovies(.nowPlaying)
            case 1:
                viewModel.fetchCategoryMovies(.upcoming)
            case 2:
                viewModel.fetchCategoryMovies(.topRated)
            case 3:
                viewModel.fetchCategoryMovies(.popular)
            default:
                break
            }
            return
        }
        let selectedMovie: Movie
        if collectionView.tag == 0 {
            selectedMovie = viewModel.trendingMovies[indexPath.row]
        } else {
            selectedMovie = viewModel.categoryMovies[indexPath.item]
        }
        goToDetail(with: selectedMovie.id)
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView === segmentCollectionView {
            let width = collectionView.frame.width / CGFloat(segmentTitles.count)
            return CGSize(width: width, height: collectionView.frame.height)
        }

        return (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
    }
}


extension MoviesViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        openSearchScreen()
    }
}
