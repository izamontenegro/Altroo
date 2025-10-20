//
//  WelcomeOnboardingViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

protocol WelcomeOnboardingViewControllerDelegate: AnyObject {
    func goToAllPatient()
}

class WelcomeOnboardingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var delegateOnboarding: WelcomeOnboardingViewControllerDelegate?

    private let pages = [
        OnboardingPageViewController(title: "Bem-vindo ao Altroo <3", showButton: true, buttonTitle: "Próximo"),
        OnboardingPageViewController(title: "Organize seus pacientes facilmente.", showButton: true, buttonTitle: "Próximo"),
        OnboardingPageViewController(title: "Vamos começar?", showButton: true, buttonTitle: "Começar")
    ]

    private let pageControl = UIPageControl()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .pureWhite
        cv.dataSource = self
        cv.delegate = self
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite

        // Adiciona child VCs
        for pageVC in pages {
            addChild(pageVC)
            pageVC.didMove(toParent: self)

            if pageVC.showButton {
                pageVC.nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
            }
        }

        setupCollectionView()
        setupPageControl()
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.teal10.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = UIColor(resource: .teal10)
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let pageVC = pages[indexPath.item]
        pageVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(pageVC.view)

        return cell
    }

    // MARK: - UICollectionView DelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = max(1, collectionView.bounds.width)
        let pageIndex = Int(round(scrollView.contentOffset.x / width))
        pageControl.currentPage = pageIndex
    }

    @objc private func didTapNextButton() {
        let width = max(1, collectionView.bounds.width)
        let visibleIndex = Int(round(collectionView.contentOffset.x / width))

        if visibleIndex < pages.count - 1 {
            let nextIndex = IndexPath(item: visibleIndex + 1, section: 0)
            collectionView.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = visibleIndex + 1
        } else {
            delegateOnboarding?.goToAllPatient()
        }
    }
}



//#Preview {
//    WelcomeOnboardingViewController()
//}
