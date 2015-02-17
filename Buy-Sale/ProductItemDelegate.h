//
//  ProductItemDelegate.h
//  Buy-Sale
//
//  Created by Jin on 4/21/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol ProductItemDelegate <NSObject>
-(void) setProductItem:(PFObject*) obj;
-(PFObject *) getProduct;
-(NSString *) getUrl;
-(void) setShipCheck:(BOOL) check;
@end
