//
//  DetailViewController.m
//  DZApiVK
//
//  Created by Dima Tixon on 27/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UIGestureRecognizerDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.photoImageView.image = self.photo;
    
   
    
    UIRotationGestureRecognizer *rotationGesture =
    [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(rotateImage:)];
    rotationGesture.delegate = self;
    
    UIPinchGestureRecognizer *pinchGesture =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(scaleImage:)];
    pinchGesture.delegate = self;
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(resetImage:)];
    
    UITapGestureRecognizer* doubleTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleDoubleTap:)];
    
    doubleTapGesture.numberOfTapsRequired = 2;
    
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    UIPanGestureRecognizer *panGesture =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(moveImage:)];
    panGesture.delegate = self;
    
    // this gesture will only work with 1 finger
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    
    [self.view addGestureRecognizer:doubleTapGesture];
    [self.view addGestureRecognizer:rotationGesture];
    [self.view addGestureRecognizer:pinchGesture];
    [self.view addGestureRecognizer:tapGesture];
    [self.view addGestureRecognizer:panGesture];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIGestureRecognizer

- (void)rotateImage:(UIRotationGestureRecognizer *)recognizer {
    
    // Begins:  when two touches have moved enough to be considered a rotation
    // Changes: when a finger moves while two fingers are down
    // Ends:    when both fingers have lifted
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        self.previousRotation = 0.0;
        return;
    }
    
    // calculate the new rotation with the previous rotation
    // and then set the current rotation
    // so our next rotation will start with the current rotation.
    
    CGFloat newRotation = 0.0 - (self.previousRotation - recognizer.rotation);
    
    // apply this rotation to the current transformation
    
    CGAffineTransform currentTransformation = self.photoImageView.transform;
    
    // adding a rotation value to an existing affine transform.
    
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransformation, newRotation);
    
    self.photoImageView.transform = newTransform;
    
    // set the previousRotationValue to the current rotation of your fingers.
    
    self.previousRotation = recognizer.rotation;
}


   // zoom in out

- (void)scaleImage:(UIPinchGestureRecognizer *)recognizer {
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        self.previousScale = 1.0;
        return;
    }
    
    // calculate the new Scale with the previous Scale
    CGFloat newScale = 1.0 - (self.previousScale - recognizer.scale);
    
    CGAffineTransform currentTransformation = self.photoImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransformation, newScale, newScale);
    
    self.photoImageView.transform = newTransform;
    self.previousScale = recognizer.scale;
}


- (void)resetImage:(UITapGestureRecognizer *)recognizer {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    // reset the image to its default state
    self.photoImageView.transform = CGAffineTransformIdentity;
    
    // center the image
    [self.photoImageView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    [UIView commitAnimations];
}


- (void) handleDoubleTap:(UITapGestureRecognizer*) tapGesture {
    
    CGAffineTransform currentTransform = self.photoImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 1.2f, 1.2f);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.photoImageView.transform = newTransform;
                     }];
    
    self.previousScale = 1.2f;
}


   // dragging gestures.
- (void)moveImage:(UIPanGestureRecognizer *)recognizer {
    
    // translation in the coordinate system of the specified view
    
      // set coord of your finger.
    CGPoint newCenter = [recognizer translationInView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        self.beginX = self.photoImageView.center.x;
        self.beginY = self.photoImageView.center.y;
    }
    
    // the center of the image view will be at the same place as our finger
    newCenter = CGPointMake(self.beginX + newCenter.x, self.beginY + newCenter.y);
    [self.photoImageView setCenter:newCenter];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]];
}














@end















