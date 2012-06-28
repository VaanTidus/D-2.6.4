package flashx.textLayout.compose
{
    import flashx.textLayout.container.*;
    import flashx.textLayout.formats.*;

    final public class VerticalJustifier extends Object
    {

        public function VerticalJustifier()
        {
            return;
        }// end function

        public static function applyVerticalAlignmentToColumn(param1:ContainerController, param2:String, param3:Array, param4:int, param5:int, param6:int, param7:int) : Number
        {
            var _loc_8:IVerticalAdjustmentHelper = null;
            var _loc_9:int = 0;
            var _loc_10:Number = NaN;
            var _loc_11:IVerticalJustificationLine = null;
            var _loc_12:Number = NaN;
            var _loc_13:int = 0;
            var _loc_14:FloatCompositionData = null;
            if (param1.rootElement.computedFormat.blockProgression == BlockProgression.RL)
            {
                _loc_8 = new RL_VJHelper(param1);
            }
            else
            {
                _loc_8 = new TB_VJHelper(param1);
            }
            switch(param2)
            {
                case VerticalAlign.MIDDLE:
                case VerticalAlign.BOTTOM:
                {
                    _loc_11 = param3[param4 + param5 - 1];
                    _loc_12 = _loc_8.getBottom(_loc_11, param1, param6, param7);
                    _loc_10 = param2 == VerticalAlign.MIDDLE ? (_loc_8.computeMiddleAdjustment(_loc_12)) : (_loc_8.computeBottomAdjustment(_loc_12));
                    _loc_9 = param4;
                    while (_loc_9 < param4 + param5)
                    {
                        
                        _loc_8.applyAdjustment(param3[_loc_9]);
                        _loc_9++;
                    }
                    _loc_13 = param6;
                    while (_loc_13 < param7)
                    {
                        
                        _loc_14 = param1.getFloatAt(_loc_13);
                        if (_loc_14.floatType != Float.NONE)
                        {
                            _loc_8.applyAdjustmentToFloat(_loc_14);
                        }
                        _loc_13++;
                    }
                    break;
                }
                case VerticalAlign.JUSTIFY:
                {
                    _loc_10 = _loc_8.computeJustifyAdjustment(param3, param4, param5);
                    _loc_8.applyJustifyAdjustment(param3, param4, param5);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_10;
        }// end function

    }
}

interface IVerticalAdjustmentHelper
{

    function IVerticalAdjustmentHelper();

    function getBottom(param1:IVerticalJustificationLine, param2:ContainerController, param3:int, param4:int) : Number;

    function computeMiddleAdjustment(param1:Number) : Number;

    function applyAdjustment(param1:IVerticalJustificationLine) : void;

    function applyAdjustmentToFloat(param1:FloatCompositionData) : void;

    function computeBottomAdjustment(param1:Number) : Number;

    function computeJustifyAdjustment(param1:Array, param2:int, param3:int) : Number;

    function applyJustifyAdjustment(param1:Array, param2:int, param3:int) : void;

}

