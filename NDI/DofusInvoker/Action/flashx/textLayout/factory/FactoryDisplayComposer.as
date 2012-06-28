package flashx.textLayout.factory
{
    import flashx.textLayout.compose.*;
    import flashx.textLayout.container.*;
    import flashx.textLayout.elements.*;

    public class FactoryDisplayComposer extends StandardFlowComposer
    {

        public function FactoryDisplayComposer()
        {
            return;
        }// end function

        override function callTheComposer(param1:int, param2:int) : ContainerController
        {
            clearCompositionResults();
            var _loc_3:* = TextLineFactoryBase._factoryComposer;
            _loc_3.composeTextFlow(textFlow, -1, -1);
            _loc_3.releaseAnyReferences();
            return getControllerAt(0);
        }// end function

        override protected function preCompose() : Boolean
        {
            return true;
        }// end function

        override function createBackgroundManager() : BackgroundManager
        {
            return new FactoryBackgroundManager();
        }// end function

    }
}
