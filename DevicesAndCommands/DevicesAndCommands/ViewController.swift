//
//  ViewController.swift
//  DevicesAndCommandsSwift
//
//  Created by Marcen, Rafael on 7/21/18.
//  Copyright © 2018 arafo. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mtkView = view as? MTKView else {
            fatalError("Metal is not supported on this device")
        }
        
        mtkView.device = MTLCreateSystemDefaultDevice()
        
        renderer = Renderer(view: mtkView)
        mtkView.delegate = renderer
        mtkView.preferredFramesPerSecond = 60
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
