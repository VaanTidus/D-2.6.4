﻿package com.ankamagames.dofus.misc.utils
{
    import com.ankamagames.dofus.types.enums.*;

    public class AnimationCleaner extends Object
    {

        public function AnimationCleaner()
        {
            return;
        }// end function

        public static function cleanBones1AnimName(param1:uint, param2:String = null) : String
        {
            var _loc_3:String = null;
            switch(param1)
            {
                case 1:
                {
                    if (param2)
                    {
                        if (param2.length > 12 && param2.slice(0, 12) == AnimationEnum.ANIM_STATIQUE && (param2.length < 15 || param2.slice(12, 15) != "_to"))
                        {
                            return AnimationEnum.ANIM_STATIQUE;
                        }
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return param2;
        }// end function

    }
}
