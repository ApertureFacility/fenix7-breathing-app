using Toybox.WatchUi;

// Use Menu2InputDelegate for Menu2 class
class ModeMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    // In Menu2, the function name is onSelect, and it passes the MenuItem object
    function onSelect(item) {
        var id = item.getId(); // This gets the symbol like :box or :even

        WatchUi.pushView(
            new BreathingView(id), 
            new BreathingViewDelegate(), 
            WatchUi.SLIDE_LEFT
        );
    }
}