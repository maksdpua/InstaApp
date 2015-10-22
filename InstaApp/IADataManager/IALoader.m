//
//  IADataManager.m
//  InstaApp
//
//  Created by Maks on 10/18/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import "IALoader.h"
#import "IADataSource.h"
#import "AFNetworking.h"
#import "IAApiclient.h"

@interface IALoader()<IADataSourceDelegate>

@property (nonatomic, strong) IADataSource *dataSource;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *nextUrl;

@end

@implementation IALoader

+ (id) dataLoader
{
    const static IALoader *loader = nil;
    if (nil == loader) {
    
    loader = [[IALoader alloc] init];
    loader.dataSource = [[IADataSource alloc]initWithDelegate:loader];
    [[NSNotificationCenter defaultCenter] addObserver:loader selector:@selector(needMore)
                                                 name:NotificationNewDataNeedToDownload object:nil];
    }
    return loader;
}

- (void) needMore{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"token"]) {

    }
    else {
        [IAApiClient getDataNextURL:self.nextUrl compliteBlock:^(NSDictionary *answer) {
            [self parseDataDictionary:answer];
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}
- (void) parseDataDictionary:(NSDictionary *)dataDict
{
    NSArray *tempArray = [dataDict objectForKey:@"data"];
    self.dataArray = tempArray;
    self.nextUrl = [[dataDict objectForKey:@"pagination"] objectForKey:@"next_url"];
    
    for (int i = 0; i < [self.dataArray count]; i++) {
        if (!modelIDObject(i, self.dataArray, self.dataSource)){
            [self.dataSource insertModelWithCaption:captionObject(i, self.dataArray) imageURL:imageSRObject(i, self.dataArray) modelID:idStringObject(i, self.dataArray)];
        }
    }
    
}

- (void) getData {
    NSString *urlString = kBaseRequestURL;
    if (self.nextUrl) {
        urlString = self.nextUrl;
    }
    NSDictionary *params = @{@"access_token":self.token, @"count":@"10"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlString
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *temp = responseObject;
             self.dataDict = temp;
             [self parseData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}



@end
