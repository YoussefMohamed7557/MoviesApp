//
//  DetailsViewController.swift
//  networkingWithDelegation
//
//  Created by Yossef on 3/17/21.
//  Copyright © 2021 Yossef. All rights reserved.
//

import UIKit
import SDWebImage
class DetailsViewController: UIViewController {

    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    var rateAsString = ""
    var releaseDateAsTextValue = ""
    var selectedMovie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      titleLabel.text = selectedMovie!.title
      rateAsString = String (selectedMovie!.rate ?? 0.0)
      rateLabel.text = rateAsString
      releaseDateAsTextValue = String (selectedMovie!.releaseYear ?? 0)
      releaseYearLabel.text = releaseDateAsTextValue
        
        for genre in selectedMovie!.genre! {
            genreLabel.text?.append(genre + "   ")
        }
        myImage.sd_setImage(with: URL(string: selectedMovie!.image!), completed: nil)
    }

}

//    var rateAsTextValue = ""
//    var releaseDateAsTextValue = ""
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        TitleLabel.text?.append(selectedMovie?.title ?? "")
//        rateAsTextValue = String(selectedMovie?.rate ?? 0.0)
//        RateLabel.text?.append(rateAsTextValue)
//        releaseDateAsTextValue = String(selectedMovie?.releaseYear ?? 0)
//        ReleaseYearLabel.text?.append(releaseDateAsTextValue)
//        for genreType in selectedMovie!.genre! {
//            GenreLabel.text?.append(genreType + "  ")
//        }
//
//    }
//
