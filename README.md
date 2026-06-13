# Blitz FX NG - Witcher 3 Next Gen

Мод с улучшенными графическими эффектами для Witcher 3: Next Gen Edition.

## Возможности
- 🌊 Улучшенные эффекты воды с волнами и пеной
- 🌑 Реалистичная система теней (PCF, Cascaded Shadows)
- ⚡ Оптимизированные эффекты заклинаний
- 🎨 Динамическое освещение
- 🎮 Адаптивное качество в зависимости от FPS

## Требования
- Witcher 3: Next Gen Edition
- WolvenKit (для редактирования)
- REDengine 4

## Установка
1. Скопировать папку мода в `Witcher 3\mods`
2. Активировать мод в REDlauncher
3. Перезагрузить игру

## Структура проекта
```
blitz-fx-ng/
├── README.md
├── shaders/              # HLSL шейдеры
│   ├── water_effect.hlsl
│   └── shadow_effect.hlsl
├── materials/           # Material конфигурации
│   ├── water_material.xml
│   └── shadow_material.xml
├── scripts/             # Witcher Script
│   ├── water_system.ws
│   └── shadow_system.ws
└── config/             # Конфигурационные файлы
    ├── water_config.ini
    └── shadow_config.ini
```

## Функции

### Система воды (Water System)
- Динамическая анимация волн
- Реалистичные отражения и преломления
- Эффект пены
- Адаптация к погоде (усиление волн при дожде)
- Зависимость от времени суток

### Система теней (Shadow System)
- PCF (Percentage-Closer Filtering) для мягких теней
- Cascaded Shadow Maps (CSM) для дальних объектов
- Динамическое качество теней (до 4 каскадов)
- Адаптация интенсивности по времени суток
- Оптимизация под разные уровни производительности

## Конфигурация

Измени параметры в файлах конфигурации:
- `config/water_config.ini` - параметры воды
- `config/shadow_config.ini` - параметры теней

## Автор
mugivaralufi1999

## Лицензия
CC0 1.0 Universal

## Благодарности
Спасибо сообществу Witcher 3 модов за вдохновение!