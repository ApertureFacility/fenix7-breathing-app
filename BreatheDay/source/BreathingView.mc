import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Timer;
import Toybox.Attention;
import Toybox.Lang;

class BreathingView extends WatchUi.View {
    private var _mode;
    private var _timer;
    private var _tickCount = 0;
    private var _circleRadiusPercent = 0.0;
    private var _statusText = "Приготовьтесь";
    
    private var _inhale = 4;
    private var _hold = 4;
    private var _exhale = 4;
    private var _cycleTotal = 12;

    function initialize(modeId) {
        View.initialize();
        _mode = modeId;

        // Настройка таймингов
        if (_mode == :box) {
            _inhale = 4; _hold = 4; _exhale = 4;
            _cycleTotal = 16; // 4 фазы по 4 секунды (вдох-задержка-выдох-задержка)
        } else if (_mode == :fourSevenEight) {
            _inhale = 4; _hold = 7; _exhale = 8;
            _cycleTotal = 19;
        } else {
            _inhale = 5; _hold = 0; _exhale = 5;
            _cycleTotal = 10;
        }
        
        _timer = new Timer.Timer();
    }

    function onShow() {
        // 100 мс для плавности
        _timer.start(method(:onTimerTick), 100, true);
    }

    function onHide() {
        _timer.stop();
    }

    function onTimerTick() as Void {
        _tickCount++;
        
        // Считаем прогресс внутри цикла (в секундах)
        var totalTicks = _cycleTotal * 10;
        var currentTickInCycle = _tickCount % totalTicks;
        var second = currentTickInCycle / 10.0;

        // ЛОГИКА ФАЗ
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
            // Вибрация в начале выдоха (когда вошли в эту фазу)
            if (currentTickInCycle == ((_inhale + _hold) * 10).toLong()) { triggerVibe(); }
        } 
        else {
            _statusText = "Задержка";
            _circleRadiusPercent = 0.0;
        }

        WatchUi.requestUpdate();
    }

    function triggerVibe() as Void {
        if (Attention has :vibrate) {
            try {
                var vibeProfile = [new Attention.VibeProfile(50, 200)] as Array<Attention.VibeProfile>;
                Attention.vibrate(vibeProfile);
            } catch (e) {
                // Игнорируем ошибки вибрации, если что-то пошло не так
            }
        }
    }

    function onUpdate(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        
        // Очистка экрана
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Цвет круга
        if (_statusText.equals("Вдох")) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        } else if (_statusText.equals("Выдох")) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        }

        // Рисуем круг
        var maxRadius = (w < h ? w : h) / 2.5;
        var minRadius = 20;
        var currentRadius = minRadius + (maxRadius - minRadius) * _circleRadiusPercent;

        dc.setPenWidth(10);
        dc.drawCircle(w / 2, h / 2, currentRadius);

        // Текст фазы
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h / 2 - 15, Graphics.FONT_MEDIUM, _statusText, Graphics.TEXT_JUSTIFY_CENTER);
    }
}