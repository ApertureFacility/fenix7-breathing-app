import Toybox.WatchUi;
import Toybox.System;

class BreathingViewDelegate extends WatchUi.BehaviorDelegate {
    private var _view;

    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    // Обработка кнопки START / STOP (и касания экрана)
    function onSelect() {
        exitToSummary();
        return true;
    }

    // Если хотите оставить возможность выйти и по кнопке BACK, оставьте этот метод.
    // Если хотите, чтобы BACK ничего не делала во время упражнения — удалите его.
    function onBack() {
        exitToSummary();
        return true;
    }

    // Вынесли общую логику перехода в отдельную функцию
  function exitToSummary() {
    // Останавливаем и сохраняем активность в FIT-файл
    _view.stopAndSaveSession();

    var durationMs = System.getTimer() - _view._startTime;
    var durationSec = durationMs / 1000;

    var cyclesCompleted = _view._cycles;
    var startHR = _view._startHR;
    var endHR = _view._currentHR;

    WatchUi.switchToView(
        new SummaryView(durationSec, cyclesCompleted, startHR, endHR), 
        new SummaryDelegate(), 
        WatchUi.SLIDE_DOWN
    );
}
}