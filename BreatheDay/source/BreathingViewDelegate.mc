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
        // 1. Считаем длительность
        var durationMs = System.getTimer() - _view._startTime;
        var durationSec = durationMs / 1000;

        
        var cyclesCompleted = _view._cycles;
        var startHR = _view._startHR;
        var endHR = _view._currentHR;

        // 3. Переходим на экран итогов, передавая ВСЕ 4 аргумента
        WatchUi.switchToView(
            new SummaryView(durationSec, cyclesCompleted, startHR, endHR), 
            new SummaryDelegate(), 
            WatchUi.SLIDE_DOWN
        );
        
        return true; 
    }
}