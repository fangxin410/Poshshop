//
//  PhotoRecord.h
//  ClassicPhotos
//
//  Created by Soheil M. Azarpour on 8/11/12.
//  Copyright (c) 2012 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h> // because we need UIImage
#import <Parse/Parse.h>

@interface PhotoRecord : NSObject
@property (nonatomic, strong) NSString *itemdescription;
@property (nonatomic, strong)PFObject *m_Object;

@property (nonatomic, strong) NSString *name;  // To store the name of image
@property (nonatomic, strong) NSString *price;  // To store the name of image
@property (nonatomic, strong) NSString *objectId;  // To store the name of image

@property (nonatomic, strong) NSString *contact;  // To store the name of image

@property (nonatomic, strong) UIImage *image; // To store the actual image
@property (nonatomic, strong) NSString *ThumbURL; // To store the URL of the image
@property (nonatomic, strong) NSString *URL; // To store the URL of the image
@property (nonatomic, strong) NSString *URL2; // To store the URL of the image
@property (nonatomic, strong) NSString *URL3; // To store the URL of the image
@property (readwrite) BOOL shipped; // Return YES if shipped.

@property (nonatomic, readonly) BOOL hasImage; // Return YES if image is downloaded.
@property (nonatomic, getter = isFiltered) BOOL filtered; // Return YES if image is sepia-filtered
@property (nonatomic, getter = isFailed) BOOL failed; // Return Yes if image failed to be downloaded

@end