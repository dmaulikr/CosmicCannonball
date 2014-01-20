#import "cocos2d.h"

#import "SceneManager.h"
#import <GameKit/GameKit.h>

@interface GameOverLayer : CCLayerColor {
    CCMenu *menu;
    NSNumber *score;
    CCMenuItemFont *report;
    BOOL cancelled;
}

- (void)onRetry:(id)sender;
- (void)onMainMenu:(id)sender;
- (void)onSendScores:(id)sender;
@end
