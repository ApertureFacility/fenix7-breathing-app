import Toybox.WatchUi;

class BreathingViewDelegate extends WatchUi.BehaviorDelegate {
    private var _view;

    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onSelect() {
        if (!_view._isActive) {
            _view.startExercise();
        } else {
            showExitMenu();
        }
        return true;
    }

    function onBack() {
        if (_view._isActive) {
            showExitMenu();
        } else {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        return true;
    }

    function showExitMenu() {
        var menu = new WatchUi.Menu2({:title=>"Занятие"});
        menu.addItem(new WatchUi.MenuItem("Возобновить", null, "resume", null));
        menu.addItem(new WatchUi.MenuItem("Сохранить", null, "save", null));
        menu.addItem(new WatchUi.MenuItem("Отменить", "(удалить)", "discard", null));
        
        WatchUi.pushView(menu, new BreathingMenuDelegate(_view), WatchUi.SLIDE_UP);
    }
}

// Новый делегат для обработки выбора в меню
class BreathingMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _view;

    function initialize(view) {
        Menu2InputDelegate.initialize();
        _view = view;
    }

    function onSelect(item) {
        var id = item.getId();
        if (id.equals("resume")) {
            WatchUi.popView(WatchUi.SLIDE_DOWN); // Просто закрыть меню и продолжить
        } else if (id.equals("save")) {
            _view.exitToSummary(true); 
        } else if (id.equals("discard")) {
            _view.exitToSummary(false); // Теперь это сработает
        }
    }
}