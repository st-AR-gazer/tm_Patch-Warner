namespace ImageAssets {
    nvg::Texture@ texIce1;  nvg::Texture@ texIce2;   nvg::Texture@ texIce3;
    nvg::Texture@ texWood;  nvg::Texture@ texBumper; nvg::Texture@ texWater;

    void LoadTextures() {
        @texIce1   = nvg::LoadTexture("src/img/ice1.png");
        @texIce2   = nvg::LoadTexture("src/img/ice2.png");
        @texIce3   = nvg::LoadTexture("src/img/ice3.png");
        @texWood   = nvg::LoadTexture("src/img/wood.png");
        @texBumper = nvg::LoadTexture("src/img/bumper.png");
        @texWater  = nvg::LoadTexture("src/img/water.png");
    }

    nvg::Texture@ IconToTexture(Physics::ViewIcon icon) {
        switch(icon) {
            case Physics::ViewIcon::PNG_WATER:  return texWater;
            case Physics::ViewIcon::PNG_ICE1:   return texIce1;
            case Physics::ViewIcon::PNG_ICE2:   return texIce2;
            case Physics::ViewIcon::PNG_ICE3:   return texIce3;
            case Physics::ViewIcon::PNG_WOOD:   return texWood;
            case Physics::ViewIcon::PNG_BUMPER: return texBumper;
            default:                            return null;
        }
    }
}
