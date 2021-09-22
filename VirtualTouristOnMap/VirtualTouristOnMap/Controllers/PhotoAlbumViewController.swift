//
//  PhotoAlbumViewController.swift
//  VirtualTouristOnMap
//
//  Created by dnlatt on 16/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: IB Outlets
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoAlbumColletionView: UICollectionView!
    @IBOutlet weak var flowLayOut: UICollectionViewFlowLayout!
    @IBOutlet weak var getNewCollection: UIButton!
    @IBOutlet weak var noImageStatus: UILabel!
    
    // MARK: Properties
    
    var photos: [Photo] = []
    var selectedPin: Pin!
    let pinAnnotationOnMap = MKPointAnnotation()
    var totalPages: Int = 0
    var pageLoadStatus = false
    var imagesURL = [String]()
    var itemsToDelete = [IndexPath]()
    
    // MARK: System

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displaySelectedPinOnMap()
        updateFlowLayout(view.frame.size)
        noImageStatus.isHidden = true
        
        guard let loadedPhotos = loadPhotos() else {
            return
        }
        
        if loadedPhotos.count > 0 {
            photos = loadedPhotos
            pageLoadStatus = true
        } else {
            getFlickrPhotos()
            getNewCollection.isEnabled = false
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    // MARK: Display Pin on Map
    
    func displaySelectedPinOnMap() {
        pinAnnotationOnMap.coordinate = CLLocationCoordinate2D(latitude: selectedPin.latitude, longitude: selectedPin.longitude)
        mapView.addAnnotation(pinAnnotationOnMap)
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }

    // MARK: Create New Collection
    
    @IBAction func createNewCollection(_ sender: Any) {
        removePhotosFromCoreData(photos: photos)
        loadNewPhotoCollection()
    }
    
    func loadNewPhotoCollection() {
        var randomPage: Int {
            if totalPages > 0 {
                let randomPage = min(totalPages, 4000/21)
                return Int(arc4random_uniform(UInt32(randomPage)) + 1)
            }
            else
            {
                return 1
            }
       }
        pageLoadStatus = false
        
        performUIUpdatesOnMain {
            self.getNewCollection.isEnabled = false
            self.photoAlbumColletionView.reloadData()
        }
        
        let dataURL = FlickrClient.Endpoints.searchPhotos(selectedPin.latitude, selectedPin.longitude, randomPage)
        FlickrClient.getAllFlickrsPhotos(completion: completeFlickrJSON(response:error:success:), url: dataURL.url)
    }
    
    func completeFlickrJSON(response: Flickr?, error: Error?, success: Bool) {
        
        performUIUpdatesOnMain {
            self.photoAlbumColletionView.reloadData()
        }
        
        removePhotosFromCoreData(photos: photos)
        photos.removeAll()
        imagesURL.removeAll()
        
        guard let response = response else {
            return
        }
        
        if success {
        
            self.totalPages = response.photos.pages
            
            photos.removeAll()
            imagesURL.removeAll()
            removePhotosFromCoreData(photos: photos)
            
            var url = ""
            for photo in response.photos.photo {
                url = photo.url_m
                imagesURL.append(url)
            }
            
            if imagesURL.count > 0 {
                addPhotosToCoreData(at: self.selectedPin, of: imagesURL)
                reLoadPhotos()
                pageLoadStatus = true
                performUIUpdatesOnMain {
                    self.getNewCollection.isEnabled = true
                    self.noImageStatus.isHidden = true
                }
                
            }
            else {
                pageLoadStatus = false
                performUIUpdatesOnMain {
                    self.getNewCollection.isEnabled = false
                    self.noImageStatus.isHidden = false
                }
            }
        
        } else {
            
            guard Utilites.connectedToNetwork() == true else {
                Utilites.showMessage(title: "Error", message: "No Internet Connection", view: self)
                return
            }
            
            Utilites.showMessage(title: "Error", message: "Something went wrong. Please try again later!", view: self)
        }
        
        
        
    }
    
    
    func reLoadPhotos() {
        self.photos = loadPhotos()!
        performUIUpdatesOnMain {
            self.photoAlbumColletionView.reloadData()
        }
    }
    
    func getFlickrPhotos() {
        let dataURL = FlickrClient.Endpoints.searchPhotos(selectedPin.latitude, selectedPin.longitude, 1)
        FlickrClient.getAllFlickrsPhotos(completion: completeFlickrJSON(response:error:success:), url: dataURL.url)
    }
    
    private func updateFlowLayout(_ withSize: CGSize) {
        
        let landscape = withSize.width > withSize.height
        
        let space: CGFloat = landscape ? 5 : 3
        let items: CGFloat = landscape ? 2 : 3
        
        let dimension = (withSize.width - ((items + 1) * space)) / items
        
        flowLayOut?.minimumInteritemSpacing = space
        flowLayOut?.minimumLineSpacing = space
        flowLayOut?.itemSize = CGSize(width: dimension, height: dimension)
        flowLayOut?.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    func addPhotosToCoreData(at pin: Pin?, of imageURLs: [String]) {
        for photoIndex in 0..<imagesURL.count {
            
                let imageURL = imageURLs[photoIndex]
                let flickrPhoto = Photo(context: DataController.shared.viewContext)
                flickrPhoto.pin = pin
                flickrPhoto.imageURL = imageURL
                flickrPhoto.image = setPhotoImage(from: imageURLs[photoIndex])
                self.photos.append(flickrPhoto)
                do {
                    try DataController.shared.viewContext.save()
                } catch {
                    Utilites.showMessage(title: "Error", message: "Something went wrong", view: self)
                }
            }
        
        
    }
    
    func setPhotoImage(from url: String) -> Data? {
        guard let imageURL = URL(string: url) else { return nil }
        guard let imageData = try? Data(contentsOf: imageURL) else { return nil }

        if let image = UIImage(data: imageData) {
            return image.jpegData(compressionQuality: 1.0)
        } else {
            return nil
        }
    }
    
    func removePhotosFromCoreData(photos: [Photo]) {
        for photo in photos {
            DataController.shared.viewContext.delete(photo)
        }
    }
    
    
}

// MARK: Fetched Results

extension PhotoAlbumViewController {
    
    func loadPhotos() -> [Photo]? {
        do {
            var photos: [Photo] = []
            let photoFetchedResultsController = self.photoFetchedResultsController()
            
            try photoFetchedResultsController.performFetch()
            
            let totalPhotos = try photoFetchedResultsController.managedObjectContext.count(for: photoFetchedResultsController.fetchRequest)
            for index in 0..<totalPhotos {
                photos.append(photoFetchedResultsController.object(at: IndexPath(row: index, section: 0)) as! Photo)
            }
            
            return photos
        } catch {
            return nil
        }
    }
    
    func photoFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let photoFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        photoFetchRequest.sortDescriptors = []
        photoFetchRequest.predicate = NSPredicate(format: "pin = %@", argumentArray: [selectedPin!])
        
        let photoFetchResultController = NSFetchedResultsController(fetchRequest: photoFetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        photoFetchResultController.delegate = self
        return photoFetchResultController
    }
    
}

// MARK : UI View Collection

extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if pageLoadStatus {
            return photos.count
        } else {
            return Utilites.photosPerPage
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        if pageLoadStatus {
            cellCollection.activityIndicator.stopAnimating()
            let photo = photos[indexPath.row]
            cellCollection.flickrPhoto.image = UIImage(data: photo.image!)
        }
        else {
            cellCollection.activityIndicator.startAnimating()
            cellCollection.flickrPhoto.image = UIImage(named: "placeholder")
        }
        return cellCollection
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            let items = selectedCells.map { $0.item }.sorted().reversed()

            for item in items {
                DataController.shared.viewContext.delete(photos[item])
                photos.remove(at: item)
            }
            collectionView.deleteItems(at: selectedCells)
            
            do {
                try DataController.shared.viewContext.save()
            } catch {
                Utilites.showMessage(title: "Error", message: "Something went wrong", view: self)
            }

        }

        
    }
    
    
}

// MARK : Map Kit

extension PhotoAlbumViewController : MKMapViewDelegate {
            
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = false
                pinView!.pinTintColor = .blue
                pinView!.animatesDrop = true
            } else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }


}

