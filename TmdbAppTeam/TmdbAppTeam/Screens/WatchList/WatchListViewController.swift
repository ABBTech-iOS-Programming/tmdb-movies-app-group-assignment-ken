//
//  WatchListViewController.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//
import UIKit
final class WatchListViewController : UIViewController {
    
    private let viewModel : WatchListViewModel
    
    
    init(viewModel: WatchListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
