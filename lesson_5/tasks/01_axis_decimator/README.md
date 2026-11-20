# Домашнее задание `01_axis_decimator`

## Что необходимо сделать в данном задании

### Проектирование верификационного окружения

Согласно [очередности изучения](#очередность-изучения) заполнить файлы агента load, окружения и тестов прореживателя. **Настоятельно рекомендуется придерживаться обозначенной очередности**!

Каркас окружения, интерфейсы и файлы запуска предоставлены. Агенты AXI-Stream и reset из `common/dv` модифицировать не нужно! Просто изучите их!

Ориентируйтесь на `TODO` в исходных файлах.

### Поиск ошибок

Проверьте соответствие RTL [спецификации](./rtl/doc/spec.pdf). Найдите ошибку и определите, какой тест ее обнаруживает.

## О верифицируемом дизайне

AXI-Stream прореживатель пропускает заданное количество отсчетов, затем один отбрасывает. Значение `dec` загружается через отдельный интерфейс load.

Спецификация расположена в файле: [`rtl/doc/spec.pdf`](./rtl/doc/spec.pdf).

## О верификационном окружении

### Структура

- `dv` - исходные файлы верификации
  - `build` - файлы для запуска симуляции
    - `Makefile` - настройки сборки, выбор теста и ширин шин
    - `rtl.f`, `tb.f` - списки исходных файлов
    - `setup.sh` - подключение библиотек
    - `run.sh` - [основной скрипт](#запуск)
  - `tb` - интерфейсы и топ-модуль тестбенча
    - `load/load_intf.sv` - интерфейс load
    - `tb_axis_decimator.sv` - топ-модуль
  - `env` - классы верификационного окружения
    - `load` - компоненты агента load
      - `load_pkg.sv` - пакет агента
      - `load_agent_base.sv` - агент
      - `...`
      - `load_sequence_lib.sv` - последовательности
    - `axis_decimator_scoreboard_base.sv` - эталонная модель и сравнение
    - `axis_decimator_env_base.sv` - окружение
    - `axis_decimator_test_lib.sv` - тестовые сценарии
- `rtl` - тестируемый RTL
  - `src` - исходные файлы
  - `doc` - спецификация

### Очередность изучения

#### Вы уже должны быть знакомы с...

  - универсальными компонентами [`common/dv`](../../../common/dv);
  - агентом AXI-Stream [`common/dv/axis`](../../../common/dv/axis);
  - агентом сигнала сброса [`common/dv/reset`](../../../common/dv/reset).

#### Интерфейс и топ-модуль верификации

  1. Интерфейс load [`dv/tb/load/load_intf`](./dv/tb/load/load_intf.sv);

  2. Топ-модуль [`dv/tb/tb_axis_decimator`](./dv/tb/tb_axis_decimator.sv) — изучите подключение DUT и передачу интерфейсов и ширин шин через базу ресурсов.

#### Агент load

  3. Типы и конфигурация [`dv/env/load/load_utils`](./dv/env/load/load_utils.sv), [`load_agent_cfg_base`](./dv/env/load/load_agent_cfg_base.sv);

  4. Транзакция [`dv/env/load/load_seq_item_lib`](./dv/env/load/load_seq_item_lib.sv);
      - `TODO`: Поле `dec` и ограничение его значения шириной из конфигурации.

  5. Sequencer [`dv/env/load/load_sequencer_base`](./dv/env/load/load_sequencer_base.sv);
      - `TODO`: Хранение конфигурации агента.

  6. Последовательность [`dv/env/load/load_sequence_lib`](./dv/env/load/load_sequence_lib.sv);
      - `TODO`: Типизированный указатель `p_sqr` и приведение типа в `start()`;
      - `TODO`: Реализация `body()`. Методы `get_item()` и `start_item()` остаются готовыми.

  7. Driver [`dv/env/load/load_driver_lib`](./dv/env/load/load_driver_lib.sv);
      - `TODO`: Начальное состояние сигналов и передача транзакции load.

  8. Monitor [`dv/env/load/load_monitor_base`](./dv/env/load/load_monitor_base.sv);
      - `TODO`: Наблюдение за интерфейсом и отправка транзакции в mailbox.

  9. Агент [`dv/env/load/load_agent_base`](./dv/env/load/load_agent_base.sv);
      - `TODO`: Создание компонентов, передача конфигурации, соединение и запуск;
      - В качестве примера используйте [`common/dv/axis/env/axis_agent_base`](../../../common/dv/axis/env/axis_agent_base.sv).

#### Окружение

  10. Scoreboard [`dv/env/axis_decimator_scoreboard_base`](./dv/env/axis_decimator_scoreboard_base.sv);
      - `TODO`: Отбор входных транзакций в `process_master()` согласно правилу прореживания;
      - Обработка load, сброса и сравнение выходных данных остаются готовыми.

  11. Окружение [`dv/env/axis_decimator_env_base`](./dv/env/axis_decimator_env_base.sv);
      - `TODO`: Создание и запуск агентов и scoreboard;
      - `TODO`: Соединение mailbox мониторов со scoreboard.

#### Тесты

  12. Базовый тест [`dv/env/axis_decimator_test_lib`](./dv/env/axis_decimator_test_lib.sv);
      - `TODO`: Создание и передача конфигураций агентов;
      - `TODO`: Запуск reset, load и AXI-Stream последовательностей;
      - `TODO`: Настройка slave в режиме `AXIS_WAIT` на ожидаемое количество выходных транзакций.

  13. Тест `axis_decimator_test_reset` в том же файле;
      - `TODO`: Повторный сброс и передача данных без новой загрузки `dec`. Отсутствие выходных транзакций проверяется в scoreboard.

  14. Тест `axis_decimator_test_multiple_config` в том же файле;
      - `TODO`: Повторение загрузки случайного `dec` и передачи данных от 3 до 5 раз.

### Запуск

Для запуска используется [`dv/build/run.sh`](./dv/build/run.sh). Список тестов находится в этом же файле.

#### Подготовка

Из директории `dv/build` выполните:

```bash
bash setup.sh
```

#### Шаблоны

Запуск всей регрессии:

```bash
bash run.sh
```

Запуск всей регрессии с ширинами 64 и 12:

```bash
bash run.sh 64 12
```

Запуск конкретного теста в консоли:

```bash
make TEST_NAME=axis_decimator_test_base MODE=-c
```

Запуск конкретного теста с GUI:

```bash
make TEST_NAME=axis_decimator_test_base
```

В качестве имени теста можно указать любой тест из `run.sh`.

Общий лог — `dv/build/out/run.log`, логи отдельных тестов — `dv/build/out/sim/<имя теста>/sim.log`.
