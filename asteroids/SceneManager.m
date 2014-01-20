#import "SceneManager.h"
#import "asteroidsScene.h"
#import "CC3EAGLView.h"

@interface SceneManager ()
+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;
@end

@implementation SceneManager

+(void) goMenu{
    CCLayer *layer = [MenuLayer node];
	[SceneManager go: layer];
}

+(void) goGameOver{
    CCLayer *layer = [[[GameOverLayer node] retain] autorelease];
	[SceneManager go: layer];
}

+(void) goGame:(NSNumber *)map{
    asteroidsAppDelegate *myDele = (asteroidsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [myDele startGame:map];

}

+(void) goTut{
    CCLayer *layer = [TutorialLayer node];
	[SceneManager go: layer];
}

+(void) goOpts{
    CCLayer *layer = [OptsLayer node];
	[SceneManager go: layer];
}


+(void) goLevelPicker:(NSNumber *)diff{
    
    //TEMP OVERWRITE TO WORK ON SHIP
    //REMOVE LATER

    asteroidsAppDelegate *myDele = (asteroidsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [myDele configureToDiff:diff];
    CCLayer *layer = [LevelLayer node];
	[SceneManager go: layer];
    /*
     Ship Picker layer. In construction.
    CCLayer *layer = [ShipLayer node];
	[SceneManager go: layer];*/
    
}


+(void) go: (CCLayer *) layer{
	CCDirector *director = [CCDirector sharedDirector];
	CCScene *newScene = [SceneManager wrap:layer];
	if ([director runningScene]) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:.50f scene:newScene]];
	}else {
		[director runWithScene:newScene];
	}
}

+(CCScene *) wrap: (CCLayer *) layer{
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
	return newScene;
}



@end