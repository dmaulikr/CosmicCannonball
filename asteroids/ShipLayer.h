#import "cocos2d.h"

#import "SceneManager.h"
#import "CCMenuItemLabelAndSprite.h"

@interface ShipLayer : CCLayer {

    CCMenuItemSprite *rightChev;
    CCMenuItemSprite *leftChev;
    CCMenu *rightChevMenu;
    CCMenu *leftChevMenu;
    
    int currentLoc;
    
    NSNumber *ship;
}


@property (nonatomic, retain) CCMenuItemSprite *rightChev;
@property (nonatomic, retain) CCMenuItemSprite *leftChev;
@property (nonatomic, retain) CCMenu *rightChevMenu;
@property (nonatomic, retain) CCMenu *leftChevMenu;


- (void)onNewGame:(id)sender;
- (void)onCredits:(id)sender;

@end
