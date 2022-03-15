//
//  MainViewController.swift
//  Baccarat
//
//  Created by Jonni Akesson on 2022-02-21.
//

import UIKit

class MainViewController: UIViewController {
    
    var modelController: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //modelController.createNewShoe()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowBigRoad" {
            if let vc = segue.destination as? BigRoadViewController {
                vc.viewModel = BigRoadViewModel(model: modelController)
            }
        }
        
        if segue.identifier == "ShowBedPlate" {
            if let vc = segue.destination as? BedPlateViewController {
                vc.viewModel = BedPlateViewModel(model: modelController)
            }
        }
    }
    
    @IBAction func didTapPlayerBtn(_ sender: UIButton) {
        modelController.addPlayer()
    }
    
    @IBAction func didTapBankerBtn(_ sender: UIButton) {
        modelController.addBanker()
    }
    
    @IBAction func didTapTieBtn(_ sender: UIButton) {
        modelController.addTie()
    }
    
    @IBAction func didTapUndoBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didDeleteData, object: nil)
    }
    
    @IBAction func createNewShoe(_ sender: Any) {
        modelController.createNewShoe()
    }
}

extension Notification.Name {
    
    static let createNewShoe = Notification.Name("createNewShoe")
    static let didCreateShoe = Notification.Name("didCreateShoe")
    
    static let didDeleteData = Notification.Name("didDeleteData")
    static let didAddData = Notification.Name("didAddData")
}
