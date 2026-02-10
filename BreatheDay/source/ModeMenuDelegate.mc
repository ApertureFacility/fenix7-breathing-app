using Toybox.WatchUi;

class ModeMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var id = item.getId();
        var view = new BreathingView(id);
        // Запускаем экран дыхания и передаем ему СВОЙ делегат
        WatchUi.pushView(view, new BreathingViewDelegate(view), WatchUi.SLIDE_LEFT);
    }
    
    // Этот onBack просто закроет меню и вернет в начало приложения
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}