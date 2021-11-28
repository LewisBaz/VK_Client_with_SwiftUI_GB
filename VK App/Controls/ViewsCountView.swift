//
//  ViewsCountView.swift
//  VK App
//
//  Created by Lev Bazhkov on 11.05.2021.
//

import UIKit

final class ViewsCountView: UIControl {
    
    private var view = UIButton()
    private var viewImage = UIImage(systemName: "eye")
    
    var viewsCount: Int = 0 {
        didSet {
            switch viewsCount {
            case 0...999:
                view.setTitle("\(viewsCount)", for: .normal)
            case 1000...1000000:
                view.setTitle("\(viewsCount/1000)K", for: .normal)
            default:
                view.setTitle("\(viewsCount)", for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        view.contentMode = .center
        view.setTitle("\(viewsCount)", for: .normal)
        view.setTitleColor(.darkGrayUIColor, for: .normal)
        view.setImage(viewImage, for: .normal)
        view.tintColor = .darkGrayUIColor
        view.addTarget(self, action: #selector(buttonAction(_ :)), for: .touchUpInside)
        self.addSubview(view)
    }
    
    @objc private func buttonAction(_ sender: UIButton) {}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }
}
