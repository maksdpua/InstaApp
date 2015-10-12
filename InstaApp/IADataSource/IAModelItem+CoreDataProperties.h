//
//  IAModelItem+CoreDataProperties.h
//  InstaApp
//
//  Created by Maks on 10/12/15.
//  Copyright © 2015 Maks. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IAModelItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface IAModelItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *nameImage;
@property (nullable, nonatomic, retain) NSString *text;

@end

NS_ASSUME_NONNULL_END
