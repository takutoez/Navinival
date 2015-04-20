#ifndef __HELLOWORLD_SCENE_H__
#define __HELLOWORLD_SCENE_H__
#include "extensions/cocos-ext.h"

USING_NS_CC_EXT;

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
    
    cocos2d::Point transformPoint(cocos2d::Point point);
    cocos2d::Vec4 unProjectPoint(cocos2d::Vec3 point);
    
    cocos2d::Camera* camera;
    
    cocos2d::Sprite3D* mapSprite;
    cocos2d::Sprite3D* pinSprite;
    
    cocos2d::Vec2 onTouchBeganPoint;
    
    // a selector callback
    void menuCloseCallback(cocos2d::Ref* pSender);
    
    // implement the "static create()" method manually
    CREATE_FUNC(HelloWorld);//7

#endif // __HELLOWORLD_SCENE_H__
};

class EffectSprite3D;

class Effect3D : public cocos2d::Ref
{
public:
    virtual void draw(const cocos2d::Mat4 &transform) = 0;
    virtual void setTarget(EffectSprite3D *sprite) = 0;
protected:
    Effect3D() : _glProgramState(nullptr) {}
    virtual ~Effect3D()
    {
        CC_SAFE_RELEASE(_glProgramState);
    }
protected:
    cocos2d::GLProgramState* _glProgramState;
};

class Effect3DOutline: public Effect3D
{
public:
    static Effect3DOutline* create();
    
    void setOutlineColor(const cocos2d::Vec3& color);
    
    void setOutlineWidth(float width);
    
    virtual void draw(const cocos2d::Mat4 &transform) override;
    virtual void setTarget(EffectSprite3D *sprite) override;
protected:
    
    Effect3DOutline();
    virtual ~Effect3DOutline();
    
    bool init();
    
    cocos2d::Vec3 _outlineColor;
    float _outlineWidth;
    //weak reference
    EffectSprite3D* _sprite;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WP8 || CC_TARGET_PLATFORM == CC_PLATFORM_WINRT)
    EventListenerCustom* _backToForegroundListener;
#endif
    
protected:
    static const std::string _vertShaderFile;
    static const std::string _fragShaderFile;
    static const std::string _keyInGLProgramCache;
    
    static const std::string _vertSkinnedShaderFile;
    static const std::string _fragSkinnedShaderFile;
    static const std::string _keySkinnedInGLProgramCache;
    
    static cocos2d::GLProgram* getOrCreateProgram();
};

class EffectSprite3D : public cocos2d::Sprite3D
{
public:
    static EffectSprite3D* createFromObjFileAndTexture(const std::string& objFilePath, const std::string& textureFilePath);
    static EffectSprite3D* create(const std::string& path);
    
    void setEffect3D(Effect3D* effect);
    void addEffect(Effect3DOutline* effect, ssize_t order);
    virtual void draw(cocos2d::Renderer *renderer, const cocos2d::Mat4 &transform, uint32_t flags) override;
protected:
    EffectSprite3D();
    virtual ~EffectSprite3D();
    
    std::vector<std::tuple<ssize_t,Effect3D*,cocos2d::CustomCommand>> _effects;
    Effect3D* _defaultEffect;
    cocos2d::CustomCommand _command;
};