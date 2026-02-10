using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Timer;

class BreathingView extends WatchUi.View {
    var mode;
    var timer;
    var counter = 0;
    var statusText = "Приготовьтесь";

    function initialize(modeId) {
        View.initialize();
        mode = modeId;
        
        // Создаем таймер, который срабатывает каждую секунду (1000 мс)
        timer = new Timer.Timer();
    }

    function onShow() {
        // Запускаем таймер при появлении экрана
        timer.start(method(:onTimerTick), 1000, true);
    }

    function onHide() {
        // Останавливаем таймер, когда уходим с экрана, чтобы не тратить батарею
        timer.stop();
    }

    // Эта функция вызывается каждую секунду
    function onTimerTick() {
        counter++;
        updateBreathingLogic();
        WatchUi.requestUpdate(); // Перерисовывает экран
    }

    function updateBreathingLogic() {
        // Простейшая логика для теста (например, для режима :box)
        if (mode == :box) {
            var cycle = counter % 12; // 4 вдох + 4 задержка + 4 выдох
            if (cycle < 4) { statusText = "Вдох"; }
            else if (cycle < 8) { statusText = "Задержка"; }
            else { statusText = "Выдох"; }
        } else {
            statusText = "Дышите ровно";
        }
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Отрисовка текста статуса (Вдох/Выдох)
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_MEDIUM,
            statusText,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Отрисовка секунд внизу
        dc.drawText(
            dc.getWidth() / 2,
            (dc.getHeight() / 2) + 40,
            Graphics.FONT_TINY,
            "Секунды: " + counter,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}