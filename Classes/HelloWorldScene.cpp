#include "HelloWorldScene.h"
#include "3d/CCAnimation3D.h"
#include "3d/CCAnimate3D.h"
#include "3d/CCAttachNode.h"
#include "3d/CCRay.h"
#include "3d/CCSprite3D.h"
#include "MapNative.h"

USING_NS_CC;

Scene* HelloWorld::createScene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::create();
    
    // 'layer' is an autorelease object
    auto layer = HelloWorld::create();//6

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !Layer::init() )
    {
        return false;
    }
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();

    /////////////////////////////
    // 3. add your codes below...
    
    mapSprite = Sprite3D::create("map.c3b");
    mapSprite->setPosition3D(Vec3(0, 0, 0));
    
    pinSprite = Sprite3D::create("pin.c3b");
    pinSprite->setPosition3D(Vec3(0, 0, 0));
    pinSprite->setScale(0.1);
    addChild(pinSprite);
    addChild(mapSprite);
    
    camera = Camera::createPerspective(60, (GLfloat)visibleSize.width/visibleSize.height, 0.01, 1000);
    
    // set parameters for camera
    camera->setPosition3D(Vec3(0, 0.15, 0.15));
    camera->lookAt(Vec3(0, 0, 0), Vec3(0, 1, 0));
    
    addChild(camera); //add camera to the scene
    
    auto light = DirectionLight::create(Vec3(-1.0f, -1.0f, 0.0f), Color3B::WHITE);
    addChild (light);
    
    auto r = 0.1f;
    
    auto back = MoveBy::create(5.0f, Vec3(0, 0, -r));
    auto right = MoveBy::create(5.0f, Vec3(-r, 0 , 0));
    auto forward = MoveBy::create(5.0f, Vec3(0, 0, r));
    auto left = MoveBy::create(5.0f, Vec3(+r , 0, 0));
    
    auto sequence = Sequence::create(back, right, forward, left, NULL);
    
    pinSprite->runAction(RepeatForever::create(sequence));
    
    this->runAction(Follow::create(pinSprite));
    
    auto listener = EventListenerTouchOneByOne::create();
    
    listener->onTouchBegan = CC_CALLBACK_2(HelloWorld::onTouchBegan, this);
    listener->onTouchMoved = CC_CALLBACK_2(HelloWorld::onTouchMoved, this);
    listener->onTouchEnded = CC_CALLBACK_2(HelloWorld::onTouchEnded, this);
    
    this->getEventDispatcher()->addEventListenerWithSceneGraphPriority(listener, this);
    
    return true;
}

bool HelloWorld::onTouchBegan(Touch *touch, Event *event){
    onTouchBeganPoint = touch[0].getLocation();
    return true;
}

void HelloWorld::onTouchMoved(Touch *touch, Event *event){
    auto location = touch[0].getLocation();
    Point newLocation = touch[0].getPreviousLocation()-location;
    mapSprite->runAction(EaseSineInOut::create(MoveBy::create(0.2, Vec3(-newLocation.x*0.0003, 0, newLocation.y*0.0003))));
    pinSprite->runAction(EaseSineInOut::create(MoveBy::create(0.2, Vec3(-newLocation.x*0.0003, 0, newLocation.y*0.0003))));
}

void HelloWorld::onTouchEnded(Touch *touch, Event *event){
    auto location = touch[0].getLocation();
    Point newLocation = onTouchBeganPoint-location;
    if(newLocation.length() < 30){
        Point screenPoint = Vec2(touch->getLocationInView().x, touch->getLocationInView().y);
        Point point = HelloWorld::transformPoint(screenPoint);
        CCLOG("%f, %f", point.x, point.y);
        MapNative::mapData(round(point.x), round(point.y), 1);//後で1, つまり階のシステムを構築する
    }
}

Point HelloWorld::transformPoint(Point point)
{
    
    Vec4 start = unProjectPoint(Vec3(point.x, point.y, 0));
    Vec4 end = unProjectPoint(Vec3(point.x, point.y, -1));
    
    Vec4 rayDir = end - start;
    rayDir.normalize();
    Vec4 normal = Vec4(0.15, 0.15, 0.0, 0);
    
    float rayDirDotNorm = rayDir.dot(normal);
    float P0DotNorm = start.dot(normal);
    
    float t = 0;
    
    if (rayDirDotNorm != 0) {
        t = -P0DotNorm / rayDirDotNorm;
    }
    
    Vec4 result = (rayDir * t) + start;
    Size visibleSize = Director::getInstance()->getVisibleSize();
    return Point(result.x, result.y);//2338, 2856
}

Vec4 HelloWorld::unProjectPoint(Vec3 point)
{
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Rect viewPort = Rect(0, 0, visibleSize.width, visibleSize.height);
    
    Director *d = Director::getInstance();
    
    Mat4 projectionMatrix = d->getMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);
    Mat4 modelView = _modelViewTransform;
    Mat4 finalMatrix = projectionMatrix * _modelViewTransform;
    assert(finalMatrix.inverse());
    
    Vec4 in = Vec4(point.x, point.y, point.z, 1);
    in.x = (in.x - viewPort.origin.x) / viewPort.size.width;
    in.y = (in.y - viewPort.origin.y) / viewPort.size.height;
    
    in.x = in.x * 2 -1;
    in.y = in.y * 2 -1;
    in.z = in.z * 2 -1;
    
    Vec4 out = finalMatrix * in;
    assert(out.w != 0);
    
    out.x /= out.w;
    out.y /= out.w;
    out.z /= out.w;
    out.w /= out.w;
    
    return out;
    
}