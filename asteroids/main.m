//
//  main.m
//  asteroids
//
//  Created by Eric Schmitt on 9/20/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"asteroidsAppDelegate");
    [pool release];
    return retVal;
}
