//
//  VKPhotosGroupTC.m
//  DZApiVK
//
//  Created by Dima Tixon on 29/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "VKPhotosGroupTC.h"
#import "VKPhotosGroupCell.h"
#import "VKGroup.h"
#import "VKAlbum.h"

@interface VKPhotosGroupTC ()

@property (strong,nonatomic) NSMutableArray *albumArray;

@end

@implementation VKPhotosGroupTC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1; //[self.albumArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"photosCell";
    
    //VKAlbum *album = [self.albumArray objectAtIndex:indexPath.row];
    VKAlbum* album = [[VKAlbum alloc] init];
    
    VKPhotosGroupCell *cell =
    (VKPhotosGroupCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[VKPhotosGroupCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  album:album
                                        reuseIdentifier:cellIdentifier];
    }

    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    [self performSegueWithIdentifier:@"detailCollectionSegue"
                              sender:indexPath];*/
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
    if ([[segue identifier] isEqualToString:@"detailCollectionSegue"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        
        VKAlbum *album = [self.albumArray objectAtIndex:indexPath.row];
       // TTDetailCollectionViewController *vc = [segue destinationViewController];
        //vc.album = album;
    }*/
}

#pragma mark - API

- (void) getAlbumsFromServer {

}


- (void) refreshWall {

}


- (void)dealloc {
    [self.tableView setDelegate:nil];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}























@end
