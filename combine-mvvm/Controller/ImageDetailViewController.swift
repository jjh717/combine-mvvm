//
//  ImageDetailViewController.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/25.
//

import UIKit

final class ImageDetailViewController: BaseViewController {
    public var returnHandler: ((Int) -> (Void))?
    public var viewModel: ImageDetailViewModel?
     
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageDetailCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        makeUI()
        bind()
    }
    
    deinit {
        print(#function)
    }
    
    public func setViewModel(viewModel: ImageContainerViewModel, currentIndex: Int) {
        self.viewModel = ImageDetailViewModel(viewModel: viewModel, currentIndex: currentIndex)
    }
    
    public func setViewModel(viewModel: SearchImageContainerViewModel, currentIndex: Int) {
        self.viewModel = ImageDetailViewModel(viewModel: viewModel, currentIndex: currentIndex)
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: {})
    }
    
    private func makeUI() {
        guard let viewModel = viewModel else { return }
        
        imageDetailCollectionView.reloadData()
        imageDetailCollectionView.performBatchUpdates { [weak self] in
            self?.imageDetailCollectionView.scrollToItem(at: IndexPath(row: viewModel.currentImageIndex , section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$currentImageIndex
            .receive(on: DispatchQueue.main)
            .removeDuplicates() // 중복제거
            .sink(receiveValue: { [weak self] in //sink : sink를 통해 publisher에 대한 subscription을 작성
                self?.returnHandler?($0)
            })
            .store(in: &bag)
        
        viewModel.imageContainerViewModel?.$imageInfoList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.imageDetailCollectionView.reloadData()
            })
            .store(in: &bag)
        
        viewModel.searchImageContainerViewModel?.$imageInfoList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.imageDetailCollectionView.reloadData()
            })
            .store(in: &bag)
    }
}

extension ImageDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getImageList()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageDetailCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setData(model: viewModel?.getImageList()?[safe: indexPath.row])
        return cell        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return imageDetailCollectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
     
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = imageDetailCollectionView.contentOffset
        visibleRect.size = imageDetailCollectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = imageDetailCollectionView.indexPathForItem(at: visiblePoint) else { return }
        
        viewModel?.setCurrentImage(index: indexPath.row)
    }
}
