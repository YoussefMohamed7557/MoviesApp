//
//  AddMovieViewController.swift
//  MoviesApp.
//
//  Created by Yossef on 3/11/21.
//

import UIKit

class AddMovieViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var releaseYearTextField: UITextField!
    @IBOutlet weak var GenreTextField: UITextField!
    var theReferenceOfPathAddedMovieProtocol :PathAddedMovieProtocol?
    var genreArray :[String] = Array()
    var addedMovie :Movie?
    
    @IBAction func addGenreToGenreArray(_ sender: Any) {
        
        if let genre = self.GenreTextField.text {
            genreArray.append(genre)
            GenreTextField.text = ""
        }else{
            self.GenreTextField.text = "FAILD"
        }
    }
    
    @IBAction func addTheDetailsOfAdddedMovie(_ sender: Any) {
        var title = ""
        var rateAsFloatValue:Double = 0.0
        var releaseYearAsIntegerValue = 0
        
        if let _title = self.titleTextField.text {
            title = _title
            titleTextField.text = ""
        }
        if let rate = Double(self.rateTextField.text!)  {
            rateAsFloatValue = rate
            rateTextField.text = ""
        }
        if let releaseYear = Int(self.releaseYearTextField.text!) {
            releaseYearAsIntegerValue = releaseYear
            releaseYearTextField.text = ""
        }
        if let finalGenreIfExisted = GenreTextField.text{
            genreArray.append(finalGenreIfExisted)
            GenreTextField.text = ""
        }
       // addedMovie = Movie(Title: title, Rate: rateAsFloatValue, ReleaseYear: releaseYearAsIntegerValue, Genre: genreArray)
       addedMovie = Movie(title: title, rate: rateAsFloatValue, releaseYear: releaseYearAsIntegerValue, image: "https://api.androidhive.info/json/movies/2.jpg", genre: genreArray)
        theReferenceOfPathAddedMovieProtocol?.addMovie(movieName: addedMovie!)
        self.navigationController?.popViewController(animated: true)
    }
    
}
