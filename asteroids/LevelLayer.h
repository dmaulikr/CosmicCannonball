#import "cocos2d.h"

#import "SceneManager.h"
#import "CCMenuItemLabelAndSprite.h"

@interface LevelLayer : CCLayer {
    CCMenuItemLabelAndSprite *level1;
    CCMenuItemLabelAndSprite *level2;
    CCMenuItemLabelAndSprite *level3;
    CCMenuItemLabelAndSprite *level4;
    CCMenuItemSprite *rightChev;
    CCMenuItemSprite *leftChev;
    CCMenu *rightChevMenu;
    CCMenu *leftChevMenu;
    CCMenu *currentMenu;
     CCMenu *currentMenu2;
     CCMenu *currentMenu3;
     CCMenu *currentMenu4;
    CCLabelTTF *level1Label;
    CCLabelTTF *level2Label;
    CCLabelTTF *level3Label;
    CCLabelTTF *level4Label;
    
    int currentLoc;
    
    NSNumber *map;
}

@property (nonatomic, retain) CCMenuItemLabelAndSprite *level1;
@property (nonatomic, retain) CCMenuItemLabelAndSprite *level2;
@property (nonatomic, retain) CCMenuItemLabelAndSprite *level3;
@property (nonatomic, retain) CCMenuItemLabelAndSprite *level4;
@property (nonatomic, retain) CCMenuItemSprite *rightChev;
@property (nonatomic, retain) CCMenuItemSprite *leftChev;
@property (nonatomic, retain) CCMenu *rightChevMenu;
@property (nonatomic, retain) CCMenu *leftChevMenu;
@property (nonatomic, retain) CCMenu *currentMenu;
@property (nonatomic, retain) CCMenu *currentMenu2;
@property (nonatomic, retain) CCMenu *currentMenu3;
@property (nonatomic, retain) CCMenu *currentMenu4;
@property (nonatomic, retain) CCLabelTTF *level1Label;
@property (nonatomic, retain) CCLabelTTF *level2Label;
@property (nonatomic, retain) CCLabelTTF *level3Label;
@property (nonatomic, retain) CCLabelTTF *level4Label;

- (void)onNewGame:(id)sender;
- (void)onCredits:(id)sender;
//-(void)moveRight:(id)sender;
//-(void)moveLeft:(id)sender;
@end
