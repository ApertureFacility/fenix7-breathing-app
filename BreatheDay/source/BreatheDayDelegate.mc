import Toybox.Lang;
import Toybox.WatchUi;

class BreatheDayDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new BreatheDayMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}