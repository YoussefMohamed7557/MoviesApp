//
//  ViewController.swift
//  networkingWithDelegation
//
//  Created by Yossef on 3/17/21.
//  Copyright © 2021 Yossef. All rights reserved.
//

import UIKit
import CoreData
import Reachability
class ViewController:UIViewController,PathMovieArrayProtocol {

    @IBOutlet weak var myTable: UITableView!
    var MovieArray : [Movie] = [Movie]()
    var movieAttributesArray:[NSManagedObject] = [NSManagedObject]()
    //================ Create AccessAPI Object and fire connecting function ====//
    func connectToAPIwith(URLString str:String)  {
        let APIConnectingObj : AccessAPI = AccessAPI(delegationReference: self)
        APIConnectingObj.connectAPIWithURL(URLstring: str)
    }
    
    //================ go to add new movie screen  =============================//
    @IBAction func presentAddMovieScreen(_ sender: Any) {
        let addMovieViewControllerObj :AddMovieViewController = self.storyboard?.instantiateViewController(withIdentifier: "add") as! AddMovieViewController
        
        addMovieViewControllerObj.theReferenceOfPathAddedMovieProtocol = self
        self.navigationController?.pushViewController(addMovieViewControllerObj, animated: true)
    }
     //================ go to collection formate screen  =============================//
    @IBAction func showAsCollectionView(_ sender: Any) {
        let collectionViewObject :CollectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "collection") as!CollectionViewController
        
        collectionViewObject.collectionMoviesArray = MovieArray
        self.navigationController?.pushViewController(collectionViewObject, animated: true )
    }
    //======================== set movieArray to coredata =======================//
    func pathMovieArrayToCoreData(theArray movieArrayAsParameter:[Movie]) {
        for movieItem in movieArrayAsParameter {
            addMovieToCoreData(movieName: movieItem)
        }
    }
    func addMovieToCoreData(movieName newMovie: Movie){
        // ======= create app delegate object ================== //
        var appDelegate = AppDelegate()
       
           appDelegate = UIApplication.shared.delegate as! AppDelegate
        // ======= create managed object context =============== //
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // ======= create object that represent MovieTable ===== //
        let movieEntity = NSEntityDescription.entity(forEntityName: "MovieTable", in: managedContext)
        let movieAttribut = NSManagedObject(entity: movieEntity!, insertInto: managedContext)
        movieAttribut.setValue(newMovie.title , forKey: "title")
        movieAttribut.setValue(newMovie.image , forKey: "image")
        movieAttribut.setValue(newMovie.rate , forKey: "rate")
        movieAttribut.setValue(newMovie.releaseYear , forKey: "releaseYear")
        do{
            try managedContext.save()
            movieAttributesArray.append(movieAttribut)
        }catch let error as NSError{
            print(error)
        }
    }
    func fetchArrayOfAttributesFromCoreData() -> [NSManagedObject] {
        // ======= create app delegate object ================== //
        var appDelegate = AppDelegate()
            appDelegate = UIApplication.shared.delegate as! AppDelegate
        // ======= create managed object context =============== //
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequist = NSFetchRequest<NSManagedObject>(entityName: "MovieTable")
        do{
            movieAttributesArray = try managedContext.fetch(fetchRequist)
        }catch let error as NSError{
            print(error)
        }
        return movieAttributesArray
    }
    //================== reachability implementation ============================//
    let reachability = try! Reachability()
    //======================== actions after view did loaded ====================//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        connectToAPIwith(URLString: "https://api.androidhive.info/json/movies.json")
        let cellNip = UINib(nibName: "CustomTableViewCell", bundle: nil)
        myTable.register(cellNip, forCellReuseIdentifier: "customCell")
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.movieAttributesArray = self.fetchArrayOfAttributesFromCoreData()
            self.myTable.reloadData()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}



extension ViewController:PathAddedMovieProtocol,UITableViewDelegate,UITableViewDataSource{
  
    //=============== PathAddedMovieProtocol stubs ========================================//
    func addMovie(movieName newMovie: Movie)
    {
        MovieArray.append(newMovie)
        addMovieToCoreData(movieName: newMovie)
        myTable.reloadData()
    }
    
    //================ PathMovieArrayProtocol stubs =======================================//
    
    // if site is reachable
    func pathMovieArray(JSONArray collectedArray: [Movie]) {
        MovieArray = collectedArray
        pathMovieArrayToCoreData(theArray: MovieArray)
            self.myTable.reloadData()
    }
    // else
    // fetch data from array == implemented in view didload
    
    //=============== UITableViewDataSource stubs ==========================================//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieAttributesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell  = tableView.dequeueReusableCell(withIdentifier: "customCell")as! CustomTableViewCell
//       cell.textLabel?.text = MovieArray[indexPath.row].title
//       cell.imageView?.sd_setImage(with: URL(string: MovieArray[indexPath.row].image!), completed: nil)
        let cell = tableView.dequeueReusableCell(withIdentifier:"customCell") as!CustomTableViewCell
       // cell.titleLabel.text = MovieArray[indexPath.row].title
        cell.titleLabel.text = movieAttributesArray[indexPath.row].value(forKey: "title")as? String
       
        cell.movieImageView?.sd_setImage(with: URL(string: (movieAttributesArray[indexPath.row].value(forKey: "image")as? String)!), completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC_Obj:DetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "details") as! DetailsViewController
        detailsVC_Obj.selectedMovie = MovieArray[indexPath.row]
        self.navigationController?.pushViewController(detailsVC_Obj, animated: true )
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 ;
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            MovieArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    }
    

/*
 // ======= create app delegate object ================== //
 DispatchQueue.main.async {
 let appDelegate = UIApplication.shared.delegate as! AppDelegate
 }
 // ======= create managed object context =============== //
 let managedContext = appDelegate.persistentContainer.viewContext
 
 // ======= create object that represent MovieTable ===== //
 let movieEntity = NSEntityDescription.entity(forEntityName: "MovieTable", in: managedContext)
 
 // ======= creat object that represent MovieTable Row((manage object)) == //
 for movieItem in movieArrayAsParameter {
 let movieAttribut = NSManagedObject(entity: movieEntity!, insertInto: managedContext)
 movieAttribut.setValue(movieItem.title , forKey: "title")
 movieAttribut.setValue(movieItem.image , forKey: "image")
 movieAttribut.setValue(movieItem.rate , forKey: "rate")
 movieAttribut.setValue(movieItem.releaseYear , forKey: "releaseYear")
 do{
 try managedContext.save()
 movieAttributesArray.append(movieAttribut)
 }catch let error as NSError{
 print(error)
 }
 }
 */
