//
//  SearchViewController.swift
//  TmdbAppTeam
//
//  Created by Durdana on 29.12.25.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {

    private let viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search movies"
        sb.searchBarStyle = .minimal
        sb.searchTextField.textColor = .white
        sb.searchTextField.backgroundColor = .darkGray
        return sb
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let spacing: CGFloat = 16
        let width = (UIScreen.main.bounds.width - spacing * 3) / 2

        layout.itemSize = CGSize(width: width, height: width * 1.5)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing
        )

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(
            MovieGridCell.self,
            forCellWithReuseIdentifier: MovieGridCell.reuseIdentifier
        )
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        title = "Search"
        searchBar.delegate = self
        setupUI()
        bindViewModel()

        searchBar.becomeFirstResponder()
    }

    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.onResultsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    @objc
    private func performSearch(_ query: String) {
        viewModel.search(query: query)
    }
}

//MARK: Search Data Source
 
extension SearchViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieGridCell.reuseIdentifier,
            for: indexPath
        ) as? SearchCollectionViewCell else {
            return SearchCollectionViewCell()
        }

        cell.configure(with: viewModel.movies[indexPath.item])
        return cell
    }
}

//MARK: Search Delegate

extension SearchViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        let movie = viewModel.movies[indexPath.item]

        let detailViewModel = MovieDetailViewModel(
            service: DefaultNetworkService(),
            movieId: movie.id
        )

        let vc = MovieDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: SearchBar Delegatee

extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {

        NSObject
            .cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(performSearch),
            object: nil
        )

        perform(
            #selector(performSearch),
            with: searchText,
            afterDelay: 0.5
        )
    }
}
