//
//  TNBottomSheet.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/15/24.
//

import UIKit

final class TNBottomSheet {
    private var title: String?
    private var hiddenConfirmBtn: Bool?
    private var height: CGFloat?
    private var dataSource: [String]?
    private var selectedIndex: Int?
    
    private let sheetViewController = TNSheetViewController()
    private var baseViewController: UIViewController
    
    init(_ baseViewController: UIViewController) {
        self.baseViewController = baseViewController
    }
    
    func setTitle(_ text: String) -> Self {
        title = text
        return self
    }
    
    func isHiddenConfirmBtn(_ flag: Bool) -> Self {
        hiddenConfirmBtn = flag
        return self
    }
    
    func setHeight(_ height: CGFloat) -> Self {
        self.height = height
        return self
    }
    
    func setDataSource(_ dataSource: [String]) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    func setSelectedIndex(_ index: Int) -> Self {
        self.selectedIndex = index
        return self
    }
    
    private func makeSheet() {
        if let sheet = sheetViewController.sheetPresentationController {
            sheet.detents = [ .custom { _ in
                    return self.height
            }]
            
            sheet.prefersGrabberVisible = true
        }
    }
    
    @discardableResult
    func present() -> Self {
        sheetViewController.confirmButton.isHidden = hiddenConfirmBtn ?? false
        sheetViewController.titleLabel.text = title
        sheetViewController.contentTableViewDataSource = dataSource ?? []
        
        if let selectedIndex {
            sheetViewController.selectedIndex = IndexPath(row: selectedIndex, section: 0)
        }
        
        makeSheet()
        baseViewController.present(sheetViewController, animated: true)
        return self
    }
}
