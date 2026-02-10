import Toybox.WatchUi;
import Toybox.System;

class BreathingViewDelegate extends WatchUi.BehaviorDelegate {
    private var _view;

    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    // Вызывается при нажатии кнопки Back
    function onBack() {
        var durationMs = System.getTimer() - _view._startTime;
        var durationSec = durationMs / 1000;

        // Переходим на экран итогов
        WatchUi.switchToView(
            new SummaryView(durationSec), 
            new SummaryDelegate(), 
            WatchUi.SLIDE_DOWN
        );
        return true; // Сообщаем системе, что мы обработали нажатие
    }
}