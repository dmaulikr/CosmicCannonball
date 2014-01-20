#import "cocos2d.h"

#import "SceneManager.h"
#import "CCMenuItemLabelAndSprite.h"

@interface TutorialLayer : CCLayerColor {
    CCSprite *tut1;
    CCSprite *tut2;

    CCMenuItemSprite *rightChev;
    CCMenuItemSprite *leftChev;
    CCMenuItemSprite *closeChev;
    CCMenu *rightChevMenu;
    CCMenu *closeChevMenu;
    CCMenu *leftChevMenu;

    CCSprite *tutSprite;
    
    int currentLoc;

}

@property (nonatomic, retain) CCSprite *tut1;
@property (nonatomic, retain) CCSprite *tut2;

@property (nonatomic, retain) CCMenuItemSprite *rightChev;
@property (nonatomic, retain) CCMenuItemSprite *leftChev;
@property (nonatomic, retain) CCMenu *rightChevMenu;
@property (nonatomic, retain) CCMenu *leftChevMenu;


- (void)onNext:(id)sender;
- (void)onPrev:(id)sender;
- (void)onClose:(id)sender;
//-(void)moveRight:(id)sender;
//-(void)moveLeft:(id)sender;
@end
