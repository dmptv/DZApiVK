//
//  AKServerManager.m
//  DZApiVK
//
//  Created by Kanat A on 20/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import "AKServerManager.h"
#import <AFNetworking.h>
#import <JSQMessagesViewController/JSQMessages.h>

#import "AKLoginViewController.h"
#import "VKAccessToken.h"

#import "AKUser.h"
#import "VKPost.h"
#import "VKGroup.h"
#import "VKPhoto.h"
#import "VKComment.h"

@interface AKServerManager ()


@property (strong, nonatomic) VKAccessToken* accessToken;
@property (strong, nonatomic) AFHTTPSessionManager* requestSessionManager;

@end

@implementation AKServerManager

+ (AKServerManager*) sharedManager {
    static AKServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AKServerManager alloc] init];
    });
    
    return manager;
}





- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL* baseURL = [NSURL URLWithString:@"https://api.vk.com/method"];
        self.requestSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    return self;
}





#pragma mark - 
#pragma mark Authorization
- (void) authorizeUser:(void(^)(AKUser* user)) completion {
    
    AKLoginViewController* loginVC = [[AKLoginViewController alloc] initWithCompletionBlock:^(VKAccessToken *token) {
        self.accessToken = token;
        
        if (token) {
            [self getUser:self.accessToken.userID
                onSuccess:^(AKUser *user) {
                    
                    if (completion) {
                        completion(user);
                    }
                }
                onFailure:^(NSError *error) {
                 NSLog(@"authorizeUser error %@", [error localizedDescription]);
                }];
        }
    }];
    
         // возьмем rootViewController и скажем ему презентовать AKLoginViewController
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC presentViewController:nav animated:YES completion:nil];
}






#pragma mark - 
#pragma mark - API Methods

- (void) postOnWall:(NSString*)groupID
            message:(NSString*)message
           onSucces:(void(^)(id result)) succes
          onFailure:(void(^)(NSError* error)) failure {
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* parameters = @{@"owner_id"     : groupID,
                                 @"message"      : message,
                                 @"access_token" : self.accessToken.token,
                                 @"version"      : @"5.60"
                                 };

    [self.requestSessionManager POST:@"wall.post"
                          parameters:parameters
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if (succes) {
                                     succes(responseObject);
                                 }
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 NSLog(@"error %@", [error localizedDescription]);
                             }];
}






- (void) getGroupWall:(NSString*)groupID
           withOffset:(NSInteger)offset
                count:(NSInteger)count
             onSucces:(void(^)(NSArray* posts)) success
            onFailure:(void(^)(NSError* error)) failure {
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* parameters = @{@"owner_id" : groupID,
                                 @"offset"   : @(offset),
                                 @"count"    : @(count),
                                 @"extended" : @"1",
                                 @"fields"   : @"photo_50",
                                 @"version"  : @"5.59"
                                 };
    
    [self.requestSessionManager GET:@"wall.get"
                         parameters:parameters
                           progress:nil
                            success:^(NSURLSessionDataTask* task, id responseObject) {
                                
                                NSDictionary* dictsDict = [responseObject objectForKey:@"response"];
                                
                                // get Users
                                NSArray* profilesArray = [dictsDict objectForKey:@"profiles"];
                                
                                // make User
                                NSMutableArray* usersArray = [NSMutableArray array];
                                
                                for (NSDictionary* userDic in profilesArray) {
                                    AKUser* user = [[AKUser alloc] initWithServerResponce:userDic];
                                    [usersArray addObject:user];
                                }
                                
                                
                                
                                
                                // get Groups
                                NSArray* groupsArray = [dictsDict objectForKey:@"groups"];
                                
                                // make Group
                                VKGroup* group = [[VKGroup alloc] initWithServerResponce:[groupsArray objectAtIndex:0]];
                                
                                // get Posts
                                NSArray* dictArray = [dictsDict objectForKey:@"wall"];
                                
                                // Cut first object
                                if ([dictArray count] > 1) {
                                    dictArray = [dictArray subarrayWithRange:NSMakeRange(1, (int)[dictArray count] - 1)];
                                } else {
                                    dictArray = nil;
                                }
                                
                                
                                
                                
                                // make posts
                                NSMutableArray* objectsArray = [NSMutableArray array];
                                
                                for (NSDictionary* dict in dictArray) {
                                    VKPost* post = [[VKPost alloc] initWithServerResponce:dict];
                                    
                                    if ([post.from_id hasPrefix:@"-"]) {
                                        // mean thet post.from_group != nil
                                        post.from_group = group;
                                        [objectsArray addObject:post];
                                        
                                            // In a loop, continue tells the program to begin
                                            // the next iteration, ignoring any code that comes after it.
                                            // Go up and continue loop
                                        
                                        continue;
                                    }
                                    
                                    for (AKUser* user in usersArray) {
                                        if ([post.from_id isEqual:user.user_id]) {
                                            
                                            // means that post.from_user != nil
                                            post.from_user = user;
                                            [objectsArray addObject:post];
                                            
                                                // break immediately ends the execution of the loop
                                                // and moves on to the code after the loop.
                                                // let outer loop continue iterating
                                                // continue and break only apply to the “closest” loop
                                            break;
                                        }
                                    }
                                }
                                
                                
                                
                                // callback posts
                                if (success) {
                                    success(objectsArray);
                                }
                                
                            }
     
     
     
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                NSLog(@"Error: %@", error);
                                
                                if (failure) {
                                    failure(error);
                                }
                                
                            }];
}






- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(AKUser* user)) success
       onFailure:(void(^)(NSError* error)) failure {
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userID,      @"user_ids",
                                @"photo_50", @"fields",
                                @"nom",      @"name_case",
                                nil];
    
    
    [self.requestSessionManager GET:@"users.get"
                         parameters:parameters
                           progress:nil
                            success:^(NSURLSessionDataTask* task, id responseObject) {
                                NSArray* dictsArray = [responseObject objectForKey:@"response"];
                                
                                if ([dictsArray count] > 0) {
                                    AKUser* user = [[AKUser alloc] initWithServerResponce:[dictsArray firstObject]];
                                    
                                    NSString* urlString = [[dictsArray firstObject] objectForKey:@"photo_50"];
                                    if (urlString) {
                                        user.imageURL = [NSURL URLWithString:urlString];
                                    }
                                    
                                    if (success) {
                                        success(user);
                                    } else {
                                        if (failure) {
                                            failure(nil);
                                        }
                                    }
                                }
                            }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                if (failure) {
                                    failure(error);
                                }
                            }];
}





#pragma mark - Messages Api

- (void) sendMessageForUserId:(NSString*)senderId
                      message:(NSString*)message
                    onSuccess:(void(^)(id result)) success
                    onFailure:(void(^)(NSError *error)) failure {
    
    NSDictionary* parameters = @{ @"access_token" : self.accessToken.token,
                                       @"user_id" : senderId,
                                       @"message" : message,
                                       @"version" : @"5.60"
                                  };
    
    [self.requestSessionManager POST:@"messages.send"
                          parameters:parameters
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if (success) {
                                     success(responseObject);
                                 }
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 NSLog(@"error %@", [error localizedDescription]);
                                 if (failure) {
                                     failure(error);
                                 }
                             }];
}


- (void) getHistoryMessagesFromUserId:(NSString *)senderId
                           senderName:(NSString *)senderDisplayName
                                count:(NSInteger)count
                               offset:(NSInteger)offset
                            onSuccess:(void (^)(NSArray *))success
                            onFailure:(void (^)(NSError *))failure {
    
    NSDictionary* parameters = @{@"access_token" : self.accessToken.token,
                                 @"offset"       : @(offset),
                                 @"count"        : @(count),
                                 @"user_id"      : senderId,
                                 @"version"      : @"5.60"
                                 };
    
    [self.requestSessionManager GET:@"messages.getHistory"
                         parameters:parameters
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                // NSLog(@"responseObject %@", responseObject);
                                
                                NSArray *dictsArray = [responseObject objectForKey:@"response"];
                                if ([dictsArray count] > 1) {
                                    dictsArray = [dictsArray subarrayWithRange:NSMakeRange(1, (int)[dictsArray count] - 1)];
                                } else {
                                    dictsArray = nil;
                                }
                                
                                NSMutableArray* objectsArray = [NSMutableArray array];
                                for (NSDictionary* dict in dictsArray) {
                                    
                                    NSString* text = [dict objectForKey:@"body"];
                                    NSString* senderId = [[dict objectForKey:@"from_id"] stringValue];
                                    
                                    NSNumber* numbSec = [dict objectForKey:@"date"];
                                    NSTimeInterval unixTime = [numbSec doubleValue];
                                    NSDate* date = [NSDate dateWithTimeIntervalSince1970:unixTime];
                                    
                                    JSQMessage* message = [[JSQMessage alloc] initWithSenderId:senderId
                                                                             senderDisplayName:senderDisplayName
                                                                                          date:date
                                                                                          text:text];
                                    [objectsArray addObject:message];
                                }
                                
                                if (success) {
                                    success(objectsArray);
                                }
                            }
     
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                NSLog(@"Error: %@", error);
                                if (failure) {
                                    failure(error);
                                }
                            }];
}


