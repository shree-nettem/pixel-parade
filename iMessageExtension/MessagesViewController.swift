//
//  MessagesViewController.swift
//  iMessageExtension
//
//  Created by Vladimir Vishnyagov on 23/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import Messages
import CoreData
import DownloadButton
import SDWebImage

final class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet var fakeTabBar: UICollectionView!
    @IBOutlet private var fakeTabBarBackgroundView: UIView!
    @IBOutlet private var placeholderView: UIView!
    @IBOutlet private var goToMainAppButton: PKDownloadButton!
    @IBOutlet private var arrowLeft: UIButton!
    @IBOutlet private var arrowRight: UIButton!
    
    @IBOutlet private var scrollRightWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var scrollLeftWidthConstraint: NSLayoutConstraint!
    
    // MARK: - fake model, begin code
    
    enum TabBarItemType {
        case shop
        case sticker
    }
    
    typealias TabBarItem = (type: TabBarItemType, pack: Pack?)
    
    // MARK: - end code
    
    var selectedIndex: Int = 1
    var tabBarItems: [TabBarItem] = [TabBarItem(type: .shop, pack: nil)]
    weak var containerTabBarController: BaseTabBarController!
    
    lazy var frcPacks: NSFetchedResultsController <Pack> = {
        let fr = NSFetchRequest<Pack>(entityName: NSStringFromClass(Pack.self))
        fr.predicate = NSPredicate(format: "isPurchased = true")
        let purchasedDateSortDescriptor = NSSortDescriptor(key: "purchasedDate", ascending: false)
        let positionSortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        fr.sortDescriptors = [purchasedDateSortDescriptor, positionSortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fr,
                                             managedObjectContext: StorageService.shared.dataStack.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    } ()

    // MARK: - ViewController life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderView.isHidden = true
        fakeTabBar.delegate = self
        fakeTabBar.dataSource = self
        fakeTabBar.register(UINib(resource: R.nib.tabBarItemCell),
                            forCellWithReuseIdentifier: R.reuseIdentifier.tabBarItemCell.identifier)
        do {
            try frcPacks.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        reloadTabBar()
    }
    
    func reloadTabBar() {
        if let sections = frcPacks.sections,
            let firstSection = sections.first,
            firstSection.numberOfObjects > 0 {
            var controllers = containerTabBarController.viewControllers ?? []
            controllers.removeAll()
            self.tabBarItems = [TabBarItem(type: .shop, pack: nil)]
            for i in 0..<firstSection.numberOfObjects {
                let indexPath = IndexPath(item: i, section: 0)
                let pack = frcPacks.object(at: indexPath)
                self.tabBarItems.append(TabBarItem(type: .sticker, pack: pack))
            }
            self.tabBarItems.forEach { (tuple) in
                switch tuple.type {
                case .shop:
                    break
                default:
                    if let stikersViewController = R.storyboard.mainInterface.stickerPackViewController() {
                        if let pack = tuple.pack {
                            stikersViewController.pack = pack
                            stikersViewController.delegate = self
                        }
                        controllers.append(stikersViewController)
                    }
                }
            }
            self.fakeTabBar.reloadData()
            self.containerTabBarController.viewControllers = controllers
            self.containerTabBarController.selectedIndex = self.selectedIndex - 1
            
            if self.fakeTabBar.bounds.size.width > CGFloat((firstSection.numberOfObjects + 1) * 49) {
                arrowLeft.isHidden = true
                arrowRight.isHidden = true
                scrollLeftWidthConstraint.constant = 0
                scrollRightWidthConstraint.constant = 0
                view.layoutIfNeeded()
            } else {
                arrowLeft.isHidden = false
                arrowRight.isHidden = false
                scrollLeftWidthConstraint.constant = 35
                scrollRightWidthConstraint.constant = 35
                view.layoutIfNeeded()
            }
        } else {
            configureGoToAppButton()
            placeholderView.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabBarController = segue.destination as? BaseTabBarController {
            containerTabBarController = tabBarController
        }
    }
    
    @IBAction private func scrollRightTouchUpInside(_ sender: Any) {
        let visibleCells = fakeTabBar.visibleCells
        var maximalIndexItem = IndexPath(item: 0, section: 0)
        visibleCells.forEach { (cell) in
            if let indexPath = fakeTabBar.indexPath(for: cell), indexPath.item > maximalIndexItem.item {
                maximalIndexItem = indexPath
            }
        }
        fakeTabBar.scrollToItem(at: maximalIndexItem, at: .left, animated: true)
    }
    
    @IBAction private func scrollLeftTouchUpInside(_ sender: Any) {
        let visibleCells = fakeTabBar.visibleCells
        var minimalIndexPathItem = IndexPath(item: 0, section: 0)
        visibleCells.forEach { (cell) in
            if let indexPath = fakeTabBar.indexPath(for: cell), minimalIndexPathItem.item == 0 {
                minimalIndexPathItem = indexPath
            }
            if let indexPath = fakeTabBar.indexPath(for: cell), indexPath.item < minimalIndexPathItem.item {
                minimalIndexPathItem = indexPath
            }
        }
        fakeTabBar.scrollToItem(at: minimalIndexPathItem, at: .right, animated: true)
    }
    
    func configureGoToAppButton() {
        goToMainAppButton.isHidden = false
        let title = "GET STICKERS from PIXEL PARADE"
        goToMainAppButton.startDownloadButton.setAttributedTitle(NSAttributedString(string: title,
                                                                                        style: .text(.button(.ppDeepSkyBlue))), for: .normal)
        goToMainAppButton.startDownloadButton.setAttributedTitle(NSAttributedString(string: title,
                                                                                        style: .text(.button(.ppWhite))), for: .selected)
        goToMainAppButton.startDownloadButton.setAttributedTitle(NSAttributedString(string: title,
                                                                                        style: .text(.button(.ppWhite))), for: .highlighted)
        goToMainAppButton.startDownloadButton.setBackgroundImage(UIImage.buttonBackground(with: UIColor.ppDeepSkyBlue), for: .normal)
        goToMainAppButton.startDownloadButton.setBackgroundImage(UIImage.highlitedButtonBackground(with: UIColor.ppDeepSkyBlue), for: .selected)
        goToMainAppButton.startDownloadButton.setBackgroundImage(UIImage.highlitedButtonBackground(with: UIColor.ppDeepSkyBlue), for: .highlighted)
        goToMainAppButton.delegate = self
    }
    
}

// MARK: - StickerPackViewControllerDelegate

extension MessagesViewController: StickerPackViewControllerDelegate {
    
    func didSelectSticker(filename: String) {
        var filenamePath = filename
        var newFileUrl = URL(string: "file:/\(filename)")
        if filenamePath.hasSuffix(".png") {
            if let newImageWithWhiteBackground = UIImage(contentsOfFile: filenamePath),
                let imageData = newImageWithWhiteBackground.jpegData(compressionQuality: 1) {
                newFileUrl = NSURL(fileURLWithPath: StorageService.shared.containerURL.absoluteString).appendingPathComponent("default/com.hackemist.SDWebImageCache.default/content.jpg")!
                filenamePath = newFileUrl!.path
                do {
                    var resourceValues = URLResourceValues()
                    resourceValues.isExcludedFromBackup = true
                    try imageData.write(to: newFileUrl!, options: .atomic)
                    try newFileUrl!.setResourceValues(resourceValues)
                } catch {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        if let newPath = newFileUrl, let activeConversation = self.activeConversation {
            activeConversation.insertAttachment(newPath, withAlternateFilename: "file", completionHandler: nil)
        }
    }
    
}

extension MessagesViewController: PKDownloadButtonDelegate {
    
    func downloadButtonTapped(_ downloadButton: PKDownloadButton!, currentState state: PKDownloadButtonState) {
        guard let context = self.extensionContext else { return }
        guard let url = URL(string: "pixelparade://") else { return }
        context.open(url, completionHandler: nil)
    }
    
}
