//
//  IndicatorTabBarController.swift
//  edX
//
//  Created by MuhammadUmer on 06/10/2022.
//  Copyright © 2022 edX. All rights reserved.
//

import UIKit

class IndicatorTabBarController: UITabBarController {    
    private var tabbarIndicatorContainer: UIView?
    private var tabbarIndicatorSubviews: [UIView]?
    
    private let indicatorHeight: CGFloat = 2
    private lazy var indicatorOffset: CGFloat = {
        if isiPad() || UIDevice.current.hasNotch {
            return 4
        }
        return 0
    }()
    
    private lazy var indicatorColor: UIColor = OEXStyles.shared().primaryDarkColor()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupTabbarIndicatorView()
        addObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.oex_addObserver(observer: self, name: UIDevice.orientationDidChangeNotification.rawValue) { _, observer, _ in
             observer.setupTabbarIndicatorView()
        }
    }
    
    private func setupTabbarIndicatorView() {
        tabbarIndicatorContainer?.snp.removeConstraints()
        tabbarIndicatorContainer = nil
        tabbarIndicatorSubviews?.forEach { $0.removeFromSuperview() }

        tabbarIndicatorSubviews = createIndicatorSubViews()
        tabbarIndicatorContainer = createTabbarIndicatorContainer()
        setupTabbarSubviews()
        moveTabbarIndicator(at: selectedIndex)
    }
    
    private func createIndicatorSubViews() -> [UIView] {
        guard let count = tabBar.items?.count else { return [] }
        var subViews: [UIView] = []
        for index in 0..<count {
            let width = UIScreen.main.bounds.width / CGFloat(count)
            let offset = index == 0 ? 0 : CGFloat(index) * width
            let frame = CGRect(x: offset, y: 0, width: width, height: indicatorHeight)
            let view = UIView(frame: frame)
            view.backgroundColor = .clear
            view.layer.transform = CATransform3DMakeTranslation(0, indicatorOffset, 0)
            subViews.append(view)
        }
        return subViews
    }
    
    private func createTabbarIndicatorContainer() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: indicatorHeight)
        let indicatorContainerView = UIView(frame: frame)
        indicatorContainerView.backgroundColor = .white
        indicatorContainerView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorContainerView
    }
    
    private func setupTabbarSubviews() {
        guard let container = tabbarIndicatorContainer,
              let subviews = tabbarIndicatorSubviews else { return }
        
        subviews.forEach { container.addSubview($0) }
        
        tabBar.addSubview(container)
        container.snp.makeConstraints { make in
            make.leading.equalTo(tabBar)
            make.trailing.equalTo(tabBar)
            make.bottom.equalTo(safeBottom)
            make.height.equalTo(indicatorHeight)
        }
    }
    
    private func moveTabbarIndicator(at index: Int) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.tabbarIndicatorSubviews?.forEach { $0.backgroundColor = .clear }
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3) { [weak self] in
                guard let weakSelf = self else { return }
                let indicator = weakSelf.tabbarIndicatorSubviews?[index]
                indicator?.backgroundColor = weakSelf.indicatorColor
            }
        }
    }
}

extension IndicatorTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        moveTabbarIndicator(at: index)
    }
}
