#import "cocos2d.h"

#import "SceneManager.h"

@interface OptsLayer : CCLayerColor {
    CCMenu *menu;
    CCMenuItemSprite *vertical;
    CCMenuItemSprite *angled;
    CCMenuItemSprite *flat;
    CCMenuItemSprite *soundOnOff;
    CCMenuItemSprite *invertOnOff;
}

- (void)onBuy:(id)sender;
- (void)onCancel:(id)sender;
@end
