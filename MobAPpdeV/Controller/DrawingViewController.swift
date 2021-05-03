//
//  DrawingViewController.swift
//  MobAPpdeV
//
//  Created by sterbro on 4/25/21.
//

import UIKit

class DrawingViewController: UIViewController {

    @IBOutlet weak var segmentedContreol: UISegmentedControl!
    
    var showingView: UIView? {
        didSet {
            guard let showingView = showingView else {
                return
            }
            view.addSubview(showingView)
            
            showingView.backgroundColor = .clear
            
            showingView.translatesAutoresizingMaskIntoConstraints = false
            
            showingView.topAnchor.constraint(equalTo: segmentedContreol.bottomAnchor, constant: 10).isActive = true
            showingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
            showingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            showingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        }
        willSet {
            showingView?.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedAction(segmentedContreol.selectedSegmentIndex)
    }
    
    @IBAction func segValueDidChanged(_ sender: UISegmentedControl) {
        selectedAction(sender.selectedSegmentIndex)
    }

    private func selectedAction(_ index: Int) {
        switch index {
        case 0:
            showingView = GraphicView()
        default:
            showingView = DiagramView()
        }
    }
}
