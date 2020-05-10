//
//  PaginationCell.swift
//  Nearby
//
//  Created by Abhisek on 13/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import UIKit

class PaginationCell: ReusableTableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pagingScrollView: UIScrollView!
    @IBOutlet weak var paginationIndicator: UIPageControl!
    
    private var viewModel: PaginationCellVM!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 0.6)
        mainView.layer.cornerRadius = 4
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = borderColor.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepareCell(viewModel: PaginationCellVM) {
        pagingScrollView.delegate = self
        self.viewModel = viewModel
        setUpUI()
    }
    
    private func setUpUI() {
        configurePaginationIndicator()
        // Provide a delay of few secs to let the frames of views to be laid properly.
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.configureScrollView()
        }
        titleLabel.text = viewModel.title
    }
    
    private func configureScrollView() {
        for i in 0..<viewModel.numberOfPages{
            let placeView = PlaceView()
            placeView.frame = CGRect(x: pagingScrollView.frame.size.width*CGFloat(i), y: 0, width: pagingScrollView.frame.size.width, height: pagingScrollView.frame.size.height)
            placeView.preparePlaceView(viewModel: viewModel.viewModelForPlaceView(position: i))
            pagingScrollView.addSubview(placeView)
        }
        pagingScrollView.contentSize = CGSize(width: pagingScrollView.frame.size.width * CGFloat(viewModel.numberOfPages), height: pagingScrollView.frame.size.height)
    }
    
    private func configurePaginationIndicator() {
        paginationIndicator.numberOfPages = viewModel.numberOfPages
        paginationIndicator.currentPage = 0
        paginationIndicator.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
    }
    
    @objc private func changePage(sender: AnyObject) -> () {
        let x = CGFloat(paginationIndicator.currentPage) * pagingScrollView.frame.size.width
        pagingScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
}

// MARK: UIScrollViewDelegate
extension PaginationCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        paginationIndicator.currentPage = Int(pageNumber)
    }
}
