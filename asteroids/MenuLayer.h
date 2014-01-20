#import "cocos2d.h"

#import "SceneManager.h"

@interface MenuLayer : CCLayer {
    CCMenuItemSprite *easy;
    CCMenuItemSprite *normal;
    CCMenuItemSprite *hard;
 //   CCMenuItemFont *insane;
 //   CCMenuItemFont *reality;
    NSNumber *diff;
}

- (void)onNewGame:(id)sender;
- (void)onCredits:(id)sender;
@end
