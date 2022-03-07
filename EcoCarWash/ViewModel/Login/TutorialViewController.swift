//
//  TutorialViewController.swift
//  EcoCarWash
//
//  Created by Indium Software on 10/09/21.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var page: Int = 0
    var isPageRefreshing:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func skipBtnAction(_ sender: UIButton) {
        showLoginVC()
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        let collectionBounds = collectionView.bounds
        let contentOffset = CGFloat(floor(collectionView.contentOffset.x + collectionBounds.size.width))
        moveCollectionToFrame(contentOffset: contentOffset)
        if pageControl.currentPage == 2 {
            showLoginVC()
        }
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.collectionView.contentOffset.y ,width : self.collectionView.frame.width,height : self.collectionView.frame.height)
        self.collectionView.scrollRectToVisible(frame, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    
    func showLoginVC() {
        let loginVC = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.loginVC) as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}

extension TutorialViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCell", for: indexPath) as! TutorialCell
        return cell
    }
}

extension TutorialViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 400)
    }
}

class TutorialCell: UICollectionViewCell  {
    @IBOutlet weak var tutorialImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
}
