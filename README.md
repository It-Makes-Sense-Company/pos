# POS — Personal Operating System (It Makes Sense)

Движок персонального агента IMS на базе [Hermes Agent](https://github.com/nousresearch/hermes-agent) (Nous Research, MIT).

Этот репозиторий — **продуктовый слой поверх Hermes**: конфигурация, кастомные skills,
деплой и документация. Сам Hermes ставится как зависимость в venv (`vendor/`, не коммитится).

> Полный разбор архитектуры и решение базироваться на Hermes — `docs/04-hermes-pod-ims-pos.md`
> (зеркало `plans/04-...` из репозитория `itmakessense`).

## Что где

```
pos/
├── docs/            # архитектура, решения
├── config/          # шаблоны config.yaml (без секретов)
├── skills/          # наши кастомные POS-skills (память бренда, Sense Engine)
├── deploy/          # systemd-юнит, install-скрипт
├── vendor/          # клон Hermes (gitignored, ставится локально)
└── .env.example     # список нужных переменных (значения — только в ~/.hermes/.env)
```

## Принципы

- **Секреты не коммитим.** Репозиторий публичный. Токены и ключи живут только в
  `~/.hermes/.env` (0600) на сервере. В репо — лишь `.env.example` с именами переменных.
- **Только удалённый инференс** (OpenRouter) и удалённый ASR — сервер SkyStark без GPU,
  RAM впритык. Локальные модели/`faster-whisper` не поднимаем.
- **Hermes из upstream**, наши правки — отдельным слоем; при необходимости патчить —
  форк под организацию `It-Makes-Sense-Company`.

## Хостинг

Сервер IMS SkyStark, единый процесс gateway (long-polling Telegram), systemd.
На старте — один личный инстанс. Мультитенантность — через профили Hermes
(`~/.hermes/profiles/<name>/`).