#pragma mark - Comments API

- (void) getCommentsFromWall:(NSString*)groupID
                      postID:(NSString*)postID
                  withOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray* comments))succsess
                   onFailure:(void(^)(NSError* error))failure {
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* parameters = @{@"access_token" : self.accessToken.token,
                                 @"offset"       : @(offset),
                                 @"count"        : @(count),
                                 @"need_likes"   : @1,
                                 @"owner_id"     : groupID,
                                 @"post_id"      : postID,
                                 @"sort"         : @"asc",
                                 @"extended"     : @1,
                                 @"v"            : @"5.60",
                                 };
    

    [self.requestSessionManager GET:@"wall.getComments"
                         parameters:parameters
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                //NSLog(@"user %@", responseObject);

                                NSDictionary* dictsDict = [responseObject objectForKey:@"response"];
                                
                                // get Users
                                NSArray* profilesArray = [dictsDict objectForKey:@"profiles"];
                               
                                // make User
                                NSMutableArray* usersArray = [NSMutableArray array];
                                
                                NSMutableDictionary* newDic = [[NSMutableDictionary alloc] init];
                                for (NSMutableDictionary* userDic in profilesArray) {
                                     // swap out keys - id, "photo_50" for - uid, photo
                                    [newDic addEntriesFromDictionary:userDic];
                                     
                                    id value = [newDic objectForKey:@"id"];
                                    [newDic removeObjectForKey:@"id"];
                                    [newDic setObject:value forKey:@"uid"];
                                    
                                    id value2 = [newDic objectForKey:@"photo_50"];
                                    [newDic removeObjectForKey:@"photo_50"];
                                    [newDic setObject:value2 forKey:@"photo"];
                                
                                    AKUser* user = [[AKUser alloc] initWithServerResponce:newDic];
                                    [usersArray addObject:user];
                                }
                                
                                // get comments
                                NSArray* dictArray = [dictsDict objectForKey:@"items"];
                                
                                // make comments
                                NSMutableArray* objectsArray = [NSMutableArray array];
                                for (NSDictionary* dict in dictArray) {
                                    VKComment* comment = [[VKComment alloc] initWithServerResponce:dict];
                                    
                                    for (AKUser* user in  usersArray) {
                                        if ([user.user_id isEqualToString:comment.from_id]) {
                                            comment.user = user;
                                        }
                                    }
                                    
                                    [objectsArray addObject:comment];
                                }
                                
                                
                                // надо распихать автора по юзеру или группе
                                
                                /*
                                 // **** ITERATING THROUGH ARRAY OF AUTHORS - LOOKING FOR AUTHOR FOR THIS COMMENT
                                 
                                 for (ANUser* author in authorsArray) {
                                 
                                    if ([comment.authorID hasPrefix:@"-"]) {
                                    comment.fromGroup = group;
                                    continue;
                                    }
                                 
                                     if ([author.userID isEqualToString:comment.authorID]) {
                                     comment.author = author;
                                     }
                                 }
                                 */
                               
                                if (succsess) {
                                    succsess(objectsArray);
                                }
                          
                            }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                NSLog(@"error %@", [error localizedDescription]);
                            }];

}

- (void) commentToPost:(NSString*)postID
              fromWall:(NSString*)groupID
               message:(NSString*)message
             onSuccess:(void(^)(id result))succsess
             onFailure:(void(^)(NSError* error))failure {
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* params = @{@"owner_id"     : groupID,
                             @"access_token" : self.accessToken.token,
                             @"post_id"      : postID,
                             @"message"      : message,
                             @"version"      : @"5.60",
                             };

    [self.requestSessionManager POST:@"wall.createComment"
                          parameters:params
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 //NSLog(@"responseObject %@", responseObject);
                                 if (succsess) {
                                     succsess(responseObject);
                                 }
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 
                             }];

}
























@end
