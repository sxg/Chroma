//
//  ViewController.swift
//  iOS Example
//
//  Created by Satyam Ghodasara on 1/31/16.
//  Copyright © 2016 Satyam Ghodasara. All rights reserved.
//

import UIKit
import Chroma

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let image = UIImage(named: "Image")!
        let backgroundColor = ImageAnalyzer(image: image).backgroundColor
        print(backgroundColor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

