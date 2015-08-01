#ifndef __HELLOWORLD_SCENE_H__
#define __HELLOWORLD_SCENE_H__

#include "cocos2d.h"

class HelloWorld : public cocos2d::Layer
{
public:
    // there's no 'id' in cpp, so we recommend returning the class instance pointer
    static cocos2d::Scene* createScene();

    // Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
    virtual bool init();
    
    bool onTouchBegan(cocos2d::Touch *touch, cocos2d::Event *event);
    void onTouchMoved(cocos2d::Touch *touch, cocos2d::Event *event);
    void onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *event);
    
    static HelloWorld *getInstance();
    void onSegmentedControlChanged(int story);
    void onLocationChanged(float latitude, float longitude);
    
    cocos2d::Point transformPoint(cocos2d::Point point);
    
    cocos2d::Camera* camera;
    
    cocos2d::Sprite3D* story0Sprite;
    cocos2d::Sprite3D* story1Sprite;
    cocos2d::Sprite3D* story2Sprite;
    cocos2d::Sprite3D* pinSprite;
    
    cocos2d::Vec2 onTouchBeganPoint;
    cocos2d::Vec2 mapPosition;
    float pinX;
    float pinY;
    int story;
    
    // implement the "static create()" method manually
    CREATE_FUNC(HelloWorld);
};
#endif // __HELLOWORLD_SCENE_H__