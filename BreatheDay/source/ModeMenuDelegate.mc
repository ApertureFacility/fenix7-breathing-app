using Toybox.WatchUi;

// Use Menu2InputDelegate for Menu2 class
class ModeMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    // In Menu2, the function name is onSelect, and it passes the MenuItem object
// В ModeMenuDelegate.mc
function onSelect(item) {
    var id = item.getId();
    var view = new BreathingView(id);
    // Передаем созданный view в делегат, чтобы он мог забрать время старта
    WatchUi.pushView(view, new BreathingViewDelegate(view), WatchUi.SLIDE_LEFT);
}
}