import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Timer;
import Toybox.Attention;
import Toybox.Lang;
import Toybox.Sensor;
import Toybox.System;

class BreathingView extends WatchUi.View {
    // Публичные переменные для доступа из делегата
    var _startTime;
    var _cycles = 0;
    var _startHR = 0;
    var _currentHR = 0;

    // Приватные переменные логики
    private var _mode;
    private var _timer;
    private var _tickCount = 0;
    private var _circleRadiusPercent = 0.0;
    private var _statusText = "Приготовьтесь";
    
    private var _inhale = 4;
    private var _hold = 0;
    private var _exhale = 4;
    private var _cycleTotal = 8;
    private var _lastCycleCount = -1;

    function initialize(modeId) {
        View.initialize();
        _mode = modeId;
        _startTime = System.getTimer();
        
        // Получаем начальный пульс
        _startHR = getHeartRate();

        // Настройка таймингов в зависимости от режима
        if (_mode == :box) {
            _inhale = 4; _hold = 4; _exhale = 4;
            _cycleTotal = 16; // Вдох(4)-Задержка(4)-Выдох(4)-Задержка(4)
        }  else if (_mode == :free) {
    _inhale = 0; _hold = 0; _exhale = 0;
    _cycleTotal = 1; // Цикл не важен, так как анимации не будет
        }
        else if (_mode == :fourSevenEight) {
            _inhale = 4; _hold = 7; _exhale = 8;
            _cycleTotal = 19;
        } else {
            _inhale = 5; _hold = 0; _exhale = 5;
            _cycleTotal = 10;
        }
        
        _timer = new Timer.Timer();
    }

    function onShow() {
        // Запуск 100мс таймера для плавной анимации круга
        _timer.start(method(:onTimerTick), 100, true);
    }

    function onHide() {
        _timer.stop();
    }

    // Вспомогательная функция получения пульса
    function getHeartRate() {
        var info = Sensor.getInfo();
        if (info has :heartRate && info.heartRate != null) {
            return info.heartRate;
        }
        return 0;
    }
function onTimerTick() as Void {
    _tickCount++;
    _currentHR = getHeartRate();

    if (_mode == :free) {
        _statusText = "Свободный темп";
        _circleRadiusPercent = 0.0; // Обнуляем процент, чтобы старый код не рисовал большой круг
    } else {
        // ЛОГИКА ФАЗ (выполняется только если НЕ :free)
        var totalTicks = _cycleTotal * 10;
        var currentFullCycles = (_tickCount / totalTicks).toNumber();
        if (currentFullCycles > _lastCycleCount) {
            _cycles = currentFullCycles;
            _lastCycleCount = currentFullCycles;
        }
        var currentTickInCycle = _tickCount % totalTicks;
        var second = currentTickInCycle / 10.0;

        if (second < _inhale) {
            _statusText = "Вдох";
            _circleRadiusPercent = second / _inhale;
            if (currentTickInCycle == 0) { triggerVibe(); }
        } 
        else if (second < (_inhale + _hold)) {
            _statusText = "Задержка";
            _circleRadiusPercent = 1.0;
        } 
        else if (second < (_inhale + _hold + _exhale)) {
            _statusText = "Выдох";
            var exhaleTime = second - (_inhale + _hold);
            _circleRadiusPercent = 1.0 - (exhaleTime / _exhale);
            if (currentTickInCycle == ((_inhale + _hold) * 10).toLong()) { triggerVibe(); }
        } else {
            _statusText = "Задержка";
            _circleRadiusPercent = 0.0;
        }
    }
    WatchUi.requestUpdate();
}
    function triggerVibe() as Void {
        if (Attention has :vibrate) {
            try {
                var vibeProfile = [new Attention.VibeProfile(50, 150)] as Array<Attention.VibeProfile>;
                Attention.vibrate(vibeProfile);
            } catch (e) {
                // Ошибка вибрации не должна вешать приложение
            }
        }
    }

function onUpdate(dc as Dc) as Void {
    var w = dc.getWidth();
    var h = dc.getHeight();
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();

    if (_mode == :free) {
        // МИНИМАЛИСТИЧНЫЙ ДИЗАЙН ДЛЯ "СВОБОДНОГО ТЕМПА"
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        
        // Тонкое кольцо по краю (не пульсирует)
        dc.setPenWidth(2);
        dc.drawCircle(w / 2, h / 2, (w < h ? w : h) / 2.2);

        // Время сессии крупно в центре
        var totalSec = _tickCount / 10;
        var timeStr = (totalSec / 60) + ":" + (totalSec % 60).format("%02d");
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h / 2 - 20, Graphics.FONT_LARGE, timeStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Статус и пульс
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h / 2 + 30, Graphics.FONT_XTINY, "СВОБОДНЫЙ ТЕМП", Graphics.TEXT_JUSTIFY_CENTER);
        
        if (_currentHR > 0) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(w / 2, h - 60, Graphics.FONT_SMALL, "♥ " + _currentHR, Graphics.TEXT_JUSTIFY_CENTER);
        }
    } else {
        // КЛАССИЧЕСКИЙ ДИЗАЙН С АНИМАЦИЕЙ
        if (_statusText.equals("Вдох")) { dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT); }
        else if (_statusText.equals("Выдох")) { dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT); }
        else { dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT); }

        var maxRadius = (w < h ? w : h) / 2.5;
        var minRadius = 25;
        var currentRadius = minRadius + (maxRadius - minRadius) * _circleRadiusPercent;

        dc.setPenWidth(12);
        dc.drawCircle(w / 2, h / 2, currentRadius);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h / 2 - 15, Graphics.FONT_MEDIUM, _statusText, Graphics.TEXT_JUSTIFY_CENTER);
        
        if (_currentHR > 0) {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(w / 2, h - 50, Graphics.FONT_XTINY, "HR: " + _currentHR, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}}