#import "cocos2d.h"
#import "MenuLayer.h"
#import "CCNodeController.h"
#import "CC3Scene.h"
#import "asteroidsLayer.h"
#import "SceneManager.h"
#import "asteroidsAppDelegate.h"
#import "LevelLayer.h"
#import "GameOverLayer.h"
#import "OptsLayer.h"
#import "TutorialLayer.h"
#import "ShipLayer.h"

@interface SceneManager : NSObject {
    NSNumber *setDiff;
    NSNumber *pickedMap;
}

@property (nonatomic, retain)  NSNumber *pickedMap;

+(void) goMenu;
+(void) goTut;
-(void) goGame:(NSNumber *)map;
+(void) goLevelPicker:(NSNumber *)diff;
+(void) goOpts;
+(void) goGameOver;


@end