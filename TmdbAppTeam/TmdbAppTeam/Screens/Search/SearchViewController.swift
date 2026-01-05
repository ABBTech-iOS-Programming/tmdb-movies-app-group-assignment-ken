//
//  SearchViewController.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//
import UIKit
final class SearchViewController : UIViewController {
    
    private let viewModal : SearchViewModel
    
    init(viewModal: SearchViewModel) {
        self.viewModal = viewModal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
    }
}
