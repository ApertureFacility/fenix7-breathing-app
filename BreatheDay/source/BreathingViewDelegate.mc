import Toybox.WatchUi;
import Toybox.System;

class BreathingViewDelegate extends WatchUi.BehaviorDelegate {
    private var _view;

    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    // Кнопка START (Select)
    function onSelect() {
        if (!_view._isActive) {
            _view.startExercise();
        } else {
            // Вызываем метод перехода, который мы написали внутри View
            _view.exitToSummary();
        }
        return true;
    }

    // Кнопка BACK
    function onBack() {
        // Если упражнение активно — останавливаем и идем в итоги
        if (_view._isActive) {
            _view.exitToSummary();
        } else {
            // Если еще не начали — просто выходим в меню
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        return true;
    }
}