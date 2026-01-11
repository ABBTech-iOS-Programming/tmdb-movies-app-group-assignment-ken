//
//  InfoItemView.swift
//  TmdbAppTeam
//
//  Created by Durdana on 07.01.26.
//

import UIKit
import SnapKit

final class InfoItemView: UIView {
    private let iconView = UIImageView()
    private let label = UILabel()
    private let stackView = UIStackView()
    
    init(icon: String) {
        super.init(frame: .zero)
        setupUI(icon: icon)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI(icon: String) {
        stackView.axis = .horizontal
        stackView.spacing = 4
        addSubview(stackView)
        
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = .whiteMedium
        iconView.contentMode = .scaleAspectFit
        
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .whiteMedium
        
        [iconView, label].forEach(stackView.addArrangedSubview)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
    }
    
    func updateText(_ text: String) {
        label.text = text
    }
}
