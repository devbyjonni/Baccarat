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
        
        modelController.createNewShoe()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "ShowBigRoad" {
            if let vc = segue.destination as? BigRoadViewController {
                vc.modelController = BigRoadModel(model: modelController)
            }
        }
        
        if segue.identifier == "ShowBedPlate" {
            if let vc = segue.destination as? BedPlateViewController {
                vc.modelController = BedPlateModel(model: modelController)
            }
        }
    }
    
    @IBAction func didTapPlayerBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didAddPlayer, object: nil)
        
    }
    
    @IBAction func didTapBankerBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didAddBanker, object: nil)
        
    }
    
    @IBAction func didTapTieBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didAddTie, object: nil)
        
    }
    
    @IBAction func didTapUndoBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: .undo, object: nil)
        
    }
    
    @IBAction func createNewShoe(_ sender: Any) {
        modelController.createNewShoe()
    }
}

extension Notification.Name {
    static let undo = Notification.Name("undo")
    static let didAddPlayer = Notification.Name("didAddPlayer")
    static let didAddBanker = Notification.Name("didAddBanker")
    static let didAddTie = Notification.Name("didAddTie")
    static let createNewShoe = Notification.Name("createNewShoe")
    static let didLoadShoe = Notification.Name("didLoadShoe")
}
