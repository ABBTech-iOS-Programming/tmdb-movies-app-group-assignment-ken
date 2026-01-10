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
    
    private let emptyStateView = EmptyStateLabel()


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

        let spacing: CGFloat = 8
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width - (spacing * 2),
            height: 170
        )
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
            MovieHorizontalCell.self,
            forCellWithReuseIdentifier: MovieHorizontalCell.reuseIdentifier
        )
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        title = "Search"
        
        searchBar.delegate = self
        setupUI()
        bindViewModel()
        searchBar.becomeFirstResponder()
        // Keyboard dismiss
        let tap = UITapGestureRecognizer(
               target: self,
               action: #selector(dismissKeyboard)
           )
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
    }

    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        
        emptyStateView.configure(image: UIImage(named: "emptyStateImage"),
                            title: "We Are Sorry, We Can Not\nFind the Movie :(",
                            subtitle: "Find your movie by Type title, categories,\nyears, etc")

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        emptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(collectionView)
        }

        emptyStateView.isHidden = true
    }

    private func bindViewModel() {
        viewModel.onResultsUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }

                self.collectionView.reloadData()

                let isEmpty = self.viewModel.movies.isEmpty
                self.collectionView.isHidden = isEmpty
                self.emptyStateView.isHidden = !isEmpty
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
            withReuseIdentifier: MovieHorizontalCell.reuseIdentifier,
            for: indexPath
        ) as? MovieHorizontalCell else {
            return MovieHorizontalCell()
        }

        cell.configure(with: viewModel.movies[indexPath.item],genreMap: viewModel.genreMap)
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
