//
//  OCAlgorythms.h
//  openClusterMapView
//
//  Created by Botond Kis on 15.07.11.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/// Enumaration for the clustering methods
/** Contains all clustering methods which are aviable in OCMapView yet*/
typedef enum {
    OCClusteringMethodBubble,
    OCClusteringMethodGrid
} OCClusteringMethod;

/// Class containing clustering algorithms.
/** The first release of OCMapView brings two different algorithms.
 This class is supposed to hold those algorithms.
 More algorithms are planned for future releases of OCMapView.

 Note for OCMapView developers:
 Every algorithm has to be a class method which returns an array of OCAnnotations or a subclass of it.
 OR for future releases they can be instance methods if they run asynchronously. The instance holder
 needs to implement the delegate protocol and the method needs to call the delegate.
 */
@interface OCAlgorithms : NSObject

/// Bubble clustering with iteration
/** This algorithm creates clusters based on the distance
 between single annotations.

 @param annotationsToCluster contains the Annotations that should be clustered
 @param radius represents the cluster size.

 It iterates through all annotations in the array and compare their
 distances. If they are near engough, they will be clustered.*/
+ (NSArray*)bubbleClusteringWithAnnotations:(NSArray*)annotationsToCluster
			      clusterRadius:(CLLocationDistance)radius
				    grouped:(BOOL)grouped;



/// Grid clustering with predefined size
/** This algorithm creates clusters based on a defined grid.

 @param annotationsToCluster contains the Annotations that should be clustered
 @param tileRect represents the size of a grid tile.

 It iterates through all annotations in the array and puts them into a grid tile based on their location.*/
+ (NSArray*)gridClusteringWithAnnotations:(NSArray*)annotationsToCluster
			      clusterRect:(MKCoordinateSpan)tileRect
				  grouped:(BOOL)grouped;

@end
