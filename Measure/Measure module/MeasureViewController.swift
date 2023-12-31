//
//  MeasureViewController.swift
//  AMMeasure
//
//  Created by Bhat, Adithya H on 04/04/19.
//

import UIKit
import ARKit
import Foundation

class MeasureViewController: UIViewController {
    
    struct Post:Codable{
        let userId: Int
        let id: Int
        let title: String
        let body: String
        
    }

    let lineWidth = CGFloat(0.003)
    let nodeRadius = CGFloat(0.015)
    let realTimeLineName = "realTimeLine"

    var realTimeLineNode: LineNode?
    
    @IBOutlet weak var centerPointImageView: UIImageView!
    @IBOutlet weak var sceneView: MeasureSCNView!
    @IBOutlet weak var verifyButton: LoaderButton!
    
    lazy var screenCenterPoint: CGPoint = {
        return centerPointImageView.center
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.pause()
        super.viewWillDisappear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func verify(_ sender: LoaderButton) {
        var image = sceneView.snapshot()
        var randNum = 1 - Double.random(in: 0..<1)
        
        sender.isLoading = true
            // simulate sending request
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            sender.isLoading = false
            
        }
        verifyButton.setTitle("Verified!", for: .normal)
        verifyButton.tintColor = UIColor.green
        
        
        print(callAPI())
    }
    
    
    //MARK: - Helper methods
    
    func callAPI(){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else{
            return
        }


        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            if let data = data, let string = String(data: data, encoding: .utf8){
                print(string)
            }
        }

        task.resume()
    }
    
    func removeNodes(fromNodeList nodes: NSMutableArray) {
        for node in nodes {
            if let node = node as? SCNNode {
                node.removeFromParentNode()
                nodes.remove(node)
            }
        }
    }
    
    func updateScaleFromCameraForNodes(_ nodes: [SCNNode], fromPointOfView pointOfView: SCNNode){
        
        nodes.forEach { (node) in
            
            //1. Get The Current Position Of The Node
            let positionOfNode = SCNVector3ToGLKVector3(node.worldPosition)
            
            //2. Get The Current Position Of The Camera
            let positionOfCamera = SCNVector3ToGLKVector3(pointOfView.worldPosition)
            
            //3. Calculate The Distance From The Node To The Camera
            let distanceBetweenNodeAndCamera = GLKVector3Distance(positionOfNode, positionOfCamera)
            
            //4. Animate Their Scaling & Set Their Scale Based On Their Distance From The Camera
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            switch distanceBetweenNodeAndCamera {
            case 0 ... 0.5:
                node.simdScale = simd_float3(0.25, 0.25, 0.25)
            case 0.5 ... 1.5:
                node.simdScale = simd_float3(0.5, 0.5, 0.5)
            case 1.5 ... 2.5:
                node.simdScale = simd_float3(1, 1, 1)
            case 2.5 ... 3:
                node.simdScale = simd_float3(1.5, 1.5, 1.5)
            case 3 ... 3.5:
                node.simdScale = simd_float3(2, 2, 2)
            case 3.5 ... 5:
                node.simdScale = simd_float3(2.5, 2.5, 2.5)
            default:
                node.simdScale = simd_float3(3, 3, 3)
            }
            SCNTransaction.commit()
        }
        
    }
    
}

class LoaderButton: UIButton {
    // 2
    var spinner = UIActivityIndicatorView()
    // 3
    var isLoading = false {
        didSet {
            // whenever `isLoading` state is changed, update the view
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 4
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        // 5
        spinner.hidesWhenStopped = true
        // to change spinner color
        spinner.color = .white
        // default style
        spinner.style = .medium
        
        // 6
        // add as button subview
        addSubview(spinner)
        // set constraints to always in the middle of button
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // 7
    func updateView() {
        if isLoading {
            spinner.startAnimating()
            titleLabel?.alpha = 0
            imageView?.alpha = 0
            // to prevent multiple click while in process
            isEnabled = false
        } else {
            spinner.stopAnimating()
            titleLabel?.alpha = 1
            imageView?.alpha = 0
            isEnabled = true
        }
    }
}


